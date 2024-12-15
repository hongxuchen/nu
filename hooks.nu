let hooks = {
    pre_prompt: [{ null }]
    pre_execution: [{ null }]
    env_change: {
        command_not_found: {
            condition: {|cmd_name| $is_win}
            code: { |cmd_name| (
                try {
                    let attrs = (
                        ftype | find $cmd_name | to text | lines | reduce -f [] { |line, acc|
                            $line | parse "{type}={path}" | append $acc
                        } | group-by path | transpose key value | each { |row|
                            { path: $row.key, types: ($row.value | get type | str join ", ") }
                        }
                    )
                    let len = ($attrs | length)

                    if $len == 0 {
                        return null
                    } else {
                        return ($attrs | table --collapse)
                    }
                }
                )
            }
        }
        # PWD: [
        #     {|before, after|try {print (ls -a | sort-by -i type name | grid -c)}}
        # ]
    }
    display_output: "if (term size).columns >= 100 { table -e } else { table }"
    command_not_found: []
}
