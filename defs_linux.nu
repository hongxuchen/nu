# fzf through shell history, typing result.
# Requires `xdotool`.
def fzf-history [
    --query (-q): string # Optionally start with given query.
] {
    let cmd = (history | reverse | reduce { |it, acc| $acc + (char nl) + $it } | fzf --prompt "HISTORY> " --query $"($query)")
    xdotool type $cmd
}
