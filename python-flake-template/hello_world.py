import sys

REQUIRED_VERSION = (3, 10)

if sys.version_info[:2] != REQUIRED_VERSION:
    print(f"ERROR: You must run this script with Python {REQUIRED_VERSION[0]}.{REQUIRED_VERSION[1]}")
    sys.exit(1)

print("Hello from Python", sys.version)
