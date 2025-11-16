# 📖 BACA INI DULU! - Bakso Business Lite

## 🎯 Instalasi untuk Raspberry Pi 3B

### ⚡ Quick Install (3 Commands)

```bash
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh
```

**Tunggu 10 menit → Selesai!** ✅

---

## ❗ PENTING: Pilih Script yang Benar

### ✅ Pakai Ini (RECOMMENDED):
```bash
bash setup-lite-node16.sh
```

**Kenapa?**
- ✅ Tidak butuh Node.js
- ✅ Tidak ada error dependency
- ✅ Paling ringan & stabil
- ✅ Cocok untuk Pi 3B

### ❌ Jangan Pakai Ini (Kecuali sudah punya Node 18+):
```bash
bash setup-lite.sh  # Butuh Node.js 18+
```

---

## 📚 Dokumentasi

- **[INSTALL_NO_NODE_ERROR.md](INSTALL_NO_NODE_ERROR.md)** ← Baca ini untuk install tanpa error
- **[WHICH_SCRIPT_TO_USE.md](WHICH_SCRIPT_TO_USE.md)** ← Panduan pilih script
- **[TROUBLESHOOTING_NODE_ERROR.md](TROUBLESHOOTING_NODE_ERROR.md)** ← Jika ada masalah

---

## 🚀 Setelah Install

### Akses Aplikasi
```
http://[IP-PI]:3000
```

### Check Status
```bash
sudo supervisorctl status
```

### View Logs
```bash
sudo supervisorctl tail -f bakso-backend
```

### Restart Services
```bash
sudo supervisorctl restart all
```

---

## 💡 Tips

1. **Pastikan koneksi internet stabil** saat instalasi
2. **Jangan interrupt** proses instalasi (tunggu sampai selesai)
3. **Gunakan setup-lite-node16.sh** untuk Pi 3B
4. **Reboot Pi** jika ada masalah: `sudo reboot`

---

## ✅ Instalasi Berhasil Jika:

```bash
sudo supervisorctl status

# Output harus:
bakso-backend    RUNNING
bakso-frontend   RUNNING
```

Dan aplikasi bisa diakses di browser!

---

## 🆘 Butuh Bantuan?

1. Cek logs: `sudo supervisorctl tail bakso-backend stderr`
2. Restart: `sudo supervisorctl restart all`
3. Baca: [TROUBLESHOOTING_NODE_ERROR.md](TROUBLESHOOTING_NODE_ERROR.md)

---

**Selamat Menggunakan Bakso Business System!** 🍜
