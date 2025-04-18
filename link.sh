#!/usr/bin/env bash
rm "$1"
mkdir -p "$(dirname "$1")"
ln -s "$PWD/$2" "$1"
