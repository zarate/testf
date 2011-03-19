#!/bin/bash
haxe src/release.hxml
haxelib run xcross release.n
rm release.n
mv release-* bin/