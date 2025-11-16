# 🚀 Quick Start - Bakso Business Lite (Raspberry Pi 3B)

## Instalasi Super Cepat - 3 Langkah Saja!

### 📥 Langkah 1: Download & Transfer ke Raspberry Pi

**Pilihan A: Via SCP (dari komputer)**
```bash
scp bakso-business-lite.tar.gz pi@[IP-RASPBERRY-PI]:~/
```

**Pilihan B: Via USB Drive**
1. Copy `bakso-business-lite.tar.gz` ke USB drive
2. Colok USB ke Raspberry Pi
3. Copy file: `cp /media/usb/bakso-business-lite.tar.gz ~/`

### 📦 Langkah 2: Extract di Raspberry Pi

```bash
# SSH ke Raspberry Pi (jika belum)
ssh pi@[IP-RASPBERRY-PI]

# Extract paket
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
```

### ⚡ Langkah 3: Jalankan Instalasi

```bash
bash setup-lite.sh
```

**Tunggu 10-15 menit**, script akan otomatis:
- ✅ Install MongoDB
- ✅ Install Python & dependencies
- ✅ Setup backend
- ✅ Deploy frontend (sudah pre-built!)
- ✅ Install PM2 process manager
- ✅ Start semua services
- ✅ Configure autostart

### 🎉 Selesai!

Akses aplikasi di browser:
- **Frontend**: `http://[IP-RASPBERRY-PI]:3000`
- **Backend API**: `http://[IP-RASPBERRY-PI]:8001/api/`
- **API Docs**: `http://[IP-RASPBERRY-PI]:8001/docs`

## 🎮 Perintah Berguna

```bash
# Cek status aplikasi
pm2 status

# Lihat logs
pm2 logs

# Restart aplikasi
pm2 restart all

# Stop aplikasi
pm2 stop all

# Monitor resource
pm2 monit
```

## 🆘 Troubleshooting

**Aplikasi tidak bisa diakses?**
```bash
pm2 restart all
```

**MongoDB error?**
```bash
sudo systemctl restart mongodb
pm2 restart all
```

**Port sudah digunakan?**
```bash
sudo lsof -i :3000
sudo lsof -i :8001
# Kill process yang menggunakan port tersebut
```

## 📱 Fitur Aplikasi

✅ **Manajemen Stok Harian**
- Input stok awal & sisa akhir hari
- Perhitungan otomatis barang terjual

✅ **Transaksi Penjualan**
- Catat penjualan paket
- Tambah condiment dengan harga berjenjang

✅ **Pencatatan Pengeluaran**
- Catat pengeluaran tak terduga
- Terintegrasi dengan laporan keuangan

✅ **Laporan Keuangan**
- Laporan harian & bulanan
- Perhitungan otomatis: omzet, biaya, laba, bonus
- Export ke Excel

✅ **Dashboard Real-time**
- Summary keuangan hari ini
- Grafik penjualan
- Status stok

## 💡 Tips

1. **Backup database secara berkala**:
   ```bash
   mongodump --out ~/backup-$(date +%Y%m%d)
   ```

2. **Cek penggunaan memory**:
   ```bash
   free -h
   pm2 monit
   ```

3. **Update aplikasi**: Stop → Extract versi baru → Restart

## 📞 Butuh Bantuan?

1. Cek logs: `pm2 logs`
2. Restart services: `pm2 restart all`
3. Reboot Pi: `sudo reboot`

---

**Selamat menggunakan Bakso Business System! 🍜**

Memory usage: ~400-500MB (sangat efisien untuk Pi 3B!)
