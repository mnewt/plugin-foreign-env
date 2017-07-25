# Foreign Environment
> A foreign environment interface for Fish shell

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v2.2.0-007EC7.svg?style=flat-square)](http://fishshell.com)

# This is a fork of the original

Some changes have been made since the original was last updated. Please see the [Change log](CHANGELOG.md)

Foreign environment wraps application execution in a way that environment variables and aliases that are exported or modified get imported back into fish. This makes possible running popular bash scripts, like the excellent `nvm`.


# Install

## Using [Oh My Fish][omf-link]:

```fish
omf install mnewt/foreign-env
```

## Using [Fisherman][fisherman-link]:

```fish
fisher mnewt/foreign-env
```

## No framework

If you dislike shell frameworks, you can still use Foreign Environment in Fish! Clone this repo somewhere and append to your `~/.config/fish/config.fish`:

```fish
set fish_function_path $fish_function_path <insert path to foreign-env repo>/functions
```


# Usage examples

You can use bash syntax to export variables:

```fish
fenv export PYTHON=python2
```

This will have the same effect as typing:

```fish
set -g -x PYTHON python2
```

You can also call multiple commands, separated by semicolon:

```fish
fenv source ~/.nvm/nvm.sh \; nvm --help
```

When commands aren't double quoted, you need to escape semicolon with slash `\;` to prevent fish from interpreting it. Or just quote the whole command:

```fish
fenv "source ~/.nvm/nvm.sh; nvm --help"
```

# Command line options

```fish
usage: fenv [-htv] <bash command>
   -h: Help    - Print this help message
   -t: Test    - Print the variables and aliases that would be created, but make no changes
   -v: Verbose - Print the variables and aliases that are created (-d also works)
```

# To Do

There are some more features I would like to add in the [TODO](TODO.md) file.

# License

[MIT][mit] © Original author [Derek Willian Stavis][author]

[mit]:            http://opensource.org/licenses/MIT
[author]:         http://github.com/derekstavis
[omf-link]:       https://www.github.com/oh-my-fish/oh-my-fish
[fisherman-link]: https://github.com/fisherman/fisherman
