# 🤔 Mana Script yang Harus Saya Pakai?

Panduan memilih script instalasi yang tepat untuk Raspberry Pi Anda.

---

## 📊 Quick Decision Chart

```
Punya Node.js? 
    ├─ Tidak → Pakai setup-lite-node16.sh ✅ (Recommended!)
    │
    └─ Ya → Versi berapa?
           ├─ v16 → Bisa upgrade? 
           │        ├─ Ya → setup-lite.sh
           │        └─ Tidak → setup-lite-node16.sh ✅
           │
           └─ v18+ → setup-lite.sh
```

---

## 🎯 Rekomendasi Cepat

### 👉 Pilih `setup-lite-node16.sh` jika:

- ✅ Ini instalasi pertama kali
- ✅ Anda pengguna biasa (bukan developer)
- ✅ Ingin instalasi paling mudah & ringan
- ✅ Pi 3B dengan RAM 1GB
- ✅ Dapat error tentang Node.js version
- ✅ Tidak mau ribet dengan Node.js

**Alasan:** 
- Tidak butuh Node.js sama sekali
- Memory paling hemat (~350MB)
- Paling stabil dengan Supervisor
- Cocok untuk semua tipe Pi

### 👉 Pilih `setup-lite.sh` jika:

- ✅ Pi 4 dengan RAM ≥2GB
- ✅ Sudah punya Node.js v18+
- ✅ Ingin monitoring lengkap dengan PM2
- ✅ Developer yang familiar dengan Node ecosystem

**Alasan:**
- PM2 features lebih lengkap
- Monitoring real-time lebih bagus
- Sesuai standard development modern

---

## 📋 Perbandingan Lengkap

| Aspek | setup-lite.sh | setup-lite-node16.sh |
|-------|---------------|----------------------|
| **Node.js** | Required v18+ | **TIDAK PERLU** ❌ |
| **Frontend Server** | `serve` (npm package) | Python HTTP Server |
| **Process Manager** | PM2 | Supervisor |
| **Memory Usage** | ~400-450MB | ~350-400MB ⬇️ |
| **CPU Usage** | Normal | Sedikit lebih rendah ⬇️ |
| **Startup Time** | ~5-8 detik | ~3-5 detik ⬇️ |
| **Monitoring** | PM2 dashboard | Basic logs |
| **Auto-restart** | ✅ Ya | ✅ Ya |
| **Auto-start boot** | ✅ Ya (systemd) | ✅ Ya (systemd) |
| **Installation Time** | 10-15 menit | 8-12 menit ⬇️ |
| **Stability** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Ease of Use** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **For Beginners** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 💻 Commands Reference

### setup-lite.sh (PM2)

```bash
# Instalasi
bash setup-lite.sh

# Management
pm2 status
pm2 logs
pm2 restart all
pm2 stop all
pm2 monit

# Auto-start (sudah dikonfigurasi otomatis)
pm2 startup
pm2 save
```

### setup-lite-node16.sh (Supervisor)

```bash
# Instalasi
bash setup-lite-node16.sh

# Management
sudo supervisorctl status
sudo supervisorctl tail -f bakso-backend
sudo supervisorctl tail -f bakso-frontend
sudo supervisorctl restart all
sudo supervisorctl stop all
sudo supervisorctl start all

# Auto-start (sudah dikonfigurasi otomatis)
# Via systemd, no extra steps needed
```

---

## 🔧 Technical Details

### setup-lite.sh

**Stack:**
```
Frontend: React build → serve (Node.js)
Backend: FastAPI → uvicorn
Database: MongoDB
Process: PM2
```

**Dependencies:**
- Node.js 18+
- npm/yarn (untuk install serve)
- Python 3
- MongoDB

**Pros:**
- Modern tooling
- Rich monitoring features
- Good for development environment
- Cross-platform compatible

**Cons:**
- Butuh Node.js 18
- Sedikit lebih berat

### setup-lite-node16.sh

**Stack:**
```
Frontend: React build → Python HTTP Server
Backend: FastAPI → uvicorn
Database: MongoDB
Process: Supervisor
```

**Dependencies:**
- Python 3 (built-in di Raspberry Pi OS)
- MongoDB

**Pros:**
- **Zero Node.js dependency!**
- Memory efficient
- Very stable (Supervisor battle-tested)
- Native to Linux/Raspberry Pi
- Simpler architecture

**Cons:**
- Monitoring tidak se-fancy PM2
- Commands perlu sudo

---

## 🎓 Use Cases

### Home User / Small Business

**Recommendation:** `setup-lite-node16.sh`

**Why:**
- Paling mudah (tidak perlu install Node)
- Paling hemat resource
- Rock-solid stability
- Set-and-forget installation

### Developer / Tech Enthusiast

**Recommendation:** `setup-lite.sh`

**Why:**
- Modern stack
- Better monitoring tools
- Familiar with PM2
- Easier debugging

### Production / 24/7 Operation

**Recommendation:** `setup-lite-node16.sh`

**Why:**
- Maximum stability
- Lower resource usage
- Proven supervisor reliability
- Less moving parts = less failure points

---

## 🚀 Installation Examples

### Example 1: Fresh Pi 3B (No Node)

**User:** Pemilik warung bakso, first time setup

**Best Choice:** `setup-lite-node16.sh`

```bash
# Simple, straight to the point
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh
# Done! 🎉
```

### Example 2: Pi 4 with Node 18

**User:** Developer, sudah ada Node 18

**Best Choice:** `setup-lite.sh`

```bash
node --version  # v18.19.0 ✅
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite.sh
# Done! Get PM2 monitoring 📊
```

### Example 3: Pi 3B with Node 16

**User:** Ada Node 16, tidak mau upgrade

**Best Choice:** `setup-lite-node16.sh`

```bash
node --version  # v16.20.2
# Don't upgrade, just use Python version
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh
# Skip Node drama! ✅
```

---

## ❓ FAQ

### Q: Apakah frontend berbeda antara 2 versi?

**A:** Tidak! Frontend identik 100%. Hanya cara serve-nya yang beda:
- `setup-lite.sh`: Pakai `serve` (Node package)
- `setup-lite-node16.sh`: Pakai Python HTTP server

Keduanya serve file static yang sama.

### Q: Performance berbeda?

**A:** Hampir tidak terasa. Python HTTP server bahkan sedikit lebih cepat untuk file static sederhana.

### Q: Bisa switch dari satu ke lainnya?

**A:** Ya, tapi harus reinstall. Stop services dulu, backup data, install ulang dengan script yang lain.

### Q: Mana yang lebih recommended untuk production?

**A:** Untuk Raspberry Pi 3B, `setup-lite-node16.sh` lebih recommended karena stability dan resource efficiency.

### Q: Apakah features aplikasi berbeda?

**A:** Tidak! Semua features identik:
- Dashboard
- Stock management
- Transactions
- Reports
- Excel export

Semuanya sama, hanya infrastructure yang berbeda.

### Q: Bagaimana kalau dapat error Node version?

**A:** Gunakan `setup-lite-node16.sh` - problem solved! Tidak perlu Node sama sekali.

---

## 📝 Summary

### Untuk 90% Users → Pakai `setup-lite-node16.sh`

**Kenapa?**
- ✅ Paling mudah (no Node drama)
- ✅ Paling ringan (save 50MB RAM)
- ✅ Paling stabil (Supervisor proven)
- ✅ Cocok untuk Pi 3B
- ✅ Zero dependency issues

### Untuk Developers → Pakai `setup-lite.sh`

**Kenapa?**
- ✅ Modern tooling (PM2)
- ✅ Better monitoring
- ✅ Familiar workflow
- ✅ Good for Pi 4+

---

## 🎯 Final Recommendation

**Tidak yakin mau pakai yang mana?**

→ **Pakai `setup-lite-node16.sh`**

Ini adalah **pilihan paling aman** untuk:
- First-time users
- Raspberry Pi 3B
- Production use
- Set-and-forget installations

Aplikasi akan jalan sempurna dengan resources minimal!

---

**Need help?** Lihat [TROUBLESHOOTING_NODE_ERROR.md](TROUBLESHOOTING_NODE_ERROR.md)

**Updated:** November 2024  
**Tested on:** Pi 3B, Pi 3B+, Pi 4
