# 🚨 Quick Fix: Backend Tidak Bisa Diakses

## Untuk User yang Aplikasinya Stuck "Memuat..."

Berdasarkan screenshot Anda, frontend sudah jalan di **192.168.189.147:3000** tapi backend tidak bisa diakses.

---

## ✅ Solusi Cepat (5 Menit)

### Step 1: Cek Status Backend

Buka Terminal di Raspberry Pi, ketik:

```bash
sudo supervisorctl status
```

**Jika hasilnya:**
```
bakso-backend    STOPPED
```

Maka backend tidak jalan! **Restart:**

```bash
sudo supervisorctl restart all
```

**Tunggu 30 detik**, lalu refresh browser.

---

### Step 2: Test Backend Langsung

```bash
curl http://localhost:8001/api/
```

**Jika muncul:**
```json
{"message":"Bakso Business System API"}
```

✅ **Backend jalan!** Tapi mungkin ada masalah firewall atau binding.

**Jika error:**
```
curl: (7) Failed to connect
```

❌ **Backend tidak jalan**. Lanjut ke Step 3.

---

### Step 3: Cek Logs Backend

```bash
sudo supervisorctl tail -30 bakso-backend stderr
```

**Cari error:**
- `ModuleNotFoundError: No module named 'fastapi'` → Reinstall packages
- `Address already in use` → Port 8001 dipakai proses lain
- `Connection to database failed` → MongoDB tidak jalan

---

### Step 4: Restart MongoDB (Jika Backend Error Database)

```bash
sudo systemctl restart mongodb
sudo supervisorctl restart bakso-backend
```

---

## 🔥 Solusi Nuclear (Jika Semua Gagal)

### Reinstall Python Dependencies:

```bash
cd ~/bakso-business-lite/backend
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate

sudo supervisorctl restart all
```

**Tunggu 2 menit**, lalu refresh browser.

---

## 📱 Jika Akses dari HP (Bukan Pi)

Kalau Anda buka browser di HP dan ketik **192.168.189.147:3000**:

### Checklist:
1. ✅ Backend harus bind ke **0.0.0.0** (bukan hanya localhost)
2. ✅ Firewall harus allow port 8001
3. ✅ Pi dan HP harus di WiFi yang SAMA

### Test dari HP:

Buka browser di HP, ketik:
```
http://192.168.189.147:8001/api/
```

**Jika muncul JSON** → Backend accessible ✅  
**Jika error/timeout** → Backend tidak accessible dari network ❌

### Fix Backend Binding:

```bash
# Edit config backend
sudo nano /etc/supervisor/conf.d/bakso-backend.conf
```

Pastikan baris `command` ada `--host 0.0.0.0`:
```
command=/home/pi/bakso-business-lite/backend/venv/bin/uvicorn server:app --host 0.0.0.0 --port 8001 --workers 1
```

Save (Ctrl+O, Enter, Ctrl+X), lalu:
```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart bakso-backend
```

---

## 🎯 Akses yang Benar

### Dari Raspberry Pi sendiri:
```
http://localhost:3000
```
Backend akan diakses di: `http://localhost:8001`

### Dari HP/Komputer lain:
```
http://192.168.189.147:3000
```
Backend akan diakses di: `http://192.168.189.147:8001`

Keduanya harus work jika backend bind ke 0.0.0.0!

---

## 📋 Command Lengkap untuk Copy-Paste

```bash
# 1. Cek status
sudo supervisorctl status

# 2. Restart semua
sudo supervisorctl restart all

# 3. Cek backend API
curl http://localhost:8001/api/

# 4. Cek logs
sudo supervisorctl tail -f bakso-backend stderr

# 5. Jika perlu restart MongoDB
sudo systemctl restart mongodb

# 6. Cek port 8001
sudo netstat -tulpn | grep 8001
```

---

## 💡 Update Package Baru

File `bakso-business-lite.tar.gz` yang BARU sudah include:

1. ✅ **Error handling lebih baik** - Pesan error yang jelas
2. ✅ **Loading state** yang informatif
3. ✅ **Timeout 10 detik** (tidak stuck forever)
4. ✅ **Dokumentasi lengkap** troubleshooting

### Cara Install Update:

```bash
# 1. Backup data (jika ada)
mongodump --db bakso_business --out ~/backup-$(date +%Y%m%d)

# 2. Stop services
cd ~/bakso-business-lite
sudo supervisorctl stop all

# 3. Extract update baru
cd ~
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite

# 4. Jalankan setup lagi
bash setup-lite-node16.sh

# 5. Restore data
mongorestore ~/backup-[tanggal]/bakso_business
```

---

## 🆘 Butuh Bantuan Lebih?

Baca file ini di package baru:
- **`FIX_BACKEND_NOT_ACCESSIBLE.md`** - Troubleshooting lengkap
- **`AKSES_LOKAL_TANPA_INTERNET.md`** - Panduan akses aplikasi

**Paling sering:**
- Backend belum start → `sudo supervisorctl restart all`
- MongoDB not running → `sudo systemctl start mongodb`
- Tunggu 1-2 menit setelah Pi boot

---

**✅ Dalam 99% kasus, restart services akan fix masalah!**
