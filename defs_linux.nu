# fzf through shell history, typing result.
# Requires `xdotool`.
export def fzf-history [ --query (-q): string ] {
    let cmd = (history | reverse | reduce { |it, acc| $acc + (char nl) + $it } | fzf --prompt "HISTORY> " --query $"($query)")
    xdotool type $cmd
}
