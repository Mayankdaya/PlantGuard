# Simple Render CLI Login Script
$RenderCLI = ".\render_cli\cli_v1.1.0.exe"

if (-not (Test-Path $RenderCLI)) {
    Write-Host "Render CLI not found at: $RenderCLI" -ForegroundColor Red
    exit 1
}

Write-Host "Logging in to Render..." -ForegroundColor Cyan
& $RenderCLI login
Write-Host "Login completed!" -ForegroundColor Green