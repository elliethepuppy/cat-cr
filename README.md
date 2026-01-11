# cat-cr

`cat-cr` is a crystal reimplementation of the standard unix `cat` utility. it's still a work in progress, but it functions in exactly the way any average user would probably expect (just spitting out the text of a file)

## Installation

installation requires the [crystal compiler](https://crystal-lang.org/install)

``` sh
git clone https://github.com/elliethepuppy/cat-cr.git && cd cat-cr
```

``` sh
sh build.sh && sh install.sh
```

optionally build manually:

``` sh
mkdir build && crystal build src/cat-cr.cr -o build/[whatever you'd like to call it] --release --no-debug --warnings all --error-on-warnings
```

then install manually:

``` sh
cp build/[name you chose] ~/.local/bin
```

if you chose to name it `cat`, you'll need to rename the system package to avoid clashing:

``` sh
sudo mv /usr/bin/cat /usr/bin/gcat
```

you don't have to use `gcat`. that's just what i do to denote "gnu cat" as opposed to my own when they are both in the `$PATH`

## Usage

example: `cat -E src/cat-cr.cr`

## Development

i need help with finding all the special characters that `cat` proper outputs with its `-v` flag, so if you could find those that would be cool.

## Contributing

1. Fork it (<https://github.com/elliethepuppy/cat-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [ellie :3](https://elliethepuppy.github.io) - creator and maintainer
