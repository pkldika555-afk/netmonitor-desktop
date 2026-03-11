@echo off
echo ============================================
echo   CLEANUP SEBELUM BUILD - Sistem Komponen
echo ============================================
echo.

if not exist "main.js" (
    echo [ERROR] Jalankan script ini dari folder electron-app!
    pause
    exit /b 1
)

echo [1/7] Build Laravel assets...
if not exist "www\public\build" (
    echo       Belum ada folder build, npm run build...
    cd www
    call npm run build
    cd ..
    echo       Build selesai!
) else (
    echo       Folder build sudah ada, skip.
)
echo.

echo [2/7] Hapus www\node_modules ...
if exist "www\node_modules" (
    echo       Menghapus... sabar ya ini yang paling lama
    rmdir /s /q "www\node_modules"
    echo       Selesai!
) else (
    echo       Tidak ada, skip.
)
echo.

echo [3/7] Bersihkan cache Laravel...
if exist "www\storage\logs" (
    del /q "www\storage\logs\*.log" 2>nul
    echo       Logs dibersihkan.
)
if exist "www\storage\framework\views" (
    del /q "www\storage\framework\views\*.php" 2>nul
    echo       Compiled views dibersihkan.
)
if exist "www\storage\framework\cache\data" (
    rmdir /s /q "www\storage\framework\cache\data" 2>nul
    mkdir "www\storage\framework\cache\data"
    echo       Framework cache dibersihkan.
)
if exist "www\bootstrap\cache\config.php" (
    del /q "www\bootstrap\cache\config.php" 2>nul
)
if exist "www\bootstrap\cache\routes-v7.php" (
    del /q "www\bootstrap\cache\routes-v7.php" 2>nul
)
echo       Cache Laravel selesai.
echo.

echo [4/7] Diet folder MySQL...
if exist "runtime\mysql\docs" (
    rmdir /s /q "runtime\mysql\docs"
    echo       Hapus mysql\docs OK
)
if exist "runtime\mysql\include" (
    rmdir /s /q "runtime\mysql\include"
    echo       Hapus mysql\include OK
)
if exist "runtime\mysql\lib" (
    rmdir /s /q "runtime\mysql\lib"
    echo       Hapus mysql\lib OK
)
if exist "runtime\mysql\data" (
    rmdir /s /q "runtime\mysql\data"
    mkdir "runtime\mysql\data"
    echo       Reset mysql\data OK
)
echo.

echo [5/7] Diet folder PHP...
if exist "runtime\php\dev" (
    rmdir /s /q "runtime\php\dev"
    echo       Hapus php\dev OK
)
if exist "runtime\php\php-debug.exe" (
    del /q "runtime\php\php-debug.exe"
    echo       Hapus php-debug.exe OK
)
if exist "runtime\php\php-embed.lib" (
    del /q "runtime\php\php-embed.lib"
    echo       Hapus php-embed.lib OK
)
echo.

echo [6/7] Hapus runtime\node...
if exist "runtime\node" (
    rmdir /s /q "runtime\node"
    echo       Hapus runtime\node OK (hemat ~80MB)
) else (
    echo       Tidak ada, skip.
)
echo.

echo [7/7] Diet folder Nginx...
if exist "runtime\nginx\html" (
    rmdir /s /q "runtime\nginx\html"
    echo       Hapus nginx\html OK
)
if exist "runtime\nginx\contrib" (
    rmdir /s /q "runtime\nginx\contrib"
    echo       Hapus nginx\contrib OK
)
if exist "runtime\nginx\docs" (
    rmdir /s /q "runtime\nginx\docs"
    echo       Hapus nginx\docs OK
)
if exist "runtime\nginx\logs" (
    del /q "runtime\nginx\logs\*.log" 2>nul
)
echo.
echo Hapus folder dist lama...
if exist "dist" (
    rmdir /s /q "dist"
    echo Dist lama dihapus.
)

echo ============================================
echo   CLEANUP SELESAI! Siap untuk build.
echo ============================================
echo.
echo Langkah selanjutnya:
echo   1. Rename www\package.json jadi www\package.json.bak
echo   2. Jalankan: npm run build  (dari CMD Administrator)
echo   3. Setelah selesai, kembalikan www\package.json.bak
echo.
pause