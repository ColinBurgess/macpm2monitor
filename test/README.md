Test harness for macpm2monitor

This folder contains a minimal mock `pm2` CLI and a small test runner script to exercise the commands the app issues.

How it works
- `test/bin/pm2` — a small bash script that simulates `pm2 jlist`, `pm2 start`, `pm2 stop`, `pm2 restart`, and `pm2 show`. It saves state to `test/state.json` so you can inspect results.
- `test/run_tests.sh` — runs a sequence of commands using the mock `pm2` to demonstrate how the app should interact with PM2.

Run the tests

```bash
chmod +x test/bin/pm2 test/run_tests.sh
./test/run_tests.sh
```

Use this harness when debugging the GUI: it reproduces the CLI side of the interaction without launching the macOS UI.
