# 📋 Deployment Checklist - Bakso Business Lite

Gunakan checklist ini sebelum membuat dan mendistribusikan paket lite ke Raspberry Pi 3B.

## ✅ Pre-Build Checklist

### Code Quality
- [ ] Semua fitur berfungsi di development
- [ ] Tidak ada console.error atau warning di browser
- [ ] Backend API semua endpoint tested
- [ ] Database connection working
- [ ] Excel export berfungsi normal

### Testing
- [ ] Test semua halaman (Dashboard, Stock, Transaction, Reports, Expenses)
- [ ] Test CRUD operations (Create, Read, Update, Delete)
- [ ] Test edge cases (empty data, invalid input)
- [ ] Test responsiveness (mobile, tablet, desktop)
- [ ] Test dengan data real

### Configuration
- [ ] `.env` files properly configured
- [ ] CORS settings correct
- [ ] Database name consistent
- [ ] API endpoints use proper prefix `/api`
- [ ] No hardcoded URLs or ports

## 🔨 Build Process Checklist

### Frontend Build
- [ ] Run `yarn install` berhasil tanpa error
- [ ] Run `yarn build` berhasil
- [ ] Build folder created di `frontend/build/`
- [ ] Check build size (harus < 5MB uncompressed)
- [ ] Tidak ada error di build log
- [ ] Source maps generated (optional, bisa disabled)

### Backend Preparation
- [ ] `requirements.txt` up to date
- [ ] All dependencies installable dengan pip
- [ ] `server.py` tidak ada hardcoded values
- [ ] MongoDB connection string dari environment variable
- [ ] CORS origins dari environment variable

### Package Creation
- [ ] Run `bash create-lite-package.sh` berhasil
- [ ] `frontend-build.tar.gz` created (~800KB)
- [ ] `bakso-business-lite.tar.gz` created (~850KB)
- [ ] Extract test: `tar -tzf bakso-business-lite.tar.gz`
- [ ] Verify contents: setup-lite.sh, backend/, frontend/

## 🧪 Pre-Deployment Testing

### Local Testing (Sebelum ke Pi)
- [ ] Extract paket di folder baru
- [ ] Verify struktur folder correct
- [ ] Check `setup-lite.sh` executable permissions
- [ ] Read through setup script untuk verify logic
- [ ] Check frontend-build.tar.gz size dan integrity

### Test di Raspberry Pi (Fresh Install)
- [ ] Use fresh Pi OS install (atau backup dulu!)
- [ ] Transfer paket ke Pi berhasil
- [ ] Extract tanpa error
- [ ] Run `setup-lite.sh` tanpa error
- [ ] MongoDB installed dan running
- [ ] Python dependencies installed
- [ ] Backend service running (`pm2 status`)
- [ ] Frontend service running (`pm2 status`)
- [ ] Check memory usage: `free -h` (harus < 600MB)

### Functional Testing di Pi
- [ ] Access frontend di browser: `http://[IP]:3000`
- [ ] Access backend API: `http://[IP]:8001/api/`
- [ ] Dashboard loads correctly
- [ ] Can add stock data
- [ ] Can add transactions
- [ ] Can view reports
- [ ] Can export to Excel
- [ ] No console errors
- [ ] No 500 errors in backend logs

### Performance Testing
- [ ] Page load time acceptable (< 5 seconds)
- [ ] API response time acceptable (< 2 seconds)
- [ ] Memory usage stable (tidak naik terus)
- [ ] CPU usage reasonable (< 50% saat idle)
- [ ] No memory leaks setelah 1 jam usage

### Persistence Testing
- [ ] Reboot Pi: `sudo reboot`
- [ ] After reboot, services auto-start
- [ ] Check `pm2 list` - both services online
- [ ] Data still accessible after reboot
- [ ] MongoDB data persisted

## 📦 Distribution Checklist

### Documentation
- [ ] README.md updated dengan versi info
- [ ] RASPBERRY_PI_3B_LITE.md lengkap
- [ ] QUICK_START_LITE.md clear dan concise
- [ ] LITE_PACKAGE_CREATION.md untuk developers
- [ ] Changelog updated dengan new features
- [ ] Known issues documented

### Version Control
- [ ] Git commit all changes
- [ ] Tag dengan version number: `git tag v1.0.0`
- [ ] Push to remote: `git push --tags`
- [ ] Create GitHub release dengan tarball

### Package Verification
- [ ] Package size reasonable (< 1MB)
- [ ] MD5/SHA256 checksum generated
- [ ] Virus scan clean (jika applicable)
- [ ] Test download dari GitHub release

## 🚀 Post-Deployment Checklist

### User Communication
- [ ] Announcement di README
- [ ] Installation instructions clear
- [ ] Support contact information provided
- [ ] Known limitations documented
- [ ] Update roadmap communicated

### Monitoring
- [ ] Monitor first user installations
- [ ] Collect feedback
- [ ] Track common issues
- [ ] Monitor memory usage reports
- [ ] Track installation success rate

### Support Preparation
- [ ] FAQ document ready
- [ ] Common troubleshooting steps documented
- [ ] Contact method established
- [ ] Response time commitment defined

## 🐛 Rollback Plan

### If Issues Found
- [ ] Stop distribution immediately
- [ ] Document the issue
- [ ] Create hotfix if possible
- [ ] Test hotfix thoroughly
- [ ] Create new package version
- [ ] Update documentation
- [ ] Notify affected users

### Backup Strategy
- [ ] Keep previous version available
- [ ] Document downgrade procedure
- [ ] Test rollback process
- [ ] Keep database migration scripts

## 📊 Success Metrics

### Installation Success
- Target: > 95% successful installations
- Metric: Installation completes without errors

### Performance
- Memory: < 500MB average usage
- CPU: < 30% average usage
- Response time: < 2 seconds for API calls

### Stability
- Uptime: > 99% (excluding maintenance)
- No crashes in first 24 hours
- No data loss reported

## 🎯 Final Verification

Sebelum release, jawab pertanyaan ini:

1. **Apakah paket tested di real Raspberry Pi 3B?** ⬜ Yes ⬜ No
2. **Apakah semua fitur berfungsi normal?** ⬜ Yes ⬜ No
3. **Apakah memory usage acceptable (< 500MB)?** ⬜ Yes ⬜ No
4. **Apakah dokumentasi lengkap dan jelas?** ⬜ Yes ⬜ No
5. **Apakah ada backup plan jika ada masalah?** ⬜ Yes ⬜ No

**Jika semua YES, paket ready untuk release! 🚀**

---

## 📝 Notes

Tanggal: ________________  
Version: ________________  
Tested by: ________________  
Pi Model: ________________  
OS Version: ________________  

Issues found:
- 
- 
- 

Resolution:
- 
- 
- 

Sign-off: ________________
