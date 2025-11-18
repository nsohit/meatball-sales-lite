# 🔧 Fix: Form Input Stok Tidak Muncul

## 🚨 Masalah

Form input stok di halaman Stock tidak muncul.

## 🔍 Penyebab

Ada 2 kemungkinan penyebab:

### 1. Backend URL Tidak Dikonfigurasi
Frontend tidak bisa connect ke backend karena environment variable `REACT_APP_BACKEND_URL` tidak diset.

### 2. Backend Tidak Running
Service backend mati atau error.

---

## ✅ SOLUSI

### **Fix 1: Set Environment Variable yang Benar**

#### Di frontend/.env:

```bash
# Edit file
nano ~/bakso-business-lite/frontend/build/.env

# ATAU jika pakai frontend/
nano ~/bakso-business-lite/frontend/.env
```

**Isi file `.env`:**
```env
REACT_APP_BACKEND_URL=http://localhost:8001
```

**Note:** File ini sudah diinclude dalam update terbaru!

### **Fix 2: Verify Backend Running**

```bash
# Check backend status
sudo supervisorctl status bakso-backend

# Harus menunjukkan: RUNNING

# Jika tidak running
sudo supervisorctl restart bakso-backend

# Check logs
sudo supervisorctl tail bakso-backend stderr
```

### **Fix 3: Test Backend API**

```bash
# Test endpoint
curl http://localhost:8001/api/

# Harus return JSON dengan message

# Test stock endpoint
curl http://localhost:8001/api/stock/2024-11-18

# Jika 404: Normal (berarti belum ada data)
# Jika error lain: Ada masalah backend
```

### **Fix 4: Clear Browser Cache**

Jika sudah fix backend tapi form tetap tidak muncul:

1. **Hard refresh browser:**
   - Chrome/Edge: `Ctrl + Shift + R` (Linux/Windows) atau `Cmd + Shift + R` (Mac)
   - Firefox: `Ctrl + F5`

2. **Clear cache:**
   - Buka DevTools (`F12`)
   - Right-click tombol refresh
   - Pilih "Empty Cache and Hard Reload"

3. **Buka Private/Incognito window**

### **Fix 5: Check Browser Console**

1. Buka browser DevTools (`F12`)
2. Pilih tab "Console"
3. Refresh halaman
4. Lihat error messages

**Pesan yang mungkin muncul:**

❌ **Error: Network Error**
```
Fetch stock error: Network Error
```
**Solusi:** Backend tidak running atau URL salah

❌ **Error: CORS**
```
Access to XMLHttpRequest has been blocked by CORS policy
```
**Solusi:** Check backend CORS settings (seharusnya sudah OK)

✅ **Success:**
```
Backend URL: http://localhost:8001
GET http://localhost:8001/api/stock/2024-11-18 404 (Not Found)
```
Ini normal! 404 = belum ada data, form akan muncul.

---

## 🎯 Update Terbaru (Sudah Diinclude)

Saya sudah update code dengan:

### 1. ✅ **Title Changed**
```html
<title>Bakso Business</title>
```

### 2. ✅ **Emergent Badge Removed**
Badge "Made with Emergent" sudah dihilangkan.

### 3. ✅ **Better Error Handling**
```javascript
// Sekarang jika network error, form tetap ditampilkan
// dengan toast notification
```

### 4. ✅ **Fallback Backend URL**
```javascript
const BACKEND_URL = process.env.REACT_APP_BACKEND_URL || 'http://localhost:8001';
```

### 5. ✅ **Console Logging**
```javascript
console.log('Backend URL:', BACKEND_URL);
console.error('Fetch stock error:', error);
```

Sekarang lebih mudah debugging!

---

## 📦 Cara Update ke Versi Terbaru

### **Opsi A: Download Paket Baru**

1. Push code ke GitHub (button "Save to GitHub")
2. Clone di Pi:
   ```bash
   cd ~
   git clone https://github.com/[username]/[repo].git
   cd [repo]
   ```

3. Extract & Install:
   ```bash
   tar -xzf bakso-business-lite.tar.gz
   cd bakso-business-lite
   
   # Stop old services
   sudo supervisorctl stop all
   
   # Install new version
   bash setup-lite-node16.sh
   ```

### **Opsi B: Update Frontend Saja**

Jika hanya mau update frontend:

```bash
# Download paket baru
cd ~/bakso-business-lite

# Extract frontend build baru
tar -xzf frontend-build.tar.gz -C frontend/

# Restart frontend
sudo supervisorctl restart bakso-frontend

# Clear browser cache
# Hard refresh: Ctrl + Shift + R
```

---

## ✅ Verify Setelah Fix

### 1. Check Backend

```bash
curl http://localhost:8001/api/
# Harus return: {"message": "Bakso Business API"}
```

### 2. Check Frontend

Buka browser: `http://[IP-PI]:3000/stok`

**Harus terlihat:**
- ✅ Title: "Bakso Business" (bukan "Emergent")
- ✅ Tidak ada badge "Made with Emergent"
- ✅ Form input stok muncul:
  - Pilih Tanggal
  - Input Stok Awal (Bakso Urat, Bakso Kecil, Tahu, dll)
  - Button "Simpan Stok Awal"

### 3. Test Input

1. Pilih tanggal hari ini
2. Input stok (contoh: Bakso Urat = 50)
3. Klik "Simpan Stok Awal"
4. Harus muncul toast "Stok awal berhasil disimpan"
5. Form "Input Stok Sisa" harus muncul

---

## 💡 Troubleshooting

### Form Masih Tidak Muncul

**Check semua ini:**

```bash
# 1. Backend running?
sudo supervisorctl status bakso-backend
# Output: RUNNING

# 2. Backend accessible?
curl http://localhost:8001/api/
# Output: JSON response

# 3. Frontend running?
sudo supervisorctl status bakso-frontend
# Output: RUNNING

# 4. Port 3000 accessible?
curl http://localhost:3000
# Output: HTML response

# 5. No firewall blocking?
sudo iptables -L | grep 3000
# Seharusnya tidak ada block
```

### Backend Error

```bash
# Check backend logs
sudo supervisorctl tail bakso-backend stderr

# Common errors:
# - MongoDB not running: sudo systemctl restart mongodb
# - Port already in use: sudo lsof -i :8001
# - Import error: Check venv activated
```

### Frontend Error

```bash
# Check frontend logs
sudo supervisorctl tail bakso-frontend stderr

# Common errors:
# - Port already in use: sudo lsof -i :3000
# - Permission denied: Check directory permissions
```

---

## 🎊 Summary Fix

**3 Update Utama:**

1. ✅ **Title → "Bakso Business"**
2. ✅ **Badge Emergent → Removed**
3. ✅ **Form Input → Better error handling + fallback**

**Jika form masih tidak muncul:**
- Check backend running
- Check browser console untuk error
- Clear cache & hard refresh
- Update ke paket terbaru

**File paket terbaru sudah include semua fix ini!**

Push ke GitHub → Download → Install → Selesai! 🚀
