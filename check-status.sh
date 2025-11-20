#!/bin/bash
# Bakso Business - Quick Status Check & Restart Helper
# Usage: bash check-status.sh [restart]

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "========================================"
echo "  Bakso Business - Status Check"
echo "========================================"
echo ""

# Check services
echo -e "${BLUE}[1/5]${NC} Checking services..."
sudo supervisorctl status | grep bakso

echo ""
echo -e "${BLUE}[2/5]${NC} Checking MongoDB..."
if sudo systemctl is-active --quiet mongodb; then
    echo -e "${GREEN}✓${NC} MongoDB is running"
else
    echo -e "${RED}✗${NC} MongoDB is NOT running"
    echo "  Fix: sudo systemctl start mongodb"
fi

echo ""
echo -e "${BLUE}[3/5]${NC} Testing backend API..."
if curl -s http://localhost:8001/api/ | grep -q "Bakso Business" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Backend API responding"
else
    echo -e "${RED}✗${NC} Backend API not responding"
    echo "  Check logs: sudo supervisorctl tail -30 bakso-backend stderr"
fi

echo ""
echo -e "${BLUE}[4/5]${NC} Testing frontend..."
if curl -s http://localhost:3000 | grep -q "html" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Frontend serving"
else
    echo -e "${RED}✗${NC} Frontend not serving"
    echo "  Check logs: sudo supervisorctl tail -30 bakso-frontend stderr"
fi

echo ""
echo -e "${BLUE}[5/5]${NC} System resources..."
USED_MEM=$(free -m | awk 'NR==2{printf "%.0f", $3}')
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.0f", $2}')
PERCENT=$(( USED_MEM * 100 / TOTAL_MEM ))

if [ $PERCENT -lt 70 ]; then
    echo -e "${GREEN}✓${NC} Memory: ${USED_MEM}MB / ${TOTAL_MEM}MB (${PERCENT}%)"
elif [ $PERCENT -lt 85 ]; then
    echo -e "${YELLOW}⚠${NC} Memory: ${USED_MEM}MB / ${TOTAL_MEM}MB (${PERCENT}%) - Getting high"
else
    echo -e "${RED}✗${NC} Memory: ${USED_MEM}MB / ${TOTAL_MEM}MB (${PERCENT}%) - CRITICAL!"
fi

echo ""
echo "========================================"

# Get IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo ""
echo "Access your application:"
echo "  From Pi:        http://localhost:3000"
echo "  From network:   http://${IP_ADDRESS}:3000"
echo ""

# Restart option
if [ "$1" == "restart" ]; then
    echo -e "${YELLOW}Restarting all services...${NC}"
    sudo supervisorctl restart all
    echo ""
    echo "Waiting for services to start..."
    sleep 5
    echo ""
    echo "Services restarted. Checking status..."
    sudo supervisorctl status | grep bakso
    echo ""
    echo -e "${GREEN}Done!${NC} Try accessing the application now."
elif [ "$1" == "logs" ]; then
    echo "=== Backend Logs (last 20 lines) ==="
    sudo supervisorctl tail -20 bakso-backend stderr
    echo ""
    echo "=== Frontend Logs (last 20 lines) ==="
    sudo supervisorctl tail -20 bakso-frontend stderr
else
    echo "Quick commands:"
    echo "  bash check-status.sh restart  - Restart all services"
    echo "  bash check-status.sh logs     - View recent logs"
    echo "  sudo supervisorctl status     - Check service status"
    echo "  sudo supervisorctl restart all - Restart all services"
fi

echo "========================================"
