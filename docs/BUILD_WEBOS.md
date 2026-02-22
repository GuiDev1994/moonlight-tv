# Build para LG webOS (LG C1 e compatíveis)

Este guia descreve como compilar o Moonlight TV para TVs LG com webOS, incluindo a **LG C1** (webOS 6.x) e outros modelos compatíveis.

## Compatibilidade LG C1

A LG C1 utiliza:
- **webOS 6.x** – suporta NDL, SMP, H.265 e HDR
- **Arquitetura ARM** – usa o toolchain `arm-webos-linux-gnueabi`

## Pré-requisitos

O build é feito via **cross-compilation** e exige ambiente **Linux** (ou WSL2 no Windows):

### Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install -y cmake gawk curl git build-essential
```

### Windows

**Opção A – Docker (recomendado se Docker Desktop estiver instalado):**

1. Inicie o Docker Desktop
2. No PowerShell, execute:
   ```powershell
   .\scripts\webos\build_with_docker.ps1
   ```

**Opção B – WSL2 com Ubuntu:**

1. Instale o WSL2 com Ubuntu: `wsl --install -d Ubuntu`
2. Abra o Ubuntu e instale as dependências: `sudo apt-get install cmake gawk curl git build-essential`
3. Execute: `./scripts/webos/build_for_lg.sh`

## Build rápido (automático)

O script `build_for_lg.sh` faz o download do SDK, configura o ambiente e compila:

```bash
# No Linux ou WSL (Ubuntu)
cd moonlight-tv
chmod +x scripts/webos/build_for_lg.sh
./scripts/webos/build_for_lg.sh
```

O pacote `.ipk` será gerado em `dist/`.

## Build manual

### 1. WebOS SDK

Baixe o SDK [buildroot-nc4](https://github.com/openlgtv/buildroot-nc4/releases) (tag `webos-b17b4cc`):

```bash
cd /tmp
curl -L -O https://github.com/openlgtv/buildroot-nc4/releases/download/webos-b17b4cc/arm-webos-linux-gnueabi_sdk-buildroot.tar.gz
tar -xzf arm-webos-linux-gnueabi_sdk-buildroot.tar.gz
./arm-webos-linux-gnueabi_sdk-buildroot/relocate-sdk.sh
```

### 2. Submodules

```bash
git submodule update --init --recursive
```

### 3. Configurar e compilar

```bash
export TOOLCHAIN_FILE=/tmp/arm-webos-linux-gnueabi_sdk-buildroot/share/buildroot/toolchainfile.cmake
./scripts/webos/easy_build.sh -DCMAKE_BUILD_TYPE=Release
```

### 4. Build em modo Release (recomendado para uso final)

```bash
CMAKE_BUILD_TYPE=Release ./scripts/webos/build_for_lg.sh
```

## Saída do build

O resultado será um pacote `.ipk` em `dist/`, por exemplo:

```
dist/com.limelight.webos_X.X.X_arm.ipk
```

## Instalação na LG C1

### Opção 1: webosbrew dev-manager (recomendado)

1. Instale o [webosbrew](https://webosbrew.org/) na TV
2. Instale o [dev-manager-desktop](https://github.com/webosbrew/dev-manager-desktop)
3. Conecte a TV e instale o `.ipk` via interface gráfica

### Opção 2: ares-cli

1. Instale o `ares-package` (webosbrew)
2. Conecte a TV na mesma rede
3. Execute:

```bash
ares-setup-device
ares-install dist/com.limelight.webos_*.ipk -d <NOME_DA_TV>
ares-launch com.limelight.webos -d <NOME_DA_TV>
```

## Resolução de problemas

### "TOOLCHAIN_FILE not found"

Defina o caminho correto do SDK:

```bash
export WEBOS_SDK_DIR=/caminho/para/arm-webos-linux-gnueabi_sdk-buildroot
./scripts/webos/build_for_lg.sh
```

### SDK em local customizado

```bash
# Instalar em /opt (padrão do easy_build)
sudo mv /tmp/arm-webos-linux-gnueabi_sdk-buildroot /opt/
export TOOLCHAIN_FILE=/opt/arm-webos-linux-gnueabi_sdk-buildroot/share/buildroot/toolchainfile.cmake
./scripts/webos/easy_build.sh -DCMAKE_BUILD_TYPE=Release
```

### Erro de dependências no CMake

O SDK buildroot-nc4 já inclui as bibliotecas necessárias (pbnjson_c, PmLogLib, webosi18n, etc.). Se faltar algo, confira a instalação do SDK.
