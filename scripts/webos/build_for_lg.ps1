# Build Moonlight TV para LG webOS (LG C1) - PowerShell launcher para WSL
# Execute este script no Windows para compilar via WSL

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

Write-Host "=== Moonlight TV - Build para LG C1 (webOS) ===" -ForegroundColor Cyan
Write-Host ""

# Verificar WSL
$wslTest = wsl -e bash -c "echo ok" 2>$null
if ($LASTEXITCODE -ne 0 -or $wslTest -ne "ok") {
    Write-Host "ERRO: WSL nao encontrado ou nao configurado." -ForegroundColor Red
    Write-Host ""
    Write-Host "Para instalar o WSL com Ubuntu:" -ForegroundColor Yellow
    Write-Host "  wsl --install -d Ubuntu" -ForegroundColor White
    Write-Host ""
    Write-Host "Apos instalar, reinicie o computador e execute este script novamente." -ForegroundColor Yellow
    exit 1
}

# Converter caminho Windows para WSL
$WslPath = wsl -e wslpath -a $ProjectRoot

Write-Host "Projeto: $ProjectRoot" -ForegroundColor Gray
Write-Host "Caminho WSL: $WslPath" -ForegroundColor Gray
Write-Host ""

Write-Host "Iniciando build no WSL (Ubuntu)..." -ForegroundColor Green
Write-Host ""

wsl -e bash -c @"
set -e
cd '$WslPath'
chmod +x scripts/webos/build_for_lg.sh
./scripts/webos/build_for_lg.sh
"@

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Build concluido com sucesso! ===" -ForegroundColor Green
    Write-Host "Pacote IPK em: $ProjectRoot\dist\" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "Build falhou. Verifique os erros acima." -ForegroundColor Red
    exit 1
}
