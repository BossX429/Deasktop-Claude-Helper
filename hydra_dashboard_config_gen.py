#!/usr/bin/env python3
"""
Priority 2: Enable Dashboard Service
Starts Hydra dashboard on port 5180 with real-time metrics
"""

import json
import argparse
from pathlib import Path
from datetime import datetime

class HydraDashboardConfig:
    def __init__(self):
        self.config = {
            "service": {
                "name": "hydra-dashboard",
                "port": 5180,
                "host": "127.0.0.1",
                "enabled": True,
                "auto_start": True
            },
            "metrics": {
                "update_interval_seconds": 5,
                "retain_history_hours": 24,
                "enable_charts": True,
                "enable_alerts": True
            },
            "thresholds": {
                "confidence_warn": 0.75,
                "confidence_critical": 0.65,
                "latency_warn_ms": 100,
                "latency_critical_ms": 150,
                "error_rate_warn": 0.05,
                "error_rate_critical": 0.10
            },
            "heads": {
                "display_all": True,
                "highlight_degraded": True,
                "show_confidence_history": True,
                "show_latency_history": True
            },
            "ui": {
                "theme": "dark",
                "refresh_interval_ms": 5000,
                "max_chart_points": 288,
                "enable_realtime": True
            },
            "logging": {
                "level": "INFO",
                "log_file": "%TEMP%/hydra_dashboard.log",
                "max_log_size_mb": 100
            },
            "api": {
                "cors_enabled": True,
                "auth_required": False,
                "rate_limit_enabled": True,
                "rate_limit_requests_per_minute": 1000
            },
            "deployment": {
                "timestamp": datetime.now().isoformat(),
                "deployment_instructions": [
                    "1. Ensure Hydra decision engine is running on port 5179",
                    "2. Deploy config: cp hydra_dashboard_config.json /path/to/hydra/config/",
                    "3. Start dashboard: python -m hydra.dashboard --config hydra_dashboard_config.json",
                    "4. Access at: http://localhost:5180",
                    "5. Verify all 15 heads appear in dashboard",
                    "6. Check real-time confidence and latency updates",
                    "7. Confirm alerts trigger at configured thresholds",
                    "8. Register dashboard service for auto-start on boot"
                ],
                "rollback": [
                    "1. Stop dashboard: curl -X POST http://localhost:5180/shutdown",
                    "2. Or kill process: taskkill /F /IM python.exe (if dashboard was only Python process)",
                    "3. Restore previous config if needed",
                    "4. Restart decision engine: python -m hydra.decision_engine"
                ]
            }
        }

    def save(self, output_file="hydra_dashboard_config.json"):
        """Save configuration to JSON file."""
        path = Path(output_file)
        with open(path, 'w') as f:
            json.dump(self.config, f, indent=2)
        print(f"✓ Dashboard configuration saved to: {path}")
        return path

    def display(self):
        """Display configuration in human-readable format."""
        print("\n" + "=" * 70)
        print("HYDRA DASHBOARD CONFIGURATION")
        print("=" * 70)

        print("\n[SERVICE]")
        svc = self.config["service"]
        print(f"  Name: {svc['name']}")
        print(f"  Port: {svc['port']}")
        print(f"  Host: {svc['host']}")
        print(f"  Enabled: {svc['enabled']}")
        print(f"  Auto-start: {svc['auto_start']}")

        print("\n[METRICS]")
        met = self.config["metrics"]
        print(f"  Update interval: {met['update_interval_seconds']}s")
        print(f"  History retention: {met['retain_history_hours']} hours")
        print(f"  Charts enabled: {met['enable_charts']}")
        print(f"  Alerts enabled: {met['enable_alerts']}")

        print("\n[ALERTING THRESHOLDS]")
        thr = self.config["thresholds"]
        print(f"  Confidence warning: {thr['confidence_warn']}")
        print(f"  Confidence critical: {thr['confidence_critical']}")
        print(f"  Latency warning: {thr['latency_warn_ms']}ms")
        print(f"  Latency critical: {thr['latency_critical_ms']}ms")
        print(f"  Error rate warning: {thr['error_rate_warn']}")
        print(f"  Error rate critical: {thr['error_rate_critical']}")

        print("\n[UI]")
        ui = self.config["ui"]
        print(f"  Theme: {ui['theme']}")
        print(f"  Refresh interval: {ui['refresh_interval_ms']}ms")
        print(f"  Max chart points: {ui['max_chart_points']}")
        print(f"  Real-time enabled: {ui['enable_realtime']}")

        print("\n[DEPLOYMENT STEPS]")
        for i, step in enumerate(self.config["deployment"]["deployment_instructions"], 1):
            print(f"  {step}")

        print("\n[ROLLBACK STEPS]")
        for i, step in enumerate(self.config["deployment"]["rollback"], 1):
            print(f"  {step}")

        print("\n" + "=" * 70)

def main():
    parser = argparse.ArgumentParser(description="Generate Hydra Dashboard configuration")
    parser.add_argument("--output", default="hydra_dashboard_config.json",
                       help="Output configuration file path")
    parser.add_argument("--port", type=int, default=5180,
                       help="Dashboard port (default: 5180)")
    parser.add_argument("--no-display", action="store_true",
                       help="Skip displaying configuration")

    args = parser.parse_args()

    config_gen = HydraDashboardConfig()

    # Override port if specified
    if args.port != 5180:
        config_gen.config["service"]["port"] = args.port
        print(f"[INFO] Using custom port: {args.port}")

    # Display configuration
    if not args.no_display:
        config_gen.display()

    # Save configuration
    output_path = config_gen.save(args.output)

    print(f"\n[NEXT STEPS]")
    print(f"1. Review configuration: {output_path}")
    print(f"2. Start dashboard: python -m hydra.dashboard --config {output_path}")
    print(f"3. Access dashboard: http://localhost:{config_gen.config['service']['port']}")
    print(f"4. Verify 15 heads appear with real-time updates")
    print(f"5. Check alert thresholds are triggering appropriately")

if __name__ == "__main__":
    main()
