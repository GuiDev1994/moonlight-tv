#!/usr/bin/env bash
# Build Moonlight TV for LG webOS (compatível com LG C1 e outras TVs webOS)
# Requer: Linux ou WSL2 com Ubuntu

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SDK_VERSION="webos-b17b4cc"
SDK_ARCHIVE="arm-webos-linux-gnueabi_sdk-buildroot.tar.gz"
SDK_URL="https://github.com/openlgtv/buildroot-nc4/releases/download/${SDK_VERSION}/${SDK_ARCHIVE}"
BUILD_TYPE="${CMAKE_BUILD_TYPE:-Release}"
SDK_DIR="${WEBOS_SDK_DIR:-/tmp/arm-webos-linux-gnueabi_sdk-buildroot}"

cd "${PROJECT_ROOT}"

echo "=== Moonlight TV - Build para LG webOS (LG C1, etc.) ==="
echo "Projeto: ${PROJECT_ROOT}"
echo "Build type: ${BUILD_TYPE}"
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "scripts/webos/easy_build.sh" ]; then
    echo "Erro: Execute este script na raiz do projeto moonlight-tv"
    exit 1
fi

# Verificar dependências
for cmd in cmake awk gawk; do
    if ! command -v $cmd &>/dev/null; then
        echo "Erro: $cmd não encontrado. Instale com: sudo apt-get install cmake gawk"
        exit 1
    fi
done

# Inicializar submodules
echo "Atualizando submodules..."
git submodule update --init --recursive

# Baixar e configurar webOS SDK se não existir
if [ ! -f "${SDK_DIR}/share/buildroot/toolchainfile.cmake" ]; then
    echo ""
    echo "WebOS SDK não encontrado em ${SDK_DIR}"
    echo "Baixando SDK (buildroot-nc4 ${SDK_VERSION})..."
    
    mkdir -p /tmp
    cd /tmp
    
    if [ ! -f "${SDK_ARCHIVE}" ]; then
        if command -v curl &>/dev/null; then
            curl -L -O "${SDK_URL}"
        elif command -v wget &>/dev/null; then
            wget "${SDK_URL}"
        else
            echo "Erro: curl ou wget necessário para baixar o SDK"
            exit 1
        fi
    fi
    
    echo "Extraindo SDK..."
    tar -xzf "${SDK_ARCHIVE}"
    
    if [ -d "arm-webos-linux-gnueabi_sdk-buildroot" ]; then
        echo "Relocando SDK..."
        ./arm-webos-linux-gnueabi_sdk-buildroot/relocate-sdk.sh
        SDK_DIR="/tmp/arm-webos-linux-gnueabi_sdk-buildroot"
    else
        echo "Erro: Estrutura do SDK inesperada após extração"
        exit 1
    fi
    
    cd "${PROJECT_ROOT}"
else
    echo "WebOS SDK encontrado em ${SDK_DIR}"
fi

TOOLCHAIN_FILE="${SDK_DIR}/share/buildroot/toolchainfile.cmake"

if [ ! -f "${TOOLCHAIN_FILE}" ]; then
    echo "Erro: Toolchain não encontrado em ${TOOLCHAIN_FILE}"
    exit 1
fi

echo ""
echo "Executando build..."
export TOOLCHAIN_FILE
./scripts/webos/easy_build.sh -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"

echo ""
echo "=== Build concluído! ==="
echo "Pacote IPK gerado em: ${PROJECT_ROOT}/dist/"
ls -la "${PROJECT_ROOT}/dist/"/*.ipk 2>/dev/null || true
echo ""
echo "Para instalar na LG C1:"
echo "  1. Instale o webosbrew e dev-manager na TV"
echo "  2. Use: ares-install dist/com.limelight.webos_*_arm.ipk -d <IP_DA_TV>"
echo "  Ou use o dev-manager-desktop para instalação fácil"
echo ""
