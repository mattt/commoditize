# commoditize

A command-line utility for macOS that mounts a Docker container image 
as an external disk image.

## Requirements

- macOS 10.0+
- skopeo

## Installation

```terminal
$ git clone https://github.com/mattt/commoditize.git
$ cd commoditize
$ brew bundle
$ make install
```

## Usage

```terminal
$ commoditize docker://ghcr.io/homebrew/core/syncthing:1.16.1
```

## License

MIT

## Contact

Mattt ([@mattt](https://twitter.com/mattt))

[`mdls`]: https://www.unix.com/man-page/osx/1/mdls/
