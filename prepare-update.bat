@echo off
echo ============================================
echo   PREPARE UPDATE - Sistem Komponen
echo ============================================
echo.

if not exist "main.js" (
    echo [ERROR] Jalankan script ini dari folder electron-app!
    pause
    exit /b 1
)

echo [1/5] Build Laravel assets...
cd www
call npm install
call npm run build
cd ..
echo       Build selesai!
echo.

echo [2/5] Bersihkan file tidak perlu...
if exist "www\node_modules" (
    rmdir /s /q "www\node_modules"
    echo       Hapus node_modules OK
)
if exist "www\storage\logs" (
    del /q "www\storage\logs\*.log" 2>nul
    echo       Hapus logs OK
)
if exist "www\storage\framework\views" (
    del /q "www\storage\framework\views\*.php" 2>nul
    echo       Hapus compiled views OK
)
if exist "www\bootstrap\cache\config.php" (
    del /q "www\bootstrap\cache\config.php" 2>nul
)
if exist "www\bootstrap\cache\routes-v7.php" (
    del /q "www\bootstrap\cache\routes-v7.php" 2>nul
)
echo.

echo [3/5] Siapkan folder update-package...
if exist "update-package" (
    rmdir /s /q "update-package"
)
mkdir "update-package"
echo       Folder siap.
echo.

echo [4/5] Copy file dengan Robocopy...
:: /E     = Copy subfolder termasuk yang kosong
:: /MT:32 = 32 thread paralel
:: /R:0   = Jangan retry kalau error
:: /W:0   = Jangan tunggu antar retry
:: /NFL /NDL /NJH /NJS = Sembunyikan log verbose
robocopy "www" "update-package\www" /E /MT:32 /R:0 /W:0 /NFL /NDL /NJH /NJS
:: Robocopy exit code 1 = sukses ada file dicopy (bukan error!)
if errorlevel 8 (
    echo [ERROR] Robocopy gagal! Cek folder www.
    pause
    exit /b 1
)
copy /y "update.bat" "update-package\update.bat" >nul
echo       Copy selesai!
echo.

echo [5/5] Membuat ZIP...
tar -a -c -f "update-package\Sistem-Komponen-Update.zip" -C "update-package" .
if errorlevel 1 (
    echo [WARN] tar gagal, coba pakai PowerShell...
    powershell -Command "Compress-Archive -Path 'update-package\*' -DestinationPath 'update-package\Sistem-Komponen-Update.zip' -Force"
    if errorlevel 1 (
        echo [WARN] ZIP gagal dibuat otomatis.
        echo        Zip manual folder update-package\ dan kirim ke klien.
    ) else (
        echo       ZIP berhasil via PowerShell!
        echo       File: update-package\Sistem-Komponen-Update.zip
    )
) else (
    echo       ZIP berhasil dibuat!
    echo       File: update-package\Sistem-Komponen-Update.zip
)
echo.

echo ============================================
echo   SELESAI! Kirim file ini ke klien:
echo   update-package\Sistem-Komponen-Update.zip
echo ============================================
echo.
pause