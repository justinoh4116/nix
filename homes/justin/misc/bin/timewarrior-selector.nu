#!/usr/bin/env nu

const SCRIPT_DIR = (path self | path dirname)
const CATEGORIES = [
    "WORK"
    "VIM"
    "WASTE"
    "STOP"
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
        do -i {
            $CATEGORIES
            | str join (char newline)
            | ^sk ...$skim_theme_args --bind "q:abort"
        }
        | complete
    )

    if $result.exit_code != 0 {
        ""
    } else {
        $result.stdout | str trim
    }
}

def main [] {
    let selected = (pick-category)

    if (($selected | str trim) == "") {
        exit 0
    }

    run-quiet tmux set -g status-interval 5

    if $selected == "STOP" {
        run-quiet timew stop
        run-quiet tmux set -g status-right ""
    } else {
        run-quiet timew start $selected

        let status_right = ($selected + ' #(timew | awk "/^ *Total/ {print \$NF}")')
        run-quiet tmux set -g status-right $status_right

        if $selected == "WASTE" {
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
