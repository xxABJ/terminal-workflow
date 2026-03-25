@echo off
setlocal EnableDelayedExpansion

echo.
echo ==========================================
echo       PORTABLE TOOLCHAIN INSTALLER
echo ==========================================
echo.

rem Resolve root and key dirs
set "ROOT=%~dp0"
set "TOOLS=%ROOT%tools"
set "CONF_DIR=%ROOT%links"
set "SCRIPTS=%ROOT%scripts"

echo Root: %ROOT%
echo.

if not exist "%CONF_DIR%" (
    echo ERROR: links directory not found: %CONF_DIR%
    pause
    exit /b 1
)

echo Available link profiles:
echo   1. links-latest.conf
echo   2. links-lts.conf
echo   3. links-custom.conf
echo.

set /p PROFILE="Choose profile (1/2/3): "

if "%PROFILE%"=="1" set "CONF_FILE=%CONF_DIR%\links-latest.conf"
if "%PROFILE%"=="2" set "CONF_FILE=%CONF_DIR%\links-lts.conf"
if "%PROFILE%"=="3" set "CONF_FILE=%CONF_DIR%\links-custom.conf"

if not exist "%CONF_FILE%" (
    echo ERROR: Profile file not found: %CONF_FILE%
    pause
    exit /b 1
)

echo Using profile: %CONF_FILE%
echo.

rem --- ROBUST CONFIG LOADER ---
for /f "usebackq tokens=1,* delims==" %%A in ("%CONF_FILE%") do (
    set "LINE=%%A"
    set "VAL=%%B"

    rem Trim leading spaces
    for /f "tokens=* delims= " %%X in ("!LINE!") do set "LINE=%%X"

    rem Skip blank lines
    if "!LINE!"=="" (
        rem skip
    ) else if "!LINE:~0,1!"=="#" (
        rem skip
    ) else (
        rem Set variable
        set "!LINE!=!VAL!"
    )
)

echo.
echo Proceeding with downloads...
echo.

rem ============================================================
rem  CREATE FOLDER STRUCTURE
rem ============================================================
echo Creating folder structure...
mkdir "%TOOLS%" >nul 2>&1
mkdir "%TOOLS%\git\current" >nul 2>&1
mkdir "%TOOLS%\ripgrep\current" >nul 2>&1
mkdir "%TOOLS%\fd\current" >nul 2>&1
mkdir "%TOOLS%\node\current" >nul 2>&1
mkdir "%TOOLS%\node\cache" >nul 2>&1
mkdir "%TOOLS%\node\tmp" >nul 2>&1
mkdir "%TOOLS%\node\current\node_modules" >nul 2>&1
mkdir "%TOOLS%\python\current" >nul 2>&1
mkdir "%TOOLS%\python\current\Scripts" >nul 2>&1
mkdir "%TOOLS%\nvim\current" >nul 2>&1
mkdir "%TOOLS%\nvim\config\nvim" >nul 2>&1
mkdir "%TOOLS%\nvim\cache" >nul 2>&1
mkdir "%TOOLS%\nvim\data" >nul 2>&1
mkdir "%TOOLS%\nvim\state" >nul 2>&1
mkdir "%SCRIPTS%" >nul 2>&1
mkdir "%TOOLS%\git\home" >nul 2>&1
mkdir "%TOOLS%\git\tmp" >nul 2>&1
mkdir "%TOOLS%\zig" >nul 2>&1
mkdir "%TOOLS%\zig\current" >nul 2>&1
rem mkdir "%TOOLS%\zig\zig-cache" >nul 2>&1

rem ============================================================
rem  GENERATOR SCRIPT (FINAL WITH CORRECT PATH HANDLING)
rem ============================================================
echo Creating generator script...

rem ============================================================
rem  CREATE state.ps1
rem ============================================================
> "%SCRIPTS%\state.ps1" echo $script:StateFile = Join-Path $PSScriptRoot '..\state.json'
>> "%SCRIPTS%\state.ps1" echo function Get-StateObject {
>> "%SCRIPTS%\state.ps1" echo     if (Test-Path $script:StateFile) {
>> "%SCRIPTS%\state.ps1" echo         $json = Get-Content $script:StateFile -Raw
>> "%SCRIPTS%\state.ps1" echo         if ($json.Trim().Length -gt 0) { return $json ^| ConvertFrom-Json }
>> "%SCRIPTS%\state.ps1" echo     }
>> "%SCRIPTS%\state.ps1" echo     return @{}
>> "%SCRIPTS%\state.ps1" echo }
>> "%SCRIPTS%\state.ps1" echo function Get-State { param([string]$Key,$Default=$null) $s=Get-StateObject; if($s.PSObject.Properties.Name -contains $Key){return $s.$Key}; return $Default }
>> "%SCRIPTS%\state.ps1" echo function Set-State { param([string]$Key,$Value) $s=Get-StateObject; $s ^| Add-Member -NotePropertyName $Key -NotePropertyValue $Value -Force; ($s ^| ConvertTo-Json -Depth 10) ^| Set-Content $script:StateFile }

echo Running generator script...
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPTS%\state.ps1" >nul 2>&1

echo.
echo Downloading tools...

rem ============================================================
rem  INSTALL ALL TOOLS
rem ============================================================
echo.
echo [1/7] Git...
call :INSTALL_TOOL "%GIT%" "%TOOLS%\git-tmp" "%TOOLS%\git\current" "%TOOLS%\git.exe"

echo.
echo [2/7] ripgrep...
call :INSTALL_TOOL "%RIPGREP%" "%TOOLS%\ripgrep-tmp" "%TOOLS%\ripgrep\current" "%TOOLS%\ripgrep.zip"

echo.
echo [3/7] fd...
call :INSTALL_TOOL "%FD%" "%TOOLS%\fd-tmp" "%TOOLS%\fd\current" "%TOOLS%\fd.zip"

echo.
echo [4/7] Node...
call :INSTALL_TOOL "%NODE%" "%TOOLS%\node-tmp" "%TOOLS%\node\current" "%TOOLS%\node.zip"

echo.
echo [5/7] Python...
call :INSTALL_TOOL "%PYTHON%" "%TOOLS%\python-tmp" "%TOOLS%\python\current" "%TOOLS%\python.zip"

echo.
echo [6/7] Neovim...
call :INSTALL_TOOL "%NEOVIM%" "%TOOLS%\nvim-tmp" "%TOOLS%\nvim\current" "%TOOLS%\nvim.zip"

echo.
echo [7/7] Zig...
call :INSTALL_TOOL "%ZIG%" "%TOOLS%\zig-tmp" "%TOOLS%\zig\current" "%TOOLS%\zig.zip"

rem ============================================================
rem  WRITE STATE.JSON
rem ============================================================
echo.
echo Writing state.json...

> "%ROOT%state.json" echo ^{
>> "%ROOT%state.json" echo   "nodePath": "%TOOLS:\=\\%\\node\\current",
>> "%ROOT%state.json" echo   "pythonPath": "%TOOLS:\=\\%\\python\\current",
>> "%ROOT%state.json" echo   "nvimPath": "%TOOLS:\=\\%\\nvim",
>> "%ROOT%state.json" echo   "rgPath": "%TOOLS:\=\\%\\ripgrep\\current",
>> "%ROOT%state.json" echo   "fdPath": "%TOOLS:\=\\%\\fd\\current",
>> "%ROOT%state.json" echo   "gitPath": "%TOOLS:\=\\%\\git\\current\\cmd",
>> "%ROOT%state.json" echo   "zigPath": "%TOOLS:\=\\%\\zig\\current"
>> "%ROOT%state.json" echo ^}

rem ============================================================
rem  PYTHON: ENABLE import site IN python314._pth (P1)
rem ============================================================
echo.
echo Enabling 'import site' in python314._pth (for pip)...
set "PY_PTH=%TOOLS%\python\current\python314._pth"
if exist "%PY_PTH%" (
    (for /f "usebackq delims=" %%L in ("%PY_PTH%") do (
        set "LINE=%%L"
        setlocal EnableDelayedExpansion
        if /I "!LINE!"=="#import site" (
            echo import site
        ) else (
            echo !LINE!
        )
        endlocal
    )) > "%PY_PTH%.tmp"
    move /Y "%PY_PTH%.tmp" "%PY_PTH%" >nul
) else (
    echo WARNING: python314._pth not found at "%PY_PTH%".
)

rem ============================================================
rem  CREATE pip.ini (ADDED)
rem ============================================================
> "%TOOLS%\python\current\pip.ini" echo [global]
>> "%TOOLS%\python\current\pip.ini" echo cache-dir = pip-cache

echo Creating CMD wrappers...

REM >>> ADDED zig + git
for %%A in (node npm npx python nvim rg fd zig git) do (
    >"%TOOLS%\%%A.cmd" echo @echo off
    >>"%TOOLS%\%%A.cmd" echo powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPTS%\launch-%%A.ps1" %%*
)

rem ============================================================
rem  GENERATE LAUNCHERS (WITH ESCAPED PATHBLOCK)
rem ============================================================

rem ============================================================
rem  launch-node.ps1
rem ============================================================
> "%SCRIPTS%\launch-node.ps1" echo . "$PSScriptRoot\state.ps1"

>> "%SCRIPTS%\launch-node.ps1" echo $nodePath   = Get-State -Key 'nodePath'
>> "%SCRIPTS%\launch-node.ps1" echo $pythonPath = Get-State -Key 'pythonPath'
>> "%SCRIPTS%\launch-node.ps1" echo $zigPath    = Get-State -Key 'zigPath'
>> "%SCRIPTS%\launch-node.ps1" echo $gitPath    = Get-State -Key 'gitPath'
>> "%SCRIPTS%\launch-node.ps1" echo $rgPath     = Get-State -Key 'rgPath'
>> "%SCRIPTS%\launch-node.ps1" echo $fdPath     = Get-State -Key 'fdPath'

>> "%SCRIPTS%\launch-node.ps1" echo $env:PATH = @(
>> "%SCRIPTS%\launch-node.ps1" echo     "$PSScriptRoot"
>> "%SCRIPTS%\launch-node.ps1" echo     $nodePath
>> "%SCRIPTS%\launch-node.ps1" echo     $pythonPath
>> "%SCRIPTS%\launch-node.ps1" echo     "$pythonPath\Scripts"
>> "%SCRIPTS%\launch-node.ps1" echo     $zigPath
>> "%SCRIPTS%\launch-node.ps1" echo     $gitPath
>> "%SCRIPTS%\launch-node.ps1" echo     $rgPath
>> "%SCRIPTS%\launch-node.ps1" echo     $fdPath
>> "%SCRIPTS%\launch-node.ps1" echo     $env:PATH
>> "%SCRIPTS%\launch-node.ps1" echo ) -join ';'

>> "%SCRIPTS%\launch-node.ps1" echo $env:NODE_PATH="$nodePath\node_modules"
>> "%SCRIPTS%\launch-node.ps1" echo $env:NPM_CONFIG_PREFIX=$nodePath
>> "%SCRIPTS%\launch-node.ps1" echo $env:NPM_CONFIG_CACHE="$nodePath\cache"
>> "%SCRIPTS%\launch-node.ps1" echo $env:NPM_CONFIG_TMP="$nodePath\tmp"

>> "%SCRIPTS%\launch-node.ps1" echo ^& "$nodePath\node.exe" @args

rem ============================================================
rem  launch-npm.ps1
rem ============================================================
> "%SCRIPTS%\launch-npm.ps1" echo . "$PSScriptRoot\state.ps1"

>> "%SCRIPTS%\launch-npm.ps1" echo $nodePath   = Get-State -Key 'nodePath'
>> "%SCRIPTS%\launch-npm.ps1" echo $pythonPath = Get-State -Key 'pythonPath'
>> "%SCRIPTS%\launch-npm.ps1" echo $zigPath    = Get-State -Key 'zigPath'
>> "%SCRIPTS%\launch-npm.ps1" echo $gitPath    = Get-State -Key 'gitPath'
>> "%SCRIPTS%\launch-npm.ps1" echo $rgPath     = Get-State -Key 'rgPath'
>> "%SCRIPTS%\launch-npm.ps1" echo $fdPath     = Get-State -Key 'fdPath'

>> "%SCRIPTS%\launch-npm.ps1" echo $env:PATH = @(
>> "%SCRIPTS%\launch-npm.ps1" echo     "$PSScriptRoot"
>> "%SCRIPTS%\launch-npm.ps1" echo     $nodePath
>> "%SCRIPTS%\launch-npm.ps1" echo     $pythonPath
>> "%SCRIPTS%\launch-npm.ps1" echo     "$pythonPath\Scripts"
>> "%SCRIPTS%\launch-npm.ps1" echo     $zigPath
>> "%SCRIPTS%\launch-npm.ps1" echo     $gitPath
>> "%SCRIPTS%\launch-npm.ps1" echo     $rgPath
>> "%SCRIPTS%\launch-npm.ps1" echo     $fdPath
>> "%SCRIPTS%\launch-npm.ps1" echo     $env:PATH
>> "%SCRIPTS%\launch-npm.ps1" echo ) -join ';'

>> "%SCRIPTS%\launch-npm.ps1" echo $env:NODE_PATH="$nodePath\node_modules"
>> "%SCRIPTS%\launch-npm.ps1" echo $env:NPM_CONFIG_PREFIX=$nodePath
>> "%SCRIPTS%\launch-npm.ps1" echo $env:NPM_CONFIG_CACHE="$nodePath\cache"
>> "%SCRIPTS%\launch-npm.ps1" echo $env:NPM_CONFIG_TMP="$nodePath\tmp"

>> "%SCRIPTS%\launch-npm.ps1" echo ^& "$nodePath\node.exe" "$nodePath\node_modules\npm\bin\npm-cli.js" @args

rem ============================================================
rem  launch-npx.ps1
rem ============================================================
> "%SCRIPTS%\launch-npx.ps1" echo . "$PSScriptRoot\state.ps1"

>> "%SCRIPTS%\launch-npx.ps1" echo $nodePath   = Get-State -Key 'nodePath'
>> "%SCRIPTS%\launch-npx.ps1" echo $pythonPath = Get-State -Key 'pythonPath'
>> "%SCRIPTS%\launch-npx.ps1" echo $zigPath    = Get-State -Key 'zigPath'
>> "%SCRIPTS%\launch-npx.ps1" echo $gitPath    = Get-State -Key 'gitPath'
>> "%SCRIPTS%\launch-npx.ps1" echo $rgPath     = Get-State -Key 'rgPath'
>> "%SCRIPTS%\launch-npx.ps1" echo $fdPath     = Get-State -Key 'fdPath'

>> "%SCRIPTS%\launch-npx.ps1" echo $env:PATH = @(
>> "%SCRIPTS%\launch-npx.ps1" echo     "$PSScriptRoot"
>> "%SCRIPTS%\launch-npx.ps1" echo     $nodePath
>> "%SCRIPTS%\launch-npx.ps1" echo     $pythonPath
>> "%SCRIPTS%\launch-npx.ps1" echo     "$pythonPath\Scripts"
>> "%SCRIPTS%\launch-npx.ps1" echo     $zigPath
>> "%SCRIPTS%\launch-npx.ps1" echo     $gitPath
>> "%SCRIPTS%\launch-npx.ps1" echo     $rgPath
>> "%SCRIPTS%\launch-npx.ps1" echo     $fdPath
>> "%SCRIPTS%\launch-npx.ps1" echo     $env:PATH
>> "%SCRIPTS%\launch-npx.ps1" echo ) -join ';'

>> "%SCRIPTS%\launch-npx.ps1" echo $env:NODE_PATH="$nodePath\node_modules"
>> "%SCRIPTS%\launch-npx.ps1" echo $env:NPM_CONFIG_PREFIX=$nodePath
>> "%SCRIPTS%\launch-npx.ps1" echo $env:NPM_CONFIG_CACHE="$nodePath\cache"
>> "%SCRIPTS%\launch-npx.ps1" echo $env:NPM_CONFIG_TMP="$nodePath\tmp"

>> "%SCRIPTS%\launch-npx.ps1" echo ^& "$nodePath\node.exe" "$nodePath\node_modules\npm\bin\npx-cli.js" @args

rem ============================================================
rem  launch-python.ps1
rem ============================================================
> "%SCRIPTS%\launch-python.ps1" echo . "$PSScriptRoot\state.ps1"

>> "%SCRIPTS%\launch-python.ps1" echo $nodePath   = Get-State -Key 'nodePath'
>> "%SCRIPTS%\launch-python.ps1" echo $pythonPath = Get-State -Key 'pythonPath'
>> "%SCRIPTS%\launch-python.ps1" echo $zigPath    = Get-State -Key 'zigPath'
>> "%SCRIPTS%\launch-python.ps1" echo $gitPath    = Get-State -Key 'gitPath'
>> "%SCRIPTS%\launch-python.ps1" echo $rgPath     = Get-State -Key 'rgPath'
>> "%SCRIPTS%\launch-python.ps1" echo $fdPath     = Get-State -Key 'fdPath'

>> "%SCRIPTS%\launch-python.ps1" echo $env:PATH = @(
>> "%SCRIPTS%\launch-python.ps1" echo     "$PSScriptRoot"
>> "%SCRIPTS%\launch-python.ps1" echo     $nodePath
>> "%SCRIPTS%\launch-python.ps1" echo     $pythonPath
>> "%SCRIPTS%\launch-python.ps1" echo     "$pythonPath\Scripts"
>> "%SCRIPTS%\launch-python.ps1" echo     $zigPath
>> "%SCRIPTS%\launch-python.ps1" echo     $gitPath
>> "%SCRIPTS%\launch-python.ps1" echo     $rgPath
>> "%SCRIPTS%\launch-python.ps1" echo     $fdPath
>> "%SCRIPTS%\launch-python.ps1" echo     $env:PATH
>> "%SCRIPTS%\launch-python.ps1" echo ) -join ';'

>> "%SCRIPTS%\launch-python.ps1" echo $env:NODE_PATH="$nodePath\node_modules"
>> "%SCRIPTS%\launch-python.ps1" echo $env:NPM_CONFIG_PREFIX=$nodePath
>> "%SCRIPTS%\launch-python.ps1" echo $env:NPM_CONFIG_CACHE="$nodePath\cache"
>> "%SCRIPTS%\launch-python.ps1" echo $env:NPM_CONFIG_TMP="$nodePath\tmp"

>> "%SCRIPTS%\launch-python.ps1" echo $env:PYTHONHOME=$pythonPath
>> "%SCRIPTS%\launch-python.ps1" echo $env:PYTHONPATH="$pythonPath\Lib;$pythonPath\Scripts"
>> "%SCRIPTS%\launch-python.ps1" echo $env:PIP_CACHE_DIR="$pythonPath\pip-cache"
>> "%SCRIPTS%\launch-python.ps1" echo $env:PIP_CONFIG_FILE="$pythonPath\pip.ini"
>> "%SCRIPTS%\launch-python.ps1" echo $env:PYTHONUSERBASE="$pythonPath\userbase"
>> "%SCRIPTS%\launch-python.ps1" echo $env:PYTHONPYCACHEPREFIX="$pythonPath\pycache"
>> "%SCRIPTS%\launch-python.ps1" echo $env:TEMP="$pythonPath\tmp"
>> "%SCRIPTS%\launch-python.ps1" echo $env:TMP="$pythonPath\tmp"

>> "%SCRIPTS%\launch-python.ps1" echo ^& "$pythonPath\python.exe" @args

rem ============================================================
rem  launch-rg.ps1
rem ============================================================
> "%SCRIPTS%\launch-rg.ps1" echo . "$PSScriptRoot\state.ps1"
>> "%SCRIPTS%\launch-rg.ps1" echo $rgPath=Get-State -Key 'rgPath'
>> "%SCRIPTS%\launch-rg.ps1" echo ^& "$rgPath\rg.exe" @args

rem ============================================================
rem  launch-fd.ps1
rem ============================================================
> "%SCRIPTS%\launch-fd.ps1" echo . "$PSScriptRoot\state.ps1"
>> "%SCRIPTS%\launch-fd.ps1" echo $fdPath=Get-State -Key 'fdPath'
>> "%SCRIPTS%\launch-fd.ps1" echo ^& "$fdPath\fd.exe" @args

rem ============================================================
rem  launch-git.ps1 (ADDED)
rem ============================================================
> "%SCRIPTS%\launch-git.ps1" echo . "$PSScriptRoot\state.ps1"
>> "%SCRIPTS%\launch-git.ps1" echo $gitPath=Get-State -Key 'gitPath'
>> "%SCRIPTS%\launch-git.ps1" echo $env:HOME="$gitPath\..\home"
>> "%SCRIPTS%\launch-git.ps1" echo $env:TEMP="$gitPath\..\tmp"
>> "%SCRIPTS%\launch-git.ps1" echo $env:TMP="$gitPath\..\tmp"
>> "%SCRIPTS%\launch-git.ps1" echo ^& "$gitPath\git.exe" @args

rem ============================================================
rem  launch-nvim.ps1
rem ============================================================
> "%SCRIPTS%\launch-nvim.ps1" echo . "$PSScriptRoot\state.ps1"

>> "%SCRIPTS%\launch-nvim.ps1" echo $nodePath   = Get-State -Key 'nodePath'
>> "%SCRIPTS%\launch-nvim.ps1" echo $pythonPath = Get-State -Key 'pythonPath'
>> "%SCRIPTS%\launch-nvim.ps1" echo $nvimPath   = Get-State -Key 'nvimPath'
>> "%SCRIPTS%\launch-nvim.ps1" echo $zigPath    = Get-State -Key 'zigPath'
>> "%SCRIPTS%\launch-nvim.ps1" echo $gitPath    = Get-State -Key 'gitPath'
>> "%SCRIPTS%\launch-nvim.ps1" echo $rgPath     = Get-State -Key 'rgPath'
>> "%SCRIPTS%\launch-nvim.ps1" echo $fdPath     = Get-State -Key 'fdPath'

rem ===== PATH prepend (ALL portable tools) =====
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:PATH = @(
>> "%SCRIPTS%\launch-nvim.ps1" echo     "$PSScriptRoot"
>> "%SCRIPTS%\launch-nvim.ps1" echo     $nodePath
>> "%SCRIPTS%\launch-nvim.ps1" echo     $pythonPath
>> "%SCRIPTS%\launch-nvim.ps1" echo     "$pythonPath\Scripts"
>> "%SCRIPTS%\launch-nvim.ps1" echo     $zigPath
>> "%SCRIPTS%\launch-nvim.ps1" echo     $gitPath
>> "%SCRIPTS%\launch-nvim.ps1" echo     $rgPath
>> "%SCRIPTS%\launch-nvim.ps1" echo     $fdPath
>> "%SCRIPTS%\launch-nvim.ps1" echo     $env:PATH
>> "%SCRIPTS%\launch-nvim.ps1" echo ) -join ';'

rem ===== Node provider =====
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:NODE_PATH="$nodePath\node_modules"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:NPM_CONFIG_PREFIX=$nodePath
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:NPM_CONFIG_CACHE="$nodePath\cache"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:NPM_CONFIG_TMP="$nodePath\tmp"

rem ===== Python provider =====
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:PYTHONHOME=$pythonPath
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:PYTHONPATH="$pythonPath\Lib;$pythonPath\Scripts"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:PIP_CACHE_DIR="$pythonPath\pip-cache"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:PIP_CONFIG_FILE="$pythonPath\pip.ini"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:PYTHONUSERBASE="$pythonPath\userbase"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:PYTHONPYCACHEPREFIX="$pythonPath\pycache"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:TEMP="$pythonPath\tmp"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:TMP="$pythonPath\tmp"

rem ===== Zig =====
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:ZIG_GLOBAL_CACHE_DIR="$zigPath\zig-cache"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:ZIG_LOCAL_CACHE_DIR="$zigPath\zig-cache"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:CC="$zigPath\zig.exe cc"

rem ===== XDG (Neovim) =====
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:XDG_CONFIG_HOME="$nvimPath\config"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:XDG_DATA_HOME="$nvimPath\data"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:XDG_STATE_HOME="$nvimPath\state"
>> "%SCRIPTS%\launch-nvim.ps1" echo $env:XDG_CACHE_HOME="$nvimPath\cache"

rem ===== Launch Neovim =====
>> "%SCRIPTS%\launch-nvim.ps1" echo ^& "$nvimPath\current\bin\nvim.exe" @args

rem ============================================================
rem  POST-INSTALL: INSTALL PIP VIA get-pip.py + PYNVIM + Pyright
rem ============================================================
echo.
echo Downloading get-pip.py...
curl -L https://bootstrap.pypa.io/get-pip.py -o "%TOOLS%\python\current\get-pip.py"

if exist "%TOOLS%\python\current\get-pip.py" (
    echo Installing pip using get-pip.py...
    call "%TOOLS%\python.cmd" "%TOOLS%\python\current\get-pip.py"
    if errorlevel 1 (
        echo WARNING: get-pip.py failed to install pip.
    ) else (
        echo pip installed successfully.
    )

    echo.
    echo Installing pynvim...
    call "%TOOLS%\python.cmd" -m pip install pynvim
    if errorlevel 1 (
        echo WARNING: 'python -m pip install pynvim' failed.
    ) else (
        echo pynvim installed successfully.
		
    )
) else (
    echo WARNING: get-pip.py download failed, skipping pip/pynvim installation.
)

echo.
echo Installing pyright...
call "%TOOLS%\python.cmd" -m pip install pyright

echo pyright installed successfully.

rem ============================================================
rem  POST-INSTALL: INSTALL NODE NEOVIM PROVIDER
rem ============================================================
echo.
echo Installing Neovim Node.js provider (npm neovim)...

call "%TOOLS%\npm.cmd" install -g neovim
if errorlevel 1 (
    echo WARNING: 'npm install -g neovim' failed.
) else (
    echo npm neovim provider installed successfully.
)

echo.
echo Fixing nvim with :checkhealth
powershell -NoLogo -NoProfile -Command ^
    "& '%TOOLS%\nvim.cmd' --headless '+checkhealth' +qa | Out-File '%ROOT%\checkhealth.txt'"

echo.
echo ==========================================
echo   INSTALLATION COMPLETE
echo ==========================================
echo.
echo Tools installed under: %TOOLS%
echo state.json written at: %ROOT%state.json
echo.
pause
endlocal
exit /b 0

rem ============================================================
rem  UNIVERSAL INSTALL FUNCTION (FINAL)
rem ============================================================
:INSTALL_TOOL
set "URL=%~1"
set "TEMP_EXTRACT=%~2"
set "TARGET_CURRENT=%~3"
set "ARCHIVE=%~4"

echo Downloading %URL%...
curl -L "%URL%" -o "%ARCHIVE%"

mkdir "%TEMP_EXTRACT%" >nul 2>&1

rem ------------------------------------------------------------
rem  PORTABLEGIT (.7z.exe) — PRESERVE FOLDER STRUCTURE
rem ------------------------------------------------------------
if /I "%ARCHIVE:~-4%"==".exe" (
    echo Extracting PortableGit self-extracting archive...
    "%ARCHIVE%" -y -o"%TEMP_EXTRACT%"
    goto :INSTALL_EXTRACTED_PRESERVE
)

rem ------------------------------------------------------------
rem  ZIP ARCHIVES — FLATTEN ONE TOP-LEVEL FOLDER + ROOT FILES
rem ------------------------------------------------------------
if /I "%ARCHIVE:~-4%"==".zip" (
    echo Extracting ZIP...
    tar -xf "%ARCHIVE%" -C "%TEMP_EXTRACT%"
    goto :INSTALL_EXTRACTED_FLATTEN
)

rem ------------------------------------------------------------
rem  TAR ARCHIVES — FLATTEN
rem ------------------------------------------------------------
echo Extracting TAR archive...
tar -xf "%ARCHIVE%" -C "%TEMP_EXTRACT%"
goto :INSTALL_EXTRACTED_FLATTEN

rem ------------------------------------------------------------
rem  PRESERVE MODE (GIT ONLY)
rem ------------------------------------------------------------
:INSTALL_EXTRACTED_PRESERVE
for /d %%D in ("%TEMP_EXTRACT%\*") do (
    echo Copying folder %%~nxD...
    xcopy "%%D" "%TARGET_CURRENT%\%%~nxD" /E /I /Y >nul
)
for %%F in ("%TEMP_EXTRACT%\*") do (
    if not "%%~aF"=="d" (
        echo Copying file %%~nxF...
        copy "%%F" "%TARGET_CURRENT%" >nul
    )
)
goto :INSTALL_CLEANUP

rem ------------------------------------------------------------
rem  FLATTEN MODE (ZIP + TAR)
rem ------------------------------------------------------------
:INSTALL_EXTRACTED_FLATTEN
rem Flatten top-level folder (if any)
for /d %%D in ("%TEMP_EXTRACT%\*") do (
    echo Flattening %%~nxD...
    xcopy "%%D\*" "%TARGET_CURRENT%" /E /I /Y >nul
)

rem Copy root-level files (Python embed needs this!)
for %%F in ("%TEMP_EXTRACT%\*") do (
    if not "%%~aF"=="d" (
        echo Copying file %%~nxF...
        copy "%%F" "%TARGET_CURRENT%" >nul
    )
)

goto :INSTALL_CLEANUP

rem ------------------------------------------------------------
rem  CLEANUP
rem ------------------------------------------------------------
:INSTALL_CLEANUP
rmdir /S /Q "%TEMP_EXTRACT%"
del "%ARCHIVE%" >nul 2>&1
exit /b
