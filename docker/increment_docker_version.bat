@echo off
:: Docker Compose version increment script for TrendRadar
:: Automatically detects current versions and increments patch versions in both docker-compose files

setlocal enabledelayedexpansion

echo ========================================
echo Docker Version Increment Script
echo ========================================
echo.

:: Process docker-compose-build.yml
set COMPOSE_BUILD_FILE=docker-compose-build.yml
if exist "%COMPOSE_BUILD_FILE%" (
    echo Processing %COMPOSE_BUILD_FILE%...
    
    :: Extract current version using PowerShell
    for /f "tokens=*" %%i in ('powershell -Command "(gc '%COMPOSE_BUILD_FILE%' | Select-String 'image: mingtosomeone/trendradar:') -replace '.*:(\d+\.\d+\.\d+).*', '$1'"') do set BUILD_CURRENT_VERSION=%%i
    
    if "!BUILD_CURRENT_VERSION!"=="" (
        echo Warning: Could not detect current version in %COMPOSE_BUILD_FILE%
    ) else (
        echo Current build version: !BUILD_CURRENT_VERSION!
        
        :: Parse version components
        for /f "tokens=1,2,3 delims=." %%a in ("!BUILD_CURRENT_VERSION!") do (
            set BUILD_MAJOR=%%a
            set BUILD_MINOR=%%b
            set BUILD_PATCH=%%c
        )
        
        :: Increment patch version
        set /a BUILD_NEW_PATCH=!BUILD_PATCH! + 1
        set BUILD_NEW_VERSION=!BUILD_MAJOR!.!BUILD_MINOR!.!BUILD_NEW_PATCH!
        
        echo New build version: !BUILD_NEW_VERSION!
        
        :: Update version in docker-compose-build.yml
        echo Updating %COMPOSE_BUILD_FILE%...
        powershell -Command "(gc '%COMPOSE_BUILD_FILE%') -replace 'image: mingtosomeone/trendradar:!BUILD_CURRENT_VERSION!', 'image: mingtosomeone/trendradar:!BUILD_NEW_VERSION!' | Out-File -encoding UTF8 '%COMPOSE_BUILD_FILE%'"
        
        if !errorlevel! equ 0 (
            echo Successfully updated %COMPOSE_BUILD_FILE% from !BUILD_CURRENT_VERSION! to !BUILD_NEW_VERSION!
        ) else (
            echo Error updating %COMPOSE_BUILD_FILE%
        )
        echo.
    )
) else (
    echo Warning: %COMPOSE_BUILD_FILE% not found
)

:: Process docker-compose.yml
set COMPOSE_FILE=docker-compose.yml
if exist "%COMPOSE_FILE%" (
    echo Processing %COMPOSE_FILE%...
    
    :: Extract current version using PowerShell
    for /f "tokens=*" %%i in ('powershell -Command "(gc '%COMPOSE_FILE%' | Select-String 'image: mingtosomeone/trendradar:') -replace '.*:(\d+\.\d+\.\d+).*', '$1'"') do set CURRENT_VERSION=%%i
    
    if "!CURRENT_VERSION!"=="" (
        echo Warning: Could not detect current version in %COMPOSE_FILE%
    ) else (
        echo Current version: !CURRENT_VERSION!
        
        :: Parse version components
        for /f "tokens=1,2,3 delims=." %%a in ("!CURRENT_VERSION!") do (
            set MAJOR=%%a
            set MINOR=%%b
            set PATCH=%%c
        )
        
        :: Increment patch version
        set /a NEW_PATCH=!PATCH! + 1
        set NEW_VERSION=!MAJOR!.!MINOR!.!NEW_PATCH!
        
        echo New version: !NEW_VERSION!
        
        :: Update version in docker-compose.yml
        echo Updating %COMPOSE_FILE%...
        powershell -Command "(gc '%COMPOSE_FILE%') -replace 'image: mingtosomeone/trendradar:!CURRENT_VERSION!', 'image: mingtosomeone/trendradar:!NEW_VERSION!' | Out-File -encoding UTF8 '%COMPOSE_FILE%'"
        
        if !errorlevel! equ 0 (
            echo Successfully updated %COMPOSE_FILE% from !CURRENT_VERSION! to !NEW_VERSION!
        ) else (
            echo Error updating %COMPOSE_FILE%
        )
        echo.
    )
) else (
    echo Warning: %COMPOSE_FILE% not found
)

:: Verification
echo ========================================
echo Verification:
echo ========================================
if exist "%COMPOSE_BUILD_FILE%" (
    echo %COMPOSE_BUILD_FILE%:
    findstr "image: mingtosomeone/trendradar:" %COMPOSE_BUILD_FILE%
    echo.
)
if exist "%COMPOSE_FILE%" (
    echo %COMPOSE_FILE%:
    findstr "image: mingtosomeone/trendradar:" %COMPOSE_FILE%
    echo.
)

:: Optional: Git commit
echo Would you like to commit these changes to git?
echo 1) Yes, commit with appropriate version bump messages
echo 2) No, just exit
choice /c 12 /m "Select option"

if %errorlevel% equ 1 (
    git add %COMPOSE_BUILD_FILE% %COMPOSE_FILE% 2>nul
    if "!BUILD_NEW_VERSION!" neq "" (
        git commit -m "Bump docker build image version to !BUILD_NEW_VERSION!"
    )
    if "!NEW_VERSION!" neq "" (
        git commit -m "Bump docker image version to !NEW_VERSION!"
    )
    if %errorlevel% equ 0 (
        echo Git commits successful
    ) else (
        echo Git commit failed or no changes to commit
    )
)

echo.
echo Docker version increment completed!
echo ========================================