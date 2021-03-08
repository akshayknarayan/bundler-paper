#!/bin/bash

set -x

mkdir -p ./graphs/data
cd ./graphs/data
python3 fetch-data.py
cd ../..
