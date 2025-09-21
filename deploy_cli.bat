@echo off
REM PlantGuard CLI Deployment Tool for Windows
REM Deploy to multiple platforms using command line interface

setlocal enabledelayedexpansion

REM Colors (using ANSI escape codes if supported)
set "RED=[31m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "BLUE=[34m"
set "NC=[0m"

REM Functions equivalent in batch
:print_header
echo %BLUE%
echo 🌱 PlantGuard CLI Deployment Tool
echo ==================================
echo %NC%
goto :eof

:print_success
echo %GREEN%✅ %~1%NC%
goto :eof

:print_error
echo %RED%❌ %~1%NC%
goto :eof

:print_warning
echo %YELLOW%⚠️  %~1%NC%
goto :eof

:print_info
echo %BLUE%ℹ️  %~1%NC%
goto :eof

:check_dependencies
echo Checking dependencies...

REM Check if git is available
where git >nul 2>nul
if %errorlevel% equ 0 (
    call :print_success "Git is available"
) else (
    call :print_error "Git is not installed. Please install Git first."
    exit /b 1
)

REM Check if curl is available
where curl >nul 2>nul
if %errorlevel% equ 0 (
    call :print_success "Curl is available"
) else (
    call :print_warning "Curl is not available. Some features may not work."
)
goto :eof

:verify_deployment_files
echo Verifying deployment files...

REM Check if we're in the right directory
if not exist "render.yaml" (
    call :print_error "render.yaml not found. Please run this script from the PlantGuard root directory."
    exit /b 1
)

REM Check Flask Deployed App directory
if not exist "Flask Deployed App" (
    call :print_error "Flask Deployed App directory not found."
    exit /b 1
)

REM Check key files
set "required_files=Flask Deployed App\app.py Flask Deployed App\requirements.txt Flask Deployed App\CNN.py Flask Deployed App\plant_disease_model_1.pt"

for %%f in (%required_files%) do (
    if exist "%%f" (
        for %%A in ("%%f") do set "size=%%~zA"
        call :print_success "Found %%f (!size! bytes)"
    ) else (
        call :print_error "Missing %%f"
        exit /b 1
    )
)
goto :eof

:deploy_to_render
echo Deploying to Render...

REM Check if render CLI is available
where render >nul 2>nul
if %errorlevel% neq 0 (
    call :print_info "Render CLI not found. Please install it manually from: https://render.com/docs/cli"
    exit /b 1
)

REM Check if user is logged in to Render
render whoami >nul 2>nul
if %errorlevel% equ 0 (
    call :print_success "Logged in to Render"
) else (
    call :print_info "Please login to Render first:"
    echo render login
    exit /b 1
)

REM Create service using render.yaml
call :print_info "Creating Render service from render.yaml..."

REM Use render blueprint
render blueprint apply --file render.yaml
if %errorlevel% equ 0 (
    call :print_success "Render service created successfully!"
    call :print_info "Check your Render dashboard for the deployment status."
) else (
    call :print_error "Failed to create Render service"
    call :print_info "You can also deploy manually at: https://render.com"
    exit /b 1
)
goto :eof

:deploy_to_fly
echo Deploying to Fly.io...

REM Check if fly CLI is available
where fly >nul 2>nul
if %errorlevel% neq 0 (
    call :print_info "Fly CLI not found. Please install it manually from: https://fly.io/docs/hands-on/install-flyctl/"
    exit /b 1
)

REM Check if user is logged in to Fly
fly auth whoami >nul 2>nul
if %errorlevel% equ 0 (
    call :print_success "Logged in to Fly.io"
) else (
    call :print_info "Please login to Fly.io first:"
    echo fly auth login
    exit /b 1
)

REM Launch app
call :print_info "Launching Fly.io app..."

REM Use existing fly.toml
if exist "fly.toml" (
    call :print_info "Using existing fly.toml configuration"
    fly launch --now --copy-config
    if %errorlevel% equ 0 (
        call :print_success "Fly.io app launched successfully!"
    ) else (
        call :print_error "Failed to launch Fly.io app"
        exit /b 1
    )
) else (
    call :print_error "fly.toml not found. Please create it first."
    exit /b 1
)
goto :eof

:deploy_to_heroku
echo Deploying to Heroku...

REM Check if Heroku CLI is available
where heroku >nul 2>nul
if %errorlevel% neq 0 (
    call :print_info "Heroku CLI not found. Please install it manually from: https://devcenter.heroku.com/articles/heroku-cli"
    exit /b 1
)

REM Check if user is logged in to Heroku
heroku auth:whoami >nul 2>nul
if %errorlevel% equ 0 (
    call :print_success "Logged in to Heroku"
) else (
    call :print_info "Please login to Heroku first:"
    echo heroku login
    exit /b 1
)

REM Create Heroku app
call :print_info "Creating Heroku app..."

REM Generate unique app name
set "timestamp=%date:~-4,4%%date:~-10,2%%date:~-7,2%%time:~-11,2%%time:~-8,2%%time:~-5,2%"
set "app_name=plantguard-%timestamp%"

heroku create %app_name%
if %errorlevel% equ 0 (
    call :print_success "Heroku app created: %app_name%"
    
    REM Set buildpack
    heroku buildpacks:add heroku/python
    
    REM Deploy
    call :print_info "Deploying to Heroku..."
    git push heroku main
    if %errorlevel% equ 0 (
        call :print_success "Deployed to Heroku successfully!"
        echo App URL: https://%app_name%.herokuapp.com
    ) else (
        call :print_error "Failed to deploy to Heroku"
        exit /b 1
    )
) else (
    call :print_error "Failed to create Heroku app"
    exit /b 1
)
goto :eof

:show_help
echo PlantGuard CLI Deployment Tool
echo.
echo Usage: %0 [PLATFORM]
echo.
echo Platforms:
echo   render    Deploy to Render.com ^(recommended^)
echo   fly       Deploy to Fly.io
echo   heroku    Deploy to Heroku
echo   help      Show this help message
echo.
echo Examples:
echo   %0 render
echo   %0 fly
echo   %0 help
echo.
echo Prerequisites:
echo - Git repository with committed changes
echo - Account on chosen platform
echo - Platform CLI installed ^(will attempt auto-install^)
goto :eof

:main
    call :print_header
    
    REM Check if no arguments provided
    if "%1"=="" (
        echo Please specify a deployment platform:
        echo render, fly, heroku, or help
        exit /b 1
    )
    
    if /i "%1"=="render" (
        call :check_dependencies
        call :verify_deployment_files
        call :deploy_to_render
    ) else if /i "%1"=="fly" (
        call :check_dependencies
        call :verify_deployment_files
        call :deploy_to_fly
    ) else if /i "%1"=="heroku" (
        call :check_dependencies
        call :verify_deployment_files
        call :deploy_to_heroku
    ) else if /i "%1"=="help" (
        call :show_help
    ) else if /i "%1"=="-h" (
        call :show_help
    ) else if /i "%1"=="--help" (
        call :show_help
    ) else (
        call :print_error "Unknown platform: %1"
        echo Use 'help' to see available options
        exit /b 1
    )
    
    echo.
    call :print_success "Deployment process completed!"
    goto :eof

REM Run main function with all arguments
call :main %*