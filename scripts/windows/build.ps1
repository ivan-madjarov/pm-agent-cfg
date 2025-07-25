# Windows build script

Write-Host "Building PM Agent for Windows..."

# Create build directory
New-Item -ItemType Directory -Force -Path "dist\windows"

# Build common components
Get-ChildItem "src\common\*.py" | ForEach-Object { python -m py_compile $_.FullName }

# Build Windows-specific components
Get-ChildItem "src\windows\*.py" | ForEach-Object { python -m py_compile $_.FullName }

# Copy configuration files
Copy-Item "config\windows\*" "dist\windows\" -Recurse -Force
Copy-Item "config\common\*" "dist\windows\" -Recurse -Force

Write-Host "Windows build completed successfully!"

