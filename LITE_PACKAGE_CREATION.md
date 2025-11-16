# Membuat Paket Lite untuk Raspberry Pi 3B

Panduan ini menjelaskan cara membuat paket instalasi lite untuk Raspberry Pi 3B dari source code.

## 🎯 Mengapa Paket Lite?

Raspberry Pi 3B memiliki RAM terbatas (1GB). Proses `npm install` dan `yarn build` membutuhkan lebih dari 1GB RAM, yang menyebabkan out-of-memory error. Solusinya adalah **pre-build** frontend di komputer yang lebih powerful, lalu deploy hasil build-nya saja ke Pi.

## 📋 Persyaratan untuk Membuat Paket

### Hardware
- Komputer dengan minimal 2GB RAM
- Koneksi internet untuk download dependencies

### Software
- Node.js 16 atau lebih tinggi
- Yarn package manager
- Bash shell

## 🚀 Cara Membuat Paket Lite

### Metode Otomatis (Direkomendasikan)

Gunakan script yang sudah disediakan:

```bash
# Dari root directory project
bash create-lite-package.sh
```

Script ini akan otomatis:
1. ✅ Install dependencies frontend (jika belum)
2. ✅ Build production bundle
3. ✅ Compress frontend build menjadi tarball
4. ✅ Membuat paket lengkap siap deploy

**Output:**
- `frontend-build.tar.gz` - Frontend pre-built saja
- `bakso-business-lite.tar.gz` - Paket lengkap dengan script instalasi

### Metode Manual

Jika ingin build manual:

#### 1. Build Frontend

```bash
cd frontend
yarn install
yarn build
cd ..
```

#### 2. Compress Build Folder

```bash
tar -czf frontend-build.tar.gz -C frontend build/
```

#### 3. Buat Struktur Paket

```bash
# Buat folder temporary
mkdir -p bakso-business-lite

# Copy files
cp setup-lite.sh bakso-business-lite/
cp frontend-build.tar.gz bakso-business-lite/
cp RASPBERRY_PI_3B_LITE.md bakso-business-lite/README.md

# Copy backend
mkdir -p bakso-business-lite/backend
cp backend/server.py bakso-business-lite/backend/
cp backend/requirements.txt bakso-business-lite/backend/

# Create frontend folder (kosong)
mkdir -p bakso-business-lite/frontend

# Compress
tar -czf bakso-business-lite.tar.gz bakso-business-lite/
```

## 📦 Isi Paket Lite

```
bakso-business-lite/
├── setup-lite.sh              # Script instalasi otomatis
├── frontend-build.tar.gz      # Pre-built React app
├── README.md                  # Dokumentasi instalasi
├── backend/
│   ├── server.py
│   └── requirements.txt
└── frontend/                  # Kosong, akan diisi oleh script
```

## 🚢 Deploy ke Raspberry Pi

### 1. Transfer Paket ke Pi

```bash
# Via SCP
scp bakso-business-lite.tar.gz pi@[IP-PI]:~/

# Atau via USB drive
# Copy ke USB, lalu di Pi:
# cp /media/usb/bakso-business-lite.tar.gz ~/
```

### 2. Extract dan Install di Pi

```bash
# SSH ke Raspberry Pi
ssh pi@[IP-PI]

# Extract paket
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite

# Jalankan instalasi
bash setup-lite.sh
```

### 3. Tunggu Instalasi Selesai

Script akan berjalan 10-15 menit dan menginstall:
- MongoDB
- Python dependencies
- Deploy pre-built frontend
- Setup PM2 process manager
- Configure autostart

## 🔄 Update Aplikasi

Untuk update versi baru:

### Di Komputer Development

```bash
# 1. Update code
git pull  # atau edit manual

# 2. Build ulang paket
bash create-lite-package.sh

# 3. Transfer ke Pi
scp bakso-business-lite.tar.gz pi@[IP-PI]:~/
```

### Di Raspberry Pi

```bash
# 1. Stop aplikasi
pm2 stop all

# 2. Backup database (opsional)
mongodump --out ~/backup-$(date +%Y%m%d)

# 3. Extract update
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite

# 4. Update backend
cd backend
source venv/bin/activate
pip install -r requirements.txt --upgrade
deactivate
cd ..

# 5. Update frontend
cd frontend
rm -rf build
tar -xzf ../frontend-build.tar.gz
cd ..

# 6. Restart aplikasi
pm2 restart all
```

## 📊 Ukuran File

Referensi ukuran file hasil build:

- Frontend build (uncompressed): ~2-3 MB
- `frontend-build.tar.gz`: ~800 KB
- `bakso-business-lite.tar.gz`: ~850 KB
- Total after installation di Pi: ~1.5 GB (dengan dependencies)

## ⚡ Optimasi

### Mengurangi Ukuran Bundle

Edit `frontend/package.json`, tambahkan:

```json
{
  "scripts": {
    "build": "GENERATE_SOURCEMAP=false craco build"
  }
}
```

Ini akan menghilangkan source maps dan mengurangi ukuran build ~30%.

### Kompresi Lebih Tinggi

Gunakan `gzip` level maksimal:

```bash
tar -czf frontend-build.tar.gz -C frontend build/ --use-compress-program="gzip -9"
```

## 🐛 Troubleshooting

### Build Gagal di Komputer

**Error: Out of memory**
- Tingkatkan swap: `sudo fallocate -l 4G /swapfile`
- Atau build di komputer dengan RAM lebih besar

**Error: ENOSPC**
- Bersihkan npm cache: `npm cache clean --force`
- Hapus `node_modules` dan install ulang

### Script Setup Gagal di Pi

**Error: frontend-build.tar.gz not found**
- Pastikan `frontend-build.tar.gz` ada di root directory
- Atau pastikan folder `frontend/build/` sudah ada

**Error: MongoDB failed to start**
- Cek logs: `sudo journalctl -u mongodb`
- Restart: `sudo systemctl restart mongodb`

## 📝 Tips

1. **Selalu test paket di Pi** sebelum distribusi
2. **Backup database** sebelum update
3. **Gunakan versi semantic** (v1.0.0, v1.1.0, dst)
4. **Dokumentasikan perubahan** di changelog

## 🎯 Checklist Release

Sebelum release paket baru:

- [ ] Code sudah di-test di development
- [ ] Frontend berhasil di-build
- [ ] Paket lite berhasil dibuat
- [ ] Test install di fresh Pi 3B
- [ ] Semua fitur berfungsi normal
- [ ] Update dokumentasi jika ada perubahan
- [ ] Tambahkan versi number di README
- [ ] Create git tag untuk versi

## 🚀 Automation (Opsional)

Untuk otomasi lebih lanjut, bisa gunakan GitHub Actions:

```yaml
name: Build Lite Package
on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '16'
      - run: bash create-lite-package.sh
      - uses: actions/upload-artifact@v2
        with:
          name: bakso-business-lite
          path: bakso-business-lite.tar.gz
```

## 📚 Referensi

- [Raspberry Pi OS Documentation](https://www.raspberrypi.org/documentation/)
- [PM2 Process Manager](https://pm2.keymetrics.io/)
- [Create React App Deployment](https://create-react-app.dev/docs/deployment/)
- [MongoDB on Raspberry Pi](https://mongodb-pi.github.io/)

---

**Selamat membuat paket lite! 🎉**
