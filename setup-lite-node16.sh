#!/bin/bash
# Bakso Business - Lite Setup untuk Raspberry Pi 3B dengan Node.js 16
# Versi khusus untuk Pi yang tidak bisa upgrade ke Node 18
# Usage: bash setup-lite-node16.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Header
clear
echo "=============================================="
echo "  Bakso Business - Lite Setup (Node 16)"
echo "  Raspberry Pi 3B Optimized"
echo "=============================================="
echo ""

log_warning "CATATAN: Versi ini TIDAK BUTUH Node.js!"
log_info "✓ Frontend sudah 100% pre-built (static files)"
log_info "✓ Python HTTP server untuk serve frontend"
log_info "✓ Supervisor untuk process management"
log_info "✓ Zero dependency issues!"
echo ""

# Prevent any Node/npm/yarn processes from running
export NODE_ENV=production
unset npm_config_prefix
unset npm_package_name

# Check if running on Pi
if [ ! -f /proc/device-tree/model ]; then
    log_warning "Not running on Raspberry Pi, but will continue..."
else
    PI_MODEL=$(cat /proc/device-tree/model)
    log_info "Detected: $PI_MODEL"
fi

# Check available memory
TOTAL_MEM=$(free -m | awk 'NR==2{print $2}')
log_info "Total Memory: ${TOTAL_MEM}MB"

if [ $TOTAL_MEM -lt 900 ]; then
    log_error "Insufficient memory! Need at least 1GB RAM"
    exit 1
fi

# Confirm installation
echo ""
log_warning "This script will install:"
echo "  - MongoDB"
echo "  - Python 3 & dependencies"
echo "  - Backend service (FastAPI)"
echo "  - Pre-built frontend (no Node needed!)"
echo "  - Python HTTP server for frontend"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installation cancelled"
    exit 0
fi

# Start installation
echo ""
log_info "Starting installation... (10-15 minutes)"
echo ""

# ============================================
# Step 1: System Update
# ============================================
log_info "Step 1/8: Updating system..."
sudo apt update > /dev/null 2>&1
log_success "System updated"

# ============================================
# Step 2: Install MongoDB
# ============================================
log_info "Step 2/8: Installing MongoDB..."
sudo apt install -y mongodb > /dev/null 2>&1
sudo systemctl start mongodb
sudo systemctl enable mongodb > /dev/null 2>&1
log_success "MongoDB installed"

# Configure MongoDB for 1GB RAM
log_info "Configuring MongoDB for limited RAM..."
if ! grep -q "cacheSizeGB" /etc/mongodb.conf; then
    echo "storage.wiredTiger.engineConfig.cacheSizeGB=0.2" | sudo tee -a /etc/mongodb.conf > /dev/null
    sudo systemctl restart mongodb
fi
log_success "MongoDB optimized for Pi 3B"

# ============================================
# Step 3: Install Python & Tools
# ============================================
log_info "Step 3/8: Installing Python 3..."
sudo apt install -y python3 python3-pip python3-venv python3-dev build-essential > /dev/null 2>&1
log_success "Python 3 installed"

# ============================================
# Step 4: Setup Backend
# ============================================
log_info "Step 4/8: Setting up backend..."

cd backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
log_info "Installing Python packages (this may take 2-3 minutes)..."
pip install --quiet --upgrade pip
pip install --quiet fastapi uvicorn motor pymongo python-dotenv pydantic openpyxl

# Create .env if not exists
if [ ! -f .env ]; then
    cat > .env << 'EOF'
MONGO_URL=mongodb://localhost:27017
DB_NAME=bakso_business
CORS_ORIGINS=*
EOF
    log_success ".env created"
fi

deactivate
cd ..
log_success "Backend setup complete"

# ============================================
# Step 5: Setup Frontend (Pre-built - NO NODE!)
# ============================================
log_info "Step 5/8: Setting up frontend (static files only)..."

# IMPORTANT: We don't cd into frontend folder to avoid triggering any Node processes
# Frontend is 100% pre-built static files, no setup needed!

# Check if build exists
if [ ! -d "frontend/build" ]; then
    log_warning "Pre-built frontend not found in frontend/build/"
    
    # Check if tarball exists
    if [ -f "frontend-build.tar.gz" ]; then
        log_info "Extracting pre-built frontend..."
        # Extract directly to frontend folder without entering it
        mkdir -p frontend
        tar -xzf frontend-build.tar.gz -C frontend/
        log_success "Frontend extracted (100% static, no Node needed!)"
    else
        log_error "Pre-built frontend not found!"
        log_error "File 'frontend-build.tar.gz' harus ada di folder ini"
        echo ""
        log_info "Pastikan paket lite sudah lengkap dengan frontend-build.tar.gz"
        exit 1
    fi
else
    log_success "Frontend build found (already extracted)"
fi

# Verify build directory has content
if [ ! -f "frontend/build/index.html" ]; then
    log_error "Frontend build tidak lengkap (index.html missing)"
    exit 1
fi

# Rename package.json files to prevent any Node processes from triggering
# Frontend is 100% static, these files not needed for serving
if [ -f "frontend/package.json" ]; then
    mv frontend/package.json frontend/package.json.bak 2>/dev/null || true
    log_info "Disabled package.json (not needed for static serving)"
fi

if [ -f "frontend/yarn.lock" ]; then
    mv frontend/yarn.lock frontend/yarn.lock.bak 2>/dev/null || true
fi

if [ -f "frontend/package-lock.json" ]; then
    mv frontend/package-lock.json frontend/package-lock.json.bak 2>/dev/null || true
fi

log_success "Frontend ready (Python HTTP server will serve it)"

# ============================================
# Step 6: Install Supervisor (for process management)
# ============================================
log_info "Step 6/8: Installing Supervisor..."
sudo apt install -y supervisor > /dev/null 2>&1
log_success "Supervisor installed"

# ============================================
# Step 7: Create Supervisor Configs
# ============================================
log_info "Step 7/8: Creating service configurations..."

# Backend config (Optimized untuk Raspberry Pi 3B)
sudo tee /etc/supervisor/conf.d/bakso-backend.conf > /dev/null << EOF
[program:bakso-backend]
directory=$(pwd)/backend
command=$(pwd)/backend/venv/bin/uvicorn server:app --host 0.0.0.0 --port 8001 --workers 1 --timeout-keep-alive 30
user=$USER
autostart=true
autorestart=true
startsecs=10
startretries=3
stopwaitsecs=10
stderr_logfile=/var/log/supervisor/bakso-backend.err.log
stdout_logfile=/var/log/supervisor/bakso-backend.out.log
environment=MONGO_URL="mongodb://localhost:27017",DB_NAME="bakso_business",CORS_ORIGINS="*"
priority=100
EOF

# Frontend config (using Python HTTP server - no Node needed!)
sudo tee /etc/supervisor/conf.d/bakso-frontend.conf > /dev/null << EOF
[program:bakso-frontend]
directory=$(pwd)/frontend/build
command=python3 -m http.server 3000
user=$USER
autostart=true
autorestart=true
startsecs=5
startretries=3
stopwaitsecs=5
stderr_logfile=/var/log/supervisor/bakso-frontend.err.log
stdout_logfile=/var/log/supervisor/bakso-frontend.out.log
priority=200
EOF

log_success "Service configurations created"

# ============================================
# Step 8: Start Services (with health checks)
# ============================================
log_info "Step 8/8: Starting services..."

# Reload supervisor
sudo supervisorctl reread > /dev/null 2>&1
sudo supervisorctl update > /dev/null 2>&1

# Wait for MongoDB to be ready
log_info "Waiting for MongoDB to be ready..."
for i in {1..10}; do
    if mongo --eval "db.version()" > /dev/null 2>&1; then
        log_success "MongoDB is ready"
        break
    fi
    if [ $i -eq 10 ]; then
        log_warning "MongoDB not responding, continuing anyway..."
    fi
    sleep 2
done

# Start backend first (higher priority)
log_info "Starting backend service..."
sudo supervisorctl start bakso-backend > /dev/null 2>&1
sleep 5

# Wait for backend to be healthy
log_info "Waiting for backend to be ready..."
for i in {1..15}; do
    if curl -s http://localhost:8001/api/ | grep -q "Bakso Business" 2>/dev/null; then
        log_success "Backend is ready and responding"
        break
    fi
    if [ $i -eq 15 ]; then
        log_warning "Backend not responding yet, check logs if needed"
    fi
    sleep 2
done

# Start frontend
log_info "Starting frontend service..."
sudo supervisorctl start bakso-frontend > /dev/null 2>&1
sleep 3

log_success "Services started"

# Check services
if sudo supervisorctl status bakso-backend | grep -q "RUNNING"; then
    log_success "Backend running"
else
    log_error "Backend failed to start"
    sudo supervisorctl tail bakso-backend stderr
    exit 1
fi

if sudo supervisorctl status bakso-frontend | grep -q "RUNNING"; then
    log_success "Frontend running"
else
    log_error "Frontend failed to start"
    sudo supervisorctl tail bakso-frontend stderr
    exit 1
fi

# ============================================
# Verification
# ============================================
echo ""
echo "=============================================="
echo "  Verifying Installation..."
echo "=============================================="
echo ""

# Get IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Test backend
log_info "Testing backend API..."
sleep 2
if curl -s http://localhost:8001/api/ | grep -q "Bakso Business" 2>/dev/null; then
    log_success "Backend API responding"
else
    log_warning "Backend API not responding yet, check logs if issues persist"
fi

# Test frontend
log_info "Testing frontend..."
if curl -s http://localhost:3000 | grep -q "html" 2>/dev/null; then
    log_success "Frontend serving"
else
    log_warning "Frontend not serving yet, check logs if issues persist"
fi

# Memory check
USED_MEM=$(free -m | awk 'NR==2{printf "%.0f", $3}')
FREE_MEM=$(free -m | awk 'NR==2{printf "%.0f", $4}')
log_info "Memory: ${USED_MEM}MB used, ${FREE_MEM}MB free"

# ============================================
# Success Message
# ============================================
echo ""
echo "=============================================="
echo -e "${GREEN}  ✓ Installation Complete!${NC}"
echo "=============================================="
echo ""
echo "Access your application:"
echo ""
echo "  Frontend: http://${IP_ADDRESS}:3000"
echo "  Backend:  http://${IP_ADDRESS}:8001/api/"
echo "  API Docs: http://${IP_ADDRESS}:8001/docs"
echo ""
echo "Useful commands:"
echo ""
echo "  sudo supervisorctl status       - Check services"
echo "  sudo supervisorctl tail -f [service] - View logs"
echo "  sudo supervisorctl restart all  - Restart services"
echo "  sudo supervisorctl stop all     - Stop services"
echo ""
echo "System resources:"
echo "  Memory used: ${USED_MEM}MB / ${TOTAL_MEM}MB"
echo "  Services: Backend (Python/FastAPI) + Frontend (Python HTTP)"
echo ""
log_success "Setup completed successfully!"
echo ""
echo "💡 TIP: Versi ini menggunakan Python HTTP server untuk frontend"
echo "         Tidak perlu Node.js sama sekali!"
echo ""
echo "Enjoy your Bakso Business System! 🎉"
echo "=============================================="
