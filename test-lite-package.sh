#!/bin/bash
# Script untuk test paket lite sebelum deployment
# Jalankan di environment yang mirip dengan Pi 3B

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

log_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[✓ PASS]${NC} $1"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}[✗ FAIL]${NC} $1"
    ((FAILED++))
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

echo "=============================================="
echo "  Bakso Business - Lite Package Tester"
echo "=============================================="
echo ""

# Test 1: Check if packages exist
log_test "Checking if packages exist..."
if [ -f "bakso-business-lite.tar.gz" ]; then
    log_pass "bakso-business-lite.tar.gz exists"
else
    log_fail "bakso-business-lite.tar.gz not found"
fi

if [ -f "frontend-build.tar.gz" ]; then
    log_pass "frontend-build.tar.gz exists"
else
    log_fail "frontend-build.tar.gz not found"
fi

# Test 2: Check package size
log_test "Checking package sizes..."
LITE_SIZE=$(du -k bakso-business-lite.tar.gz | cut -f1)
FRONTEND_SIZE=$(du -k frontend-build.tar.gz | cut -f1)

if [ $LITE_SIZE -lt 1500 ]; then
    log_pass "Lite package size OK (${LITE_SIZE}KB < 1500KB)"
else
    log_fail "Lite package too large (${LITE_SIZE}KB)"
fi

if [ $FRONTEND_SIZE -lt 1000 ]; then
    log_pass "Frontend package size OK (${FRONTEND_SIZE}KB < 1000KB)"
else
    log_fail "Frontend package too large (${FRONTEND_SIZE}KB)"
fi

# Test 3: Extract and verify structure
log_test "Extracting and verifying package structure..."
TEST_DIR="/tmp/bakso-test-$$"
mkdir -p $TEST_DIR
cd $TEST_DIR

tar -xzf /app/bakso-business-lite.tar.gz

if [ -f "bakso-business-lite/setup-lite.sh" ]; then
    log_pass "setup-lite.sh found"
else
    log_fail "setup-lite.sh missing"
fi

if [ -f "bakso-business-lite/README.md" ]; then
    log_pass "README.md found"
else
    log_fail "README.md missing"
fi

if [ -f "bakso-business-lite/backend/server.py" ]; then
    log_pass "backend/server.py found"
else
    log_fail "backend/server.py missing"
fi

if [ -f "bakso-business-lite/backend/requirements.txt" ]; then
    log_pass "backend/requirements.txt found"
else
    log_fail "backend/requirements.txt missing"
fi

if [ -f "bakso-business-lite/frontend-build.tar.gz" ]; then
    log_pass "frontend-build.tar.gz included"
else
    log_fail "frontend-build.tar.gz missing"
fi

# Test 4: Check script permissions
log_test "Checking script permissions..."
if [ -x "bakso-business-lite/setup-lite.sh" ]; then
    log_pass "setup-lite.sh is executable"
else
    log_fail "setup-lite.sh not executable"
fi

# Test 5: Extract frontend build
log_test "Testing frontend build extraction..."
cd bakso-business-lite/frontend
tar -xzf ../frontend-build.tar.gz

if [ -f "build/index.html" ]; then
    log_pass "Frontend build/index.html exists"
else
    log_fail "Frontend build/index.html missing"
fi

if [ -d "build/static" ]; then
    log_pass "Frontend build/static directory exists"
else
    log_fail "Frontend build/static directory missing"
fi

# Test 6: Check build size
BUILD_SIZE=$(du -sm build | cut -f1)
if [ $BUILD_SIZE -lt 10 ]; then
    log_pass "Frontend build size OK (${BUILD_SIZE}MB < 10MB)"
else
    log_fail "Frontend build too large (${BUILD_SIZE}MB)"
fi

# Test 7: Verify index.html content
log_test "Verifying frontend content..."
if grep -q "root" build/index.html; then
    log_pass "index.html has root div"
else
    log_fail "index.html missing root div"
fi

if grep -q ".js" build/index.html; then
    log_pass "index.html references JS files"
else
    log_fail "index.html missing JS references"
fi

# Test 8: Check backend server.py
log_test "Checking backend code..."
cd ../backend

if grep -q "FastAPI" server.py; then
    log_pass "server.py uses FastAPI"
else
    log_fail "server.py missing FastAPI import"
fi

if grep -q "MONGO_URL" server.py; then
    log_pass "server.py uses MONGO_URL env var"
else
    log_fail "server.py might have hardcoded MongoDB URL"
fi

if grep -q "@app.get" server.py || grep -q "@app.post" server.py; then
    log_pass "server.py has API endpoints"
else
    log_fail "server.py missing API endpoints"
fi

# Test 9: Check requirements.txt
log_test "Checking Python dependencies..."
if grep -q "fastapi" requirements.txt; then
    log_pass "fastapi in requirements.txt"
else
    log_fail "fastapi missing from requirements.txt"
fi

if grep -q "motor" requirements.txt || grep -q "pymongo" requirements.txt; then
    log_pass "MongoDB driver in requirements.txt"
else
    log_fail "MongoDB driver missing from requirements.txt"
fi

if grep -q "openpyxl" requirements.txt; then
    log_pass "openpyxl in requirements.txt"
else
    log_fail "openpyxl missing from requirements.txt"
fi

# Test 10: Verify setup script content
log_test "Verifying setup script content..."
cd ..

if grep -q "mongodb" setup-lite.sh; then
    log_pass "setup-lite.sh installs MongoDB"
else
    log_fail "setup-lite.sh missing MongoDB installation"
fi

if grep -q "pm2" setup-lite.sh; then
    log_pass "setup-lite.sh uses PM2"
else
    log_fail "setup-lite.sh missing PM2 setup"
fi

if grep -q "frontend-build.tar.gz" setup-lite.sh; then
    log_pass "setup-lite.sh extracts frontend build"
else
    log_fail "setup-lite.sh doesn't handle frontend build"
fi

# Cleanup
log_info "Cleaning up test directory..."
cd /
rm -rf $TEST_DIR

# Summary
echo ""
echo "=============================================="
echo "  Test Summary"
echo "=============================================="
echo ""
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${RED}Failed:${NC} $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo "Paket lite siap untuk deployment!"
    exit 0
else
    echo -e "${RED}✗ Some tests failed!${NC}"
    echo "Perbaiki issues sebelum deployment."
    exit 1
fi
