# 🚀 Cara Push ke GitHub & Create Release

## 📋 Langkah-Langkah Push Code ke GitHub

### Step 1: Setup GitHub Repository

Jika belum punya repository:

1. **Buka GitHub.com**
2. **Klik "New Repository"**
3. **Nama repository:** `bakso-business` atau `meatball-sales-lite`
4. **Description:** Bakso Business Management System - Lite for Raspberry Pi 3B
5. **Public/Private:** Pilih sesuai kebutuhan
6. **JANGAN** centang "Initialize with README" (sudah ada di code)
7. **Klik "Create repository"**

### Step 2: Connect Local ke GitHub

Di environment ini (atau di terminal lokal jika sudah download):

```bash
cd /app

# Add remote repository (ganti [USERNAME] dan [REPO] dengan milik Anda)
git remote add origin https://github.com/[USERNAME]/[REPO].git

# Contoh:
# git remote add origin https://github.com/nsohit/meatball-sales-lite.git

# Verify
git remote -v
```

### Step 3: Push Code

```bash
# Push semua code
git push -u origin main

# Jika diminta login
# Username: [your-github-username]
# Password: [your-personal-access-token]
```

**Note:** Sejak 2021, GitHub tidak accept password biasa. Gunakan Personal Access Token:
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token
3. Pilih scope: `repo` (full control)
4. Generate → Copy token
5. Use sebagai password saat push

---

## 📦 Step 4: Create GitHub Release

### Cara Manual (Via Web Interface)

1. **Buka repository di GitHub**
   ```
   https://github.com/[USERNAME]/[REPO]
   ```

2. **Klik tab "Releases"**

3. **Klik "Draft a new release"**

4. **Tag version:** `v1.0.0`
   - Click "Choose a tag" → Type `v1.0.0` → "Create new tag"

5. **Release title:** `v1.0.0 - Lite Edition for Raspberry Pi 3B`

6. **Description:** (copy ini)
   ```markdown
   ## 🎉 Bakso Business v1.0.0 - Lite Edition

   Versi Lite untuk Raspberry Pi 3B - Instalasi mudah tanpa error Node.js!

   ### ✨ Features
   - ✅ Pre-built frontend (no npm/yarn needed on Pi!)
   - ✅ One-script installation (8-12 minutes)
   - ✅ Memory optimized (~350-400MB)
   - ✅ Zero Node.js dependency with setup-lite-node16.sh
   - ✅ Complete documentation

   ### 📥 Download
   Download `bakso-business-lite.tar.gz` below ⬇️

   ### 🚀 Quick Start
   ```bash
   tar -xzf bakso-business-lite.tar.gz
   cd bakso-business-lite
   bash setup-lite-node16.sh
   ```

   ### 📚 Documentation
   - [Quick Start](./QUICK_START_LITE.md)
   - [Installation Guide](./INSTALL_NO_NODE_ERROR.md)
   - [Troubleshooting](./TROUBLESHOOTING_NODE_ERROR.md)

   **Compatible with:** Raspberry Pi 3B, 3B+, 4, 5
   ```

7. **Upload File:**
   - Klik "Attach binaries by dropping them here or selecting them"
   - Upload file: `bakso-business-lite.tar.gz` (812KB)
   - File ada di: `/app/bakso-business-lite.tar.gz`

8. **Options:**
   - ✅ Check "Set as the latest release"
   - ❌ Uncheck "This is a pre-release"

9. **Klik "Publish release"** 🎉

### Cara via Command Line (Dengan GitHub CLI)

Jika punya GitHub CLI (`gh`):

```bash
# Install gh jika belum (di Linux)
# curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
# sudo apt update && sudo apt install gh

# Login
gh auth login

# Create release
cd /app
gh release create v1.0.0 \
  --title "v1.0.0 - Lite Edition for Raspberry Pi 3B" \
  --notes "Pre-built frontend, one-script install, zero Node.js errors!" \
  bakso-business-lite.tar.gz

# Done! ✅
```

---

## ✅ Verify Release

Setelah publish:

1. **Check release page:**
   ```
   https://github.com/[USERNAME]/[REPO]/releases
   ```

2. **Test download link:**
   ```
   https://github.com/[USERNAME]/[REPO]/releases/download/v1.0.0/bakso-business-lite.tar.gz
   ```

3. **Test download:**
   ```bash
   wget https://github.com/[USERNAME]/[REPO]/releases/download/v1.0.0/bakso-business-lite.tar.gz
   
   # Verify size
   ls -lh bakso-business-lite.tar.gz
   # Should be: 812K
   ```

---

## 📝 Update Documentation

Setelah release, update dokumentasi dengan link download:

1. **Edit README.md:**
   ```markdown
   ## 📥 Download
   
   [Download bakso-business-lite.tar.gz (812KB)](https://github.com/[USERNAME]/[REPO]/releases/download/v1.0.0/bakso-business-lite.tar.gz)
   ```

2. **Commit & push update:**
   ```bash
   git add README.md
   git commit -m "docs: add download link to release"
   git push
   ```

---

## 🎯 Alternative: Jika Tidak Bisa Push

Jika Anda tidak bisa push karena permission atau setting:

### Option A: Download & Push dari Local

1. **Download semua file dari environment ini**
2. **Di komputer lokal:**
   ```bash
   git clone [your-repo] atau git init
   # Copy semua file ke folder
   git add .
   git commit -m "Initial commit - Lite version"
   git push
   ```

### Option B: Saya Buatkan ZIP

Saya bisa create ZIP dengan semua file:

```bash
cd /app
zip -r bakso-business-complete.zip . -x ".git/*" "node_modules/*" "frontend/build/*"
```

Kemudian Anda download dan upload manual ke GitHub.

### Option C: Fork & PR

Jika ada repository existing:
1. Fork repository tersebut
2. Clone fork Anda
3. Add files
4. Push ke fork
5. Create Pull Request

---

## 📊 Checklist

Sebelum publish release:

- [ ] Code sudah di-push ke GitHub
- [ ] File `bakso-business-lite.tar.gz` ada dan verified (812KB)
- [ ] Release notes sudah ditulis
- [ ] Tag version created (v1.0.0)
- [ ] File uploaded ke release assets
- [ ] Release published
- [ ] Download link tested
- [ ] Documentation updated dengan link

---

## 🚀 Setelah Release Published

User bisa download dengan:

```bash
# Direct download
wget https://github.com/[USERNAME]/[REPO]/releases/download/v1.0.0/bakso-business-lite.tar.gz

# Or via curl
curl -LO https://github.com/[USERNAME]/[REPO]/releases/download/v1.0.0/bakso-business-lite.tar.gz
```

---

## 💡 Tips

1. **Tag Naming:** Gunakan semantic versioning (v1.0.0, v1.1.0, dst)
2. **Release Notes:** Selalu jelas dan detail
3. **Assets:** Upload tar.gz, bukan zip (lebih common di Linux)
4. **Checksums:** Consider adding MD5/SHA256 di release notes
5. **Keep Old Releases:** Jangan delete old releases untuk backward compatibility

---

## ❓ Troubleshooting

### "Permission denied" saat push

**Solution:** Check:
1. GitHub credentials correct
2. Using Personal Access Token (not password)
3. Token has `repo` scope
4. Repository not archived

### "Release already exists"

**Solution:** 
- Delete existing release atau
- Use different tag (v1.0.1)

### "File too large"

**Solution:**
- GitHub limit: 2GB per file
- Our file: 812KB ✅ (well under limit)

---

## 🎯 Quick Commands Summary

```bash
# 1. Setup remote
git remote add origin https://github.com/[USERNAME]/[REPO].git

# 2. Push code
git push -u origin main

# 3. Create release (via web or gh cli)
gh release create v1.0.0 \
  --title "v1.0.0 - Lite Edition" \
  --notes "One-script install, zero errors!" \
  /app/bakso-business-lite.tar.gz

# 4. Verify
curl -I https://github.com/[USERNAME]/[REPO]/releases/download/v1.0.0/bakso-business-lite.tar.gz
```

---

**Need help?** Let me know mana step yang stuck! 🚀
