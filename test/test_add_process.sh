#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
PM2="$DIR/bin/pm2"

echo "Test: add process with --name (simulating GUI Add Process with name)"
"$PM2" start --name gui-test -- node ./server.js --port 4001
echo "jlist after named start:"
"$PM2" jlist

echo
echo "Test: add process without name (simulating GUI Add Process without name)"
"$PM2" start -- node ./other.js --flag
echo "jlist after unnamed start:"
"$PM2" jlist

echo
echo "Verify both entries exist in state.json:"
cat "$DIR/state.json"

echo
echo "Done. If both processes appear, the CLI side of Add Process works as expected."
