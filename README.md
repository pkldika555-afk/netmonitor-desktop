# NetMonitor Desktop

> Internal LAN Service Monitor — Electron Wrapper  
> Laravel 10 + Nginx + MySQL + PHP-CGI + Electron

---

## Struktur Folder

```
netmonitor-desktop/
├── assets/
│   └── icon.ico
├── runtime/          ← TIDAK di-push ke repo (lihat setup di bawah)
│   ├── php/
│   ├── mysql/
│   └── nginx/
├── www/              ← Source Laravel NetMonitor
├── main.js
├── preload.js
├── splash.html
├── package.json
├── before-build.bat
├── prepare-update.bat
├── update.bat
└── .gitignore
```

---

## Requirement

- Windows 10/11 x64
- Node.js (untuk development & build)
- npm

---

## Setup Development

### 1. Clone repo

```bash
git clone https://github.com/username/netmonitor-desktop.git
cd netmonitor-desktop
```

### 2. Setup runtime

Runtime **tidak disertakan di repo** karena ukurannya ratusan MB.  
Copy folder `runtime/` dari project **stokkomponendesktop** (struktur identik):

```
runtime/
├── php/      ← PHP 8.x + php-cgi.exe
├── mysql/    ← MySQL 8.x
└── nginx/    ← Nginx Windows
```

> Setelah copy, **hapus isi folder `runtime/mysql/data/`** biar MySQL initialize fresh untuk database `network_monitor`.

### 3. Setup Laravel (www/)

```bash
cd www
composer install
cp .env.example .env
php artisan key:generate
npm install
npm run build
cd ..
```

### 4. Install Electron dependencies

```bash
npm install
```

### 5. Jalankan development

```bash
npm start
```

App akan otomatis:
- Detect IP lokal via `os.networkInterfaces()`
- Start MySQL di port `3307`
- Start PHP-CGI (FPM) di port `9000`
- Start Nginx di port `8001`
- Buka browser window ke `http://<IP-lokal>:8001`

---

## Build .exe

### 1. Jalankan cleanup & build assets

```bat
before-build.bat
```

Script ini akan:
- Build Laravel assets (`npm run build`)
- Hapus `node_modules`, cache Laravel
- Diet folder MySQL/PHP/Nginx dari file yang tidak perlu

### 2. Build installer

```bash
npm run build
```

Output: `dist/NetMonitor Setup 1.0.0.exe`

---

## Kirim Update ke Klien

Gunakan `prepare-update.bat` untuk menyiapkan package update:

```bat
prepare-update.bat
```

Output: `update-package/NetMonitor-Update.zip`

Kirim file ZIP tersebut ke klien, lalu klien jalankan `update.bat` yang ada di dalam ZIP.

---

## Konfigurasi

| Property | Value |
|---|---|
| App Port | `8001` |
| MySQL Port | `3307` |
| PHP-CGI Port | `9000` |
| Database | `network_monitor` |
| APP_URL | Auto-detect IP lokal |

---

## Catatan Penting

- **Sound alert** — `autoplayPolicy: 'no-user-gesture-required'` sudah di-set di Electron agar alarm MP3 bisa bunyi tanpa interaksi user
- **IP otomatis** — `APP_URL` di `.env` otomatis diisi IP lokal saat startup, bukan `127.0.0.1`, sehingga bisa diakses dari device lain di LAN yang sama
- **First time setup** — Migration database hanya berjalan sekali, ditandai file `.setup_done` di AppData
- **MySQL data** — Disimpan di `%AppData%\NetMonitor\mysql-data` agar aman saat update/uninstall

---

## Fitur

- Ping IP/URL dan pantau status online/offline
- Alert suara otomatis saat service offline
- Per-service mute, snooze, cooldown
- Auto-check dengan interval configurable
- Role-based access (admin/viewer)
- CRUD service & user management
- History log (delta logging — hanya catat saat status berubah)
- Backup & restore data JSON
- Sidebar dinamis kategori + count offline

---

## Tech Stack

| Layer | Tech |
|---|---|
| Backend | Laravel 10 |
| Frontend | Blade + Tailwind CSS + Vite |
| Database | MySQL 8 (port 3307) |
| Web Server | Nginx |
| PHP | PHP-CGI (FastCGI) |
| Desktop | Electron 28 |
| Installer | NSIS via electron-builder |

---

*NetMonitor Desktop — PKL Dika 2026*
