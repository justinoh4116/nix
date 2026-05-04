#!/usr/bin/env nu

def main [...files: string] {
    if ($files | is-empty) {
        error make {
            msg: "expected at least one file path"
        }
    }

    let ripdrag = (which ripdrag | get 0.path)
    let expanded_files = ($files | each {|file| $file | path expand })

    ^daemonize $ripdrag -Ax ...$expanded_files
    sleep 250ms
    ^piri sticky add
}
