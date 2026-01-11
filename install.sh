#!/usr/bin/env sh

echo "installing cat-cr to ~/.local/bin/cat"
cp build/cat ../.local/cat

echo "cat-cr is now installed!"
echo "to avoid name clashes, rename '/usr/bin/cat' to '/usr/bin/gcat', or whatever you'd like"
echo "run 'cat install.sh' to test!"
