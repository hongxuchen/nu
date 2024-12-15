def "cargo search" [ query: string, --limit=10] {
    ^cargo search $query --limit $limit --registry crates-io
    | lines
    | each {
        |line| if ($line | str contains "#") {
            $line | parse --regex '(?P<name>.+) = "(?P<version>.+)" +# (?P<description>.+)'
        } else {
            $line | parse --regex '(?P<name>.+) = "(?P<version>.+)"'
        }
    }
    | flatten
}

export def kill-all [name: string] {
  ps | where name == $name | get pid | each { |it| kill -9 $it }
}

export def exec-async [commands: string] {
    sh -c $"nu -c '($commands)' &"
}

export def --env gcd [] {
    let in_dotgit_dir_info = git rev-parse --is-inside-git-dir | complete
    if (($in_dotgit_dir_info.stdout | str trim) == "true") {
        let dotgit_dir = realpath (git rev-parse --git-dir)
        cd (dirname $dotgit_dir)
    }
    let git_root_dir_info = (git rev-parse --show-toplevel | complete)
    if ($git_root_dir_info.exit_code != 0) {
        let errmsg = $git_root_dir_info.stderr | str trim
        if ($errmsg | str contains "not a git repository") {
            print $"not in git: ($env.PWD)"
        } else {
            print $"??? ($errmsg)"
        }
    } else {
        cd ($git_root_dir_info.stdout | str trim)
    }

}
