@echo off
title ServerLaunch
cd /d "%~dp0"
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0ServerLaunch.ps1"
exit
