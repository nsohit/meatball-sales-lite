# 🚀 Instalasi TANPA Error Node.js - Dijamin Berhasil!

## ✅ Cara Install yang BENAR untuk Pi 3B

### Step 1: Transfer Paket ke Pi

```bash
# Dari komputer
scp bakso-business-lite.tar.gz pi@[IP-PI]:~/
```

### Step 2: Extract di Pi

```bash
# Di Raspberry Pi
cd ~
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
```

### Step 3: Install dengan Script TANPA Node.js

```bash
bash setup-lite-node16.sh
```

**PENTING:** Jangan pakai `setup-lite.sh` - pakai `setup-lite-node16.sh`!

### Step 4: Tunggu Selesai (8-12 menit)

Script akan otomatis:
- ✅ Install MongoDB
- ✅ Install Python dependencies
- ✅ Extract frontend (static files)
- ✅ Setup Supervisor
- ✅ Start services
- ✅ **TIDAK ADA proses Node.js sama sekali!**

### Step 5: Akses Aplikasi

```
http://[IP-PI]:3000
```

---

## 🔥 Kenapa Pakai setup-lite-node16.sh?

### ❌ Jangan Pakai setup-lite.sh Karena:
- Butuh Node.js 18
- Harus upgrade Node
- Bisa error di Pi lama

### ✅ Pakai setup-lite-node16.sh Karena:
- **TIDAK BUTUH Node.js sama sekali!**
- Frontend sudah 100% pre-built
- Python HTTP server (built-in)
- Supervisor (built-in)
- Zero error!

---

## 🛡️ Jaminan Tanpa Error

Script `setup-lite-node16.sh` dijamin tidak akan error karena:

1. **Frontend sudah pre-built** - Tidak ada proses build
2. **Python HTTP server** - Tidak butuh npm/yarn/serve
3. **Supervisor** - Tidak butuh PM2 (yang perlu Node)
4. **Zero Node.js** - Script aktif prevent Node processes

---

## 📋 Checklist

Sebelum install, pastikan:

- [ ] Pakai script **setup-lite-node16.sh** (bukan setup-lite.sh)
- [ ] File bakso-business-lite.tar.gz sudah di Pi
- [ ] Koneksi internet stabil (untuk install MongoDB & Python)
- [ ] RAM minimal 1GB

---

## ⚠️ Jika Masih Error

Jika masih dapat error, coba:

### 1. Hapus folder Node (jika ada)

```bash
rm -rf ~/.npm ~/.nvm ~/.node-gyp
sudo apt remove -y nodejs npm
```

### 2. Install ulang

```bash
cd ~/bakso-business-lite
bash setup-lite-node16.sh
```

### 3. Cek logs jika service tidak start

```bash
sudo supervisorctl status
sudo supervisorctl tail bakso-backend stderr
```

---

## 🎯 Commands Setelah Install

```bash
# Status
sudo supervisorctl status

# Restart
sudo supervisorctl restart all

# Stop
sudo supervisorctl stop all

# Logs
sudo supervisorctl tail -f bakso-backend
sudo supervisorctl tail -f bakso-frontend
```

---

## 💡 Tips

1. **Jangan masuk folder frontend** - Tidak perlu, sudah auto-setup
2. **Jangan run npm/yarn command** - Tidak dibutuhkan
3. **Jangan install Node.js** - Script tidak butuh Node sama sekali

---

## 🎉 Success Indicators

Instalasi berhasil jika:

```bash
sudo supervisorctl status

# Output:
bakso-backend                    RUNNING   pid 1234, uptime 0:01:23
bakso-frontend                   RUNNING   pid 1235, uptime 0:01:23
```

Test akses:
```bash
curl http://localhost:3000
curl http://localhost:8001/api/
```

Keduanya harus response!

---

## 📞 Still Having Issues?

Jalankan diagnostic:

```bash
# Check Python
python3 --version  # Harus ada

# Check MongoDB
sudo systemctl status mongodb  # Harus running

# Check Supervisor
sudo supervisorctl status  # Kedua service harus RUNNING

# Check memory
free -h  # Minimal 200MB free
```

---

**SUMMARY:**

```bash
# 3 Commands Saja:
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh

# Tunggu 10 menit → SELESAI! ✅
```

**No Node.js. No Error. 100% Works!** 🚀
