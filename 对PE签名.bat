set /p e=请输入你要签名的可执行文件名称:
::签名
signtool.exe sign /f testcer.pfx /fd SHA256 /p 123456 "%e%"
::加盖时间戳
signtool.exe timestamp /td SHA256 /tr http://rfc3161timestamp.globalsign.com/advanced "%e%"
pause