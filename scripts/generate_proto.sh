#!/bin/bash
# Generate Go protobuf files

set -e

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PROTO_DIR="./metroproto"
OUT_DIR="./proto"

if [ ! -f "$PROTO_DIR/listentogether.proto" ]; then
    echo "Proto file missing at $PROTO_DIR, cloning from repository..."
    rm -rf "$PROTO_DIR"
    git clone --depth 1 https://github.com/marki19/metroproto.git "$PROTO_DIR"
fi

if [ ! -f "$PROTO_DIR/listentogether.proto" ]; then
    echo "Missing proto file at $PROTO_DIR/listentogether.proto"
    echo "Did you initialize submodules? Try: git submodule update --init --recursive"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Generate Go code
protoc --go_out="$OUT_DIR" --go_opt=paths=source_relative \
    -I="$PROTO_DIR" \
    "$PROTO_DIR/listentogether.proto"

echo "Protobuf files generated successfully in $OUT_DIR"
