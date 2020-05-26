#!/bin/bash

set -e # Exit on any errors
set -x # Enable debugging

# Get the directory of this script
# https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get the name of the repository
# https://stackoverflow.com/questions/23162299/how-to-get-the-last-part-of-dirname-in-bash/23162553
REPO="$(dirname "$DIR")"
REPO="$(basename "$REPO")"

# Ensure that the ".env" file exists
if [[ ! -f "$DIR/../.env" ]]; then
  cp "$DIR/../.env_template" "$DIR/../.env"
fi

# Build the Golang files, which will automatically install the Golang dependencies
cd "$DIR/../src"
go build -o "$DIR/../$REPO"

# Install the JavaScript/TypeScript dependencies
cd "$DIR/../public/js"
npm install

# Build the client code
"$DIR/../build_client.sh"

echo "Successfully installed dependencies."
