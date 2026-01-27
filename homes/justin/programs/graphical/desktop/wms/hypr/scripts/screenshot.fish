#! /usr/bin/env fish

mkdir -p ~/safe/pictures/screenshots/$(date +%Y-%m) && set IMG ~/safe/pictures/screenshots/$(date +%Y-%m)/$(date +%Y-%m-%d_%H-%M-%s).png && grim -g "$(slurp)" $IMG && wl-copy < $IMG
