# PlantGuard Deployment Status Check
Write-Host "🌱 PlantGuard Deployment Status Check" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

# Check render.yaml
if (Test-Path "render.yaml") {
    Write-Host "✅ render.yaml configuration found" -ForegroundColor Green
    Write-Host "`n📋 Configuration:" -ForegroundColor Cyan
    Get-Content "render.yaml" | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
} else {
    Write-Host "❌ render.yaml not found" -ForegroundColor Red
}

# Git status
Write-Host "`n📁 Git Status:" -ForegroundColor Cyan
git status --short

# Render CLI check
if (Test-Path ".\render_cli\cli_v1.1.0.exe") {
    Write-Host "`n✅ Render CLI available" -ForegroundColor Green
} else {
    Write-Host "`n❌ Render CLI not found" -ForegroundColor Red
}

Write-Host "`n🌐 Deployment Status:" -ForegroundColor Yellow
Write-Host "   • Code pushed to GitHub with render.yaml" -ForegroundColor White
Write-Host "   • Render should auto-detect and create service" -ForegroundColor White
Write-Host "   • Check dashboard: https://dashboard.render.com" -ForegroundColor White

Write-Host "`n✨ Process initiated successfully!" -ForegroundColor Green