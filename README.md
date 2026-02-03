# pather

Path manipulation tool inspired by Zsh parameter expansion modifiers.

Instead of chaining `dirname`, `basename`, and `realpath`, you can do:

```sh
pather -ahh /path/to/file.txt     # grandparent directory
pather -at ../relative/path       # absolute basename
pather -r file.tar.gz             # strip extension
```

## Install

macOS:

```sh
brew tap mattmc3/tools
brew install pather
```

On other systems clone this repository and put the `pather` Lua script in your path.

## Usage

```sh
pather [-aAther] path [...]
```

Modifiers work like Zsh's `${var:a:h:t}` syntax:
- `-a` absolute path
- `-A` absolute + resolve symlinks
- `-t` tail (basename)
- `-h` head (dirname)
- `-e` extension only
- `-r` remove extension

## License

MIT
