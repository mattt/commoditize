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

<img width="1118" alt="Example disk image mounted with commoditize on macOS Big Sur" src="https://user-images.githubusercontent.com/7659/118305159-71ad1b00-b49c-11eb-9280-bb16011229e5.png">


## License

MIT

## Contact

Mattt ([@mattt](https://twitter.com/mattt))

[`mdls`]: https://www.unix.com/man-page/osx/1/mdls/
