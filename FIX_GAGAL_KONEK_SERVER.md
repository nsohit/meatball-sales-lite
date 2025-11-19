# 🔧 Fix: Gagal Konek ke Server

## 🚨 Error yang Muncul

Screenshot menunjukkan 2 masalah:

1. **"Low voltage warning"** - Masalah power supply
2. **"Tidak bisa terhubung ke server. Silakan cek koneksi"** - Backend error

---

## ✅ SOLUSI - Step by Step

### **Step 1: Fix Power Supply Dulu** ⚡

**Low voltage warning** bisa bikin Pi tidak stabil dan services mati.

```bash
# Check power
vcgencmd get_throttled
# Output 0x0 = OK
# Output lain = Ada throttling/undervoltage
```

**Fix:**
1. Gunakan adaptor 5V 3A (minimal 2.5A)
2. Ganti kabel USB yang lebih bagus
3. Colok langsung ke wall socket (jangan pakai hub)
4. Reboot Pi setelah power stable

```bash
sudo reboot
```

---

### **Step 2: Check Backend Service** 🔍

Setelah power stable, cek apakah backend running:

```bash
# Check service status
sudo supervisorctl status bakso-backend

# Expected output:
# bakso-backend    RUNNING   pid 1234, uptime 0:10:23

# Jika STOPPED atau ERROR:
sudo supervisorctl restart bakso-backend
```

#### **Check Backend Logs**

```bash
# Lihat error di logs
sudo supervisorctl tail bakso-backend stderr

# Atau full logs
sudo supervisorctl tail -f bakso-backend
```

**Common Errors:**

❌ **"MongoDB connection failed"**
```bash
# Fix: Restart MongoDB
sudo systemctl restart mongodb
sudo supervisorctl restart bakso-backend
```

❌ **"Port 8001 already in use"**
```bash
# Fix: Kill process yang pakai port
sudo lsof -i :8001
sudo kill -9 [PID]
sudo supervisorctl restart bakso-backend
```

❌ **"ImportError" atau "ModuleNotFoundError"**
```bash
# Fix: Reinstall dependencies
cd ~/bakso-business-lite/backend
source venv/bin/activate
pip install -r requirements.txt
deactivate
sudo supervisorctl restart bakso-backend
```

---

### **Step 3: Test Backend API** 🧪

```bash
# Test dari Pi sendiri
curl http://localhost:8001/api/

# Expected response:
# {"message":"Bakso Business API"}

# Jika error "Connection refused":
# Backend tidak running, check logs!
```

---

### **Step 4: Check Network** 🌐

```bash
# Check Pi IP address
hostname -I
# Example: 192.168.1.23

# Test dari komputer lain (bukan Pi)
curl http://192.168.1.23:8001/api/

# Jika tidak bisa dari luar:
# - Check firewall
# - Check backend bind address (harus 0.0.0.0)
```

---

### **Step 5: Check Frontend Config** ⚙️

Frontend harus tahu backend URL yang benar:

```bash
# Cek environment variable
cat ~/bakso-business-lite/frontend/build/.env 2>/dev/null

# Atau check langsung di browser console (F12)
# Harus muncul: Backend URL: http://localhost:8001
```

**Jika URL salah atau tidak ada:**

Frontend seharusnya pakai fallback `http://localhost:8001` (sudah di-code).

---

## 🎯 Quick Fix - All in One

```bash
# 1. Restart semua services
sudo systemctl restart mongodb
sudo supervisorctl restart all

# 2. Wait 5 seconds
sleep 5

# 3. Check status
sudo supervisorctl status

# 4. Test backend
curl http://localhost:8001/api/

# 5. Refresh browser
# Ctrl + Shift + R
```

---

## 🔍 Diagnostic Commands

### **Full System Check**

```bash
echo "=== System Status ==="
vcgencmd get_throttled
echo ""

echo "=== Services Status ==="
sudo supervisorctl status
echo ""

echo "=== MongoDB Status ==="
sudo systemctl status mongodb --no-pager
echo ""

echo "=== Backend Test ==="
curl -s http://localhost:8001/api/ || echo "Backend NOT accessible"
echo ""

echo "=== Frontend Test ==="
curl -s http://localhost:3000 | head -n 5 || echo "Frontend NOT accessible"
echo ""

echo "=== Network ==="
hostname -I
echo ""

echo "=== Ports ==="
sudo ss -tlnp | grep -E ":(3000|8001|27017)"
```

**Save output & share jika masih error!**

---

## 📋 Troubleshooting Matrix

| Symptom | Probable Cause | Solution |
|---------|----------------|----------|
| Low voltage warning | Adaptor lemah | Ganti adaptor 5V 3A |
| Backend STOPPED | Service crashed | `sudo supervisorctl restart bakso-backend` |
| MongoDB error | MongoDB not running | `sudo systemctl restart mongodb` |
| Port error | Port already used | Kill process: `sudo lsof -i :8001` |
| Import error | Missing packages | Reinstall: `pip install -r requirements.txt` |
| Connection refused | Backend not running | Start backend: `supervisorctl start bakso-backend` |
| Network error | Firewall blocking | Check firewall or backend bind address |

---

## 🚑 Emergency Fix

Jika semua cara tidak work, reinstall:

```bash
# 1. Backup database
mongodump --db bakso_business --out ~/backup

# 2. Uninstall
cd ~/bakso-business-lite
bash uninstall.sh

# 3. Reinstall
cd ~
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh

# 4. Wait 8-10 minutes
# 5. Test again
```

---

## ✅ Success Indicators

Setelah fix, cek ini semua ✓:

```bash
# 1. No undervoltage
vcgencmd get_throttled
# Output: throttled=0x0

# 2. Services running
sudo supervisorctl status
# Output: 
# bakso-backend    RUNNING
# bakso-frontend   RUNNING

# 3. Backend accessible
curl http://localhost:8001/api/
# Output: {"message":"Bakso Business API"}

# 4. Frontend accessible
curl http://localhost:3000
# Output: <!doctype html>...

# 5. Browser test
# http://[IP]:3000
# No error "Tidak bisa terhubung ke server"
```

---

## 💡 Prevention

Untuk prevent error ini di masa depan:

### **1. Power Supply yang Benar**

```
✓ Use official Raspberry Pi power supply
✓ Or quality 5V 3A adaptor
✓ Good quality USB cable (short is better)
✓ Plug directly to wall socket
```

### **2. Auto Restart on Failure**

Services sudah configured untuk auto-restart, tapi bisa enhance:

```bash
# Add watchdog untuk restart jika hang
sudo apt install -y watchdog

# Config
sudo nano /etc/watchdog.conf
# Uncomment:
# watchdog-device = /dev/watchdog
# max-load-1 = 24

sudo systemctl enable watchdog
sudo systemctl start watchdog
```

### **3. Monitoring**

```bash
# Create monitoring script
cat > ~/monitor-bakso.sh << 'EOF'
#!/bin/bash
# Check if services running
if ! curl -s http://localhost:8001/api/ > /dev/null; then
    echo "Backend down! Restarting..."
    sudo supervisorctl restart bakso-backend
fi

if ! curl -s http://localhost:3000 > /dev/null; then
    echo "Frontend down! Restarting..."
    sudo supervisorctl restart bakso-frontend
fi
EOF

chmod +x ~/monitor-bakso.sh

# Add to cron (check every 5 minutes)
crontab -e
# Add: */5 * * * * /home/pi/monitor-bakso.sh >> /home/pi/monitor.log 2>&1
```

---

## 📞 Still Having Issues?

Jika masih error setelah semua step:

1. **Capture logs:**
   ```bash
   sudo supervisorctl tail bakso-backend stderr > ~/backend-error.log
   sudo supervisorctl tail bakso-frontend stderr > ~/frontend-error.log
   ```

2. **Share info:**
   - Screenshot error
   - Output dari `sudo supervisorctl status`
   - Content dari error logs
   - Output dari `vcgencmd get_throttled`

3. **Ask for help** dengan info di atas

---

## 🎊 Summary Fix

**Quick Fix Commands:**

```bash
# Fix power (manual: ganti adaptor)
sudo reboot

# After reboot, fix services
sudo systemctl restart mongodb
sudo supervisorctl restart all

# Test
curl http://localhost:8001/api/

# Refresh browser: Ctrl + Shift + R
```

**Result:**
- ✓ No low voltage warning
- ✓ Backend accessible
- ✓ No "Gagal konek ke server" error
- ✓ Form input muncul & work

🚀 **Good luck!**
