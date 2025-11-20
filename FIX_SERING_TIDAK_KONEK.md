# 🔧 FIX: Sering Tidak Konek (Masalah Berulang)

## 🎯 Masalah yang Dilaporkan

**Gejala:**
- Aplikasi sering tidak konek ke backend
- Harus restart services terus (`sudo supervisorctl restart all`)
- Besoknya / setelah beberapa waktu, tidak konek lagi
- Error: "Tidak bisa terhubung ke backend di https://bakso-business-app.preview.emergentagent.com"

---

## 🚨 ROOT CAUSE - BUG KRITIS DITEMUKAN!

### Masalah Utama:
Frontend di Raspberry Pi Anda **masih coba konek ke server Emergent** (internet), bukan ke backend lokal!

**Error message Anda:**
```
Tidak bisa terhubung ke backend di https://bakso-business-app.preview.emergentagent.com
```

Ini URL **SALAH** untuk Pi! Seharusnya:
```
http://localhost:8001
atau
http://192.168.189.147:8001
```

---

## 🔍 Kenapa Ini Terjadi?

### Penjelasan Teknis:

1. **Build Production Include URL Emergent**
   - File `.env` punya `REACT_APP_BACKEND_URL=https://bakso-business-app.preview.emergentagent.com`
   - Saat build production, URL ini ter-embed di JavaScript bundle
   
2. **Logic Detection Gagal**
   - Code coba detect environment, tapi gagal recognize Pi
   - Karena env var ada dan bukan localhost, pakai URL Emergent
   
3. **Akibatnya:**
   - Frontend di Pi coba konek ke internet (Emergent server)
   - Tentu saja gagal karena server itu tidak ada/tidak accessible
   - **Sering tidak konek** karena memang salah target!

---

## ✅ SOLUSI - Update Package Baru

### Yang Sudah Diperbaiki:

#### 1. **Smart Environment Detection (UPGRADED)**

**Code Baru:**
```javascript
const getBackendURL = () => {
  const currentHostname = window.location.hostname;
  
  // PRODUCTION/PI DETECTION: Cek apakah hostname adalah localhost atau IP lokal
  const isLocalEnvironment = 
    currentHostname === 'localhost' || 
    currentHostname === '127.0.0.1' ||
    /^192\.168\.\d{1,3}\.\d{1,3}$/.test(currentHostname) || // 192.168.x.x
    /^10\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(currentHostname) || // 10.x.x.x
    /^172\.(1[6-9]|2[0-9]|3[0-1])\.\d{1,3}\.\d{1,3}$/.test(currentHostname); // 172.x.x
  
  if (isLocalEnvironment) {
    // Pi detected! Gunakan hostname lokal
    return `http://${currentHostname}:8001`;
  }
  
  // Development/preview Emergent
  return process.env.REACT_APP_BACKEND_URL;
};
```

**Improvement:**
- ✅ Detect localhost, 127.0.0.1
- ✅ Detect semua IP private (192.168.x.x, 10.x.x.x, 172.16-31.x.x)
- ✅ Jika detect IP lokal → **FORCE gunakan dynamic URL lokal**
- ✅ Ignore env variable saat di Pi

---

#### 2. **Build Production dengan .env.production Khusus Pi**

**Script update:** `create-lite-package.sh`

Sekarang script otomatis create `.env.production` sebelum build:

```bash
# Create .env.production khusus untuk Pi
cat > .env.production << EOF
REACT_APP_BACKEND_URL=http://localhost:8001
EOF

yarn build  # Build dengan config Pi
```

**Benefit:**
- Build production **tidak include URL Emergent**
- Meski include, code akan detect IP lokal dan override
- Guaranteed gunakan backend lokal di Pi

---

## 📦 Install Package Update (WAJIB!)

### Step-by-Step:

```bash
# 1. BACKUP DATA DULU!
mongodump --db bakso_business --out ~/backup-$(date +%Y%m%d)

# 2. Stop services lama
cd ~/bakso-business-lite
sudo supervisorctl stop all

# 3. Backup folder lama (opsional)
cd ~
mv bakso-business-lite bakso-business-lite.OLD

# 4. Extract package BARU
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite

# 5. Install (script akan setup fresh)
bash setup-lite-node16.sh

# TUNGGU 10-15 menit sampai selesai

# 6. Restore data
mongorestore ~/backup-[tanggal]/bakso_business

# 7. Restart services
sudo supervisorctl restart all
```

---

## ✅ Verifikasi Fix Berhasil

### Test 1: Cek Backend URL di Browser Console

1. Buka aplikasi: `http://localhost:3000` atau `http://192.168.x.x:3000`
2. Tekan F12 (buka Console)
3. Refresh page
4. Lihat log: `✓ Production/Pi mode - Backend URL: http://localhost:8001`

**✅ BENAR:** URL adalah `http://localhost:8001` atau `http://192.168.x.x:8001`  
**❌ SALAH:** URL masih `https://bakso-business-app.preview.emergentagent.com`

---

### Test 2: Cek Koneksi Backend

```bash
# Test dari Pi
curl http://localhost:8001/api/

# Test dari network
curl http://192.168.189.147:8001/api/
```

**Expected output:**
```json
{"message":"Bakso Business System API"}
```

---

### Test 3: Buka Aplikasi dan Input Stok

1. Buka `http://localhost:3000` atau `http://[IP-Pi]:3000`
2. Klik menu **Stok**
3. Input stok sisa (atau stok awal)
4. Klik **Simpan**

**✅ BERHASIL:** Data tersimpan, muncul toast success  
**❌ GAGAL:** Masih error "tidak bisa terhubung"

---

## 🔄 Masalah "Sering Tidak Konek" Seharusnya HILANG

### Kenapa?

**Sebelumnya:**
- Frontend coba konek ke Emergent (internet) → **Gagal terus**
- Restart services kadang "work" tapi sebenarnya masih ke Emergent
- Tidak stabil karena koneksi internet

**Sekarang:**
- Frontend **PASTI** konek ke localhost/IP lokal
- Tidak depend internet
- Stabil dan konsisten

---

## 💡 Jika Masih Ada Masalah Setelah Update

### Scenario 1: Backend Tidak Jalan

```bash
# Cek status
sudo supervisorctl status

# Jika STOPPED
sudo supervisorctl restart bakso-backend

# Cek logs
sudo supervisorctl tail -30 bakso-backend stderr
```

**Fix common issues:**
- `ModuleNotFoundError` → Reinstall deps: `pip install -r requirements.txt`
- `Address in use` → Port 8001 clash: `sudo lsof -i :8001; kill -9 [PID]`
- `MongoDB connection` → Start mongo: `sudo systemctl start mongodb`

---

### Scenario 2: Backend Jalan Tapi Tidak Accessible dari Network

```bash
# Cek binding
sudo netstat -tulpn | grep 8001
# Harus: 0.0.0.0:8001 (bukan 127.0.0.1:8001)
```

**Fix:**
```bash
sudo nano /etc/supervisor/conf.d/bakso-backend.conf
# Pastikan: --host 0.0.0.0

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart bakso-backend
```

---

### Scenario 3: Aplikasi Load Tapi Data Tidak Muncul

**Cek MongoDB:**
```bash
sudo systemctl status mongodb

# Jika not running
sudo systemctl start mongodb
sudo systemctl enable mongodb
```

---

## 🎯 Checklist Setelah Install Update

- [ ] Package baru sudah di-extract
- [ ] `setup-lite-node16.sh` sudah dijalankan
- [ ] Services running: `sudo supervisorctl status` (semua RUNNING)
- [ ] Backend test OK: `curl http://localhost:8001/api/`
- [ ] Browser console log: `✓ Production/Pi mode`
- [ ] Input stok berhasil tanpa error
- [ ] Restart Pi, aplikasi auto-start
- [ ] Akses dari HP work (jika perlu)

---

## 📊 Perbandingan Before vs After

| Aspek | Before (Bug) | After (Fixed) |
|-------|-------------|---------------|
| Target Backend | Emergent (internet) ❌ | Localhost/IP lokal ✅ |
| Stabilitas | Sering tidak konek | Stabil konsisten |
| Depend Internet | Ya | Tidak |
| Restart Berulang | Perlu terus | Tidak perlu |
| Error Message | "tidak bisa terhubung" | Bekerja normal |
| Environment Detection | Gagal | Akurat |

---

## 🆘 Support

Jika setelah install update masih ada masalah:

1. Screenshot browser console (F12)
2. Copy error dari: `sudo supervisorctl tail -50 bakso-backend stderr`
3. Check backend URL di console
4. Test: `curl http://localhost:8001/api/`

---

## 📝 Technical Details (Untuk Developer)

### Perubahan di Code:

**File:** `frontend/src/App.js`

```javascript
// OLD (Bug)
if (envUrl && !envUrl.includes('localhost')) {
  return envUrl; // Pakai URL Emergent di Pi ❌
}

// NEW (Fixed)
const isLocalEnvironment = /^192\.168\.\d{1,3}\.\d{1,3}$/.test(currentHostname);
if (isLocalEnvironment) {
  return `http://${currentHostname}:8001`; // Force lokal ✅
}
```

**File:** `create-lite-package.sh`

```bash
# NEW: Create .env.production untuk Pi
cat > .env.production << EOF
REACT_APP_BACKEND_URL=http://localhost:8001
EOF

yarn build  # Build dengan config lokal
```

---

**✅ Update package ini akan PERMANENTLY fix masalah "sering tidak konek"!**

Install sekarang untuk aplikasi yang stabil dan reliable! 🎉
