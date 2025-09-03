#!/usr/bin/env bash
# Run quick CLI smoke tests against the mock pm2 to validate integration calls
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
export PATH="$DIR/bin:$PATH"
PM2_BIN="$DIR/bin/pm2"

echo "Test: initial jlist (should be empty array)"
pm2 jlist

echo
echo "Test: start a process with --name and complex command"
"$PM2_BIN" start --name test-server -- node ./server.js --port 3000

echo
echo "State after start (jlist):"
"$PM2_BIN" jlist

echo
echo "Test: show info for test-server"
"$PM2_BIN" show test-server

echo
echo "Test: restart test-server"
"$PM2_BIN" restart test-server

echo
echo "Test: stop test-server"
"$PM2_BIN" stop test-server

echo
echo "Final jlist:"
"$PM2_BIN" jlist

echo
echo "Contents of state.json (for debugging):"
cat "$DIR/state.json" || true
