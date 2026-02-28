@echo off
:: Docker Compose version increment script for TrendRadar
:: Increments version from 1.1.0 to 1.1.1 in docker-compose-build.yml

setlocal enabledelayedexpansion

set COMPOSE_FILE=docker-compose-build.yml
set CURRENT_VERSION=1.1.0
set NEW_VERSION=1.1.1

echo Current version: %CURRENT_VERSION%
echo New version: %NEW_VERSION%
echo.

:: Check if docker-compose-build.yml exists
if not exist "%COMPOSE_FILE%" (
    echo Error: %COMPOSE_FILE% not found
    exit /b 1
)

:: Update version in docker-compose-build.yml
echo Updating version in %COMPOSE_FILE%...
powershell -Command "(gc '%COMPOSE_FILE%') -replace 'image: mingtosomeone/trendradar:%CURRENT_VERSION%', 'image: mingtosomeone/trendradar:%NEW_VERSION%' | Out-File -encoding UTF8 '%COMPOSE_FILE%'"

if %errorlevel% equ 0 (
    echo Version updated successfully from %CURRENT_VERSION% to %NEW_VERSION%
    
    :: Display the change
    echo.
    echo Verification:
    findstr "image: mingtosomeone/trendradar:" %COMPOSE_FILE%
    
    :: Optional: Git commit
    echo.
    echo Would you like to commit this change to git?
    echo 1) Yes, commit with message "Bump docker image version to %NEW_VERSION%"
    echo 2) No, just exit
    choice /c 12 /m "Select option"
    
    if %errorlevel% equ 1 (
        git add %COMPOSE_FILE%
        git commit -m "Bump docker image version to %NEW_VERSION%"
        if %errorlevel% equ 0 (
            echo Git commit successful
        ) else (
            echo Git commit failed
        )
    )
) else (
    echo Error updating version
    exit /b 1
)

echo.
echo Docker version increment completed!