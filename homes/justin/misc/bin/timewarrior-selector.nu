#!/usr/bin/env nu

const SCRIPT_DIR = (path self | path dirname)
const CATEGORIES = [
    "class"
    "working"
    "workflow"
    "wasting"
    "stop"
    "reading"
]
const BLOCKED_HOSTS = [
    "studio.youtube.com"
    "www.youtube.com"
    "www.reddit.com"
    "www.x.com"
    "www.linkedin.com"
    "www.privatemail.com"
]

def --wrapped run-quiet [program: string, ...args: string] {
    run-external $program ...$args | complete | ignore
}

def status-file [] {
    $env.HOME | path join ".time"
}

def write-status [status: string] {
    $status | save --force (status-file)
}

def get-skim-theme-args [] {
    let theme_script = ($SCRIPT_DIR | path join "skim-themes.sh")

    if not ($theme_script | path exists) {
        []
    } else {
        # Keep compatibility with an adjacent bash theme file if you add one later.
        let result = (
            with-env { THEME_SCRIPT: $theme_script } {
                ^bash -lc 'source "$THEME_SCRIPT"; printf "%s\0" "${SKIM_THEME_BASE[@]}"'
            }
            | complete
        )

        if $result.exit_code != 0 {
            []
        } else {
            $result.stdout
            | split row (char nul)
            | where { |arg| $arg != "" }
        }
    }
}

def pick-category [] {
    let skim_theme_args = (get-skim-theme-args)
    let result = (
        do {
            $CATEGORIES
            | str join (char newline)
            | ^sk ...$skim_theme_args --bind "q:abort"
            # | ^sk  --bind "q:abort" #| complete
        }
    )
  $result
}

def main [] {
    let selected = (pick-category)

    if (($selected | str trim) == "") {
        exit 0
    }

    run-quiet tmux set -g status-interval 30

    if $selected == "stop" {
        run-quiet timew stop
        write-status "stopped"
        run-quiet tmux set -g status-right ""
    } else {
        run-quiet timew start $selected
        write-status $selected

        let status_right = ($selected + ' #(timew | awk "/^ *Total/ {print \$NF}")')
        run-quiet tmux set -g status-right $status_right

        if $selected == "wasting" {
            for host in $BLOCKED_HOSTS {
                run-quiet hostess rm $host
            }
        } else {
            for host in $BLOCKED_HOSTS {
                run-quiet hostess add $host "127.0.0.1"
            }
        }
    }
}

