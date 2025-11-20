# 📱 Cara Akses yang BENAR

## ⚠️ PENTING: Format URL yang Benar

### ❌ **SALAH:**
```
http://192.168.147.3000     (TIDAK ADA TITIK DUA!)
http://192.168.172.3000     (SALAH FORMAT!)
```

### ✅ **BENAR:**
```
http://192.168.147.x:3000   (ADA TITIK DUA SEBELUM PORT!)
http://192.168.172.147:3000 (FORMAT IP:PORT)
http://localhost:3000       (DARI PI SENDIRI)
```

---

## 🎯 Penjelasan Format URL

### Anatomy URL yang Benar:
```
http://  [IP ADDRESS]  :  [PORT]
         └────┬────┘    └──┬──┘
         192.168.x.x      3000
```

**Format lengkap:**
- **Protocol:** `http://`
- **IP Address:** `192.168.x.x` (4 angka dipisah titik)
- **Separator:** `:` (TITIK DUA - ini wajib!)
- **Port:** `3000` (nomor port)

---

## 📋 Cara Cari IP Address Pi Anda

### Step 1: Buka Terminal di Raspberry Pi

```bash
hostname -I
```

**Contoh output:**
```
192.168.172.147 192.168.1.1
```

Ambil IP yang pertama: **192.168.172.147**

---

### Step 2: Buat URL dengan Format yang Benar

**Jika IP Pi adalah:** `192.168.172.147`

**Maka URL yang benar:**
```
Frontend: http://192.168.172.147:3000
Backend:  http://192.168.172.147:8001
```

**PERHATIKAN TITIK DUA (`:`) SEBELUM NOMOR PORT!**

---

## 🌐 Cara Akses dari Berbagai Device

### 1️⃣ **Akses dari Raspberry Pi Sendiri**

Buka browser di Pi, ketik:
```
http://localhost:3000
```

ATAU

```
http://127.0.0.1:3000
```

**Cara cepat:** Tekan `Ctrl+T` (new tab) lalu ketik URL di atas.

---

### 2️⃣ **Akses dari HP (Android/iPhone)**

**Syarat:** HP dan Pi harus di WiFi yang SAMA!

**Step-by-step:**

1. **Cek IP Pi:**
   ```bash
   # Di terminal Pi
   hostname -I
   ```
   Contoh output: `192.168.172.147`

2. **Buka browser di HP** (Chrome/Firefox/Safari)

3. **Ketik URL dengan format yang BENAR:**
   ```
   http://192.168.172.147:3000
   ```
   *(Ganti dengan IP Pi Anda)*

4. **Tekan Enter/Go**

---

### 3️⃣ **Akses dari Laptop/PC**

**Syarat:** Laptop dan Pi harus di WiFi yang SAMA!

**Step-by-step:**

1. **Cek IP Pi:**
   ```bash
   hostname -I
   ```

2. **Buka browser di laptop** (Chrome/Firefox/Edge)

3. **Ketik URL:**
   ```
   http://192.168.172.147:3000
   ```

4. **Bookmark URL** untuk akses cepat nanti!

---

## 🔧 Troubleshooting URL

### Masalah 1: "Site can't be reached"

**Penyebab:**
- ❌ Format URL salah (tidak ada titik dua)
- ❌ IP address salah
- ❌ Backend tidak jalan
- ❌ Device tidak di WiFi yang sama

**Solusi:**

1. **Cek format URL:**
   ```
   ✓ http://192.168.x.x:3000  (BENAR - ada titik dua)
   ✗ http://192.168.x.x3000   (SALAH - tidak ada titik dua)
   ```

2. **Cek IP Pi lagi:**
   ```bash
   hostname -I
   ```

3. **Test dari Pi dulu:**
   ```bash
   curl http://localhost:3000
   ```

4. **Cek services:**
   ```bash
   sudo supervisorctl status
   ```

---

### Masalah 2: "Connection timeout" atau Loading Lama

**Solusi:**

1. **Restart services:**
   ```bash
   sudo supervisorctl restart all
   ```

2. **Tunggu 30 detik**, lalu refresh browser

3. **Cek backend:**
   ```bash
   curl http://localhost:8001/api/
   ```
   
   Harus return: `{"message":"Bakso Business System API"}`

---

### Masalah 3: Page Blank/Kosong

**Cek browser console:**
1. Tekan **F12** di browser
2. Klik tab **Console**
3. Cek ada error?

**Common error:**
- `ERR_CONNECTION_REFUSED` → Backend tidak jalan
- `CORS error` → Config backend salah
- `timeout` → Backend lambat, tunggu atau restart

---

## 📝 Contoh URL untuk Berbagai Skenario

### Scenario 1: IP Pi = `192.168.1.100`

```
Frontend: http://192.168.1.100:3000
Backend:  http://192.168.1.100:8001
API Docs: http://192.168.1.100:8001/docs
```

---

### Scenario 2: IP Pi = `10.0.0.50`

```
Frontend: http://10.0.0.50:3000
Backend:  http://10.0.0.50:8001
```

---

### Scenario 3: IP Pi = `172.16.0.20`

```
Frontend: http://172.16.0.20:3000
Backend:  http://172.16.0.20:8001
```

---

## 💡 Tips & Best Practices

### 1. Set Static IP di Router

**Kenapa?** Biar IP Pi tidak berubah setiap restart.

**Cara:**
- Masuk ke router settings (biasanya 192.168.1.1)
- Cari "DHCP Reservation" atau "Static IP"
- Assign IP tetap ke MAC address Pi

---

### 2. Bookmark URL di Semua Device

**Di Browser:**
1. Buka aplikasi: `http://[IP-Pi]:3000`
2. Klik ⭐ (bookmark/favorite)
3. Nama: "Bakso Business"

**Di HP:**
1. Buka URL di browser
2. Tap "Add to Home Screen"
3. Sekarang ada icon di home screen!

---

### 3. Buat Shortcut di Desktop Pi

**Create desktop shortcut:**

1. Klik kanan di desktop → Create New → Link

2. Command:
   ```
   chromium-browser http://localhost:3000
   ```

3. Nama: "Bakso Business"

4. Double-click untuk buka aplikasi!

---

## 🆘 Quick Fix Commands

### Cek Status:
```bash
bash check-status.sh
```

### Restart All:
```bash
sudo supervisorctl restart all
```

### Cek Logs:
```bash
sudo supervisorctl tail -f bakso-backend stderr
```

### Test Backend:
```bash
curl http://localhost:8001/api/
```

### Cek IP:
```bash
hostname -I
```

---

## 📖 Format IP Address Cheat Sheet

```
FORMAT STANDAR:
XXX.XXX.XXX.XXX:PORT

PRIVATE IP RANGES:
192.168.0.0   - 192.168.255.255
10.0.0.0      - 10.255.255.255
172.16.0.0    - 172.31.255.255

CONTOH VALID:
✓ 192.168.1.100:3000
✓ 10.0.0.50:3000
✓ 172.16.0.20:3000
✓ localhost:3000
✓ 127.0.0.1:3000

CONTOH SALAH:
✗ 192.168.1.1003000    (tidak ada titik dua)
✗ 192.168.1003000      (format IP salah)
✗ 192.168.1.100 3000   (pakai spasi)
✗ 192.168.1.100/3000   (pakai slash)
```

---

**✅ INGAT: Selalu gunakan TITIK DUA (`:`) antara IP dan PORT!**

Format yang benar: `http://[IP]:3000` bukan `http://[IP]3000`
