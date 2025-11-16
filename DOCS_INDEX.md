# 📚 Dokumentasi Index - Bakso Business System

Panduan lengkap untuk instalasi, penggunaan, dan development sistem Bakso Business.

## 🎯 Untuk Pengguna (User)

### Instalasi Raspberry Pi 3B (Recommended!)

1. **[QUICK_START_LITE.md](QUICK_START_LITE.md)** ⭐ **MULAI DI SINI!**
   - Instalasi super cepat 3 langkah
   - Untuk Raspberry Pi 3B dengan RAM terbatas
   - Sudah include pre-built frontend

2. **[RASPBERRY_PI_3B_LITE.md](RASPBERRY_PI_3B_LITE.md)**
   - Dokumentasi lengkap versi Lite
   - Troubleshooting guide
   - Maintenance procedures
   - Performance optimization tips

### Instalasi Standard (Pi 4, Server, PC)

3. **[RASPBERRY_PI_INSTALL.md](RASPBERRY_PI_INSTALL.md)**
   - Instalasi standard untuk Pi 4
   - Build frontend on-device
   - Untuk device dengan RAM 2GB+

4. **[RASPBERRY_PI_3B_INSTALL.md](RASPBERRY_PI_3B_INSTALL.md)**
   - Instalasi alternatif untuk Pi 3B
   - Dengan Node.js 16 optimization
   - Jika versi Lite tidak cocok

### Guides & Compatibility

5. **[MIGRATE_NODE16.md](MIGRATE_NODE16.md)**
   - Cara migrate ke Node.js 16
   - Fix dependency conflicts
   - Untuk compatibility issues

6. **[NODE16_CHEATSHEET.md](NODE16_CHEATSHEET.md)**
   - Quick reference Node.js 16
   - Common commands
   - Troubleshooting tips

## 👨‍💻 Untuk Developer

### Development & Build

7. **[LITE_PACKAGE_CREATION.md](LITE_PACKAGE_CREATION.md)** ⭐ **WAJIB BACA!**
   - Cara membuat paket lite
   - Build frontend di development machine
   - Package & distribute ke Pi
   - Update procedures

8. **[README.md](README.md)**
   - Overview sistem
   - Tech stack details
   - Development setup
   - API documentation

### Testing & Deployment

9. **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)**
   - Checklist sebelum release
   - Testing procedures
   - Quality assurance steps
   - Rollback plan

10. **Scripts:**
    - `create-lite-package.sh` - Build paket lite otomatis
    - `setup-lite.sh` - Install di Raspberry Pi
    - `test-lite-package.sh` - Test paket sebelum deploy

## 📖 Berdasarkan Use Case

### "Saya ingin install di Raspberry Pi 3B"
→ Baca: [QUICK_START_LITE.md](QUICK_START_LITE.md)

### "Saya ingin install di Raspberry Pi 4"
→ Baca: [RASPBERRY_PI_INSTALL.md](RASPBERRY_PI_INSTALL.md)

### "Aplikasi error saat npm install di Pi 3B"
→ Baca: [RASPBERRY_PI_3B_LITE.md](RASPBERRY_PI_3B_LITE.md) (gunakan versi Lite!)

### "Saya developer, ingin buat paket baru"
→ Baca: [LITE_PACKAGE_CREATION.md](LITE_PACKAGE_CREATION.md)

### "Dependency conflict dengan Node.js"
→ Baca: [MIGRATE_NODE16.md](MIGRATE_NODE16.md)

### "Ingin release ke production"
→ Baca: [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

## 🎓 Learning Path

### Path 1: End User (Pemilik Bisnis)
```
QUICK_START_LITE.md
    ↓
RASPBERRY_PI_3B_LITE.md (Troubleshooting section)
    ↓
README.md (Features overview)
```

### Path 2: System Administrator
```
RASPBERRY_PI_3B_LITE.md (Full doc)
    ↓
setup-lite.sh (Understanding automation)
    ↓
DEPLOYMENT_CHECKLIST.md (Maintenance)
```

### Path 3: Developer
```
README.md (Tech stack)
    ↓
LITE_PACKAGE_CREATION.md (Build process)
    ↓
create-lite-package.sh (Automation)
    ↓
DEPLOYMENT_CHECKLIST.md (QA)
```

## 🔍 Quick Reference

### Installation Commands

**Raspberry Pi 3B Lite:**
```bash
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite.sh
```

**Create Lite Package:**
```bash
bash create-lite-package.sh
```

**Test Package:**
```bash
bash test-lite-package.sh
```

### Useful PM2 Commands

```bash
pm2 status          # Check status
pm2 logs            # View logs
pm2 restart all     # Restart services
pm2 stop all        # Stop services
pm2 monit           # Monitor resources
```

### MongoDB Commands

```bash
sudo systemctl status mongodb      # Check status
sudo systemctl restart mongodb     # Restart
mongodump --out ~/backup          # Backup
```

## 📞 Support & Troubleshooting

### Common Issues

**Issue: Out of memory saat instalasi**
→ Solusi: Gunakan [QUICK_START_LITE.md](QUICK_START_LITE.md) dengan pre-built frontend

**Issue: npm install gagal di Pi 3B**
→ Solusi: Jangan gunakan npm! Gunakan versi Lite yang tidak perlu build

**Issue: Service tidak start setelah reboot**
→ Solusi: Check PM2 autostart dengan `pm2 startup`

**Issue: Port already in use**
→ Solusi: `sudo lsof -i :3000` dan kill process yang bentrok

### Getting Help

1. **Check logs first:**
   ```bash
   pm2 logs
   sudo journalctl -u mongodb
   ```

2. **Check documentation:**
   - Lihat troubleshooting section di [RASPBERRY_PI_3B_LITE.md](RASPBERRY_PI_3B_LITE.md)
   - Check FAQ di [README.md](README.md)

3. **Verify installation:**
   ```bash
   pm2 status
   curl http://localhost:8001/api/
   ```

## 📊 Document Status

| Document | Status | Last Updated | Target Audience |
|----------|--------|--------------|-----------------|
| QUICK_START_LITE.md | ✅ Complete | 2024 | End Users |
| RASPBERRY_PI_3B_LITE.md | ✅ Complete | 2024 | Users & Admins |
| LITE_PACKAGE_CREATION.md | ✅ Complete | 2024 | Developers |
| DEPLOYMENT_CHECKLIST.md | ✅ Complete | 2024 | Developers |
| RASPBERRY_PI_INSTALL.md | ✅ Complete | 2024 | Users |
| MIGRATE_NODE16.md | ✅ Complete | 2024 | Developers |
| NODE16_CHEATSHEET.md | ✅ Complete | 2024 | Developers |
| README.md | ✅ Complete | 2024 | All |

## 🎉 Selamat Menggunakan!

Sistem Bakso Business dirancang untuk mudah digunakan dan diinstall. Pilih dokumentasi yang sesuai dengan kebutuhan Anda dan ikuti langkah-langkahnya.

**Quick Links:**
- 🚀 [Mulai Install](QUICK_START_LITE.md)
- 📦 [Download Paket](../../releases/latest)
- 🐛 [Report Issues](../../issues)
- 💬 [Diskusi](../../discussions)

---

**Last Updated:** November 2024  
**Version:** 1.0.0  
**Platform:** Raspberry Pi 3B/4, Linux, Windows
