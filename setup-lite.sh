#!/bin/bash
# Bakso Business - Lite Setup untuk Raspberry Pi 3B
# One-command installation tanpa build frontend
# Usage: bash setup-lite.sh

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
echo "  Bakso Business - Lite Setup"
echo "  Raspberry Pi 3B Optimized (No Build!)"
echo "=============================================="
echo ""

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
echo "  - Backend service"
echo "  - Pre-built frontend (no npm build!)"
echo "  - PM2 process manager"
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
log_info "Step 1/10: Updating system..."
sudo apt update > /dev/null 2>&1
log_success "System updated"

# ============================================
# Step 2: Install MongoDB
# ============================================
log_info "Step 2/10: Installing MongoDB..."
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
log_info "Step 3/10: Installing Python 3..."
sudo apt install -y python3 python3-pip python3-venv python3-dev build-essential > /dev/null 2>&1
log_success "Python 3 installed"

# ============================================
# Step 4: Setup Backend
# ============================================
log_info "Step 4/10: Setting up backend..."

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
# Step 5: Setup Frontend (Pre-built)
# ============================================
log_info "Step 5/10: Setting up frontend..."

cd frontend

# Check if build exists
if [ ! -d "build" ]; then
    log_warning "Pre-built frontend not found in frontend/build/"
    
    # Check if tarball exists in parent directory
    if [ -f "../frontend-build.tar.gz" ]; then
        log_info "Found frontend-build.tar.gz, extracting..."
        tar -xzf ../frontend-build.tar.gz
        log_success "Frontend extracted from tarball"
    else
        log_error "Pre-built frontend not found!"
        log_error "This lite version requires pre-built frontend."
        echo ""
        log_info "Solusi:"
        log_info "1. Pastikan file 'frontend-build.tar.gz' ada di folder root"
        log_info "   ATAU"
        log_info "2. Pastikan folder 'frontend/build/' sudah ada"
        echo ""
        log_info "Jika belum ada, build di komputer dengan RAM cukup:"
        log_info "  cd frontend"
        log_info "  yarn install"
        log_info "  yarn build"
        log_info "  cd .."
        log_info "  tar -czf frontend-build.tar.gz -C frontend build/"
        echo ""
        log_info "Kemudian copy frontend-build.tar.gz ke Raspberry Pi"
        exit 1
    fi
else
    log_success "Frontend build found"
fi

# Create .env for frontend if not exists
if [ ! -f .env ]; then
    cat > .env << 'EOF'
REACT_APP_BACKEND_URL=http://localhost:8001
EOF
    log_success "Frontend .env created"
fi

cd ..

# ============================================
# Step 6: Install Node.js (for serve only)
# ============================================
log_info "Step 6/10: Installing Node.js..."

if ! command -v node &> /dev/null; then
    log_info "Downloading Node.js 16..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - > /dev/null 2>&1
    sudo apt install -y nodejs > /dev/null 2>&1
fi

log_success "Node.js $(node --version) installed"

# ============================================
# Step 7: Install serve & PM2
# ============================================
log_info "Step 7/10: Installing serve & PM2..."

sudo npm install -g serve pm2 --quiet
log_success "serve & PM2 installed"

# ============================================
# Step 8: Create PM2 Ecosystem
# ============================================
log_info "Step 8/10: Creating PM2 configuration..."

cat > ecosystem.lite.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'bakso-backend',
      cwd: './backend',
      script: 'venv/bin/uvicorn',
      args: 'server:app --host 0.0.0.0 --port 8001 --workers 1',
      interpreter: 'none',
      instances: 1,
      exec_mode: 'fork',
      max_memory_restart: '300M',
      env: {
        MONGO_URL: 'mongodb://localhost:27017',
        DB_NAME: 'bakso_business',
        CORS_ORIGINS: '*'
      },
      error_file: './logs/backend-error.log',
      out_file: './logs/backend-out.log',
      time: true,
      autorestart: true
    },
    {
      name: 'bakso-frontend',
      cwd: './frontend',
      script: 'serve',
      args: '-s build -l 3000',
      instances: 1,
      exec_mode: 'fork',
      max_memory_restart: '200M',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/frontend-error.log',
      out_file: './logs/frontend-out.log',
      time: true,
      autorestart: true
    }
  ]
};
EOF

mkdir -p logs
log_success "PM2 configuration created"

# ============================================
# Step 9: Start Services
# ============================================
log_info "Step 9/10: Starting services..."

# Start with PM2
pm2 start ecosystem.lite.config.js > /dev/null 2>&1
pm2 save > /dev/null 2>&1

log_success "Services started"

# Wait for services to start
sleep 3

# Check services
if pm2 list | grep -q "bakso-backend.*online"; then
    log_success "Backend running"
else
    log_error "Backend failed to start"
    pm2 logs bakso-backend --lines 20
    exit 1
fi

if pm2 list | grep -q "bakso-frontend.*online"; then
    log_success "Frontend running"
else
    log_error "Frontend failed to start"
    pm2 logs bakso-frontend --lines 20
    exit 1
fi

# ============================================
# Step 10: Setup Autostart
# ============================================
log_info "Step 10/10: Configuring autostart..."

pm2 startup systemd -u $USER --hp $HOME > /tmp/pm2-startup.sh 2>&1
if [ -f /tmp/pm2-startup.sh ]; then
    STARTUP_CMD=$(grep "sudo env" /tmp/pm2-startup.sh)
    if [ ! -z "$STARTUP_CMD" ]; then
        eval $STARTUP_CMD > /dev/null 2>&1
        log_success "Autostart configured"
    fi
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
if curl -s http://localhost:8001/api/ | grep -q "Bakso Business"; then
    log_success "Backend API responding"
else
    log_error "Backend API not responding"
fi

# Test frontend
log_info "Testing frontend..."
if curl -s http://localhost:3000 | grep -q "html"; then
    log_success "Frontend serving"
else
    log_error "Frontend not serving"
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
echo "  pm2 status          - Check services"
echo "  pm2 logs            - View logs"
echo "  pm2 restart all     - Restart services"
echo "  pm2 stop all        - Stop services"
echo ""
echo "System resources:"
echo "  Memory used: ${USED_MEM}MB / ${TOTAL_MEM}MB"
echo "  PM2 autostart: Enabled"
echo ""
log_success "Setup completed successfully!"
echo ""
echo "Enjoy your Bakso Business System! 🎉"
echo "=============================================="
