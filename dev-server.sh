#!/bin/sh

UWE_HEADLESS=1 uwe dev > /dev/null 2>&1 &
echo $! > dev-server.pid
