def create_left_prompt [] {
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let ndir = $dir | split row "/" | last 2 | str join "/"

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi green_bold } else { ansi red_bold })
    let path_segment = $"($path_color)($ndir)(ansi reset)"

    let final_path_segment = $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"

    let git_symbolic_ref_info = (git symbolic-ref HEAD | complete)
    if ($git_symbolic_ref_info.exit_code != 0) {
        $final_path_segment
    } else {
        let git_branch = $git_symbolic_ref_info.stdout | str trim | split row "/" | last 1 | get 0
        $"($git_branch) ($final_path_segment)"
    }

}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%X') # try to respect user's locale
        # (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

$env.EDITOR = "nvim"

$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

if $nu.os-info.name == "windows" {
    $env.HOME = $nu.home-path
}

$env.CARGO_HOME = ( $env.HOME | path join ".cargo")

use std "path add"
$env.PATH = ($env.PATH | split row (char esep))
path add ($env.CARGO_HOME | path join "bin")
path add ($env.HOME | path join ".local/bin")
path add ($env.HOME | path join ".bin")
path add ($env.HOME | path join ".fzf/bin")
path add ($env.HOME | path join ".local/share/nvim/mason/bin")
# $env.PATH = ($env.PATH | uniq)

$env.CARAPACE_BRIDGES = 'zsh'
if not ("~/.cache/carapace" | path exists) {
    mkdir ~/.cache/carapace
    carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
}
