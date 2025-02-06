let keybindings = [
    {
        name: completion_menu
        modifier: none
        keycode: tab
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: menu name: completion_menu }
                { send: menunext }
            ]
        }
    }
    {
        name: help_menu
        modifier: none
        keycode: f1
        mode: [emacs, vi_insert, vi_normal]
        event: { send: menu name: help_menu }
    }
    {
        name: vars_menu
        modifier: none
        keycode: f2
        mode: [emacs, vi_insert, vi_normal]
        event: { send: menu name: vars_menu }
    }
    {
        name: fuzzy_module
        modifier: none
        keycode: f3
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: '
                commandline edit --replace "use "
                commandline edit --insert (
                    $env.NU_LIB_DIRS
                    | each {|dir|
                        ls ($dir | path join "**" "*.nu" | into glob)
                        | get name
                        | str replace $dir ""
                        | str trim -c "/"
                    }
                    | flatten
                    | input list --fuzzy
                        $"Please choose a (ansi magenta)module(ansi reset) to (ansi cyan_underline)load(ansi reset):"
                )
            '
        }
    }
    {
        name: completion_previous_menu
        modifier: shift
        keycode: backtab
        mode: [emacs, vi_normal, vi_insert]
        event: { send: menuprevious }
    }
    {
        name: next_page_menu
        modifier: control
        keycode: char_x
        mode: emacs
        event: { send: menupagenext }
    }
    {
        name: undo_or_previous_page_menu
        modifier: control
        keycode: char_z
        mode: emacs
        event: {
            until: [
                { send: menupageprevious }
                { edit: undo }
            ]
        }
    }
    {
        name: escape
        modifier: none
        keycode: escape
        mode: [emacs, vi_normal, vi_insert]
        event: { send: esc }    # NOTE: does not appear to work
    }
    {
        name: cancel_command
        modifier: control
        keycode: char_c
        mode: [emacs, vi_normal, vi_insert]
        event: { send: ctrlc }
    }
    {
        name: delete_one_character_forward
        modifier: control
        keycode: char_d
        mode: [emacs, vi_normal, vi_insert]
        event: {edit: delete}
    }
    {
        name: clear_screen
        modifier: control
        keycode: char_l
        mode: [emacs, vi_normal, vi_insert]
        event: { send: clearscreen }
    }
    {
        name: move_to_line_start
        modifier: control
        keycode: char_a
        mode: [emacs, vi_normal, vi_insert]
        event: {edit: movetolinestart}
    }
    {
        name: move_to_line_end_or_take_history_hint
        modifier: control
        keycode: char_e
        mode: [emacs, vi_normal, vi_insert]
        event: {
            until: [
                {send: historyhintcomplete}
                {edit: movetolineend}
            ]
        }
    }
    {
        name: move_up
        modifier: control
        keycode: char_p
        mode: [emacs, vi_normal, vi_insert]
        event: {
            until: [
                {send: menuup}
                {send: up}
            ]
        }
    }
    {
        name: move_down
        modifier: control
        keycode: char_n
        mode: [emacs, vi_normal, vi_insert]
        event: {
            until: [
                {send: menudown}
                {send: down}
            ]
        }
    }
    {
        name: delete_one_character_backward
        modifier: control
        keycode: char_h
        mode: [emacs, vi_insert]
        event: {edit: backspace}
    }
    # { # cutwordleft is enough
    #     name: delete_one_word_backward
    #     modifier: control
    #     keycode: char_w
    #     mode: [emacs, vi_insert]
    #     event: {edit: backspaceword}
    # }
    {
        name: move_left
        modifier: none
        keycode: backspace
        mode: vi_normal
        event: {edit: moveleft}
    }
    {
        name: newline_or_run_command
        modifier: none
        keycode: enter
        mode: emacs
        event: {send: enter}
    }
    {
        name: move_left
        modifier: control
        keycode: char_b
        mode: emacs
        event: {
            until: [
                {send: menuleft}
                {send: left}
            ]
        }
    }
    {
        name: move_right_or_take_history_hint
        modifier: control
        keycode: char_f
        mode: emacs
        event: {
            until: [
                {send: menuright}
                {send: right}
            ]
        }
    }
    { # reverse of 'undo'
        name: redo_change
        modifier: control
        keycode: char_g
        mode: emacs
        event: {edit: redo}
    }
    {
        name: undo_change
        modifier: control
        keycode: char_z
        mode: emacs
        event: {edit: undo}
    }
    {
        name: paste_before
        modifier: control
        keycode: char_y
        mode: emacs
        event: {edit: pastecutbufferbefore}
    }
    {
        name: cut_word_left
        modifier: control
        keycode: char_w
        mode: emacs
        event: {edit: cutwordleft}
    }
    {
        name: cut_line_to_end
        modifier: control
        keycode: char_k
        mode: emacs
        event: {edit: cuttoend}
    }
    {
        name: cut_line_from_start
        modifier: control
        keycode: char_u
        mode: emacs
        event: {edit: cutfromstart}
    }
    {
        name: swap_graphemes
        modifier: control
        keycode: char_t
        mode: emacs
        event: {edit: swapgraphemes}
    }
    {
        name: move_one_word_left
        modifier: alt
        keycode: left
        mode: emacs
        event: {edit: movewordleft}
    }
    {
        name: move_one_word_right_or_take_history_hint
        modifier: alt
        keycode: right
        mode: emacs
        event: {
            until: [
                {send: historyhintwordcomplete}
                {edit: movewordright}
            ]
        }
    }
    {
        name: move_one_word_left
        modifier: alt
        keycode: char_b
        mode: emacs
        event: {edit: movewordleft}
    }
    {
        name: move_one_word_right_or_take_history_hint
        modifier: alt
        keycode: char_f
        mode: emacs
        event: {
            until: [
                {send: historyhintwordcomplete}
                {edit: movewordright}
            ]
        }
    }
    # { # cutwordright is enough
    #     name: delete_one_word_forward
    #     modifier: alt
    #     keycode: delete
    #     mode: emacs
    #     event: {edit: deleteword}
    # }
    {
        name: cut_word_to_right
        modifier: alt
        keycode: char_d
        mode: emacs
        event: {edit: cutwordright}
    }
    {
        name: upper_case_word
        modifier: alt
        keycode: char_u
        mode: emacs
        event: {edit: uppercaseword}
    }
    {
        name: lower_case_word
        modifier: alt
        keycode: char_l
        mode: emacs
        event: {edit: lowercaseword}
    }
    {
        name: capitalize_char
        modifier: alt
        keycode: char_c
        mode: emacs
        event: {edit: capitalizechar}
    }
    {
      name: zoxide_menu
      modifier: control
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: menu name: zoxide_menu }
      ]
    }
    {
      name: edit
      modifier: alt
      keycode: char_e
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: OpenEditor }
      ]
    }
    {
        name: fuzzy_history
        modifier: control
        keycode: char_r
        mode: [emacs, vi_normal, vi_insert]
        event: [
        {
            send: ExecuteHostCommand
            cmd: "commandline edit --replace (
            history
                | where exit_status == 0
                | get command
                | reverse
                | uniq
                | str join (char -i 0)
                | fzf
                --preview '{}'
                --preview-window 'right:30%'
                --scheme history
                --read0
                --layout reverse
                --height 40%
                --query (commandline)
                | decode utf-8
                | str trim
            )"
        }
        ]
    }
    {
        name: fuzzy_file
        modifier: control
        keycode: char_t
        mode: emacs
        event: {
        send: executehostcommand
        cmd: "commandline edit --insert (fzf --layout=reverse)"
        }
    }
]
