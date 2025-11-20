#!/bin/bash
# Bakso Business - Backend Startup Script dengan Pre-flight Checks
# This script ensures all dependencies are ready before starting backend

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Log function
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Get script directory (should be backend directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If script is in backend folder, use current dir
# If script is in parent folder, go to backend
if [ -f "$SCRIPT_DIR/server.py" ]; then
    BACKEND_DIR="$SCRIPT_DIR"
elif [ -f "$SCRIPT_DIR/backend/server.py" ]; then
    BACKEND_DIR="$SCRIPT_DIR/backend"
else
    echo "Error: Cannot find backend directory!"
    exit 1
fi

cd "$BACKEND_DIR"

echo "========================================"
echo "  Bakso Business - Backend Startup"
echo "========================================"
echo ""

# Pre-flight checks
log_info "Running pre-flight checks..."

# 1. Check MongoDB
log_info "[1/4] Checking MongoDB..."
if sudo systemctl is-active --quiet mongodb 2>/dev/null || mongod --version > /dev/null 2>&1; then
    if mongo --eval "db.version()" > /dev/null 2>&1; then
        log_info "✓ MongoDB is running and accessible"
    else
        log_warning "⚠ MongoDB may not be fully ready, waiting..."
        sleep 3
    fi
else
    log_error "✗ MongoDB is not running!"
    log_error "Fix: sudo systemctl start mongodb"
    exit 1
fi

# 2. Check Python virtual environment
log_info "[2/4] Checking Python environment..."
if [ ! -d "venv" ]; then
    log_error "✗ Virtual environment not found!"
    log_error "Run: python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

if [ ! -f "venv/bin/python" ]; then
    log_error "✗ Python interpreter not found in venv!"
    exit 1
fi

log_info "✓ Python environment OK"

# 3. Check dependencies
log_info "[3/4] Checking Python dependencies..."
if ! venv/bin/python -c "import fastapi, motor, openpyxl" 2>/dev/null; then
    log_warning "⚠ Some dependencies missing, installing..."
    venv/bin/pip install -r requirements.txt --quiet
fi
log_info "✓ Dependencies OK"

# 4. Check environment variables
log_info "[4/4] Checking environment variables..."
if [ -z "$MONGO_URL" ]; then
    log_warning "⚠ MONGO_URL not set in environment, using default"
    export MONGO_URL="mongodb://localhost:27017"
fi

if [ -z "$DB_NAME" ]; then
    log_warning "⚠ DB_NAME not set in environment, using default"
    export DB_NAME="bakso_business"
fi

if [ -z "$CORS_ORIGINS" ]; then
    export CORS_ORIGINS="*"
fi

log_info "Environment: MONGO_URL=$MONGO_URL, DB_NAME=$DB_NAME"

# 5. Test MongoDB connection with Python
log_info "Testing MongoDB connection..."
if venv/bin/python -c "
from motor.motor_asyncio import AsyncIOMotorClient
import asyncio

async def test():
    client = AsyncIOMotorClient('$MONGO_URL', serverSelectionTimeoutMS=5000)
    await client.admin.command('ping')
    print('MongoDB ping successful')

asyncio.run(test())
" 2>/dev/null; then
    log_info "✓ MongoDB connection test passed"
else
    log_error "✗ Cannot connect to MongoDB at $MONGO_URL"
    log_error "Check: 1) MongoDB running  2) URL correct  3) Network accessible"
    exit 1
fi

echo ""
echo "========================================"
log_info "✓ All pre-flight checks passed!"
echo "========================================"
echo ""
log_info "Starting FastAPI backend..."
echo ""

# Start uvicorn
exec venv/bin/uvicorn server:app \
    --host 0.0.0.0 \
    --port 8001 \
    --workers 1 \
    --timeout-keep-alive 30 \
    --log-level info
