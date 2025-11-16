# 🚀 GitHub Release Guide - Bakso Business Lite

Panduan step-by-step untuk membuat GitHub release versi Lite.

## 📋 Pre-Release Checklist

Sebelum membuat release, pastikan:

- [ ] Code sudah di-commit dan push ke GitHub
- [ ] Frontend berhasil di-build (`yarn build`)
- [ ] Paket lite sudah dibuat (`bash create-lite-package.sh`)
- [ ] Paket sudah di-test (`bash test-lite-package.sh`)
- [ ] Test di actual Raspberry Pi 3B (jika possible)
- [ ] Dokumentasi sudah complete dan up-to-date
- [ ] CHANGELOG updated
- [ ] Version number decided (e.g., v1.0.0)

## 🏷️ Create Git Tag

### 1. Create and Push Tag

```bash
# Dari root directory project
cd /app

# Create annotated tag
git tag -a v1.0.0 -m "Release v1.0.0 - Lite Edition for Raspberry Pi 3B"

# Verify tag
git tag -l

# Push tag to GitHub
git push origin v1.0.0
```

### 2. Alternative: Tag from GitHub

1. Go to: `https://github.com/[username]/bakso-business/releases`
2. Click **"Create a new release"**
3. Click **"Choose a tag"** → Type `v1.0.0` → **"Create new tag on publish"**

## 📦 Prepare Release Assets

### Files to Upload

Pastikan file ini ready:

```bash
# Verify files exist
ls -lh /app/*.tar.gz

# Expected:
# -rw-r--r-- 1 root root 806K Nov 16 11:15 bakso-business-lite.tar.gz
# -rw-r--r-- 1 root root 790K Nov 16 11:15 frontend-build.tar.gz
```

### Calculate Checksums (Optional tapi Recommended)

```bash
# MD5
md5sum bakso-business-lite.tar.gz > bakso-business-lite.tar.gz.md5
md5sum frontend-build.tar.gz > frontend-build.tar.gz.md5

# SHA256 (lebih secure)
sha256sum bakso-business-lite.tar.gz > bakso-business-lite.tar.gz.sha256
sha256sum frontend-build.tar.gz > frontend-build.tar.gz.sha256

# Display checksums
cat *.md5 *.sha256
```

## 🎯 Create GitHub Release

### Method 1: Via GitHub Web Interface (Recommended)

#### Step 1: Navigate to Releases

1. Buka repository: `https://github.com/[username]/bakso-business`
2. Click tab **"Releases"**
3. Click **"Draft a new release"**

#### Step 2: Configure Release

**Tag Version:**
- Select or create tag: `v1.0.0`

**Release Title:**
```
🎉 Bakso Business v1.0.0 - Lite Edition
```

**Description:**

Copy-paste from [RELEASE_NOTES.md](RELEASE_NOTES.md) atau custom:

```markdown
## 🚀 Release Highlights

**Versi Lite** untuk Raspberry Pi 3B kini tersedia! Instalasi mudah tanpa memory issues.

### ✨ What's New

- ✅ **Pre-built Frontend** - Tidak perlu npm install/build di Pi!
- ✅ **One-Script Installation** - Satu command, tunggu 10-15 menit, selesai!
- ✅ **Memory Optimized** - Hanya butuh ~400MB RAM
- ✅ **Auto-start on Boot** - PM2 configured
- ✅ **Complete Documentation** - 6+ comprehensive docs

## 🚀 Quick Start

```bash
# 1. Download & transfer to Pi
scp bakso-business-lite.tar.gz pi@[IP]:~/

# 2. Extract & install
tar -xzf bakso-business-lite.tar.gz
cd bakso-business-lite
bash setup-lite.sh

# 3. Access at http://[IP]:3000
```

📘 **Full Docs:** [QUICK_START_LITE.md](https://github.com/[username]/bakso-business/blob/v1.0.0/QUICK_START_LITE.md)

## 📋 System Requirements

- **Hardware:** Raspberry Pi 3B (1GB RAM) or higher
- **OS:** Raspberry Pi OS (Buster/Bullseye/Bookworm)
- **Storage:** 16GB microSD minimum

## 🎯 Features

- ✅ Dashboard Real-time
- ✅ Stock Management
- ✅ Sales Transactions
- ✅ Expense Tracking
- ✅ Financial Reports
- ✅ Excel Export

## 📊 Performance

- **RAM Usage:** ~400-500MB
- **Install Time:** 10-15 minutes
- **Disk Space:** ~1.5GB

## 📚 Documentation

- [Quick Start Guide](https://github.com/[username]/bakso-business/blob/v1.0.0/QUICK_START_LITE.md)
- [Full Documentation](https://github.com/[username]/bakso-business/blob/v1.0.0/RASPBERRY_PI_3B_LITE.md)
- [Developer Guide](https://github.com/[username]/bakso-business/blob/v1.0.0/LITE_PACKAGE_CREATION.md)
- [Docs Index](https://github.com/[username]/bakso-business/blob/v1.0.0/DOCS_INDEX.md)

## 🐛 Known Issues

- Script requires internet for installation
- First load might take < 10 seconds (cold start)

## 📝 Changelog

See full [RELEASE_NOTES.md](https://github.com/[username]/bakso-business/blob/v1.0.0/RELEASE_NOTES.md)

---

**Happy Managing! 🍜**
```

#### Step 3: Upload Assets

Click **"Attach binaries"** dan upload:

1. **bakso-business-lite.tar.gz** (Primary package)
2. **frontend-build.tar.gz** (Optional, for developers)
3. **bakso-business-lite.tar.gz.md5** (Checksum)
4. **bakso-business-lite.tar.gz.sha256** (Checksum)

#### Step 4: Set Release Options

- [ ] **This is a pre-release** - Uncheck (ini stable release)
- [x] **Set as the latest release** - Check
- [ ] **Create a discussion for this release** - Optional, check jika ingin feedback

#### Step 5: Publish

Click **"Publish release"** 🎉

### Method 2: Via GitHub CLI (Advanced)

```bash
# Install GitHub CLI jika belum
# https://cli.github.com/

# Login
gh auth login

# Create release
gh release create v1.0.0 \
  --title "🎉 Bakso Business v1.0.0 - Lite Edition" \
  --notes-file RELEASE_NOTES.md \
  bakso-business-lite.tar.gz \
  frontend-build.tar.gz

# Verify
gh release view v1.0.0
```

## 📢 Post-Release Tasks

### 1. Update README Badges

Update `README.md` dengan release info:

```markdown
![Version](https://img.shields.io/github/v/release/[username]/bakso-business)
![Downloads](https://img.shields.io/github/downloads/[username]/bakso-business/total)
![License](https://img.shields.io/github/license/[username]/bakso-business)
```

### 2. Update Documentation Links

Update semua docs dengan correct version links:

```bash
# Find and replace [username] dengan actual username
find . -name "*.md" -type f -exec sed -i 's/\[username\]/youractualusername/g' {} +

# Commit changes
git add .
git commit -m "docs: update links after v1.0.0 release"
git push
```

### 3. Announce Release

**GitHub Discussions:**
1. Go to Discussions
2. Create new post in "Announcements"
3. Title: "🎉 v1.0.0 Lite Edition Released!"
4. Link to release

**Social Media (Optional):**
- Twitter/X
- LinkedIn
- Reddit (r/raspberry_pi, r/selfhosted)
- Dev.to

### 4. Monitor Initial Feedback

- Watch GitHub Issues untuk bug reports
- Monitor Discussions untuk questions
- Check download stats

## 🔄 Release Workflow Summary

```
Code Ready → Create Tag → Build Package → Test Package
     ↓
Write Release Notes → Create GitHub Release → Upload Assets
     ↓
Publish → Announce → Monitor → Support
```

## 📊 Release Analytics

### Track Performance

GitHub provides analytics:
1. Go to **Insights** → **Traffic**
2. Check **Views** and **Clones**
3. **Releases** → View download count

### Success Metrics

Track these after 1 week:

- **Downloads:** > 10 (good start)
- **Stars:** > 5 (community interest)
- **Issues:** < 3 bugs (quality indicator)
- **Feedback:** Positive comments/discussions

## 🐛 Hotfix Release Process

Jika ada bug critical setelah release:

```bash
# 1. Fix bug di code
git add .
git commit -m "fix: critical bug in setup script"

# 2. Create hotfix tag
git tag -a v1.0.1 -m "Hotfix v1.0.1 - Fix setup script bug"
git push origin v1.0.1

# 3. Rebuild package
bash create-lite-package.sh

# 4. Create new release
# Title: "🐛 Bakso Business v1.0.1 - Hotfix"
# Description: Brief explanation of fix
# Upload: bakso-business-lite.tar.gz

# 5. Announce in original release
# Add comment: "⚠️ Please use v1.0.1 instead (fixes bug X)"
```

## 📝 Version Numbering

Follow Semantic Versioning:

- **Major (1.x.x):** Breaking changes
- **Minor (x.1.x):** New features, backward compatible
- **Patch (x.x.1):** Bug fixes

Examples:
- `v1.0.0` - First stable release
- `v1.0.1` - Bug fix
- `v1.1.0` - New feature added
- `v2.0.0` - Major rewrite/breaking changes

## ✅ Release Checklist

Final checklist sebelum publish:

- [ ] Tag created dan pushed
- [ ] Release notes complete
- [ ] Assets uploaded (tar.gz files)
- [ ] Checksums generated dan uploaded
- [ ] Release description clear dan helpful
- [ ] Documentation links correct
- [ ] Version number follows semver
- [ ] "Latest release" flag set
- [ ] Announcement prepared
- [ ] Monitoring plan ready

## 🎯 Example Release URLs

After release, verify these work:

- Release page: `https://github.com/[username]/bakso-business/releases/tag/v1.0.0`
- Direct download: `https://github.com/[username]/bakso-business/releases/download/v1.0.0/bakso-business-lite.tar.gz`
- Latest release: `https://github.com/[username]/bakso-business/releases/latest`

## 📞 Support After Release

Be prepared to:

1. **Answer questions** in Issues/Discussions
2. **Fix bugs** reported by users
3. **Update documentation** if unclear
4. **Collect feedback** for next version
5. **Thank contributors** and users

## 🎉 Congratulations!

Setelah follow guide ini, Anda berhasil:
- ✅ Create professional GitHub release
- ✅ Distribute Lite package
- ✅ Provide complete documentation
- ✅ Support user community

**Next:** Monitor feedback dan plan untuk v1.1.0! 🚀

---

**Good luck with your release!** 🎊

*Dibuat untuk memudahkan proses release Bakso Business System*
