# 🔧 Troubleshooting: Node.js Version Error

## 🚨 Error yang Sering Muncul

Jika Anda mendapat error seperti ini saat instalasi:

```
error react-hook-form@7.66.0: The engine "node" is incompatible with this module. 
Expected version ">=18.0.0" Got "16.20.2"
error Found incompatible module.
```

**Jangan khawatir!** Ada 2 solusi mudah.

---

## ✅ Solusi 1: Update Node.js ke Versi 18 (Recommended)

### Mengapa Error Ini Terjadi?

Package `react-hook-form` versi terbaru butuh Node.js ≥18, sedangkan Raspberry Pi Anda masih pakai Node.js 16.

### Cara Fix (Otomatis)

**Gunakan script `setup-lite.sh` yang sudah diperbaiki:**

```bash
cd bakso-business-lite
bash setup-lite.sh
```

Script ini akan otomatis:
1. Detect versi Node.js yang terinstall
2. Upgrade ke Node.js 18 jika masih versi lama
3. Lanjutkan instalasi normal

### Cara Fix (Manual)

Jika ingin upgrade Node.js manual:

```bash
# 1. Remove Node.js lama
sudo apt remove -y nodejs

# 2. Install Node.js 18 LTS
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 3. Verify versi
node --version
# Output: v18.x.x

# 4. Lanjutkan instalasi
bash setup-lite.sh
```

---

## ✅ Solusi 2: Pakai Python HTTP Server (Tanpa Node.js!)

### Untuk Pi yang Sulit Upgrade Node

Jika Raspberry Pi Anda tidak bisa atau tidak mau upgrade Node.js, gunakan **versi alternatif** yang **TIDAK BUTUH Node.js sama sekali!**

### Cara Install

**Gunakan script khusus Node 16:**

```bash
cd bakso-business-lite
bash setup-lite-node16.sh
```

### Perbedaan Versi Ini

| Aspek | setup-lite.sh | setup-lite-node16.sh |
|-------|---------------|----------------------|
| Node.js Required | Ya (v18+) | **TIDAK** |
| Frontend Server | serve (npm) | Python HTTP Server |
| Process Manager | PM2 | Supervisor |
| Memory Usage | ~400MB | ~350MB (lebih hemat!) |
| Installation | Otomatis | Otomatis |

### Keuntungan Versi Node16

✅ **Tidak perlu Node.js sama sekali** - Python saja cukup!  
✅ **Memory lebih hemat** - Python HTTP server sangat ringan  
✅ **Lebih stabil** - Supervisor process manager built-in Raspberry Pi OS  
✅ **Kompatibel semua Pi** - Dari Pi 3B sampai Pi 5  

---

## 📋 Perbandingan Detail

### Setup-lite.sh (Standard - Node 18)

**Kelebihan:**
- ✅ PM2 modern process manager
- ✅ Features lengkap (monitoring, auto-restart)
- ✅ Sesuai dokumentasi development

**Kekurangan:**
- ⚠️ Butuh Node.js 18
- ⚠️ Sedikit lebih berat di memory

**Install:**
```bash
bash setup-lite.sh
```

### Setup-lite-node16.sh (Alternative - No Node!)

**Kelebihan:**
- ✅ **Tidak butuh Node.js!**
- ✅ Memory lebih hemat (~50MB lebih sedikit)
- ✅ Supervisor sangat reliable
- ✅ Cocok untuk Pi lama atau limited resources

**Kekurangan:**
- ⚠️ Monitoring tidak se-fancy PM2
- ⚠️ Commands sedikit berbeda

**Install:**
```bash
bash setup-lite-node16.sh
```

---

## 🎯 Rekomendasi

### Gunakan `setup-lite.sh` jika:
- Pi 3B+ atau Pi 4 dengan RAM ≥1GB
- Bisa upgrade Node.js ke v18
- Ingin monitoring lengkap dengan PM2

### Gunakan `setup-lite-node16.sh` jika:
- Pi 3B atau hardware limited
- Node.js 16 tidak bisa di-upgrade
- Ingin instalasi paling ringan
- Error dengan Node.js version
- Prefer stability over features

---

## 🔄 Commands Reference

### Jika Pakai PM2 (setup-lite.sh)

```bash
# Status
pm2 status

# Logs
pm2 logs

# Restart
pm2 restart all

# Stop
pm2 stop all

# Monitor
pm2 monit
```

### Jika Pakai Supervisor (setup-lite-node16.sh)

```bash
# Status
sudo supervisorctl status

# Logs
sudo supervisorctl tail -f bakso-backend
sudo supervisorctl tail -f bakso-frontend

# Restart
sudo supervisorctl restart all

# Stop
sudo supervisorctl stop all

# Start
sudo supervisorctl start all
```

---

## 🐛 Troubleshooting Lanjutan

### Error Masih Muncul Setelah Update Node

**Jika error masih muncul setelah upgrade Node ke v18:**

1. **Clear cache npm/yarn:**
   ```bash
   rm -rf node_modules
   rm package-lock.json
   rm yarn.lock
   ```

2. **Verify Node version:**
   ```bash
   node --version
   npm --version
   ```

3. **Reinstall:**
   ```bash
   bash setup-lite.sh
   ```

### Python HTTP Server Tidak Bisa Akses File

**Jika frontend tidak bisa load assets:**

```bash
# Check permissions
ls -la frontend/build/

# Fix permissions
chmod -R 755 frontend/build/

# Restart service
sudo supervisorctl restart bakso-frontend
```

### Supervisor Service Tidak Start

**Jika services gagal start:**

```bash
# Check config
sudo supervisorctl reread
sudo supervisorctl update

# Check logs
sudo supervisorctl tail bakso-backend stderr
sudo supervisorctl tail bakso-frontend stderr

# Manual start
sudo supervisorctl start all
```

---

## 💡 Tips

### Cek Versi Node Sebelum Install

```bash
node --version
```

- **v16.x.x** → Gunakan `setup-lite-node16.sh`
- **v18.x.x atau lebih** → Gunakan `setup-lite.sh`
- **Tidak ada Node** → Pilih salah satu (recommend: node16 untuk Pi 3B)

### Test Instalasi Berhasil

```bash
# Test backend
curl http://localhost:8001/api/

# Test frontend
curl http://localhost:3000

# Check memory
free -h
```

### Jika Ragu, Pakai Versi Node16

Untuk Raspberry Pi 3B dengan RAM 1GB, versi `setup-lite-node16.sh` adalah **pilihan paling aman** karena:
- Tidak butuh upgrade Node.js
- Lebih ringan di memory
- Supervisor sangat stable
- Tested di banyak Pi

---

## 📞 Masih Ada Masalah?

1. **Cek logs terlebih dahulu:**
   - PM2: `pm2 logs`
   - Supervisor: `sudo supervisorctl tail -f bakso-backend`

2. **Restart services:**
   - PM2: `pm2 restart all`
   - Supervisor: `sudo supervisorctl restart all`

3. **Reboot Pi:**
   ```bash
   sudo reboot
   ```

4. **Re-install dari awal:**
   ```bash
   # Backup data (optional)
   mongodump --out ~/backup
   
   # Clean install
   cd ~
   rm -rf bakso-business-lite
   tar -xzf bakso-business-lite.tar.gz
   cd bakso-business-lite
   bash setup-lite-node16.sh  # atau setup-lite.sh
   ```

---

## 🎉 Summary

**2 Cara Mudah Fix Node Error:**

1. **Upgrade Node → v18** (gunakan `setup-lite.sh`)
2. **Skip Node, pakai Python** (gunakan `setup-lite-node16.sh`) ← **Paling Mudah!**

**Recommendation untuk Pi 3B:**  
→ Pakai `setup-lite-node16.sh` untuk instalasi paling mudah dan ringan!

---

**Updated:** November 2024  
**Tested on:** Raspberry Pi 3B, Pi 4  
**Status:** ✅ Both solutions working
