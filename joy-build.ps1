# ESP32 构建脚本 - PowerShell 版本
# 使用方法: .\joy-build.ps1 [COM端口]
# 示例: .\joy-build.ps1 COM3

param(
    [string]$Port = "COM3"
)

$cachePath = "D:\idfcache"
if (-not (Test-Path $cachePath)) {
    New-Item -ItemType Directory -Path $cachePath -Force | Out-Null
    Write-Host "Created cache directory: $cachePath" -ForegroundColor Cyan
}
$env:IDF_COMPONENT_CACHE_PATH = $cachePath

Write-Host "start build..." -ForegroundColor Green

Write-Host "`n[1/3] clean build..." -ForegroundColor Yellow
idf.py fullclean
rm -Force -Recurse build
if ($LASTEXITCODE -ne 0) {
    Write-Host "clean build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n[2/3] build esp32s3..." -ForegroundColor Yellow
idf.py set-target esp32s3
if ($LASTEXITCODE -ne 0) {
    Write-Host "set target failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n[3/3] flash (port: $Port)..." -ForegroundColor Yellow
idf.py build flash monitor -p $Port
if ($LASTEXITCODE -ne 0) {
    Write-Host "flash failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`nfinished!" -ForegroundColor Green
