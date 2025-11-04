#!/usr/bin/env python3
"""
Priority 1: Consensus Head Rebalancing - Adaptive Weight Calculator
Calculates optimal weights for each head based on profiling data.
Weights formula: (accuracy_component * 0.40) + (speed_component * 0.30) + (confidence_component * 0.30)
"""

import json
import sys
import statistics
from pathlib import Path
from datetime import datetime

class AdaptiveWeightCalculator:
    def __init__(self, profile_file=None):
        self.profile_file = profile_file
        self.profiles = {}
        self.weights = {}
        self.timestamp = datetime.now().isoformat()

    def load_profile(self, profile_file):
        """Load profiling data from JSON file."""
        try:
            with open(profile_file, 'r') as f:
                data = json.load(f)
            self.profiles = data.get("heads", {})
            print(f"✓ Loaded profile data from: {profile_file}")
            return True
        except FileNotFoundError:
            print(f"✗ Profile file not found: {profile_file}")
            return False
        except json.JSONDecodeError:
            print(f"✗ Invalid JSON in profile file: {profile_file}")
            return False

    def calculate_weights(self):
        """Calculate adaptive weights for all heads."""
        if not self.profiles:
            print("✗ No profile data loaded. Run hydra_profile_heads.py first.")
            return False

        print("\n[CALCULATING] Adaptive weights...")
        print("=" * 70)

        # Extract normalized metrics
        accuracy_scores = {}
        latency_scores = {}
        confidence_scores = {}

        # Calculate accuracy (inverse error rate)
        for head_name, profile in self.profiles.items():
            error_rate = profile.get("error_rate", 0)
            accuracy_scores[head_name] = max(0, 1.0 - error_rate)

        # Calculate speed (inverse latency, normalized)
        latencies = [p["latency"]["mean_ms"] for p in self.profiles.values()]
        max_latency = max(latencies) if latencies else 1
        for head_name, profile in self.profiles.items():
            latency = profile["latency"]["mean_ms"]
            latency_scores[head_name] = 1.0 - (latency / max_latency)

        # Get confidence scores (already normalized 0-1)
        for head_name, profile in self.profiles.items():
            confidence_scores[head_name] = profile["confidence"]["mean"]

        # Normalize all scores to 0-1 range
        accuracy_scores = self._normalize_scores(accuracy_scores)
        latency_scores = self._normalize_scores(latency_scores)
        confidence_scores = self._normalize_scores(confidence_scores)

        # Calculate weighted scores
        print("\nHead\t\t\tAccuracy  Speed    Confidence  Weighted")
        print("-" * 70)

        weighted_scores = {}
        for head_name in self.profiles.keys():
            weighted = (
                accuracy_scores[head_name] * 0.40 +
                latency_scores[head_name] * 0.30 +
                confidence_scores[head_name] * 0.30
            )
            weighted_scores[head_name] = weighted

            print(f"{head_name:20} {accuracy_scores[head_name]:6.2%}  "
                  f"{latency_scores[head_name]:6.2%}    {confidence_scores[head_name]:6.2%}      "
                  f"{weighted:6.2%}")

        # Normalize to probability distribution
        self.weights = self._normalize_to_probabilities(weighted_scores)
        print("-" * 70)

        return True

    def _normalize_scores(self, scores):
        """Normalize scores to 0-1 range."""
        values = list(scores.values())
        min_val = min(values) if values else 0
        max_val = max(values) if values else 1
        range_val = max_val - min_val if max_val > min_val else 1

        return {k: (v - min_val) / range_val for k, v in scores.items()}

    def _normalize_to_probabilities(self, scores):
        """Normalize scores to probability distribution (sum to 1.0)."""
        total = sum(scores.values())
        if total == 0:
            # Uniform distribution fallback
            uniform = 1.0 / len(scores)
            return {k: uniform for k in scores.keys()}

        return {k: v / total for k, v in scores.items()}

    def generate_configuration(self):
        """Generate Hydra configuration JSON for deployment."""
        config = {
            "timestamp": self.timestamp,
            "calculation_method": "adaptive_weighting_v1",
            "weight_formula": "accuracy(40%) + speed(30%) + confidence(30%)",
            "heads": self.weights,
            "deployment_instructions": [
                "1. Backup current Hydra config: cp hydra_config.json hydra_config.json.backup",
                "2. Apply weights to decision engine: hydra_cli config set decision_engine.head_weights <this_file>",
                "3. Enable adaptive rebalancing: hydra_cli config set decision_engine.auto_rebalance true",
                "4. Verify deployment: hydra_cli decision_engine heads --show-weights",
                "5. Monitor head confidence: python hydra_head_health_monitor.ps1"
            ]
        }

        output_file = Path("hydra_weights_config.json")
        with open(output_file, 'w') as f:
            json.dump(config, f, indent=2)

        print(f"\n✓ Configuration saved to: {output_file}")
        print(f"✓ Ready for deployment")

        return config

    def display_summary(self):
        """Display weight distribution summary."""
        if not self.weights:
            print("✗ No weights calculated yet")
            return

        print("\n[SUMMARY] Final Head Weights (Probability Distribution)")
        print("=" * 70)

        sorted_weights = sorted(self.weights.items(), key=lambda x: x[1], reverse=True)
        for head_name, weight in sorted_weights:
            bar = "█" * int(weight * 50)
            print(f"{head_name:20} {weight:6.2%}  {bar}")

        # Calculate statistics
        values = list(self.weights.values())
        mean_weight = statistics.mean(values)
        stdev = statistics.stdev(values) if len(values) > 1 else 0

        print("-" * 70)
        print(f"Mean weight:         {mean_weight:6.2%}")
        print(f"Std deviation:       {stdev:6.2%}")
        print(f"Weight range:        {min(values):6.2%} - {max(values):6.2%}")

def main():
    if len(sys.argv) < 2:
        # Look for most recent profile
        profile_dir = Path("hydra_profiles")
        if profile_dir.exists():
            profiles = sorted(profile_dir.glob("head_profile_*.json"), reverse=True)
            if profiles:
                profile_file = profiles[0]
            else:
                print("✗ No profile files found. Run hydra_profile_heads.py first.")
                sys.exit(1)
        else:
            print("✗ Usage: python hydra_adaptive_weighting.py <profile_file>")
            print("✗ Or run hydra_profile_heads.py first to generate profiles.")
            sys.exit(1)
    else:
        profile_file = sys.argv[1]

    calculator = AdaptiveWeightCalculator()

    if not calculator.load_profile(profile_file):
        sys.exit(1)

    if not calculator.calculate_weights():
        sys.exit(1)

    calculator.display_summary()
    calculator.generate_configuration()

    print("\n[NEXT STEPS]")
    print("1. Review hydra_weights_config.json for reasonableness")
    print("2. Apply configuration to Hydra decision engine")
    print("3. Monitor system confidence for improvement (target: 0.80+ per head)")

if __name__ == "__main__":
    main()
