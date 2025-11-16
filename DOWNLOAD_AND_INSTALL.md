# 📥 Download & Install - Bakso Business Lite

Panduan lengkap untuk mendapatkan dan menginstall Bakso Business Lite di Raspberry Pi 3B.

## 🎯 Pilihan Download

### Opsi 1: File Sudah Ada di Komputer Development

Jika Anda adalah developer atau sudah punya source code:

```bash
# Di komputer development
cd /path/to/bakso-business
bash create-lite-package.sh

# Output: bakso-business-lite.tar.gz (806KB)
```

Lanjut ke [Cara Transfer ke Pi](#cara-transfer-ke-pi)

### Opsi 2: Download dari GitHub Releases

**COMING SOON:** Link download akan tersedia setelah release pertama

```bash
# Download dari GitHub
wget https://github.com/[username]/bakso-business/releases/latest/download/bakso-business-lite.tar.gz

# Atau via browser
# Buka: https://github.com/[username]/bakso-business/releases/latest
# Download file: bakso-business-lite.tar.gz
```

## 📤 Cara Transfer ke Pi

### Metode 1: Via Network (SCP) - Recommended

**Dari Windows:**
```powershell
# Install WinSCP atau gunakan PowerShell
scp bakso-business-lite.tar.gz pi@192.168.1.100:~/
```

**Dari Linux/Mac:**
```bash
# Ganti 192.168.1.100 dengan IP Raspberry Pi Anda
scp bakso-business-lite.tar.gz pi@192.168.1.100:~/
```

**Cara cek IP Raspberry Pi:**
```bash
# Di Raspberry Pi, jalankan:
hostname -I
```

### Metode 2: Via USB Drive

1. **Copy ke USB Drive:**
   - Colok USB ke komputer
   - Copy file `bakso-business-lite.tar.gz` ke USB

2. **Transfer ke Pi:**
   ```bash
   # Di Raspberry Pi
   # Colok USB, tunggu mount
   
   # Cek mount point
   lsblk
   
   # Biasanya di /media/pi/[DRIVE_NAME]
   # Copy file
   cp /media/pi/USB/bakso-business-lite.tar.gz ~/
   
   # Atau
   sudo mount /dev/sda1 /mnt
   cp /mnt/bakso-business-lite.tar.gz ~/
   sudo umount /mnt
   ```

### Metode 3: Via Direct Download (Jika Pi Punya Internet)

```bash
# Di Raspberry Pi langsung
cd ~
wget https://github.com/[username]/bakso-business/releases/latest/download/bakso-business-lite.tar.gz
```

## 🚀 Instalasi di Raspberry Pi

### Langkah 1: Koneksi ke Raspberry Pi

**Via SSH (Recommended):**
```bash
# Dari komputer lain
ssh pi@192.168.1.100
# Password default: raspberry
```

**Via Monitor & Keyboard:**
- Colok monitor HDMI dan keyboard USB langsung ke Pi
- Login dengan user: `pi`, password: `raspberry`

### Langkah 2: Verifikasi File

```bash
# Pastikan file ada di home directory
cd ~
ls -lh bakso-business-lite.tar.gz

# Output expected:
# -rw-r--r-- 1 pi pi 806K Nov 16 10:00 bakso-business-lite.tar.gz
```

### Langkah 3: Extract Package

```bash
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
```

### Langkah 4: Verifikasi Isi Package

```bash
ls -la

# Expected output:
# drwxr-xr-x 4 pi pi 4096 Nov 16 10:00 .
# drwxr-xr-x 3 pi pi 4096 Nov 16 10:00 ..
# drwxr-xr-x 2 pi pi 4096 Nov 16 10:00 backend
# drwxr-xr-x 2 pi pi 4096 Nov 16 10:00 frontend
# -rw-r--r-- 1 pi pi  790K Nov 16 10:00 frontend-build.tar.gz
# -rw-r--r-- 1 pi pi  11K Nov 16 10:00 README.md
# -rwxr-xr-x 1 pi pi  9.8K Nov 16 10:00 setup-lite.sh
```

### Langkah 5: Jalankan Instalasi

```bash
bash setup-lite.sh
```

**Apa yang akan terjadi:**
```
==============================================
  Bakso Business - Lite Setup
  Raspberry Pi 3B Optimized (No Build!)
==============================================

[INFO] Detected: Raspberry Pi 3B Rev 1.2
[INFO] Total Memory: 926MB

This script will install:
  - MongoDB
  - Python 3 & dependencies
  - Backend service
  - Pre-built frontend (no npm build!)
  - PM2 process manager

Continue? (y/n)
```

**Ketik `y` dan Enter** untuk mulai instalasi.

### Langkah 6: Tunggu Instalasi Selesai

Script akan berjalan **10-15 menit** dan menampilkan progress:

```
[INFO] Step 1/10: Updating system...
[✓] System updated

[INFO] Step 2/10: Installing MongoDB...
[✓] MongoDB installed

[INFO] Step 3/10: Installing Python 3...
[✓] Python 3 installed

... (dan seterusnya)

[✓] Installation Complete!
```

### Langkah 7: Verifikasi Instalasi

Script akan otomatis test dan menampilkan:

```
==============================================
  ✓ Installation Complete!
==============================================

Access your application:

  Frontend: http://192.168.1.100:3000
  Backend:  http://192.168.1.100:8001/api/
  API Docs: http://192.168.1.100:8001/docs

Useful commands:

  pm2 status          - Check services
  pm2 logs            - View logs
  pm2 restart all     - Restart services

System resources:
  Memory used: 450MB / 926MB
  PM2 autostart: Enabled

Enjoy your Bakso Business System! 🎉
```

## 🎮 Menggunakan Aplikasi

### 1. Buka Browser

Di komputer lain yang satu network dengan Pi:
```
http://192.168.1.100:3000
```

**Tips:** Ganti `192.168.1.100` dengan IP Raspberry Pi Anda.

### 2. Mulai Gunakan

Aplikasi siap digunakan! Tidak perlu login atau setup tambahan.

**Halaman Tersedia:**
- 📊 **Dashboard** - Overview harian
- 📦 **Stok** - Input stok harian
- 💰 **Transaksi** - Catat penjualan
- 📈 **Laporan** - Export data
- 💸 **Pengeluaran** - Catat biaya

## 🔧 Troubleshooting Instalasi

### Error: "Insufficient memory"

**Penyebab:** RAM Pi kurang dari 1GB atau terlalu banyak aplikasi running

**Solusi:**
```bash
# Stop aplikasi lain yang tidak perlu
sudo systemctl stop bluetooth
sudo systemctl stop avahi-daemon

# Reboot dan coba lagi
sudo reboot
```

### Error: "MongoDB failed to start"

**Solusi:**
```bash
# Check logs
sudo journalctl -u mongodb -n 50

# Restart MongoDB
sudo systemctl restart mongodb

# Verify running
sudo systemctl status mongodb
```

### Error: "frontend-build.tar.gz not found"

**Penyebab:** Package tidak lengkap atau corrupt

**Solusi:**
```bash
# Download ulang
cd ~
rm -rf bakso-business-lite*
# Download lagi dari source
```

### Error: "Port 3000/8001 already in use"

**Solusi:**
```bash
# Cek process yang menggunakan port
sudo lsof -i :3000
sudo lsof -i :8001

# Kill process jika perlu
sudo kill -9 [PID]

# Restart instalasi
cd ~/bakso-business-lite
bash setup-lite.sh
```

### Services Tidak Auto-start Setelah Reboot

**Solusi:**
```bash
# Setup PM2 autostart manual
pm2 startup systemd
# Copy-paste command yang muncul, jalankan

# Save PM2 list
pm2 save

# Reboot untuk test
sudo reboot
```

## 📊 Verifikasi Instalasi Berhasil

### Checklist ✅

Setelah instalasi, verifikasi bahwa:

- [ ] PM2 menunjukkan 2 services online: `pm2 status`
- [ ] Frontend accessible di browser: `http://[IP]:3000`
- [ ] Backend API responding: `curl http://localhost:8001/api/`
- [ ] MongoDB running: `sudo systemctl status mongodb`
- [ ] Memory usage < 600MB: `free -h`
- [ ] Dashboard halaman loads tanpa error
- [ ] Bisa add data stok
- [ ] Bisa add transaksi

Jika semua ✅, instalasi **BERHASIL!** 🎉

## 🔄 Update Aplikasi (Future)

Ketika ada versi baru:

```bash
# 1. Stop aplikasi
pm2 stop all

# 2. Backup database (opsional)
mongodump --out ~/backup-$(date +%Y%m%d)

# 3. Download versi baru
cd ~
wget [URL_VERSI_BARU]

# 4. Extract
tar -xzf bakso-business-lite-v2.tar.gz
cd bakso-business-lite

# 5. Update
bash setup-lite.sh

# 6. Aplikasi akan restart otomatis
```

## 💡 Tips

### Akses dari Handphone

1. Pastikan HP tersambung ke WiFi yang sama dengan Pi
2. Buka browser di HP
3. Akses: `http://[IP-PI]:3000`
4. Voila! Bisa diakses dari HP

### Bookmark untuk Akses Cepat

Di browser, bookmark:
- `http://[IP-PI]:3000` - Frontend
- `http://[IP-PI]:8001/docs` - API Documentation

### Set Static IP untuk Pi

Agar IP Pi tidak berubah-ubah:

```bash
# Edit dhcpcd.conf
sudo nano /etc/dhcpcd.conf

# Tambahkan di akhir file:
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8

# Save (Ctrl+X, Y, Enter)
# Reboot
sudo reboot
```

### Monitor Resource Usage

```bash
# Real-time monitor
pm2 monit

# Memory usage
free -h

# CPU usage
htop

# Disk usage
df -h
```

## 📞 Butuh Bantuan?

### Cek Logs

```bash
# Semua logs
pm2 logs

# Backend logs only
pm2 logs bakso-backend

# Frontend logs only
pm2 logs bakso-frontend

# MongoDB logs
sudo journalctl -u mongodb -f
```

### Restart Everything

```bash
# Quick fix untuk banyak masalah
pm2 restart all
sudo systemctl restart mongodb
```

### Full Reboot

```bash
sudo reboot
```

Setelah reboot, cek `pm2 status` - harusnya services otomatis jalan.

## 📚 Dokumentasi Lengkap

- 📘 [Dokumentasi Full](RASPBERRY_PI_3B_LITE.md)
- 🚀 [Quick Start](QUICK_START_LITE.md)
- 👨‍💻 [Developer Guide](LITE_PACKAGE_CREATION.md)
- 📋 [Docs Index](DOCS_INDEX.md)

---

**Selamat menggunakan Bakso Business System!** 🍜

Aplikasi dirancang untuk memudahkan pengelolaan bisnis bakso Anda.  
Jika ada pertanyaan atau masalah, silakan hubungi support.
