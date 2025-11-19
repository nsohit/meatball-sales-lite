# 📥 Cara Download File bakso-business-lite.tar.gz

## 🎯 File Sudah Siap!

File **`bakso-business-lite.tar.gz`** (819KB) sudah dibuat dan siap digunakan di Raspberry Pi Anda.

---

## 📍 Lokasi File

File terletak di direktori:
```
/app/bakso-business-lite.tar.gz
```

---

## 🚀 Cara Download ke Raspberry Pi

### Metode 1: Download Langsung (PALING MUDAH)

Jika Anda develop aplikasi ini di platform Emergent:

1. **Download dari browser** - Gunakan fitur download file dari Emergent UI
2. **Copy ke USB drive** - Simpan file di flashdisk
3. **Copy ke Raspberry Pi** - Colokkan USB ke Pi, copy file

---

### Metode 2: Via SCP (Jika Ada Akses SSH)

Jika Anda punya akses SSH ke server development dan Raspberry Pi:

```bash
# Dari komputer Anda
scp /app/bakso-business-lite.tar.gz pi@[IP-RASPBERRY-PI]:~/

# Contoh:
scp /app/bakso-business-lite.tar.gz pi@192.168.1.100:~/
```

Password default Raspberry Pi: `raspberry`

---

### Metode 3: Via GitHub (Jika Push ke Repo)

Jika Anda push project ke GitHub:

```bash
# Di Raspberry Pi
cd ~
git clone https://github.com/[username]/[repo-name].git
cd [repo-name]
# File tar.gz ada di root folder
```

---

## 📦 Setelah File Ada di Raspberry Pi

```bash
# 1. Extract file
tar -xzf bakso-business-lite.tar.gz

# 2. Masuk ke folder
cd bakso-business-lite

# 3. Lihat isi dan dokumentasi
ls -la
cat README.md

# 4. Jalankan installer
bash setup-lite-node16.sh

# 5. Tunggu 10-15 menit
```

---

## ✅ Verifikasi File

Sebelum copy ke Pi, cek ukuran file:

```bash
ls -lh bakso-business-lite.tar.gz
# Seharusnya: 819K (sekitar 820KB)
```

Cek isi file:

```bash
tar -tzf bakso-business-lite.tar.gz | head -20
# Seharusnya ada:
# - setup-lite-node16.sh
# - backend/server.py
# - frontend-build.tar.gz
# - AKSES_LOKAL_TANPA_INTERNET.md
# dll
```

---

## 🆘 Troubleshooting Download

### File Tidak Bisa Di-extract:

```bash
# Cek integritas file
tar -tzf bakso-business-lite.tar.gz > /dev/null

# Jika error, download ulang
```

### File Corrupted:

- Coba download ulang
- Pastikan transfer selesai 100%
- Jangan interupsi saat copy dari USB

### Permission Denied:

```bash
# Ubah permission
chmod +x setup-lite-node16.sh
```

---

## 📖 Dokumentasi Lengkap

Setelah extract di Raspberry Pi, baca file-file ini:

1. **`README.md`** - Panduan instalasi
2. **`AKSES_LOKAL_TANPA_INTERNET.md`** - Cara akses aplikasi (PENTING!)
3. **`WHICH_SCRIPT_TO_USE.md`** - Script mana yang harus digunakan
4. **`TROUBLESHOOTING_NODE_ERROR.md`** - Jika ada error Node.js

---

## 💡 Tips

- Simpan file tar.gz sebagai backup
- Jangan hapus setelah extract (untuk install ulang nanti)
- Test instalasi di Pi yang fresh untuk hasil terbaik

---

Selamat mencoba! 🎉
