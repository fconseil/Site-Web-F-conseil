@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0backup-to-github.ps1" %*
exit /b %ERRORLEVEL%
