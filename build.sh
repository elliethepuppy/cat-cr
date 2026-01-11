#!/usr/bin/bash

crystal build src/cat-cr.cr -o build/cat --release --no-debug --warnings all --error-on-warnings
