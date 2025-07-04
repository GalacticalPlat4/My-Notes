# Script to configure power options to never sleep or turn off display
# Run as Administrator

# Check if running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        Write-Host "Please run this script as an Administrator." -ForegroundColor Red
        exit
    }

# Get the active power scheme GUID
$activeScheme = (powercfg /getactivescheme).Split()[3]
Write-Host "Active Power Scheme GUID: $activeScheme"

# Set monitor timeout to never (0 minutes) for AC and DC power
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0

# Set sleep timeout to never (0 minutes) for AC and DC power
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

# Optional: Disable hibernation
#powercfg /hibernate off

Write-Host "Power settings updated: Display and sleep set to 'Never' for both AC and DC power." -ForegroundColor Green