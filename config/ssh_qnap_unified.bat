@echo off
:: Unified SSH Connection Script for QNAP Server
:: Usage: ssh_qnap_unified.bat [config_file]
:: Example: ssh_qnap_unified.bat config.yaml
:: Example: ssh_qnap_unified.bat timeline.yaml
:: Example: ssh_qnap_unified.bat frequency_words.txt

:: Set default configuration if no parameter provided
if "%1"=="" (
    set LOCAL_CONFIG=config.yaml
) else (
    set LOCAL_CONFIG=%1
)

:: Server configuration
set SERVER_IP=192.168.0.65
set USERNAME=jackychung
set PORT=822
set TARGET_DIR=/share/Container/trendradar/config/
set DOCKER_DIR=/share/Container/trendradar/docker/

echo ========================================
echo SSH Connection to QNAP Server
echo ========================================
echo Server: %SERVER_IP%:%PORT%
echo User: %USERNAME%
echo Target Directory: %TARGET_DIR%
echo Local Config File: %LOCAL_CONFIG%
echo ========================================
echo.

:: Validate that the local config file exists
if not exist "%LOCAL_CONFIG%" (
    echo Error: Local config file '%LOCAL_CONFIG%' not found.
    echo Available files in current directory:
    dir *.yaml *.txt | findstr /i "\.yaml$ \|\.txt$"
    pause
    exit /b 1
)

:: Check if SSH client is available
where ssh >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: SSH client not found.
    echo Please install OpenSSH client via Windows Features.
    pause
    exit /b 1
)

:: Copy config file to remote server using scp
echo Copying %LOCAL_CONFIG% to remote server...
echo Backing up existing file on remote server...
ssh -p %PORT% %USERNAME%@%SERVER_IP% "cd %TARGET_DIR% && if [ -f %LOCAL_CONFIG% ]; then mv %LOCAL_CONFIG% %LOCAL_CONFIG%.backup.`date +%%Y%%m%%d_%%H%%M%%S`; echo 'Backup created'; else echo 'No existing file to backup'; fi"
if %errorlevel% neq 0 (
    echo Warning: Failed to backup existing file on remote server, continuing anyway...
)

echo Copying local %LOCAL_CONFIG% to remote server...
scp -P %PORT% %LOCAL_CONFIG% %USERNAME%@%SERVER_IP%:%TARGET_DIR%
if %errorlevel% neq 0 (
    echo Error: Failed to copy %LOCAL_CONFIG% to remote server.
    pause
    exit /b 1
)
echo Successfully copied %LOCAL_CONFIG% to %TARGET_DIR% on remote server.
echo.

echo Starting SSH connection...
echo After login, will automatically:
echo 1. Change to: %DOCKER_DIR%
echo 2. Run: docker-compose down and up echo.
:: To-do: Consider adding an option to skip docker-compose commands for non-config files in the future.
echo.
echo Connection closed.
echo Press any key to exit...
pause >nul