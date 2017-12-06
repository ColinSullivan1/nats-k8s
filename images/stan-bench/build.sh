#!/bin/sh

cd "$(dirname ${BASH_SOURCE[0]})"

docker build -t stan-bench .
