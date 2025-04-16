@echo off
setlocal enabledelayedexpansion

echo ====================================
echo    Project Initialization Script
echo ====================================
echo.



:: Check if pyenv is installed
echo 1. Checking if pyenv is installed...
where pyenv >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo pyenv is installed.
    echo Installing Python 3.11.9...
    
    :: Check if version is already installed
    pyenv versions | findstr "3.11.9" >nul
    if %ERRORLEVEL% EQU 0 (
        echo Python 3.11.9 is already installed.
    ) else (
        echo Installing Python 3.11.9...
        pyenv install 3.11.9
        if %ERRORLEVEL% NEQ 0 (
            echo Failed to install Python 3.11.9.
            goto :exit_script
        )
    )
    
    :: Set local Python version to 3.11.9
    echo Setting Python version to 3.11.9 for this project...
    pyenv local 3.11.9
    echo Python version has been set to 3.11.9.
) else (
    echo pyenv is not installed.
    echo Please install pyenv first and then run this script again.
    echo Installation guide: https://github.com/pyenv-win/pyenv-win#installation
    goto :exit_script
)

echo.

:: Check if conda is installed
echo 2. Checking if conda is installed...
where conda >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo conda is installed.
    
    :: Check if environment already exists and remove it
    conda env list | findstr "pyone-t5" >nul
    if %ERRORLEVEL% EQU 0 (
        echo Removing existing pyone-t5 environment...
        call conda remove --name pyone-t5 --all -y
    )
    
    :: Create new environment and install packages
    echo Creating conda environment and installing packages...
    call conda env create -f environment.yml
    
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to create conda environment.
        goto :exit_script
    )
    
    echo.
    echo Environment has been successfully created!
    echo To activate the environment, run:
    echo   conda activate pyone-t5
) else (
    echo conda is not installed.
    echo Please install conda first and then run this script again.
    echo Installation guide: https://docs.conda.io/en/latest/miniconda.html
    goto :exit_script
)

echo.
echo Initialization completed!
goto :eof

:exit_script
echo.
echo Exiting script.
exit /b 1
