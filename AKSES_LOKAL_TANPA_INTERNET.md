# ✅ Akses Aplikasi LOKAL (Tanpa Internet)

## 🎯 **APLIKASI INI 100% LOKAL - TIDAK PERLU INTERNET!**

Setelah instalasi selesai, aplikasi Bakso Business berjalan sepenuhnya di Raspberry Pi Anda dan **TIDAK memerlukan koneksi internet** untuk digunakan.

---

## 📱 Cara Mengakses Aplikasi

### 1️⃣ **Akses dari Raspberry Pi itu sendiri**

Buka browser di Raspberry Pi (Chromium) dan ketik:

```
http://localhost:3000
```

atau

```
http://127.0.0.1:3000
```

---

### 2️⃣ **Akses dari HP/Komputer lain (dalam jaringan WiFi yang SAMA)**

**Langkah-langkah:**

#### A. Cari IP Address Raspberry Pi

Di Raspberry Pi, buka Terminal dan ketik:

```bash
hostname -I
```

Contoh output: `192.168.1.100` (ini adalah IP lokal Pi Anda)

#### B. Akses dari perangkat lain

Di HP atau komputer yang **terhubung ke WiFi yang sama**, buka browser dan ketik:

```
http://192.168.1.100:3000
```

*(Ganti `192.168.1.100` dengan IP Pi Anda)*

---

## 🔍 Kenapa Sering "Tidak Bisa Terhubung ke Server"?

### ❌ **Masalah Umum:**

1. **Backend belum jalan**: Tunggu 1-2 menit setelah restart Pi
2. **Akses dari IP yang salah**: Pastikan gunakan IP lokal yang benar
3. **WiFi berbeda**: HP dan Pi harus di jaringan WiFi yang SAMA

### ✅ **Solusi Cepat:**

#### Cek Status Services:

```bash
sudo supervisorctl status
```

Output yang benar:
```
bakso-backend    RUNNING
bakso-frontend   RUNNING
```

#### Jika Backend STOPPED, restart:

```bash
sudo supervisorctl restart bakso-backend
sudo supervisorctl restart bakso-frontend
```

#### Cek Logs jika masih error:

```bash
sudo supervisorctl tail -f bakso-backend stderr
```

---

## 🌐 Apakah Butuh Internet?

### ❌ **TIDAK** untuk penggunaan normal:
- Input stok
- Input transaksi
- Lihat laporan
- Export Excel
- Semua fitur utama

### ✅ **YA** hanya untuk:
- Update sistem (apt update)
- Install package baru
- Download updates (opsional)

---

## 🚀 Akses Cepat (Bookmark ini di Browser Pi Anda!)

```
Frontend (UI):       http://localhost:3000
Backend API:         http://localhost:8001/api/
API Documentation:   http://localhost:8001/docs
```

---

## 💡 Tips Praktis

### Untuk Penggunaan Sehari-hari:

1. **Simpan bookmark** `http://localhost:3000` di Chromium
2. **Buat shortcut** di desktop Pi untuk akses cepat
3. **Matikan WiFi** Pi (jika tidak perlu akses dari HP) untuk hemat daya
4. **Backup database** secara berkala:

```bash
mongodump --db bakso_business --out ~/backup-$(date +%Y%m%d)
```

---

## 🔧 Troubleshooting

| Masalah | Solusi |
|---------|--------|
| Page tidak muncul | Pastikan services running: `sudo supervisorctl status` |
| "Server error" | Restart backend: `sudo supervisorctl restart bakso-backend` |
| Lambat | Tunggu 30 detik setelah restart Pi |
| Tidak bisa dari HP | Cek IP Pi dengan `hostname -I`, pastikan WiFi sama |

---

## 📞 Butuh Bantuan?

Jika masih ada masalah:

1. Screenshot error message
2. Jalankan: `sudo supervisorctl status`
3. Cek logs: `sudo supervisorctl tail bakso-backend stderr`
4. Catat IP address: `hostname -I`

---

**✅ Aplikasi ini dirancang untuk berjalan OFFLINE di Raspberry Pi Anda!**

Selamat menggunakan Bakso Business System! 🍜🎉
