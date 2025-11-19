# 🔧 Fix: Backend Tidak Bisa Diakses

## 🎯 Gejala

- Frontend terbuka tapi stuck "Memuat..."
- Error: "Tidak bisa terhubung ke backend"
- Input stok tidak bisa
- Dashboard kosong terus

---

## ✅ Solusi Langkah Demi Langkah

### Step 1: Cek Status Backend

```bash
sudo supervisorctl status
```

**Output yang BENAR:**
```
bakso-backend    RUNNING   pid 1234, uptime 0:05:23
bakso-frontend   RUNNING   pid 1235, uptime 0:05:23
```

**Jika STOPPED atau ERROR:**
```bash
sudo supervisorctl restart bakso-backend
sudo supervisorctl restart bakso-frontend
```

---

### Step 2: Cek Logs Backend

```bash
sudo supervisorctl tail -30 bakso-backend stderr
```

**Cari error seperti:**
- `ModuleNotFoundError` → Package belum terinstall
- `Address already in use` → Port 8001 sudah dipakai
- `Connection refused` → MongoDB tidak jalan

---

### Step 3: Test Backend Langsung

```bash
# Test dari Pi sendiri
curl http://localhost:8001/api/

# Test dari IP lokal
curl http://192.168.x.x:8001/api/
```

**Output yang BENAR:**
```json
{"message":"Bakso Business System API"}
```

**Jika gagal:**
- Backend tidak jalan atau crash
- Port tidak accessible

---

### Step 4: Cek MongoDB

```bash
sudo systemctl status mongodb
```

**Jika NOT RUNNING:**
```bash
sudo systemctl start mongodb
sudo systemctl enable mongodb
```

---

### Step 5: Cek Firewall (Jika Akses dari HP/Komputer Lain)

```bash
# Lihat firewall status
sudo ufw status

# Jika active dan blocking, allow port
sudo ufw allow 8001
sudo ufw allow 3000
```

---

## 🔍 Troubleshooting Spesifik

### Masalah: Backend RUNNING tapi tidak bisa diakses

**Cek binding:**
```bash
sudo netstat -tulpn | grep 8001
```

**Output yang BENAR:**
```
tcp  0  0.0.0.0:8001  0.0.0.0:*  LISTEN  1234/python
```

**Jika hanya 127.0.0.1:**
- Backend hanya listen di localhost
- Edit `/etc/supervisor/conf.d/bakso-backend.conf`
- Pastikan: `--host 0.0.0.0`

---

### Masalah: Import Error / ModuleNotFoundError

```bash
cd ~/bakso-business-lite/backend
source venv/bin/activate
pip install -r requirements.txt
deactivate

sudo supervisorctl restart bakso-backend
```

---

### Masalah: MongoDB Connection Error

```bash
# Restart MongoDB
sudo systemctl restart mongodb

# Test koneksi
mongo --eval "db.version()"

# Jika gagal, reinstall
sudo apt remove mongodb -y
sudo apt install mongodb -y
sudo systemctl start mongodb
```

---

### Masalah: Port 8001 Sudah Dipakai

```bash
# Cari proses yang pakai port 8001
sudo lsof -i :8001

# Kill proses (ganti PID dengan hasil di atas)
kill -9 [PID]

# Restart backend
sudo supervisorctl restart bakso-backend
```

---

## 🚀 Reinstall Backend (Jika Semua Gagal)

```bash
# 1. Stop services
sudo supervisorctl stop all

# 2. Reinstall Python dependencies
cd ~/bakso-business-lite/backend
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

# 3. Restart services
sudo supervisorctl start all

# 4. Cek status
sudo supervisorctl status
```

---

## 📱 Akses dari IP Lokal (HP/Komputer Lain)

Jika akses dari **192.168.x.x:3000** dan backend tidak bisa diakses:

### Checklist:
- ✅ Backend RUNNING: `sudo supervisorctl status`
- ✅ Backend bind ke 0.0.0.0: `netstat -tulpn | grep 8001`
- ✅ Firewall allow: `sudo ufw allow 8001`
- ✅ Pi dan HP di WiFi yang SAMA
- ✅ Test: `curl http://[IP-Pi]:8001/api/` dari HP

---

## 🔄 Quick Fix Commands

```bash
# Restart semua services
sudo supervisorctl restart all

# Restart hanya backend
sudo supervisorctl restart bakso-backend

# Cek logs real-time
sudo supervisorctl tail -f bakso-backend stderr

# Test backend
curl http://localhost:8001/api/
```

---

## 💡 Tips Pencegahan

1. **Tunggu 1-2 menit** setelah Pi booting sebelum akses aplikasi
2. **Jangan matikan Pi** secara paksa (shutdown dengan benar)
3. **Monitor memory**: `free -h` (jika RAM penuh, restart Pi)
4. **Backup config**: `cp /etc/supervisor/conf.d/bakso-backend.conf ~/backup-backend.conf`

---

## 📖 Verifikasi Lengkap

Jalankan script ini untuk cek semua komponen:

```bash
#!/bin/bash
echo "=== Bakso Business Health Check ==="
echo ""
echo "1. Supervisor Status:"
sudo supervisorctl status
echo ""
echo "2. Backend Listening:"
sudo netstat -tulpn | grep 8001
echo ""
echo "3. Backend API Test:"
curl -s http://localhost:8001/api/
echo ""
echo "4. MongoDB Status:"
sudo systemctl status mongodb | grep Active
echo ""
echo "5. Memory Usage:"
free -h
echo ""
echo "=== Health Check Complete ==="
```

Save sebagai `check-health.sh`, jalankan dengan `bash check-health.sh`

---

## 🆘 Masih Tidak Bisa?

Jika semua cara di atas sudah dicoba:

1. **Screenshot error** dari browser Console (F12)
2. **Copy logs**: `sudo supervisorctl tail -50 bakso-backend stderr > ~/backend-error.log`
3. **Cek IP Pi**: `hostname -I`
4. **Test koneksi**: `ping [IP-Pi]` dari HP

Kemungkinan perlu **reinstall ulang** dengan `bash setup-lite-node16.sh`

---

**✅ Dalam 99% kasus, masalahnya adalah backend belum start atau MongoDB belum jalan!**

Cek dengan: `sudo supervisorctl status` dan pastikan semua RUNNING.
