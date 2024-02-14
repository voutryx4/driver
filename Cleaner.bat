@echo off
REM Batch script to delete FiveM app data
REM Prompt for admin access
NET FILE >NUL 2>&1
if '%errorlevel%' == '0' ( goto START ) else ( goto ELEVATE )

:ELEVATE
  echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
  echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
  "%temp%\getadmin.vbs"
  exit /B

:START
REM Rest of the script goes here...

@echo off
setlocal
set "FIVEM_APP_DIR=%localappdata%\fivem\fivem.app"


if exist "%FIVEM_APP_DIR%\crashes" (
    del /q /s /f "%FIVEM_APP_DIR%\crashes\*.*"
    rmdir /s /q "%FIVEM_APP_DIR%\crashes"
    echo "cache folder deleted successfully."
) else (
    echo "cache folder not found."
)

if exist "%FIVEM_APP_DIR%\logs" (
    del /q /s /f "%FIVEM_APP_DIR%\logs\*.*"
    rmdir /s /q "%FIVEM_APP_DIR%\logs"
    echo "logs folder deleted successfully."
) else (
    echo "logs folder not found."
)



echo Deleting MachineGUID content...
reg add "HKLM\SOFTWARE\Microsoft\Cryptography" /v "MachineGUID" /t REG_SZ /d "" /f

echo Deleting DigitalEntitlements folder...
if exist "%localappdata%\DigitalEntitlements" (
    rmdir /s /q "%localappdata%\DigitalEntitlements"
    echo "DigitalEntitlements folder deleted successfully."
) else (
    echo "DigitalEntitlements folder not found."
)

echo Deleting kvs folder in Roaming AppData...
if exist "%appdata%\CitizenFX\kvs" (
    rmdir /s /q "%appdata%\CitizenFX\kvs"
    echo "CitizenFX folder deleted successfully."
) else (
    echo "kvs folder not found."
)

echo Cleaner Finalizado!!!


cd %userprofile%\Desktop\
REN "%userprofile%\AppData\Local\Discord\app-1.0.9023\modules\discord_rpc-1" "discord_rpc-3"

REN "%userprofile%\AppData\Local\Discord\app-1.0.9023\modules\discord_rpc-3\discord_rpc" "discord_rpc2"


@echo off
echo Limpando Cache Network

NETSH WINSOCK RESET
NETSH INT IP RESET
NETSH INTERFACE IPV4 RESET
NETSH INTERFACE TCP RESET
IPCONFIG /RELEASE
IPCONFIG /RENEW
IPCONFIG /FLUSHDNS
IPCONFIG /RENEW
net stop winmgmt /y >nul 2>&1
vssadmin delete shadows /All /Quiet >nul 2>&1

echo Cleaner Finalizado.

timeout /t 1

@echo off
echo Desabilitando Riot Vanguard - sc stop vgk

echo Current user privileges: %userprofile%
echo.
echo Solicitando privilegios administrativos...

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :continue
) else (
    goto :admin
)

:admin
echo.
echo Você precisa executar este arquivo em lote como administrador.
echo Conceda privilegios administrativos selecionando "Sim" quando solicitado.
echo.
powershell -Command "Start-Process '%0' -Verb RunAs"
exit

:continue
echo privilegios administrativos confirmados.
echo.
echo Desativando Riot Vanguard...

sc stop vgk

echo.
echo Success!
echo.
pause>nul
exit
