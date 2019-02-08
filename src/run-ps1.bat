@echo off

rem change the fucking ExecutionPolicy, when its not allowed.
setlocal

SET ALLOW=RemoteSigned
FOR /F %%t IN ('powershell Get-ExecutionPolicy') DO SET POLICY=%%t

if not %POLICY% == %ALLOW% (
  powershell Set-ExecutionPolicy %ALLOW%
)

rem powershell Get-ExecutionPolicy
powershell %~dpnx1

endlocal
pause
exit /b 0
