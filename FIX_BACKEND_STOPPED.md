# 🚨 FIX: Backend STOPPED (Paling Sering Terjadi!)

## 🎯 Masalah

```bash
sudo supervisorctl status

# Output:
bakso-backend    STOPPED    # ← MASALAH INI!
bakso-frontend   RUNNING
```

**Gejala:**
- Frontend loading stuck "Memuat..."
- Error: "Tidak bisa terhubung ke backend"
- `sudo supervisorctl status` menunjukkan backend **STOPPED**
- Harus restart terus-terusan

---

## 🔍 Kenapa Backend STOPPED?

### Penyebab Umum (Sorted by Frequency):

#### 1. **MongoDB Tidak Jalan** (80% kasus)

Backend butuh MongoDB. Jika MongoDB stop, backend langsung crash.

**Check:**
```bash
sudo systemctl status mongodb
```

**Fix:**
```bash
sudo systemctl start mongodb
sudo systemctl enable mongodb  # Auto-start on boot
sudo supervisorctl restart bakso-backend
```

---

#### 2. **Python Dependencies Missing** (10% kasus)

Package Python belum terinstall atau corrupt.

**Check logs:**
```bash
sudo supervisorctl tail -50 bakso-backend stderr
```

**Cari error seperti:**
```
ModuleNotFoundError: No module named 'fastapi'
ModuleNotFoundError: No module named 'motor'
ModuleNotFoundError: No module named 'openpyxl'
```

**Fix:**
```bash
cd ~/bakso-business-lite/backend
source venv/bin/activate
pip install -r requirements.txt
deactivate

sudo supervisorctl restart bakso-backend
```

---

#### 3. **Port 8001 Already in Use** (5% kasus)

Port 8001 dipakai proses lain.

**Check:**
```bash
sudo lsof -i :8001
```

**Output contoh:**
```
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
python  1234 pi    3u  IPv4  12345      0t0  TCP *:8001 (LISTEN)
```

**Fix:**
```bash
# Kill proses yang pakai port 8001
sudo kill -9 1234

# Restart backend
sudo supervisorctl restart bakso-backend
```

---

#### 4. **Memory Habis** (3% kasus - Pi 3B only)

Pi 3B cuma punya 1GB RAM.

**Check:**
```bash
free -m
```

**Output contoh:**
```
              total  used  free
Mem:           923   891    32  ← CRITICAL!
```

**Fix:**
```bash
# Restart Pi untuk clear memory
sudo reboot
```

**Prevention:**
```bash
# Disable swap thrashing
sudo dphys-swapfile swapoff
sudo dphys-swapfile swapon
```

---

#### 5. **Environment Variables Missing** (2% kasus)

Backend butuh MONGO_URL dan DB_NAME.

**Check config:**
```bash
cat /etc/supervisor/conf.d/bakso-backend.conf
```

**Should have:**
```ini
environment=MONGO_URL="mongodb://localhost:27017",DB_NAME="bakso_business",CORS_ORIGINS="*"
```

**If missing, fix:**
```bash
sudo nano /etc/supervisor/conf.d/bakso-backend.conf
# Add environment line above

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart bakso-backend
```

---

## ✅ PERBAIKAN DI UPDATE TERBARU

### 1. **Pre-flight Checks Script** (NEW!)

**File:** `start-backend.sh`

Backend sekarang gunakan wrapper script yang check semua dependency sebelum start:

```bash
[1/4] Checking MongoDB...
  ✓ MongoDB is running and accessible

[2/4] Checking Python environment...
  ✓ Python environment OK

[3/4] Checking Python dependencies...
  ✓ Dependencies OK

[4/4] Checking environment variables...
  ✓ Environment: MONGO_URL=mongodb://localhost:27017

Testing MongoDB connection...
  ✓ MongoDB connection test passed

✓ All pre-flight checks passed!
Starting FastAPI backend...
```

**Benefit:**
- ✅ Detect masalah SEBELUM backend start
- ✅ Clear error message jika ada dependency missing
- ✅ Auto-install dependencies jika kurang
- ✅ Test MongoDB connection dulu

---

### 2. **Better Logging** (NEW!)

**File:** `backend/server.py`

Backend sekarang log semua:
- Environment variables
- MongoDB connection status
- Available collections
- Startup errors dengan detail

**Check logs:**
```bash
sudo supervisorctl tail -f bakso-backend stdout
```

**Output contoh:**
```
2025-11-20 05:30:15 - INFO - Connecting to MongoDB: mongodb://localhost:27017
2025-11-20 05:30:15 - INFO - Database name: bakso_business
2025-11-20 05:30:15 - INFO - MongoDB client created successfully
2025-11-20 05:30:16 - INFO - ✓ MongoDB connection successful!
2025-11-20 05:30:16 - INFO - Available collections: ['products', 'stocks', 'transactions']
2025-11-20 05:30:16 - INFO - Application startup complete.
```

---

### 3. **Auto-retry & Better Config** (IMPROVED!)

**Supervisor config updated:**
```ini
startsecs=15          # ← Wait 15 detik (backend butuh waktu startup)
startretries=3        # ← Retry 3x jika gagal
autorestart=true      # ← Auto-restart jika crash
priority=100          # ← Start DULUAN (sebelum frontend)
redirect_stderr=true  # ← Gabung error & info logs
```

---

## 🔧 Quick Fix Flowchart

```
Backend STOPPED?
    ↓
1. Check MongoDB
   sudo systemctl status mongodb
    ↓ (NOT RUNNING)
   sudo systemctl start mongodb
   sudo supervisorctl restart bakso-backend
   ✓ DONE!

    ↓ (RUNNING)
2. Check Logs
   sudo supervisorctl tail -50 bakso-backend stderr
    ↓
   ModuleNotFoundError?
    ↓ (YES)
   cd ~/bakso-business-lite/backend
   source venv/bin/activate
   pip install -r requirements.txt
   deactivate
   sudo supervisorctl restart bakso-backend
   ✓ DONE!

    ↓ (NO ERROR IN LOGS)
3. Check Port 8001
   sudo lsof -i :8001
    ↓ (PROCESS FOUND)
   sudo kill -9 [PID]
   sudo supervisorctl restart bakso-backend
   ✓ DONE!

    ↓ (PORT FREE)
4. Reinstall Backend
   cd ~/bakso-business-lite/backend
   rm -rf venv
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   deactivate
   sudo supervisorctl restart bakso-backend
   ✓ DONE!
```

---

## 📝 Helper Commands (Copy-Paste Friendly)

### Full Diagnostic:
```bash
echo "=== Backend Diagnostic ==="
echo ""
echo "1. Backend Status:"
sudo supervisorctl status bakso-backend
echo ""
echo "2. MongoDB Status:"
sudo systemctl status mongodb | grep Active
echo ""
echo "3. Backend Logs (last 20 lines):"
sudo supervisorctl tail -20 bakso-backend stderr
echo ""
echo "4. Port 8001 Usage:"
sudo lsof -i :8001
echo ""
echo "5. Memory Usage:"
free -m
echo ""
echo "6. Backend API Test:"
curl -s http://localhost:8001/api/
echo ""
```

---

### Complete Fix (All-in-One):
```bash
#!/bin/bash
echo "Fixing backend..."

# 1. Start MongoDB
sudo systemctl start mongodb
sudo systemctl enable mongodb

# 2. Reinstall dependencies
cd ~/bakso-business-lite/backend
if [ -d venv ]; then
    source venv/bin/activate
    pip install -r requirements.txt --quiet
    deactivate
fi

# 3. Kill any process on port 8001
PID=$(sudo lsof -t -i:8001)
if [ ! -z "$PID" ]; then
    sudo kill -9 $PID
fi

# 4. Restart backend
sudo supervisorctl restart bakso-backend

# 5. Wait and check
sleep 5
sudo supervisorctl status bakso-backend

# 6. Test API
echo ""
echo "Testing backend API..."
curl -s http://localhost:8001/api/
echo ""
```

**Save as:** `fix-backend.sh` dan run: `bash fix-backend.sh`

---

## 🎯 Prevention Tips

### 1. **Auto-start MongoDB on Boot**
```bash
sudo systemctl enable mongodb
```

### 2. **Monitor Backend Status**
```bash
# Add to crontab: Check every 5 minutes
crontab -e

# Add this line:
*/5 * * * * sudo supervisorctl status bakso-backend | grep -q STOPPED && sudo supervisorctl restart bakso-backend
```

### 3. **Set Watchdog**

Create `/etc/supervisor/conf.d/bakso-watchdog.conf`:
```ini
[eventlistener:bakso-watchdog]
command=/usr/bin/supervisorctl restart bakso-backend
events=PROCESS_STATE_STOPPED
```

---

## 🆘 Still STOPPED After All Fixes?

### Last Resort: Complete Reinstall

```bash
# 1. Backup data
mongodump --db bakso_business --out ~/backup-$(date +%Y%m%d)

# 2. Stop all
sudo supervisorctl stop all

# 3. Remove old installation
cd ~
rm -rf bakso-business-lite

# 4. Extract fresh
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite

# 5. Run setup again
bash setup-lite-node16.sh

# 6. Wait 10-15 minutes

# 7. Restore data
mongorestore ~/backup-[tanggal]/bakso_business

# 8. Check status
bash check-status.sh
```

---

## 📖 Read Logs Like a Pro

### Good Logs (Backend Running):
```
INFO - ✓ MongoDB connection successful!
INFO - Available collections: [...]
INFO - Application startup complete
INFO - Uvicorn running on http://0.0.0.0:8001
```

### Bad Logs (Need Fix):
```
ERROR - Cannot connect to MongoDB        ← Start MongoDB!
ERROR - ModuleNotFoundError: 'fastapi'   ← Install dependencies!
ERROR - Address already in use           ← Kill process on port 8001!
ERROR - Cannot allocate memory           ← Restart Pi (memory full)!
```

---

**✅ Update terbaru include pre-flight checks yang akan detect masalah sebelum backend start!**

Dengan update ini, backend akan jelas kasih tahu masalahnya apa sehingga mudah di-fix! 🎉
