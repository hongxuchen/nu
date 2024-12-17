export def history_in_pwd [] {
  let history_ = (history | where cwd == $env.PWD | get command | uniq | reverse | to text | fzf)
  xdotool type $history_
}
alias hh = history_in_pwd
