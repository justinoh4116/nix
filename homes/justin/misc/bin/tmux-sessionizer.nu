#!/usr/bin/env nu

const DEFAULT_SEARCH_CATEGORIES = [
    "projects"
    "nix"
    "school"
    "notes"
]

def usage [] {
    print --stderr "usage: tmux-sessionizer [-c category] [path]"
}

def search-dir-categories [] {
    let home = $env.HOME

    {
        projects: [
            {
                path: ($home | path join "safe" "repos")
                depth: 1
            }
        ]
        nix: [
            {
                path: ($home | path join "safe" "nix")
                depth: 0
            }
        ]
        school: [
            {
                path: ($home | path join "safe" "nextcloud" "school")
                depth: 2
            }
        ]
        notes: [
            {
                path: ($home | path join "safe" "nextcloud" "documents" "notes")
                depth: 1
            }
        ]
    }
}

def set-search-dirs [selected_category?: string] {
    let categories = (search-dir-categories)
    let available_categories = ($categories | columns | sort)

    if $selected_category != null and not ($available_categories | any { |category| $category == $selected_category }) {
        print --stderr $"tmux-sessionizer: unknown category: ($selected_category)"
        print --stderr $"available categories: ($available_categories | str join ' ')"
        exit 1
    }

    let chosen_categories = if $selected_category == null {
        $DEFAULT_SEARCH_CATEGORIES
    } else {
        [$selected_category]
    }

    $chosen_categories
    | each { |category| $categories | get $category }
    | flatten
}

def build-candidates [search_dirs: list] {
    $search_dirs
    | each { |entry|
        let dir = $entry.path
        let depth = $entry.depth

        if not ($dir | path exists) {
            []
        } else if $depth == 0 {
            [$dir]
        } else {
            ^fd "." $dir --type directory --min-depth "1" --max-depth ($depth | into string) --full-path
            | lines
            | where { |path| $path != "" }
        }
    }
    | flatten
}

def display-path [target: string] {
    let home = $env.HOME

    if $target == $home {
        "~"
    } else if ($target | str starts-with $"($home)/") {
        $target | str replace $"($home)/" ""
    } else {
        $target
    }
}

def pick-path [search_dirs: list] {
    if ($search_dirs | is-empty) {
        print --stderr "tmux-sessionizer: add path/depth pairs to configured categories in tmux-sessionizer"
        exit 1
    }

    let selected = (
        build-candidates $search_dirs
        | sort
        | uniq
        | each { |target|
            let display = (display-path $target)
            $"($display)\t($target)"
        }
        | str join (char newline)
        | ^sk --delimiter "\t" --with-nth "1"
        | str trim
    )

    if $selected == "" {
        ""
    } else {
        $selected
        | split row "\t"
        | skip 1
        | str join "\t"
    }
}

def session-name [target: string] {
    let parent = ($target | path dirname | path basename)
    let child = ($target | path basename)

    if $parent == "" or $parent == $child {
        $child
    } else {
        [$parent $child] | str join "_"
    }
    | str replace --all "." "_"
    | str replace --all ":" "_"
    | str replace --all " " "_"
}

def main [
    path?: string
    --category(-c): string
    --help(-h)
] {
    if $help {
        usage
        return
    }

    let active_search_dirs = (set-search-dirs $category)
    let selected = if $path == null {
        pick-path $active_search_dirs
    } else {
        $path
    }

    if $selected == "" {
        exit 0
    }

    let selected_name = (session-name $selected)
    let has_session = ((^tmux has-session -t $selected_name | complete).exit_code == 0)

    if not $has_session {
        ^tmux new-session -ds $selected_name -c $selected | complete | ignore
        ^tmux select-window -t $"($selected_name):1" | complete | ignore
    }

    if (($env.TMUX? | default "") != "") {
        ^tmux switch-client -t $selected_name | complete | ignore
    } else {
        ^tmux attach-session -t $selected_name | complete | ignore
    }
}
