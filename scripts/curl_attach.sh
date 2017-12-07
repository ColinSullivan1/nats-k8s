#!/bin/sh

kubectl attach $1 -c curl -i -t
