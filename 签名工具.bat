@echo off & title 可执行文件签名工具
PUSHD "%~DP0" && CD /D "%~DP0"
IF EXIST "%Public%"> NUL 2>&1 REG QUERY "HKU\S-1-5-19\Environment"
IF NOT %errorlevel% EQU 0 (
IF EXIST "%Public%" powershell.exe -windowstyle hidden -noprofile "Start-Process '%~dpnx0' -Verb RunAs")
title 可执行文件签名工具
@echo off & cls
set /p n=请设置testcer中创建者的名称:
::创建testcer
makecert.exe -sv testcer.pvk -r -n "CN=%n%" testcer.cer
::创建发行者testcer
certmgr.exe /c /add testcer.cer /s root
cert2spc.exe testcer.cer testcer.spc
set /p p=请输入你刚才设置的密码:
::提取pfxtestcer
pvk2pfx.exe -pvk testcer.pvk -pi %p% -spc testcer.spc -pfx testcer.pfx -f
set /p e=请输入你要签名的可执行文件名称:
::签名
signtool.exe sign /f testcer.pfx /fd SHA256 /p %p% "%e%"
::加盖时间戳
signtool.exe timestamp /td SHA256 /tr http://rfc3161timestamp.globalsign.com/advanced "%e%"
pause