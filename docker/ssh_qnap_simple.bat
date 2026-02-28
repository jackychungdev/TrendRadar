@echo off
:: SSH Connection Script for QNAP Server with Auto Directory Change
:: Server: 192.168.0.65
:: User: jackychung
:: Port: 822
:: Password: 234788aB!
:: Auto-executes: cd /share/Container/trendradar/docker/

set SERVER_IP=192.168.0.65
set USERNAME=jackychung
set PORT=822
set TARGET_DIR=/share/Container/trendradar/docker/

echo ========================================
echo SSH Connection to QNAP Server
echo ========================================
echo Server: %SERVER_IP%:%PORT%
echo User: %USERNAME%
echo Target Directory: %TARGET_DIR%
echo ========================================
echo.

:: Check if SSH client is available
where ssh >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: SSH client not found.
    echo Please install OpenSSH client via Windows Features.
    pause
    exit /b 1
)

echo Starting SSH connection...
echo When prompted for password, it will be: %PASSWORD%
echo After login, will automatically:
echo 1. Change to: %TARGET_DIR%
echo 2. Run: docker-compose down
echo.

:: SSH connection with automatic directory change and docker-compose down
ssh -p %PORT% %USERNAME%@%SERVER_IP% "cd %TARGET_DIR% && pwd && sudo rm -rf /tmp/* && docker-compose down"

echo.
echo Connection closed.
pause