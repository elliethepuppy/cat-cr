# cat-cr

`cat-cr` is a crystal reimplementation of the standard GNU `cat` utility. it's still a work in progress, but it functions in exactly the way any average user would probably expect (just spitting out the text of a file)

## Installation

installation requires the crystal compiler

``` sh
git clone https://github.com/elliethepuppy/cat-cr.git && cd cat-cr
```

``` sh
mkdir build && crystal build src/cat-cr.cr -o build/[whatever you'd like to call it] --release --no-debug
```

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

- [ellie :3](https://github.com/your-github-user) - creator and maintainer
