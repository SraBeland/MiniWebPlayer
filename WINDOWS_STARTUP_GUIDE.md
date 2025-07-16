# Windows Startup Feature Guide

## Overview

MiniWebPlayer now includes Windows startup functionality that allows users to automatically start the application when Windows boots up. This feature can be configured both during installation and from within the application settings.

## Installation Options

### During Installation
When installing MiniWebPlayer using the NSIS installer, users will see a custom "Startup Options" page with:
- **"Start MiniWebPlayer automatically when Windows starts"** checkbox
- This option is checked by default for user convenience
- Users can uncheck it if they don't want automatic startup
- The installer will add the registry entry if the option is selected

### After Installation
Users can enable or disable Windows startup from within the application:

1. Right-click anywhere in the MiniWebPlayer window
2. Select "Edit Settings" from the context menu
3. In the settings window, check or uncheck "Start with Windows"
4. Click "Save Settings"

## Technical Implementation

### Registry Location
The startup functionality uses the Windows registry at:
```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
```

### Registry Entry
- **Key Name**: `MiniWebPlayer`
- **Value**: Path to the MiniWebPlayer executable

### Application Features
- **Cross-platform detection**: Only works on Windows (gracefully handles other platforms)
- **Real-time status**: Settings window shows current startup status
- **Error handling**: Provides user feedback if registry operations fail
- **Clean uninstall**: Automatically removes startup entry when uninstalling

## User Benefits

1. **Convenience**: Application starts automatically with Windows
2. **Immediate access**: No need to manually launch the application
3. **Flexible control**: Can be enabled/disabled at any time
4. **Clean removal**: Properly cleaned up during uninstallation

## Technical Details

### IPC Communication
The feature uses Electron's IPC (Inter-Process Communication) system:
- `get-startup-enabled`: Check if startup is currently enabled
- `set-startup-enabled`: Enable or disable startup functionality

### Registry Commands
- **Check status**: `reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "MiniWebPlayer"`
- **Enable startup**: `reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "MiniWebPlayer" /t REG_SZ /d "path\to\app.exe" /f`
- **Disable startup**: `reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "MiniWebPlayer" /f`

### Security Considerations
- Uses current user registry (HKCU) - no administrator privileges required
- Only affects the current user's startup programs
- Clean removal ensures no leftover registry entries

## Troubleshooting

### Common Issues
1. **Permission errors**: Ensure the application has permission to modify the registry
2. **Path issues**: The application path must be valid and accessible
3. **Registry corruption**: Rare cases may require manual registry cleanup

### Manual Registry Cleanup
If needed, users can manually remove the startup entry:
1. Press `Win + R`, type `regedit`, press Enter
2. Navigate to `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run`
3. Delete the `MiniWebPlayer` entry if it exists

## Future Enhancements

Potential future improvements:
- Startup delay options
- Minimized startup mode
- Startup arguments configuration
- System-wide installation support (HKLM registry)
