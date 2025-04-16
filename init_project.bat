@echo off
setlocal enabledelayedexpansion

echo ====================================
echo    프로젝트 초기화 스크립트
echo ====================================
echo.

:: 환경 설정 파일 생성
echo environment.yml 파일 생성 중...
(
echo name: pyone-t5
echo channels:
echo   - conda-forge
echo   - defaults
echo dependencies:
echo   - python=3.11.8
echo   - fastapi^>=0.110.0
echo   - uvicorn^>=0.27.0
echo   - tensorflow^>=2.15.0,^<2.16.0
echo   - numpy^>=1.22.0
echo   - pandas=2.2.2
echo   - pillow^>=10.0.0
echo   - pip
echo   - pip:
echo     - python-multipart^>=0.0.9
echo     - tensorflow-io-gcs-filesystem==0.34.0
) > environment.yml
echo environment.yml 파일이 생성되었습니다.
echo.

:: pyenv 설치 확인
echo 1. pyenv 설치 여부 확인 중...
where pyenv >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo pyenv가 설치되어 있습니다.
    echo Python 3.11.8 설치 중...
    
    :: 이미 설치된 버전인지 확인
    pyenv versions | findstr "3.11.8" >nul
    if %ERRORLEVEL% EQU 0 (
        echo Python 3.11.8이 이미 설치되어 있습니다.
    ) else (
        echo Python 3.11.8 설치 중...
        pyenv install 3.11.8
        if %ERRORLEVEL% NEQ 0 (
            echo Python 3.11.8 설치에 실패했습니다.
            goto :exit_script
        )
    )
    
    :: 로컬 Python 버전을 3.11.8로 설정
    echo 현재 프로젝트의 Python 버전을 3.11.8로 설정 중...
    pyenv local 3.11.8
    echo Python 버전이 3.11.8로 설정되었습니다.
) else (
    echo pyenv가 설치되어 있지 않습니다.
    echo pyenv를 먼저 설치한 후 이 스크립트를 다시 실행하세요.
    echo pyenv 설치 방법: https://github.com/pyenv-win/pyenv-win#installation
    goto :exit_script
)

echo.

:: conda 설치 확인
echo 2. conda 설치 여부 확인 중...
where conda >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo conda가 설치되어 있습니다.
    
    :: 기존 환경이 있는지 확인하고 제거
    conda env list | findstr "pyone-t5" >nul
    if %ERRORLEVEL% EQU 0 (
        echo 기존 pyone-t5 환경을 제거합니다...
        call conda remove --name pyone-t5 --all -y
    )
    
    :: 새 환경 생성 및 패키지 설치
    echo conda 환경 생성 및 패키지 설치 중...
    call conda env create -f environment.yml
    
    if %ERRORLEVEL% NEQ 0 (
        echo conda 환경 생성에 실패했습니다.
        goto :exit_script
    )
    
    echo.
    echo 환경이 성공적으로 생성되었습니다!
    echo 환경을 활성화하려면 다음 명령어를 실행하세요:
    echo   conda activate pyone-t5
) else (
    echo conda가 설치되어 있지 않습니다.
    echo conda를 먼저 설치한 후 이 스크립트를 다시 실행하세요.
    echo conda 설치 방법: https://docs.conda.io/en/latest/miniconda.html
    goto :exit_script
)

echo.
echo 초기화가 완료되었습니다!
goto :eof

:exit_script
echo.
echo 스크립트를 종료합니다.
exit /b 1
