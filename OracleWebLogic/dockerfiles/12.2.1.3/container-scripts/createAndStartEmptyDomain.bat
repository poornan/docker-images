 
rem set DOMAIN_NAME=test
rem setx /M DOMAIN_HOME C:\u01\oracle\user_projects\domains\%DOMAIN_NAME%
set DOMAIN_HOME="C:\u01\oracle\user_projects\domains\%DOMAIN_NAME%"
echo "Domain Home is: " %DOMAIN_HOME%

set ADD_DOMAIN=1
if NOT EXIST "%DOMAIN_HOME%\servers\AdminServer\logs\AdminServer.log" (
    set ADD_DOMAIN=0
)

rem SET ORACLE_HOME=C:\u01\oracle

rem mkdir %ORACLE_HOME%\properties
SET PROPERTIES_FILE="C:\u01\oracle\properties\domain.properties"
if %ADD_DOMAIN% EQU 0 (
  if NOT EXIST %PROPERTIES_FILE% (
      echo "A properties file with the username and password needs to be supplied."
      exit 0
  )
  for /F "eol=# delims== tokens=1,*" %%a in (%PROPERTIES_FILE%) do (
      if NOT "%%a"=="" if NOT "%%b"=="" set %%a=%%b
  )

  echo %username%
  echo %password%
  echo %PATH%
  echo %CD%
  call "C:\u01\oracle\oracle_common\common\bin\wlst.bat" -skipWLSModuleScanning -loadProperties %PROPERTIES_FILE%  C:/u01/oracle/create-wls-domain.py
)
call "%DOMAIN_HOME%\startWebLogic.bat"
echo. > %DOMAIN_HOME%\servers\AdminServer\logs\AdminServer.log
powershell -Command "& {Get-Content %DOMAIN_HOME%\servers\AdminServer\logs\AdminServer.log –Wait}"
