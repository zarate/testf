#!/bin/bash
haxe preprocess.hxml
haxelib run xcross bin/preprocess.n
rm bin/preprocess.n