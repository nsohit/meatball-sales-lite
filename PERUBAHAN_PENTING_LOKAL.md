# ⚠️ PERUBAHAN PENTING - Konfigurasi Lokal

## 🎯 Masalah yang Diperbaiki

**Masalah Sebelumnya:**
- Aplikasi mencoba konek ke server eksternal (internet)
- Error: "Tidak bisa terhubung ke server"
- Butuh koneksi internet untuk berfungsi

**Solusi Sekarang:**
- ✅ Aplikasi 100% lokal di Raspberry Pi
- ✅ Tidak perlu internet setelah instalasi
- ✅ Akses dari localhost atau IP lokal
- ✅ Otomatis detect hostname untuk akses dari perangkat lain

---

## 🔧 Perubahan Teknis

### File yang Diubah:

1. **`frontend/.env`**
   ```diff
   - REACT_APP_BACKEND_URL=https://bakso-business-app.preview.emergentagent.com
   + REACT_APP_BACKEND_URL=http://localhost:8001
   ```

2. **`frontend/src/App.js`**
   - Backend URL sekarang dinamis
   - Menggunakan hostname saat ini (localhost atau IP lokal)
   - Otomatis adjust saat diakses dari HP/komputer lain

---

## 📱 Cara Akses Setelah Instalasi Ulang

### Dari Raspberry Pi sendiri:
```
http://localhost:3000
```

### Dari HP/Komputer lain (WiFi sama):
1. Cek IP Pi: `hostname -I` di Terminal Pi
2. Buka browser di HP: `http://[IP]:3000`
   
   Contoh: `http://192.168.1.100:3000`

---

## 🔄 Untuk User yang Sudah Install Sebelumnya

Jika Anda sudah install versi lama yang sering error "Tidak bisa terhubung ke server":

### Opsi 1: Install Ulang (RECOMMENDED)

```bash
# 1. Backup data (jika ada)
mongodump --db bakso_business --out ~/backup-$(date +%Y%m%d)

# 2. Uninstall versi lama
cd ~/bakso-business-lite
bash uninstall.sh

# 3. Install versi baru
cd ~
rm -rf bakso-business-lite
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh

# 4. Restore data (jika perlu)
mongorestore ~/backup-[tanggal]/bakso_business
```

### Opsi 2: Manual Fix (untuk Advanced User)

Jika tidak ingin install ulang, edit file frontend yang sudah di-extract:

```bash
# Edit file index.html yang sudah di-build
cd ~/bakso-business-lite/frontend/build/static/js
# Cari file main.*.js dan ganti URL hardcoded
# (Tidak recommended karena file sudah minified)
```

**LEBIH MUDAH: Install ulang dengan versi baru!**

---

## ✅ Verifikasi Setelah Update

Setelah install versi baru, cek di browser console (F12):

```
Backend URL: http://localhost:8001
```

atau (jika akses dari HP):

```
Backend URL: http://192.168.1.100:8001
```

---

## 📖 Dokumentasi Lengkap

Baca file ini untuk panduan lengkap:
- **`AKSES_LOKAL_TANPA_INTERNET.md`** - Panduan akses aplikasi
- **`README.md`** - Panduan instalasi
- **`TROUBLESHOOTING_NODE_ERROR.md`** - Troubleshooting umum

---

## 💡 Keuntungan Versi Baru

✅ **Lebih Stabil** - Tidak bergantung koneksi internet
✅ **Lebih Cepat** - Akses lokal lebih responsif
✅ **Lebih Fleksibel** - Bisa akses dari perangkat manapun di jaringan
✅ **Offline First** - Cocok untuk warung/toko tanpa WiFi stabil

---

Tanggal Update: $(date +"%d %B %Y")
Versi: 2.0 - Full Local Support
