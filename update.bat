@echo off
echo ============================================
echo   UPDATE NetMonitor
echo ============================================
echo.
set APP_DIR=C:\Users\%USERNAME%\AppData\Local\Programs\NetMonitor\resources
set PHP=%APP_DIR%\runtime\php\php.exe
set WWW=%APP_DIR%\www

echo [1/5] Mengecek instalasi...
if not exist "%APP_DIR%" (
    echo [ERROR] Aplikasi belum terinstall!
    echo         Install dulu via Setup.exe
    pause
    exit /b 1
)
if not exist "%PHP%" (
    echo [ERROR] PHP tidak ditemukan di: %PHP%
    pause
    exit /b 1
)
echo       OK, aplikasi ditemukan.
echo.

echo [2/5] Pastikan aplikasi sudah ditutup dulu!
echo       (klik kanan icon tray ^> Keluar)
echo.
pause

echo [3/5] Copy file www baru...
xcopy /e /y /i /q "www\*" "%WWW%\"
if errorlevel 1 (
    echo [ERROR] Gagal copy file! Coba jalankan sebagai Administrator.
    pause
    exit /b 1
)
echo       Copy selesai!
echo.

echo [4/5] Jalankan migration database...
"%PHP%" "%WWW%\artisan" migrate --force
if errorlevel 1 (
    echo [WARN] Migration gagal atau tidak ada migration baru.
)
echo.

echo [5/5] Clear cache Laravel...
"%PHP%" "%WWW%\artisan" config:clear
"%PHP%" "%WWW%\artisan" cache:clear
"%PHP%" "%WWW%\artisan" view:clear
"%PHP%" "%WWW%\artisan" route:clear
echo       Cache cleared!
echo.

echo ============================================
echo   UPDATE SELESAI!
echo   Silakan buka aplikasi kembali.
echo ============================================
echo.
pause