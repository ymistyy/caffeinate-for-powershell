# caffeinate-for-powershell

A simple PowerShell script and executable to prevent your Windows system and/or display from sleeping, inspired by the macOS `caffeinate` command.

![Preview](https://i.imgur.com/72Tkik0.png)

---

## Features

- Prevent system sleep (CPU stays awake)  
- Prevent display sleep (screen stays on)  
- Specify duration to stay awake (in seconds)  
- Continuous mode (runs until manually stopped)  
- Simple command-line switches, similar to macOS caffeinate

---

## Usage

Run the script or executable with these parameters:

```powershell
.\caffeinate.ps1 [-t <seconds>] [-i] [-d]
```

- `-t <seconds>`: Stay awake for a specific number of seconds  
- `-i`: Prevent system sleep (CPU awake)  
- `-d`: Prevent display sleep (screen awake)  

If neither `-i` nor `-d` is specified, both system and display sleep are prevented by default.

### Examples

- Stay awake for 60 seconds (system + display):  
  ```powershell
  .\caffeinate.ps1 -t 60
  ```

- Keep system awake indefinitely (until Ctrl+C):  
  ```powershell
  .\caffeinate.ps1 -i
  ```

- Keep display awake indefinitely:  
  ```powershell
  .\caffeinate.ps1 -d
  ```

- Compile to executable (requires [ps2exe](https://github.com/MScholtes/PS2EXE)):

  ```powershell
  Invoke-ps2exe .\caffeinate.ps1 .\caffeinate.exe
  ```

---

## Making it work globally from anywhere

After compiling the script into `caffeinate.exe`, you can add its folder to your system PATH:

### Steps:

1. Compile the script:
   
   ```powershell
   Install-Module -Name ps2exe -Scope CurrentUser -Force
   Invoke-ps2exe .\caffeinate.ps1 .\caffeinate.exe
   ```

3. Move `caffeinate.exe` to a folder like:
   ```
   C:\Tools\caffeinate   ```

4. Add that folder to your system `PATH`:
   - Open **Start Menu**, search for **Environment Variables**
   - Click **"Environment Variables…"**
   - In **System variables**, find and select **Path**, then click **Edit**
   - Click **New**, and add:
     ```
     C:\Tools\caffeinate     ```
   - Click OK, then OK again

5. Now you can run:
   ```
   caffeinate -t 60
   ```
   from **any** terminal window.

---

## How it works

The script uses the Windows API function `SetThreadExecutionState` to inform Windows that the system and/or display should stay awake. It leverages flags like:

- `ES_CONTINUOUS (0x80000000)` — Keeps the state continuous until reset  
- `ES_SYSTEM_REQUIRED (0x00000001)` — Keeps system awake  
- `ES_DISPLAY_REQUIRED (0x00000002)` — Keeps display awake

---

## Notes

- The script requires PowerShell with .NET support (Windows 10/11).  
- The script handles 32-bit unsigned integer values correctly to avoid common PowerShell casting issues.  
- Press `Ctrl+C` to stop continuous mode.

---

## License

This project is licensed under the MIT License.

---

## Author

Ymistyy

---

Feel free to contribute or report issues!
