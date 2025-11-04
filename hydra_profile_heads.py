#!/usr/bin/env python3
"""
Priority 1: Consensus Head Rebalancing - Head Profiler
Profiles all 15 Hydra consensus heads for accuracy, latency, and confidence variance.
"""

import json
import time
import statistics
from datetime import datetime
from pathlib import Path

HEADS = [
    "COORDINATOR", "ANALYST", "EXECUTOR", "GUARDIAN", "ARCHITECT",
    "MEDIATOR", "SENTINEL", "SYNTHESIZER", "NAVIGATOR", "RESEARCHER",
    "COMMUNICATOR", "CATALYST", "INNOVATOR", "ORACLE", "STRATEGIST"
]

class HeadProfiler:
    def __init__(self, output_dir="hydra_profiles"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        self.profiles = {}
        self.timestamp = datetime.now().isoformat()

    def profile_head(self, head_name, num_tests=100):
        """Profile a single head."""
        print(f"[PROFILING] {head_name}...")

        latencies = []
        confidences = []
        errors = 0

        for i in range(num_tests):
            try:
                start = time.time()
                confidence = 0.65  # Placeholder - from decision engine in production
                latency = (time.time() - start) * 1000

                latencies.append(latency)
                confidences.append(confidence)
            except Exception as e:
                errors += 1

        profile = {
            "head_name": head_name,
            "test_count": num_tests,
            "errors": errors,
            "error_rate": errors / num_tests,
            "latency": {
                "min_ms": min(latencies) if latencies else 0,
                "max_ms": max(latencies) if latencies else 0,
                "mean_ms": statistics.mean(latencies) if latencies else 0,
                "median_ms": statistics.median(latencies) if latencies else 0,
                "stdev_ms": statistics.stdev(latencies) if len(latencies) > 1 else 0,
            },
            "confidence": {
                "min": min(confidences) if confidences else 0,
                "max": max(confidences) if confidences else 0,
                "mean": statistics.mean(confidences) if confidences else 0,
                "median": statistics.median(confidences) if confidences else 0,
                "stdev": statistics.stdev(confidences) if len(confidences) > 1 else 0,
            }
        }

        self.profiles[head_name] = profile
        print(f"  ✓ {head_name}: avg_latency={profile['latency']['mean_ms']:.1f}ms, avg_confidence={profile['confidence']['mean']:.2f}")

        return profile

    def profile_all_heads(self, num_tests=100):
        """Profile all 15 heads."""
        print(f"\n[STARTING] Head profiling with {num_tests} tests per head")
        print("=" * 70)

        for head in HEADS:
            self.profile_head(head, num_tests)

        self.generate_report()

    def generate_report(self):
        """Generate profiling report."""
        report = {
            "timestamp": self.timestamp,
            "test_summary": {
                "total_heads": len(self.profiles),
                "profiled_heads": len(self.profiles),
            },
            "heads": self.profiles,
            "analysis": self._analyze_variance(),
            "recommendations": self._generate_recommendations()
        }

        output_file = self.output_dir / f"head_profile_{int(time.time())}.json"
        with open(output_file, 'w') as f:
            json.dump(report, f, indent=2)

        print(f"\n✓ Report saved to: {output_file}")
        return report

    def _analyze_variance(self):
        """Analyze variance across heads."""
        confidences = [h["confidence"]["mean"] for h in self.profiles.values()]
        latencies = [h["latency"]["mean_ms"] for h in self.profiles.values()]

        return {
            "confidence_variance": statistics.variance(confidences) if len(confidences) > 1 else 0,
            "confidence_stdev": statistics.stdev(confidences) if len(confidences) > 1 else 0,
            "latency_variance": statistics.variance(latencies) if len(latencies) > 1 else 0,
            "latency_stdev": statistics.stdev(latencies) if len(latencies) > 1 else 0,
            "confidence_range": (min(confidences), max(confidences)),
            "latency_range_ms": (min(latencies), max(latencies)),
        }

    def _generate_recommendations(self):
        """Generate rebalancing recommendations."""
        recommendations = []
        mean_conf = statistics.mean([h["confidence"]["mean"] for h in self.profiles.values()])

        for head_name, profile in self.profiles.items():
            conf = profile["confidence"]["mean"]

            if conf < mean_conf - 0.05:
                recommendations.append({
                    "head": head_name,
                    "issue": "LOW_CONFIDENCE",
                    "current": conf,
                    "target": mean_conf + 0.05,
                    "action": "Increase weight"
                })

        return recommendations

if __name__ == "__main__":
    profiler = HeadProfiler()
    profiler.profile_all_heads(num_tests=100)
