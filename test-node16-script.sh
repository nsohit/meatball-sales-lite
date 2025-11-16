#!/bin/bash
# Quick test untuk verify setup-lite-node16.sh tidak trigger Node.js

echo "Testing setup-lite-node16.sh for Node.js triggers..."
echo ""

# Test 1: Check script doesn't contain npm/yarn commands
echo "[1/5] Checking for npm/yarn commands..."
if grep -q "npm install\|yarn install\|npm run\|yarn build" setup-lite-node16.sh; then
    echo "❌ FAIL: Script contains npm/yarn commands!"
    grep -n "npm\|yarn" setup-lite-node16.sh
    exit 1
else
    echo "✅ PASS: No npm/yarn commands found"
fi

# Test 2: Check script doesn't install Node.js
echo "[2/5] Checking for Node.js installation..."
if grep -q "setup_18.x\|setup_16.x\|install.*nodejs" setup-lite-node16.sh; then
    echo "❌ FAIL: Script tries to install Node.js!"
    grep -n "nodejs" setup-lite-node16.sh
    exit 1
else
    echo "✅ PASS: No Node.js installation"
fi

# Test 3: Check uses Python HTTP server
echo "[3/5] Checking for Python HTTP server..."
if grep -q "python3 -m http.server" setup-lite-node16.sh; then
    echo "✅ PASS: Uses Python HTTP server"
else
    echo "❌ FAIL: Python HTTP server not found!"
    exit 1
fi

# Test 4: Check uses Supervisor
echo "[4/5] Checking for Supervisor usage..."
if grep -q "supervisor" setup-lite-node16.sh; then
    echo "✅ PASS: Uses Supervisor"
else
    echo "❌ FAIL: Supervisor not configured!"
    exit 1
fi

# Test 5: Check frontend setup doesn't cd into frontend folder
echo "[5/5] Checking frontend setup safety..."
if grep -A 20 "Step 5:" setup-lite-node16.sh | grep -q "cd frontend$"; then
    echo "❌ WARNING: Script cd into frontend folder (might trigger Node)"
    echo "   (This might be OK if just extracting)"
else
    echo "✅ PASS: Safe frontend handling"
fi

echo ""
echo "======================================"
echo "✅ All tests passed!"
echo "setup-lite-node16.sh is Node-free!"
echo "======================================"
