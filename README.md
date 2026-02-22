# Moonlight TV

Moonlight TV is a community version of [Moonlight GameStream Client](https://moonlight-stream.org/), made for large
screens. It works on LG webOS powered TVs, and Raspberry Pi running Raspbian.

![Download Stats](https://img.shields.io/github/downloads/mariotaku/moonlight-tv/total)

## Features

* High performance streaming for webOS
* UI optimized for large screen and remote controller
* Supports up to 4 controllers
* Easy to port to other OSes (Now runs on macOS, Arch, Debian, Raspbian and Windows)

## Screenshots

![Launcher](https://user-images.githubusercontent.com/830358/141690137-529d3b94-b56a-4f24-a3c5-00a56eb30952.png)

![Settings](https://user-images.githubusercontent.com/830358/147389849-6907f614-dbd4-4c24-987e-1a214a9680d0.png)

![In-game Overlay](https://user-images.githubusercontent.com/830358/141690146-27ee2564-0cc8-43ef-a5b0-54b8487dda1e.png)
_Screenshot performed on TV has lower picture quality. Actual picture quality is better._

## Download

### For webOS

[Easy installation with dev-manager-desktop](https://github.com/webosbrew/dev-manager-desktop) (recommended)

Or download IPK from [Latest release](https://github.com/mariotaku/moonlight-tv/releases/latest)

### For Raspbian

Download DEB from [Latest release](https://github.com/mariotaku/moonlight-tv/releases/latest)

## Building from Source

### For LG webOS (LG C1, etc.)

See [docs/BUILD_WEBOS.md](docs/BUILD_WEBOS.md) for detailed instructions. Quick start:

- **Windows (Docker):** `.\scripts\webos\build_with_docker.ps1`
- **Linux/WSL:** `./scripts/webos/build_for_lg.sh`

## [Documentations](https://github.com/mariotaku/moonlight-tv/wiki)

## Credits

* [moonlight-embedded](https://github.com/irtimmer/moonlight-embedded), for original libgamestream and decoder
  components