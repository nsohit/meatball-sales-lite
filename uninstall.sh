#!/bin/bash
# Script untuk uninstall Bakso Business System
# Berguna untuk clean install ulang

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

echo "=============================================="
echo "  Bakso Business - Uninstall Script"
echo "=============================================="
echo ""

log_warning "Script ini akan menghapus instalasi Bakso Business"
echo ""
echo "Yang akan dihapus:"
echo "  1. Services (Supervisor/PM2)"
echo "  2. Application files"
echo "  3. Configuration files"
echo ""
echo "Yang TIDAK dihapus (optional):"
echo "  - MongoDB database (data Anda)"
echo "  - MongoDB software"
echo "  - Python packages"
echo ""

# Confirm
read -p "Lanjutkan uninstall? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Uninstall dibatalkan"
    exit 0
fi

echo ""

# ============================================
# Step 1: Stop Services
# ============================================
log_info "Step 1/5: Stopping services..."

# Stop Supervisor services
if command -v supervisorctl &> /dev/null; then
    sudo supervisorctl stop bakso-backend 2>/dev/null || true
    sudo supervisorctl stop bakso-frontend 2>/dev/null || true
    log_success "Supervisor services stopped"
fi

# Stop PM2 services
if command -v pm2 &> /dev/null; then
    pm2 stop bakso-backend 2>/dev/null || true
    pm2 stop bakso-frontend 2>/dev/null || true
    pm2 delete bakso-backend 2>/dev/null || true
    pm2 delete bakso-frontend 2>/dev/null || true
    log_success "PM2 services stopped"
fi

# ============================================
# Step 2: Remove Service Configurations
# ============================================
log_info "Step 2/5: Removing service configurations..."

# Remove Supervisor configs
if [ -f "/etc/supervisor/conf.d/bakso-backend.conf" ]; then
    sudo rm -f /etc/supervisor/conf.d/bakso-backend.conf
    log_success "Removed Supervisor backend config"
fi

if [ -f "/etc/supervisor/conf.d/bakso-frontend.conf" ]; then
    sudo rm -f /etc/supervisor/conf.d/bakso-frontend.conf
    log_success "Removed Supervisor frontend config"
fi

# Reload supervisor
if command -v supervisorctl &> /dev/null; then
    sudo supervisorctl reread 2>/dev/null || true
    sudo supervisorctl update 2>/dev/null || true
fi

# Remove PM2 startup
if command -v pm2 &> /dev/null; then
    pm2 unstartup 2>/dev/null || true
fi

log_success "Service configurations removed"

# ============================================
# Step 3: Remove Application Files
# ============================================
log_info "Step 3/5: Removing application files..."

# Get current directory
CURRENT_DIR=$(pwd)

# If we're in bakso-business-lite directory, go up
if [[ "$CURRENT_DIR" == *"bakso-business-lite"* ]]; then
    cd ..
fi

# Remove application directory
if [ -d "$HOME/bakso-business-lite" ]; then
    rm -rf "$HOME/bakso-business-lite"
    log_success "Removed $HOME/bakso-business-lite"
fi

# Remove tar.gz files
rm -f "$HOME/bakso-business-lite.tar.gz" 2>/dev/null || true
rm -f "$HOME/frontend-build.tar.gz" 2>/dev/null || true

log_success "Application files removed"

# ============================================
# Step 4: Optional - Backup Database
# ============================================
log_info "Step 4/5: Database backup..."
echo ""
read -p "Backup database sebelum hapus? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    BACKUP_DIR="$HOME/bakso-backup-$(date +%Y%m%d-%H%M%S)"
    log_info "Creating backup..."
    
    if command -v mongodump &> /dev/null; then
        mongodump --db bakso_business --out "$BACKUP_DIR" 2>/dev/null || \
        mongodump --out "$BACKUP_DIR" 2>/dev/null
        log_success "Database backed up to: $BACKUP_DIR"
    else
        log_warning "mongodump not found, skipping backup"
    fi
else
    log_info "Skipping database backup"
fi

# ============================================
# Step 5: Optional - Clean Database
# ============================================
log_info "Step 5/5: Database cleanup..."
echo ""
read -p "Hapus database bakso_business? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v mongo &> /dev/null; then
        mongo bakso_business --eval "db.dropDatabase()" 2>/dev/null || \
        mongosh bakso_business --eval "db.dropDatabase()" 2>/dev/null || true
        log_success "Database bakso_business dihapus"
    else
        log_warning "mongo/mongosh not found, database tidak dihapus"
    fi
else
    log_info "Database bakso_business dipertahankan"
fi

# ============================================
# Optional - Remove Dependencies
# ============================================
echo ""
log_info "Optional: Hapus dependencies?"
echo ""
echo "Hapus software ini juga? (tidak recommended jika dipakai aplikasi lain)"
echo "  - MongoDB"
echo "  - Python packages"
echo "  - PM2"
echo "  - Supervisor"
echo ""
read -p "Hapus dependencies? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Removing dependencies..."
    
    # Remove PM2
    if command -v pm2 &> /dev/null; then
        npm uninstall -g pm2 2>/dev/null || true
        log_success "PM2 removed"
    fi
    
    # Ask about MongoDB
    read -p "Hapus MongoDB juga? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo systemctl stop mongodb 2>/dev/null || true
        sudo apt remove -y mongodb 2>/dev/null || true
        sudo apt autoremove -y 2>/dev/null || true
        log_success "MongoDB removed"
    fi
else
    log_info "Dependencies dipertahankan"
fi

# ============================================
# Summary
# ============================================
echo ""
echo "=============================================="
echo -e "${GREEN}  ✓ Uninstall Complete!${NC}"
echo "=============================================="
echo ""
echo "Yang sudah dihapus:"
echo "  ✓ Services (Supervisor/PM2)"
echo "  ✓ Application files"
echo "  ✓ Configuration files"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    echo "Backup database tersimpan di:"
    echo "  $BACKUP_DIR"
    echo ""
fi

echo "Untuk install ulang:"
echo "  1. Download paket terbaru"
echo "  2. tar -xzf bakso-business-lite.tar.gz"
echo "  3. cd bakso-business-lite"
echo "  4. bash setup-lite-node16.sh"
echo ""
echo "=============================================="
