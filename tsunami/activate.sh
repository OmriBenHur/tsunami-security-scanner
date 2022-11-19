#!/bin/bash
# entrypoint script for the tsunami scanner, activates the scan for each passed ip adress
# and calls the identify python script to scan and join vulnerabilities(if found) in any of the reports

./scan.sh
python3 identify.py
