let hooks = {
    pre_prompt: [{ null }]
    pre_execution: [{ null }]
    env_change: {
        PWD: [
                {
                    condition: {|_, after| ($after | path join 'Cargo.lock' | path exists) }
                    code: {
                        $env.PATH = (
                            $env.PATH
                                | prepend ($env.PWD | path join 'target/debug')
                                | prepend ($env.PWD | path join 'target/release')
                                | uniq
                            )
                    }
                }
        ]
    }
    command_not_found: {
        code: { |cmd_name| (
        if ($is_win) {
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
        } else if ($is_linux) {
            use std
            try {
                /usr/lib/command-not-found --no-failure-msg $cmd_name o> (std null-device)
            }
        }
            )
        }
    }
    display_output: "if (term size).columns >= 100 { table -e } else { table }"
}
