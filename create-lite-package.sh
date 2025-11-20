#!/bin/bash
# Script untuk membuat paket lite lengkap untuk Raspberry Pi 3B
# Jalankan di komputer dengan RAM cukup (minimal 2GB)

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=============================================="
echo "  Bakso Business - Lite Package Creator"
echo "=============================================="
echo ""

# Check if we're in the right directory
if [ ! -f "setup-lite.sh" ] || [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo -e "${YELLOW}Error: Harus dijalankan dari root directory project${NC}"
    exit 1
fi

# Step 1: Build frontend untuk Raspberry Pi
echo -e "${BLUE}[1/4]${NC} Building frontend for Raspberry Pi..."
cd frontend

if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    yarn install
fi

# Backup .env original
if [ -f .env ]; then
    cp .env .env.backup
fi

# Create .env.production khusus untuk Pi (force localhost untuk trigger dynamic detection)
echo "Creating .env.production for Raspberry Pi..."
cat > .env.production << EOF
# Production build untuk Raspberry Pi
# URL ini akan di-override oleh dynamic detection di runtime
REACT_APP_BACKEND_URL=http://localhost:8001
WDS_SOCKET_PORT=443
REACT_APP_ENABLE_VISUAL_EDITS=false
ENABLE_HEALTH_CHECK=false
EOF

echo "Building production bundle (with Pi-specific config)..."
yarn build

# Restore .env original
if [ -f .env.backup ]; then
    mv .env.backup .env
fi

cd ..
echo -e "${GREEN}✓${NC} Frontend build complete"
echo ""

# Step 2: Create frontend tarball
echo -e "${BLUE}[2/4]${NC} Creating frontend tarball..."
tar -czf frontend-build.tar.gz -C frontend build/
SIZE=$(du -h frontend-build.tar.gz | cut -f1)
echo -e "${GREEN}✓${NC} Created frontend-build.tar.gz ($SIZE)"
echo ""

# Step 3: Create complete package
echo -e "${BLUE}[3/4]${NC} Creating complete lite package..."

# Create temporary directory
TEMP_DIR="bakso-business-lite"
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

# Copy necessary files
cp setup-lite.sh $TEMP_DIR/
cp setup-lite-node16.sh $TEMP_DIR/
cp uninstall.sh $TEMP_DIR/
cp frontend-build.tar.gz $TEMP_DIR/
cp README.md $TEMP_DIR/ 2>/dev/null || true
cp RASPBERRY_PI_3B_LITE.md $TEMP_DIR/README.md
cp FIX_SERING_TIDAK_KONEK.md $TEMP_DIR/README_PENTING.md 2>/dev/null || true
cp AKSES_LOKAL_TANPA_INTERNET.md $TEMP_DIR/ 2>/dev/null || true
cp FIX_BACKEND_NOT_ACCESSIBLE.md $TEMP_DIR/ 2>/dev/null || true
cp TROUBLESHOOTING_NODE_ERROR.md $TEMP_DIR/ 2>/dev/null || true
cp WHICH_SCRIPT_TO_USE.md $TEMP_DIR/ 2>/dev/null || true
cp CARA_INSTALL_ULANG.md $TEMP_DIR/ 2>/dev/null || true
cp FIX_FORM_TIDAK_MUNCUL.md $TEMP_DIR/ 2>/dev/null || true

# Copy backend
mkdir -p $TEMP_DIR/backend
cp backend/server.py $TEMP_DIR/backend/
cp backend/requirements.txt $TEMP_DIR/backend/

# Create frontend directory structure (empty, will be populated by script)
mkdir -p $TEMP_DIR/frontend

# Create archive
tar -czf bakso-business-lite.tar.gz $TEMP_DIR/
SIZE=$(du -h bakso-business-lite.tar.gz | cut -f1)
echo -e "${GREEN}✓${NC} Created bakso-business-lite.tar.gz ($SIZE)"
echo ""

# Cleanup
rm -rf $TEMP_DIR

# Step 4: Summary
echo -e "${BLUE}[4/4]${NC} Package ready!"
echo ""
echo "=============================================="
echo -e "${GREEN}  ✓ Lite Package Created Successfully!${NC}"
echo "=============================================="
echo ""
echo "File yang dibuat:"
echo "  1. frontend-build.tar.gz ($SIZE)"
echo "  2. bakso-business-lite.tar.gz"
echo ""
echo "Cara menggunakan di Raspberry Pi 3B:"
echo ""
echo "  1. Copy file ke Pi:"
echo "     scp bakso-business-lite.tar.gz pi@[IP-PI]:~/"
echo ""
echo "  2. Di Raspberry Pi, extract dan jalankan:"
echo "     tar -xzf bakso-business-lite.tar.gz"
echo "     cd bakso-business-lite"
echo ""
echo "     # Pilih salah satu:"
echo "     bash setup-lite-node16.sh  # Recommended! (Tanpa Node.js)"
echo "     # ATAU"
echo "     bash setup-lite.sh         # Dengan Node.js 18+"
echo ""
echo "  3. Tunggu 10-15 menit, selesai!"
echo ""
echo "=============================================="
