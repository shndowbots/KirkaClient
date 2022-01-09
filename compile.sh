#!/bin/bash

# Requires: npm i -g bytenode

# Encode.
for jsfile in $(find . -type f -wholename './src/*.js' -not -wholename './src/scripts/*' -not -wholename './src/windows/*'); do
        echo "==> $jsfile"
        bytenode -c -e "$jsfile"
        file=${jsfile##*/}
        file=${file::-3}
        if [[ "$jsfile" == *"src/features"* ]] then
                printf "require('bytenode');\nmodule.exports = require('./${file}.jsc');" > $jsfile
        else
                printf "require('bytenode');\nrequire('./${file}.jsc');" > $jsfile
        fi
done

# Build.
npm start

# Remove junk.
find . -type f -name '*.jsc' -delete

# Revert files back to what they were
for jsfile in $(find . -type f -wholename './src/*.js' -not -wholename './src/scripts/*' -not -wholename './src/windows/*'); do
        echo "==> $jsfile"
        git checkout $jsfile
done