# 📥 Cara Download & Install Bakso Business Lite

## 🎯 3 Cara Mendapatkan File

### Cara 1: Download dari Chat Ini (Paling Mudah!)

File `bakso-business-lite.tar.gz` sudah ada di environment ini dan siap download!

**Lokasi file:** `/app/bakso-business-lite.tar.gz` (812KB)

**Cara download:**

1. **Via Web Interface** (jika ada tombol download)
   - Cari file `bakso-business-lite.tar.gz` di file browser
   - Klik untuk download

2. **Via Command** (jika punya akses ke environment ini)
   ```bash
   # File ada di:
   /app/bakso-business-lite.tar.gz
   ```

---

### Cara 2: Build Sendiri dari Source Code

Jika Anda punya akses ke source code project ini:

```bash
# Dari folder root project
cd /app
bash create-lite-package.sh

# Output: bakso-business-lite.tar.gz (812KB)
```

Script akan otomatis:
- Build frontend production
- Create tarball frontend
- Bundle semua files
- Generate paket lengkap

---

### Cara 3: Transfer Langsung ke Raspberry Pi

Jika environment ini terhubung dengan Raspberry Pi Anda:

```bash
# Dari environment ini ke Raspberry Pi
scp /app/bakso-business-lite.tar.gz pi@[IP-RASPBERRY-PI]:~/

# Contoh:
scp /app/bakso-business-lite.tar.gz pi@192.168.1.100:~/
```

---

## 📦 Isi Paket

File `bakso-business-lite.tar.gz` berisi:

```
bakso-business-lite/
├── setup-lite-node16.sh ⭐ (Installer tanpa Node.js)
├── setup-lite.sh (Installer dengan Node.js 18+)
├── frontend-build.tar.gz (Frontend pre-built 790KB)
├── backend/
│   ├── server.py
│   └── requirements.txt
├── README.md
├── README_FIRST.md
├── TROUBLESHOOTING_NODE_ERROR.md
├── WHICH_SCRIPT_TO_USE.md
└── INSTALL_NO_NODE_ERROR.md
```

---

## 🚀 Setelah Download, Install di Raspberry Pi

### Step 1: Transfer ke Pi (jika belum)

```bash
# Dari komputer tempat download
scp bakso-business-lite.tar.gz pi@[IP-PI]:~/
```

### Step 2: Extract di Raspberry Pi

```bash
# SSH ke Raspberry Pi
ssh pi@[IP-PI]

# Extract
cd ~
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
```

### Step 3: Lihat File

```bash
ls -la

# Anda akan melihat:
# setup-lite-node16.sh  ← Pakai ini!
# setup-lite.sh
# frontend-build.tar.gz
# backend/
# README_FIRST.md       ← Baca ini dulu!
```

### Step 4: Install

```bash
bash setup-lite-node16.sh
```

**Tunggu 8-12 menit → Selesai!** ✅

---

## 💡 Tips Download

### Jika Download Lambat

File hanya 812KB, sangat kecil! Seharusnya cepat.

### Jika Download Gagal

1. **Coba lagi** - Koneksi mungkin terputus
2. **Gunakan resume** (jika support):
   ```bash
   wget -c [URL]
   ```

### Verify File Setelah Download

```bash
# Check ukuran file
ls -lh bakso-business-lite.tar.gz

# Harus sekitar: 812K atau 831199 bytes

# Test extract
tar -tzf bakso-business-lite.tar.gz | head -10

# Harus muncul list file tanpa error
```

---

## ❓ FAQ

### Q: Dimana saya bisa download file ini?

**A:** File ada di environment ini (`/app/bakso-business-lite.tar.gz`). 

Cara download tergantung platform:
- **Emergent AI:** Cek file manager di interface
- **Local environment:** File sudah ada di `/app/`
- **Remote:** Gunakan `scp` untuk copy

### Q: Apakah file ini aman?

**A:** Ya! File ini adalah hasil build dari source code yang visible. Berisi:
- Frontend static files (React build)
- Backend Python (FastAPI)
- Installation scripts
- Dokumentasi

Tidak ada executable atau binary yang aneh.

### Q: Berapa ukuran file?

**A:** Hanya **812KB** (compressed). Setelah extract:
- Frontend build: ~2-3MB
- Backend: ~50KB
- Scripts & docs: ~100KB
- Total setelah extract: ~3-4MB

### Q: Apakah bisa install tanpa download?

**A:** Jika environment ini dan Raspberry Pi dalam network yang sama:
```bash
# Direct SCP
scp /app/bakso-business-lite.tar.gz pi@[IP-PI]:~/
```

### Q: File sudah di-download, apa selanjutnya?

**A:** Baca file `README_FIRST.md` setelah extract!

```bash
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
cat README_FIRST.md
```

---

## 🎯 Quick Reference

```bash
# 1. Download (salah satu cara di atas)
# 2. Transfer ke Pi
scp bakso-business-lite.tar.gz pi@[IP]:~/

# 3. Di Raspberry Pi
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh

# 4. Akses
http://[IP-PI]:3000
```

---

## 📞 Need Help?

Jika ada masalah download atau transfer, laporkan:
- Ukuran file yang terdownload
- Error message (jika ada)
- Platform yang digunakan

---

**Happy Installing!** 🚀🍜
