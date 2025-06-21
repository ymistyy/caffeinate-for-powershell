param (
    [int]$t,         # Time in seconds to stay awake
    [switch]$d,      # Keep display awake
    [switch]$i       # Keep system (CPU) awake
)

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class PowerHelper {
    [DllImport("kernel32.dll")]
    public static extern uint SetThreadExecutionState(uint esFlags);
}
"@

# Correctly parse hex as uint32 
[uint32]$flags = [Convert]::ToUInt32("80000000",16)  # ES_CONTINUOUS

if ($d) { $flags = $flags -bor 0x00000002 } # ES_DISPLAY_REQUIRED
if ($i) { $flags = $flags -bor 0x00000001 } # ES_SYSTEM_REQUIRED

if (-not $d -and -not $i) {
    $flags = $flags -bor 0x00000001 -bor 0x00000002
}

[PowerHelper]::SetThreadExecutionState([uint32]$flags)

if ($t) {
    Write-Host "Staying awake for $t seconds..."
    Start-Sleep -Seconds $t
    Write-Host "Time expired. Reverting state."
} else {
    Write-Host "Staying awake... Press Ctrl+C to stop."
    while ($true) {
        Start-Sleep -Seconds 60
    }
}

[PowerHelper]::SetThreadExecutionState([Convert]::ToUInt32("80000000",16))
