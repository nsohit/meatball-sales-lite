# 🎉 Bakso Business v1.0.0 - Lite Edition

## 🚀 Release Highlights

**Versi Lite** untuk Raspberry Pi 3B kini tersedia! Instalasi mudah tanpa memory issues.

### ✨ What's New

- ✅ **Pre-built Frontend** - Tidak perlu npm install/build di Pi!
- ✅ **One-Script Installation** - Satu command, tunggu 10-15 menit, selesai!
- ✅ **Memory Optimized** - Hanya butuh ~400MB RAM (dari 1GB available)
- ✅ **Auto-start on Boot** - Aplikasi jalan otomatis setelah reboot
- ✅ **PM2 Process Manager** - Easy management & monitoring
- ✅ **Complete Documentation** - 6 dokumen lengkap untuk semua user level

## 📦 Download

### For Raspberry Pi 3B (Recommended)

**Lite Package** (806KB):
- [bakso-business-lite.tar.gz](https://github.com/[username]/bakso-business/releases/download/v1.0.0/bakso-business-lite.tar.gz)

### For Development

**Frontend Build Only** (790KB):
- [frontend-build.tar.gz](https://github.com/[username]/bakso-business/releases/download/v1.0.0/frontend-build.tar.gz)

**Source Code**:
- [Source code (zip)](https://github.com/[username]/bakso-business/archive/refs/tags/v1.0.0.zip)
- [Source code (tar.gz)](https://github.com/[username]/bakso-business/archive/refs/tags/v1.0.0.tar.gz)

## 🚀 Quick Start

### Raspberry Pi 3B Installation

```bash
# 1. Transfer file ke Pi
scp bakso-business-lite.tar.gz pi@[IP-PI]:~/

# 2. SSH ke Pi
ssh pi@[IP-PI]

# 3. Extract & Install
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite.sh

# 4. Tunggu 10-15 menit, selesai!
# Access: http://[IP-PI]:3000
```

📘 **Dokumentasi Lengkap:** [QUICK_START_LITE.md](https://github.com/[username]/bakso-business/blob/main/QUICK_START_LITE.md)

## 📋 System Requirements

### Minimum (Lite Version)
- **Hardware:** Raspberry Pi 3B (1GB RAM)
- **OS:** Raspberry Pi OS (Buster/Bullseye/Bookworm)
- **Storage:** 16GB microSD card
- **Network:** For initial installation only

### Recommended
- **Hardware:** Raspberry Pi 4 (2GB+ RAM)
- **OS:** Fresh Raspberry Pi OS install
- **Storage:** 32GB microSD card (Class 10)
- **Network:** Stable connection for installation

## 🎯 Features

### Core Functionality
- ✅ **Dashboard Real-time** - Total pendapatan, laba, bonus karyawan
- ✅ **Manajemen Stok** - Input stok awal & sisa, kalkulasi otomatis
- ✅ **Transaksi Penjualan** - Paket bakso + condiment custom
- ✅ **Pencatatan Pengeluaran** - Track biaya tak terduga
- ✅ **Laporan Keuangan** - Daily & monthly reports
- ✅ **Export Excel** - Professional format reports

### Technical Features
- ✅ **FastAPI Backend** - Modern Python async framework
- ✅ **React 19 Frontend** - Latest UI library
- ✅ **MongoDB Database** - Flexible NoSQL storage
- ✅ **PM2 Process Manager** - Auto-restart, monitoring
- ✅ **Responsive Design** - Works on mobile, tablet, desktop

## 📊 Performance

### Resource Usage (Pi 3B)
- **RAM:** ~400-500MB (dari 1GB)
- **Disk:** ~1.5GB (dengan dependencies)
- **CPU Idle:** 5-15%
- **CPU Active:** 30-60%

### Speed
- **Page Load:** < 5 seconds
- **API Response:** < 2 seconds
- **Installation Time:** 10-15 minutes

## 🔧 What's Included

### Package Contents
```
bakso-business-lite/
├── setup-lite.sh              # Instalasi otomatis
├── frontend-build.tar.gz      # Pre-built React app
├── README.md                  # Dokumentasi
├── backend/
│   ├── server.py              # FastAPI server
│   └── requirements.txt       # Python dependencies
└── frontend/                  # (will be populated by script)
```

### Documentation
- **QUICK_START_LITE.md** - Quick start 3 langkah
- **RASPBERRY_PI_3B_LITE.md** - Dokumentasi lengkap
- **LITE_PACKAGE_CREATION.md** - Developer guide
- **DEPLOYMENT_CHECKLIST.md** - QA checklist
- **DOCS_INDEX.md** - Documentation navigator
- **DOWNLOAD_AND_INSTALL.md** - Complete install guide

### Scripts
- **setup-lite.sh** - Auto installation script
- **create-lite-package.sh** - Build new package
- **test-lite-package.sh** - Package verification

## 🆕 Changes from Standard Version

### What's Different
| Feature | Standard | Lite |
|---------|----------|------|
| Installation | `npm install` + `yarn build` | Pre-built, no npm! |
| Memory Usage | ~800MB+ | ~400-500MB |
| Install Time | 1+ hour | 10-15 minutes |
| CPU Usage | Higher (build) | Lower (no build) |
| Disk Space | ~2.5GB | ~1.5GB |

### What's the Same
- ✅ All features identical
- ✅ Same tech stack
- ✅ Same API endpoints
- ✅ Same UI/UX
- ✅ Same functionality

## 🐛 Known Issues

### Installation
- **Issue:** Script requires internet connection
  - **Workaround:** Download dependencies manual or use pre-configured Pi

### Runtime
- **Issue:** First load might be slow (< 10 seconds)
  - **Cause:** Cold start, database connection
  - **Workaround:** Wait, subsequent loads fast

### Compatibility
- **Issue:** Only tested on Pi 3B and Pi 4
  - **Status:** Should work on Pi 3B+, Pi 400, Pi Zero 2 (not tested)

## 🔄 Upgrade Path

### From Previous Versions
Ini adalah first release, tidak ada upgrade path yet.

### Future Updates
```bash
# Stop aplikasi
pm2 stop all

# Backup database
mongodump --out ~/backup

# Download & extract new version
tar -xzf bakso-business-lite-v1.1.0.tar.gz
cd bakso-business-lite

# Run update
bash setup-lite.sh

# Restart (automatic)
```

## 🙏 Acknowledgments

### Technologies Used
- **FastAPI** - High-performance Python web framework
- **React** - Modern UI library
- **MongoDB** - Flexible NoSQL database
- **PM2** - Advanced process manager
- **Shadcn/UI** - Beautiful component library
- **Tailwind CSS** - Utility-first CSS framework

## 📞 Support

### Documentation
- 📘 [Full Documentation](https://github.com/[username]/bakso-business/blob/main/RASPBERRY_PI_3B_LITE.md)
- 🚀 [Quick Start](https://github.com/[username]/bakso-business/blob/main/QUICK_START_LITE.md)
- 👨‍💻 [Developer Guide](https://github.com/[username]/bakso-business/blob/main/LITE_PACKAGE_CREATION.md)

### Get Help
- 🐛 [Report Issues](https://github.com/[username]/bakso-business/issues)
- 💬 [Discussions](https://github.com/[username]/bakso-business/discussions)
- 📧 [Email Support](mailto:support@example.com)

### Community
- ⭐ [Star on GitHub](https://github.com/[username]/bakso-business)
- 🍴 [Fork & Contribute](https://github.com/[username]/bakso-business/fork)
- 📢 [Share with Friends](https://twitter.com/intent/tweet?text=Check+out+Bakso+Business+System)

## 🗓️ Release Information

- **Version:** 1.0.0 (Lite Edition)
- **Release Date:** November 16, 2024
- **Type:** Stable Release
- **Platform:** Raspberry Pi 3B/4, Linux
- **License:** MIT

## 🔐 Security Notes

- ✅ No default passwords (except MongoDB - should be configured)
- ✅ CORS configured for local network only
- ✅ No sensitive data in logs
- ⚠️ **Important:** Configure firewall if exposed to internet
- ⚠️ **Important:** Change default Pi password from `raspberry`

## 📸 Screenshots

### Dashboard
![Dashboard](screenshots/dashboard.png)
*Real-time overview dengan total pendapatan, laba, dan bonus*

### Stock Management
![Stock](screenshots/stock.png)
*Input stok harian dengan kalkulasi otomatis*

### Transactions
![Transactions](screenshots/transactions.png)
*Catat penjualan paket dengan condiment custom*

### Reports
![Reports](screenshots/reports.png)
*Export laporan ke Excel format professional*

## 🎯 Roadmap

### v1.1.0 (Planned)
- [ ] Tambah grafik penjualan
- [ ] Multi-user support
- [ ] Role-based access control
- [ ] Automated daily backup

### v2.0.0 (Future)
- [ ] Mobile app (React Native)
- [ ] Cloud sync
- [ ] Advanced analytics
- [ ] Invoice generation

## 📝 Changelog

### [1.0.0] - 2024-11-16

#### Added
- ✅ Pre-built frontend for Lite installation
- ✅ One-script automated installation
- ✅ PM2 process management
- ✅ MongoDB optimization for 1GB RAM
- ✅ Complete documentation suite
- ✅ Package creation & testing scripts
- ✅ Auto-start on boot configuration

#### Changed
- 🔄 Installation process simplified to 1 command
- 🔄 Memory usage reduced by 50%
- 🔄 Installation time reduced from 1+ hour to 10-15 minutes

#### Fixed
- 🐛 Out-of-memory errors on Pi 3B
- 🐛 Dependency conflicts with Node.js 16
- 🐛 Long installation times

## ⚖️ License

MIT License - See [LICENSE](LICENSE) file for details

---

**Happy Managing! 🍜**

Dibuat dengan ❤️ untuk komunitas penjual bakso Indonesia  
Raspberry Pi 3B Ready! 🥧
