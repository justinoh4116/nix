#!/usr/bin/env nu

const REPO_ROOT = ("~/safe/nix" | path expand)

def backup-suffix [] {
    date now | format date "%Y%m%d-%H%M%S"
}

def ensure-link [source: string, destination: string] {
    let source = ($source | path expand)
    let destination = ($destination | path expand)
    let parent = ($destination | path dirname)

    if not ($source | path exists) {
        error make {msg: $"Source path does not exist: ($source)"}
    }

    ^mkdir -p $parent

    if ($destination | path exists) and (($destination | path type) != "symlink") {
        let backup = $"($destination).bak.(backup-suffix)"
        print $"Backing up ($destination) to ($backup)"
        ^mv $destination $backup
    }

    print $"Linking ($destination) -> ($source)"
    ^ln -sfnT $source $destination
}

def main [] {
    ensure-link (
        $REPO_ROOT
        | path join "homes" "justin" "programs" "graphical" "desktop" "shells" "fufexan"
    ) "~/.config/quickshell"

    ensure-link (
        $REPO_ROOT
        | path join "homes" "justin" "programs" "nvim" "dots"
    ) "~/.config/nvim"
}
