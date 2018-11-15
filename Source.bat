@echo off
setlocal enableextensions enabledelayedexpansion
set NODE_VERSION=8.12.0
set GIT_VERSION=2.19.1

echo iNut Node-RED IDE - Windows Installer
:: get OS arch 

set OS=86
echo %PROCESSOR_ARCHITECTURE% | find /i "64" > tmp.txt
set /p OS_VALUE=< tmp.txt
if NOT "%OS_VALUE%"=="" (
	set OS=64
)

echo Your operating system arch is x%OS%



::check for git 
echo Checking git version

call :get_git_version


If NOT "%GIT_ERROR%"=="" (
    echo Now, we install git. Because you haven't installed Git yet.
	start /wait "Git installer" Git-%GIT_VERSION%-%OS%-bit.exe
	call :get_git_version
	If NOT "%GIT_ERROR%"=="" (
		echo ERROR: You must install Git. Please restart setup process.
		goto :eof
	)
)
echo Your git version is %GIT_VERSION%

::check for node
echo Checking NodeJS version

call :get_node_version


If NOT "%NODE_ERROR%"=="" (
    echo Now, we install nodejs. Because you haven't installed Nodejs yet.
	start /wait "Nodejs installer" node-v%NODE_VERSION%-x%OS%.msi
	call :get_node_version
	If NOT "%NODE_ERROR%"=="" (
		echo ERROR: You must install NodeJS. Please restart setup process.
		goto :eof
	)
)

echo Your nodejs version is %NODE_VERSION%

echo Clean install data 
del *.txt




git clone https://github.com/ngohuynhngockhanh/iNut-Node-RED-IDE
del *.txt
cd iNut-Node-RED-IDE

::check for installed 
set /p NODERED_INSTALLED=<installed.txt
echo  iNut NodeRED IDE %NODERED_INSTALLED%
If NOT x"%NODERED_INSTALLED%"==x"Installed" (
	echo hihi > installed.txt
	start cmd /wait /c "echo iNut-Node-RED-IDE is installing............ && npm install && echo|set /p="Installed">installed.txt"
	
	:check_installed
	set /p NODERED_INSTALLED=<installed.txt
	If NOT x"%NODERED_INSTALLED%"==x"Installed" (
		echo .
		timeout /t 5 /nobreak > NUL
		goto :check_installed
	)
)

:start
echo Your PC is good! Let opening the first app
npm start


::end batch
goto :eof


:get_git_version

git --version > gcv.txt 2> gcv_error.txt
set /p GIT_ERROR=<gcv_error.txt
SET /p GIT_VERSION=<gcv.txt 
EXIT /B 0

:get_node_version

node -v > gcv.txt 2> gcv_error.txt
set /p NODE_ERROR=<gcv_error.txt
SET /p NODE_VERSION=<gcv.txt 
EXIT /B 0