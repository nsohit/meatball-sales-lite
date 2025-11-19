# 📦 Fitur Carry-Over Stok (Stok Otomatis Hari Berikutnya)

## 🎯 Penjelasan Fitur

Aplikasi sekarang mendukung **carry-over stok** sesuai dengan business logic bakso:

### **2 Kategori Barang**

#### 1️⃣ **Barang yang Dijual Lagi Besok (Carry-Over)**

Sisa hari ini **OTOMATIS** masuk ke stok awal besok:

- ✅ **Bakso Urat**
- ✅ **Bakso Kecil**  
- ✅ **Tahu**
- ✅ **Somay**

#### 2️⃣ **Barang yang Harus Habis (Non Carry-Over)**

Sisa hari ini **TIDAK** dibawa besok (harus habis):

- ❌ **Pangsit Malang**
- ❌ **Soun**

---

## 🔄 Cara Kerja Carry-Over

### **Skenario Contoh**

#### **Hari Senin:**
**Input Stok Awal:**
- Bakso Urat: 50
- Bakso Kecil: 100
- Tahu: 80
- Somay: 60
- Pangsit Malang: 20
- Soun: 10

**Input Stok Sisa (Akhir Hari):**
- Bakso Urat: 10 (dibawa pulang)
- Bakso Kecil: 15 (dibawa pulang)
- Tahu: 5 (dibawa pulang)
- Somay: 8 (dibawa pulang)
- Pangsit Malang: 0 (harus habis!)
- Soun: 0 (harus habis!)

**Yang Terjual:**
- Bakso Urat: 50 - 10 = 40 pcs
- Bakso Kecil: 100 - 15 = 85 pcs
- Tahu: 80 - 5 = 75 pcs
- Somay: 60 - 8 = 52 pcs
- Pangsit Malang: 20 pcs
- Soun: 10 pcs

---

#### **Hari Selasa:**

**Input Stok Bawa Baru:**
- Bakso Urat: 40 (bawa baru)
- Bakso Kecil: 80 (bawa baru)
- Tahu: 70 (bawa baru)
- Somay: 50 (bawa baru)
- Pangsit Malang: 25 (bawa baru)
- Soun: 12 (bawa baru)

**Stok Awal Selasa (OTOMATIS):**
```
Bakso Urat    = 40 (baru) + 10 (sisa kemarin) = 50 ✓
Bakso Kecil   = 80 (baru) + 15 (sisa kemarin) = 95 ✓
Tahu          = 70 (baru) + 5  (sisa kemarin) = 75 ✓
Somay         = 50 (baru) + 8  (sisa kemarin) = 58 ✓
Pangsit Malang = 25 (baru) + 0 (tidak carry)   = 25 ✓
Soun          = 12 (baru) + 0 (tidak carry)   = 12 ✓
```

**User hanya input "bawa baru", sistem otomatis tambahkan sisa kemarin!**

---

## 🖥️ Tampilan di UI

### **Form Input Stok Awal**

```
┌─────────────────────────────────────────────────────┐
│ INPUT STOK AWAL HARI INI                            │
├─────────────────────────────────────────────────────┤
│                                                      │
│ Bakso Urat (Dijual lagi besok)      [____]         │
│ Bakso Kecil (Dijual lagi besok)     [____]         │
│ Tahu (Dijual lagi besok)            [____]         │
│ Somay (Dijual lagi besok)           [____]         │
│ Pangsit Malang (Harus habis)        [____]         │
│ Soun (Harus habis)                  [____]         │
│                                                      │
│ ℹ️ Stok kemarin (jika ada) akan ditambahkan        │
│    otomatis untuk bakso urat, kecil, tahu & somay! │
│                                                      │
│ [Simpan Stok Awal]                                  │
└─────────────────────────────────────────────────────┘
```

### **Form Input Stok Sisa**

```
┌─────────────────────────────────────────────────────┐
│ INPUT STOK SISA                                      │
├─────────────────────────────────────────────────────┤
│ Catat sisa barang yang dibawa pulang.               │
│ ✓ Sisa bakso urat, kecil, tahu & somay → besok     │
│ ✗ Pangsit & Soun harus habis!                      │
├─────────────────────────────────────────────────────┤
│                                                      │
│ Bakso Urat (Sisa → besok)          [____]          │
│ Bakso Kecil (Sisa → besok)         [____]          │
│ Tahu (Sisa → besok)                [____]          │
│ Somay (Sisa → besok)               [____]          │
│ Pangsit Malang (Harus habis!)      [ 0 ] (disabled)│
│ Soun (Harus habis!)                [ 0 ] (disabled)│
│                                                      │
│ [Simpan Stok Sisa]                                  │
└─────────────────────────────────────────────────────┘
```

**Pangsit & Soun otomatis 0 dan disabled (tidak bisa diubah)**

---

## 💡 Keuntungan Fitur Ini

### **1. Otomatis & Akurat**
- ✅ Tidak perlu ingat sisa kemarin
- ✅ Sistem otomatis hitung & tambahkan
- ✅ Tidak ada human error

### **2. Business Logic yang Benar**
- ✅ Bakso/tahu/somay: Bisa dijual lagi → carry-over
- ✅ Pangsit/soun: Harus habis → tidak carry-over

### **3. Laporan Lebih Akurat**
- ✅ Stok sold/remaining tepat
- ✅ Revenue calculation benar
- ✅ Inventory management proper

---

## 🔧 Technical Details

### **Backend Logic**

```python
# Konstanta
CARRY_OVER_ITEMS = ['bakso_urat', 'bakso_kecil', 'tahu', 'somay']
NON_CARRY_OVER_ITEMS = ['pangsit_malang', 'soun']

# Saat create stock baru
1. Get input stok bawa baru
2. Check kemarin ada sisa?
3. If yes, tambahkan sisa untuk CARRY_OVER_ITEMS
4. NON_CARRY_OVER_ITEMS tidak ditambahkan
5. Save ke database
```

### **Frontend Indication**

```javascript
const stockItems = [
  { key: 'bakso_urat', carryOver: true, info: '(Dijual lagi besok)' },
  // ...
  { key: 'pangsit_malang', carryOver: false, info: '(Harus habis)' }
];

// Form remaining stock
disabled={!item.carryOver}  // Pangsit & Soun disabled
```

---

## 📊 Contoh Data di Database

### **Stock Senin (2024-11-18)**

```json
{
  "date": "2024-11-18",
  "stock_brought": {
    "bakso_urat": 50,
    "bakso_kecil": 100,
    "tahu": 80,
    "somay": 60,
    "pangsit_malang": 20,
    "soun": 10
  },
  "stock_remaining": {
    "bakso_urat": 10,
    "bakso_kecil": 15,
    "tahu": 5,
    "somay": 8,
    "pangsit_malang": 0,
    "soun": 0
  }
}
```

### **Stock Selasa (2024-11-19)**

User input (bawa baru):
```json
{
  "bakso_urat": 40,
  "bakso_kecil": 80,
  "tahu": 70,
  "somay": 50,
  "pangsit_malang": 25,
  "soun": 12
}
```

Yang tersimpan (otomatis + sisa kemarin):
```json
{
  "date": "2024-11-19",
  "stock_brought": {
    "bakso_urat": 50,      // 40 + 10 (sisa kemarin)
    "bakso_kecil": 95,     // 80 + 15 (sisa kemarin)
    "tahu": 75,            // 70 + 5  (sisa kemarin)
    "somay": 58,           // 50 + 8  (sisa kemarin)
    "pangsit_malang": 25,  // 25 + 0  (tidak carry)
    "soun": 12             // 12 + 0  (tidak carry)
  }
}
```

---

## ✅ Testing

### **Test Scenario 1: Normal Flow**

1. **Day 1:**
   - Input stok awal: Bakso Urat 50
   - Input stok sisa: Bakso Urat 10
   - ✓ Tersimpan

2. **Day 2:**
   - Input stok awal: Bakso Urat 40 (bawa baru)
   - System: Auto tambah 10 (sisa kemarin)
   - Result: Stok awal = 50 ✓

3. **Verify:**
   ```bash
   # Check database
   mongo bakso_business --eval "db.daily_stocks.find({date: '2024-11-19'}).pretty()"
   
   # Check frontend
   # Dashboard → Stok → Lihat data
   ```

### **Test Scenario 2: Pangsit & Soun**

1. **Day 1:**
   - Input stok sisa: Pangsit 0, Soun 0 (forced)
   - ✓ Cannot input > 0

2. **Day 2:**
   - Input stok awal: Pangsit 25, Soun 12
   - Result: Tetap 25 & 12 (tidak ada carry-over) ✓

---

## 🚨 Important Notes

### **1. Pangsit & Soun HARUS Habis**

Form remaining stock:
- Field pangsit & soun **disabled** (always 0)
- Cannot input > 0
- Business rule: Harus habis setiap hari

### **2. Carry-Over Otomatis**

User **TIDAK PERLU** manual tambahkan sisa kemarin:
- ❌ Salah: Input 40 + 10 = 50 manual
- ✅ Benar: Input 40, sistem auto +10

### **3. Edit Stock**

Jika edit stock:
- Edit stok awal: Tidak affect carry-over logic
- Edit stok sisa: Akan affect besok hari

---

## 💼 Business Benefits

### **Before (Manual)**
- ❌ Harus ingat sisa kemarin
- ❌ Prone to human error
- ❌ Laporan tidak akurat
- ❌ Repot hitung manual

### **After (Automated)**
- ✅ Otomatis carry-over
- ✅ Zero human error
- ✅ Laporan 100% akurat
- ✅ Fokus ke jualan, bukan admin

---

## 🎊 Summary

**Fitur Carry-Over:**

1. **Bakso Urat, Kecil, Tahu, Somay:**
   - ✅ Sisa hari ini → Stok besok (otomatis)
   - ✅ User input "bawa baru", sistem tambah "sisa kemarin"

2. **Pangsit & Soun:**
   - ❌ Harus habis setiap hari
   - ❌ Tidak carry-over
   - ❌ Field disabled di form sisa

**User Experience:**
- Input simple, sistem handle kompleksitas
- Clear visual indicators (warna & label)
- Toast notifications explain apa yang terjadi

**Result:**
- Inventory management akurat
- Zero calculation error  
- Business logic implemented correctly

🚀 **Update sudah include di paket terbaru!**
