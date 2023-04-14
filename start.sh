#!/bin/sh

# Start Httpd
apachectl -k start

# Run this in foreground mode. This is the process that 
# will prevent the container from stopping
cd /app
python3 server.py
