#!/bin/bash

coffee -o ./js -c ./lib/*.coffee
mv ./js/index.js ./
