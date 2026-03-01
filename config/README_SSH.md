# SSH QNAP Scripts Documentation

## Overview
This directory contains scripts for managing SSH connections to your QNAP server and synchronizing configuration files.

## Files

### Main Scripts
- **`ssh_qnap_unified.bat`** - Unified script that accepts configuration file as parameter
- **`ssh_config.bat`** - Wrapper for config.yaml
- **`ssh_timeline.bat`** - Wrapper for timeline.yaml  
- **`ssh_frequency.bat`** - Wrapper for frequency_words.txt

## Usage

### Method 1: Using Wrapper Scripts (Recommended)
Simply double-click the appropriate wrapper script:
- `ssh_config.bat` - Sync config.yaml
- `ssh_timeline.bat` - Sync timeline.yaml
- `ssh_frequency.bat` - Sync frequency_words.txt

### Method 2: Direct Usage
Call the unified script directly with the configuration file name:
```batch
ssh_qnap_unified.bat config.yaml
ssh_qnap_unified.bat timeline.yaml
ssh_qnap_unified.bat frequency_words.txt
```

## Features
- ✅ Automatic file backup on remote server with timestamp
- ✅ File existence validation before transfer
- ✅ SSH client availability check
- ✅ Automatic docker-compose restart on remote server
- ✅ Secure SSH key authentication support
- ✅ Error handling and user feedback

## Configuration
The scripts use the following server settings (configured in `ssh_qnap_unified.bat`):
- **Server IP**: 192.168.0.65
- **Username**: jackychung
- **Port**: 822
- **Target Directory**: /share/Container/trendradar/config/
- **Docker Directory**: /share/Container/trendradar/docker/

## Security Notes
- Password is not stored in scripts (following security best practices)
- Uses SSH key authentication when available
- Remote files are automatically backed up with timestamps

## Requirements
- Windows with OpenSSH client installed
- SSH access to your QNAP server
- Proper SSH key setup (recommended) or password authentication