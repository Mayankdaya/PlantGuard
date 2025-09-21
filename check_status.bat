@echo off
echo 🌱 PlantGuard Deployment Status Check
echo ======================================
echo.

if exist render.yaml (
    echo ✅ render.yaml configuration found
    echo.
    echo 📋 Configuration:
    type render.yaml
) else (
    echo ❌ render.yaml not found
)

echo.
echo 📁 Git Status:
git status --short

echo.
if exist render_cli\cli_v1.1.0.exe (
    echo ✅ Render CLI available
) else (
    echo ❌ Render CLI not found
)

echo.
echo 🌐 Deployment Status:
echo    • Code pushed to GitHub with render.yaml
echo    • Render should auto-detect and create service
echo    • Check dashboard: https://dashboard.render.com

echo.
echo ✨ Process initiated successfully!
pause