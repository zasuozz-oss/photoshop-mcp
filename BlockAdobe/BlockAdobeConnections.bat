@echo off
setlocal enabledelayedexpansion
color 0C
title Kills Block and Clean Adobe Genuine Service

:: === TU DONG NANG QUYEN ADMIN ===
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Dang yeu cau quyen Admin...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b 0
)

echo =======================================================
echo   FIX LOI ^"UNG DUNG KHONG DUOC CAP PHEP^" ^(ADOBE POPUP^)
echo =======================================================
echo.

echo [1/6] DANG TAT CAC DICH VU KIEM TRA BAN QUYEN NGAM (AGS)...
sc stop "AGSService" >nul 2>&1
sc config "AGSService" start= disabled >nul 2>&1
sc stop "AGMService" >nul 2>&1
sc config "AGMService" start= disabled >nul 2>&1
sc stop "AdobeUpdateService" >nul 2>&1
sc config "AdobeUpdateService" start= disabled >nul 2>&1
sc stop "Adobe Genuine Monitor Service" >nul 2>&1
sc config "Adobe Genuine Monitor Service" start= disabled >nul 2>&1
echo - Da tat vinh vien cac services Adobe.
echo.

echo [2/6] DANG TIM VA XOA THU MUC CHECK BAN QUYEN...
set "gcDir1=C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient"
set "gcDir2=C:\Program Files\Common Files\Adobe\AdobeGCClient"

if not exist "%gcDir1%\." goto :skipDir1
echo - Dang xoa: %gcDir1%
rd /s /q "%gcDir1%" >nul 2>&1
goto :doneDir1
:skipDir1
echo - Khong ton tai: %gcDir1% (Da sach)
:doneDir1

if not exist "%gcDir2%\." goto :skipDir2
echo - Dang xoa: %gcDir2%
rd /s /q "%gcDir2%" >nul 2>&1
goto :doneDir2
:skipDir2
echo - Khong ton tai: %gcDir2% (Da sach)
:doneDir2
echo - Xu ly xoa thu muc hoan tat.
echo.

echo [3/6] DANG TAT DNS-OVER-HTTPS DE HOSTS FILE CO HIEU LUC...
:: Windows 11 co the bypass hosts file khi dung DoH - tat di
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d 0 /f >nul 2>&1
echo - Da tat DNS-over-HTTPS.
echo.

echo [4/6] DANG THEM HANG LOAT DOMAIN VAO FILE HOSTS TU REPO...
set "hostsFile=%windir%\System32\drivers\etc\hosts"
set "repoHostsFile=%~dp0hosts"

attrib -r "%hostsFile%" >nul 2>&1

if exist "%repoHostsFile%" (
    echo - Dang tien hanh doc file hosts va cap nhat ^(mat vai giay^)...
    powershell -Command "$sys='%windir%\System32\drivers\etc\hosts'; $rep='%~dp0hosts'; $curr=Get-Content -Path $sys -Raw; $lines=Get-Content -Path $rep; $add=0; foreach ($l in $lines) { if ($l -match '^0\.0\.0\.0\s+(.+)') { $d=$matches[1]; if ($curr -notmatch [regex]::Escape($d)) { Add-Content -Path $sys -Value $l; $add++ } } }; Write-Host '- Da them' $add 'domain vao hosts.'"
) else (
    echo - Khong tim lay file hosts trong thu muc %~dp0
)
echo.

echo [5/6] DANG XOA CACHE DNS...
ipconfig /flushdns >nul 2>&1
echo - Thanh cong.
echo.

echo [6/6] DANG QUET FILE EXE VA SET TUONG LUA CHAN KET NOI...

call :BlockDir "C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient" "AGS_Block"
call :BlockDir "C:\Program Files\Common Files\Adobe\AdobeGCClient" "AGS_Block"
call :BlockDir "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\ADS" "AGS_Block"
call :BlockDir "C:\Program Files\Adobe" "Adobe_App"
call :BlockDir "C:\Program Files (x86)\Adobe" "Adobe_App"

echo - Da thiet lap xong tuong lua cho toan bo ung dung.
echo.

color 0A
echo =======================================================
echo HOAN THANH! Mo lai ung dung Adobe de kiem tra.
echo =======================================================
echo.
pause
exit /b 0

:BlockDir
set "targetDir=%~1"
set "rulePrefix=%~2"
if not exist "%targetDir%\." goto :eof
for /R "%targetDir%" %%f in (*.exe) do (
    netsh advfirewall firewall add rule name="%rulePrefix%_Out_%%~nxf" dir=out action=block program="%%f" enable=yes profile=any >nul 2>&1
    netsh advfirewall firewall add rule name="%rulePrefix%_In_%%~nxf" dir=in action=block program="%%f" enable=yes profile=any >nul 2>&1
)
goto :eof