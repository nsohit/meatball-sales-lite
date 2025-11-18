# 🔄 Cara Install Ulang Bakso Business (Clean Install)

## 🎯 Kapan Perlu Install Ulang?

- Update ke versi baru
- Fix masalah yang tidak bisa diselesaikan
- Hapus branding Emergent yang masih muncul
- Clean slate untuk testing

---

## 📋 Metode 1: Uninstall Lalu Install Ulang (Recommended)

### **Step 1: Backup Database (Optional tapi Recommended)**

```bash
# Backup database
mongodump --db bakso_business --out ~/backup-$(date +%Y%m%d)

# Verify backup
ls -lh ~/backup-*
```

### **Step 2: Download Script Uninstall**

```bash
# Jika ada di paket
cd ~/bakso-business-lite
bash uninstall.sh

# Atau manual (lihat Metode 2 di bawah)
```

### **Step 3: Download Paket Baru**

```bash
cd ~

# Download dari GitHub
git clone https://github.com/[username]/[repo].git
cd [repo]

# Atau jika sudah punya
git pull origin main
```

### **Step 4: Install Versi Baru**

```bash
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh
```

### **Step 5: Restore Database (Jika Perlu)**

```bash
# Jika ingin restore data lama
mongorestore --db bakso_business ~/backup-20241118/bakso_business/
```

### **Step 6: Clear Browser Cache**

```
Ctrl + Shift + R (hard refresh)
```

---

## 📋 Metode 2: Manual Uninstall (Step by Step)

Jika tidak ada script uninstall atau ingin manual:

### **1. Stop Services**

```bash
# Jika pakai Supervisor
sudo supervisorctl stop bakso-backend
sudo supervisorctl stop bakso-frontend

# Jika pakai PM2
pm2 stop all
pm2 delete all
```

### **2. Remove Service Configs**

```bash
# Supervisor
sudo rm -f /etc/supervisor/conf.d/bakso-backend.conf
sudo rm -f /etc/supervisor/conf.d/bakso-frontend.conf
sudo supervisorctl reread
sudo supervisorctl update

# PM2
pm2 unstartup
```

### **3. Remove Application Files**

```bash
# Remove app directory
rm -rf ~/bakso-business-lite

# Remove tar files
rm -f ~/bakso-business-lite.tar.gz
rm -f ~/frontend-build.tar.gz
```

### **4. Optional: Clean Database**

```bash
# Backup dulu
mongodump --db bakso_business --out ~/backup

# Hapus database (HATI-HATI!)
mongo bakso_business --eval "db.dropDatabase()"
# atau
mongosh bakso_business --eval "db.dropDatabase()"
```

### **5. Optional: Remove Dependencies**

```bash
# Hanya jika tidak dipakai aplikasi lain!

# Remove PM2
npm uninstall -g pm2

# Remove MongoDB (HATI-HATI!)
sudo systemctl stop mongodb
sudo apt remove -y mongodb
sudo apt autoremove -y
```

---

## 📋 Metode 3: Update in Place (Tanpa Uninstall)

Jika hanya update file frontend:

### **Step 1: Stop Frontend**

```bash
sudo supervisorctl stop bakso-frontend
# atau
pm2 stop bakso-frontend
```

### **Step 2: Backup Old Build**

```bash
cd ~/bakso-business-lite/frontend
mv build build.old
```

### **Step 3: Extract New Build**

```bash
tar -xzf ../frontend-build.tar.gz
```

### **Step 4: Restart Frontend**

```bash
sudo supervisorctl restart bakso-frontend
# atau
pm2 restart bakso-frontend
```

### **Step 5: Clear Browser Cache**

```
Ctrl + Shift + R
```

---

## 🎯 Quick Commands

### **Uninstall Cepat (Tanpa Backup)**

```bash
# Stop services
sudo supervisorctl stop all
pm2 stop all; pm2 delete all

# Remove configs
sudo rm -f /etc/supervisor/conf.d/bakso-*.conf
sudo supervisorctl reread; sudo supervisorctl update

# Remove files
rm -rf ~/bakso-business-lite ~/bakso-business-lite.tar.gz

echo "✓ Uninstall complete!"
```

### **Install Ulang Cepat**

```bash
cd ~
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh
```

---

## ✅ Checklist Setelah Install Ulang

### **1. Services Running**

```bash
sudo supervisorctl status

# Harus muncul:
# bakso-backend    RUNNING
# bakso-frontend   RUNNING
```

### **2. Backend Accessible**

```bash
curl http://localhost:8001/api/
# Harus return JSON
```

### **3. Frontend Accessible**

```bash
curl http://localhost:3000
# Harus return HTML
```

### **4. Browser Test**

Buka: `http://[IP-PI]:3000`

**Check:**
- ✅ Title: "Bakso Business" (bukan "Emergent | Fullstack App")
- ✅ No badge "Made with Emergent"
- ✅ Form input muncul
- ✅ No error di console

### **5. Data Test**

- Input stok → Save → Harus berhasil
- View dashboard → Harus muncul data
- Export Excel → Harus work

---

## 🐛 Troubleshooting

### **Services Tidak Start**

```bash
# Check logs
sudo supervisorctl tail bakso-backend stderr
sudo supervisorctl tail bakso-frontend stderr

# Restart all
sudo supervisorctl restart all
```

### **Port Already in Use**

```bash
# Check what's using port
sudo lsof -i :8001
sudo lsof -i :3000

# Kill process
sudo kill -9 [PID]
```

### **MongoDB Not Running**

```bash
sudo systemctl status mongodb
sudo systemctl restart mongodb
```

### **Title Masih "Emergent"**

```bash
# Clear browser cache
Ctrl + Shift + R

# Or private window
Ctrl + Shift + N
```

### **Form Tidak Muncul**

```bash
# Check backend
curl http://localhost:8001/api/

# Check frontend build
ls -la ~/bakso-business-lite/frontend/build/

# Check browser console
# F12 → Console tab → lihat error
```

---

## 💡 Tips

### **Backup Otomatis**

Buat cron job untuk backup database harian:

```bash
# Edit crontab
crontab -e

# Tambahkan (backup setiap jam 2 pagi)
0 2 * * * mongodump --db bakso_business --out ~/backups/backup-$(date +\%Y\%m\%d)
```

### **Keep Old Versions**

```bash
# Rename instead of delete
mv ~/bakso-business-lite ~/bakso-business-lite.old

# Test new version
# If ok, delete old:
rm -rf ~/bakso-business-lite.old
```

### **Fast Rollback**

Jika versi baru bermasalah:

```bash
# Stop new version
sudo supervisorctl stop all

# Restore old version
mv ~/bakso-business-lite.old ~/bakso-business-lite

# Start old version
sudo supervisorctl start all
```

---

## 📝 Summary Commands

```bash
# === FULL CLEAN INSTALL ===

# 1. Backup
mongodump --db bakso_business --out ~/backup

# 2. Uninstall
bash uninstall.sh

# 3. Download new
cd ~
git pull  # or git clone

# 4. Install
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite-node16.sh

# 5. Clear cache
# Browser: Ctrl + Shift + R

# 6. Verify
curl http://localhost:8001/api/
curl http://localhost:3000
```

---

## 🆘 Butuh Bantuan?

Jika ada masalah saat uninstall atau install ulang:

1. Check logs: `sudo supervisorctl tail [service] stderr`
2. Check status: `sudo supervisorctl status`
3. Restart: `sudo supervisorctl restart all`
4. Reboot: `sudo reboot`

**File sudah include script uninstall.sh untuk memudahkan proses!**
