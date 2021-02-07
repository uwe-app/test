#!/bin/sh

BIN_UWE=${BIN_UWE:-uwe}
UWE_HEADLESS=1 ${BIN_UWE} dev > /dev/null 2>&1 &
echo $! > dev-server.pid
