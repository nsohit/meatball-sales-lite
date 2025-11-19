# 🔄 Dual Environment Support

## 🎯 Aplikasi Bekerja di 2 Environment

Aplikasi Bakso Business sekarang **smart** - otomatis detect environment dan adjust backend URL:

---

## 🌐 Environment 1: Development/Preview (Emergent)

### Karakteristik:
- URL: `https://bakso-business-app.preview.emergentagent.com`
- Backend: Server eksternal (Emergent cloud)
- Butuh internet: ✅ Ya

### Backend URL:
```
https://bakso-business-app.preview.emergentagent.com:8001
```

### Cara Kerja:
- `.env` file punya `REACT_APP_BACKEND_URL` dengan URL Emergent
- Code detect URL bukan localhost → pakai URL dari `.env`
- Frontend konek ke backend Emergent

---

## 🏠 Environment 2: Production (Raspberry Pi)

### Karakteristik:
- URL: `http://localhost:3000` atau `http://192.168.x.x:3000`
- Backend: Server lokal di Pi
- Butuh internet: ❌ Tidak (100% offline)

### Backend URL (Dinamis):
```
http://localhost:8001              # Akses dari Pi
http://192.168.189.147:8001       # Akses dari HP/laptop
```

### Cara Kerja:
- Build production tidak include external URL (atau include tapi kode detect localhost)
- Code detect hostname dari browser (`window.location.hostname`)
- Otomatis build URL: `http://[hostname]:8001`
- Support akses dari localhost DAN IP lokal!

---

## 🧠 Smart Detection Logic

```javascript
const getBackendURL = () => {
  const envUrl = process.env.REACT_APP_BACKEND_URL;
  
  // Jika env URL bukan localhost (development/Emergent)
  if (envUrl && !envUrl.includes('localhost') && !envUrl.includes('127.0.0.1')) {
    return envUrl; // Use configured URL
  }
  
  // Production/Pi: use dynamic hostname
  const protocol = window.location.protocol;
  const hostname = window.location.hostname;
  return `${protocol}//${hostname}:8001`;
};
```

### Decision Flow:

```
1. Cek REACT_APP_BACKEND_URL
   ↓
2. Apakah URL eksternal (bukan localhost)?
   → YES: Pakai URL itu (Development/Emergent)
   → NO: Continue ke step 3
   ↓
3. Pakai hostname dinamis (Production/Pi)
   - localhost → http://localhost:8001
   - 192.168.x.x → http://192.168.x.x:8001
```

---

## ✅ Testing di Kedua Environment

### Test Preview (Emergent):

1. Buka: `https://bakso-business-app.preview.emergentagent.com`
2. Open Console (F12)
3. Check log: `Using configured backend URL (development)`
4. Backend URL: `https://bakso-business-app.preview.emergentagent.com:8001`

✅ **Expected:** Dashboard load dengan data

---

### Test Production (Raspberry Pi):

#### A. Akses dari Pi sendiri:

1. Buka: `http://localhost:3000`
2. Open Console (F12)
3. Check log: `Using dynamic backend URL (production/Pi)`
4. Backend URL: `http://localhost:8001`

✅ **Expected:** Dashboard load, stok bisa diinput

#### B. Akses dari HP (WiFi sama):

1. Buka: `http://192.168.189.147:3000`
2. Open Console (F12)
3. Check log: `Using dynamic backend URL (production/Pi)`
4. Backend URL: `http://192.168.189.147:8001`

✅ **Expected:** Dashboard load, semua fitur work

---

## 🔧 Troubleshooting by Environment

### Preview Environment Tidak Work:

**Cek:**
```bash
sudo supervisorctl status backend
sudo supervisorctl tail backend stderr
```

**Pastikan:**
- Backend Emergent running
- MongoDB connected
- Port 8001 accessible

---

### Production (Pi) Tidak Work:

**Cek:**
```bash
# Status services
sudo supervisorctl status

# Test backend local
curl http://localhost:8001/api/

# Test backend dari network
curl http://192.168.189.147:8001/api/
```

**Pastikan:**
- Backend bind ke `0.0.0.0` (bukan hanya 127.0.0.1)
- Firewall allow port 8001
- MongoDB running

**Fix binding:**
```bash
sudo nano /etc/supervisor/conf.d/bakso-backend.conf
# Pastikan: --host 0.0.0.0

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart bakso-backend
```

---

## 📝 File Configuration

### Development (Emergent):

**`frontend/.env`:**
```
REACT_APP_BACKEND_URL=https://bakso-business-app.preview.emergentagent.com
```

**Backend:**
```
Host: 0.0.0.0
Port: 8001
External URL: https://bakso-business-app.preview.emergentagent.com:8001
```

---

### Production (Pi):

**`frontend/.env`:**
```
# Tidak dipakai atau set ke localhost
REACT_APP_BACKEND_URL=http://localhost:8001
```

**Backend (Supervisor config):**
```ini
command=/path/to/venv/bin/uvicorn server:app --host 0.0.0.0 --port 8001
```

**`--host 0.0.0.0`** PENTING! Ini buat backend accessible dari network.

---

## 🎁 Keuntungan Dual Environment

### Development (Emergent):
✅ Test fitur baru dengan mudah  
✅ Kolaborasi team  
✅ Preview sebelum deploy ke Pi  
✅ Debugging dengan tools lengkap  

### Production (Pi):
✅ Offline operation (tidak perlu internet)  
✅ Low latency (lokal network)  
✅ Multi-device access (Pi, HP, laptop)  
✅ Data privacy (semua lokal)  

---

## 🚀 Deployment Workflow

### 1. Development di Emergent:
```bash
# Edit code
# Test di preview URL
# Pastikan all features work
```

### 2. Build untuk Pi:
```bash
cd /app
bash create-lite-package.sh
# Dapat: bakso-business-lite.tar.gz
```

### 3. Deploy ke Pi:
```bash
# Copy file ke Pi (USB/SCP)
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh
```

### 4. Verify:
```bash
# Test local
curl http://localhost:8001/api/

# Test dari network
curl http://[IP-Pi]:8001/api/

# Buka browser
http://[IP-Pi]:3000
```

---

## 💡 Best Practices

### Untuk Development:
1. Selalu test di preview environment dulu
2. Commit stable code sebelum build untuk Pi
3. Update dokumentasi jika ada perubahan config

### Untuk Production:
1. Backup database sebelum update
2. Test akses dari localhost DAN IP lokal
3. Verifikasi backend bind ke 0.0.0.0
4. Monitor logs setelah deployment

---

## 🆘 FAQ

**Q: Kenapa preview environment butuh internet?**  
A: Backend ada di Emergent cloud, frontend perlu konek ke sana.

**Q: Kenapa Pi tidak butuh internet?**  
A: Backend dan frontend sama-sama di Pi, komunikasi via localhost/LAN.

**Q: Bisa akses dari internet saat di Pi?**  
A: Bisa, tapi perlu setup port forwarding di router (tidak recommended untuk security).

**Q: Build sekali jalan di kedua environment?**  
A: Ya! Code smart detect environment otomatis.

**Q: Update .env file pengaruh ke Pi?**  
A: Tidak. Pi pakai dynamic hostname, tidak peduli .env file.

---

**✅ Aplikasi sekarang work di preview Emergent DAN Raspberry Pi!**
