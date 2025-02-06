export def get-sign [cmd] {
    let x = (scope commands | where name == $cmd).signatures?.0?.any?
    mut s = []
    mut n = {}
    mut p = []
    mut pr = []
    mut r = []
    for it in $x {
        if $it.parameter_type == 'switch' {
            if ($it.short_flag | is-not-empty) {
                $s ++= [$it.short_flag]
            }
            if ($it.parameter_name | is-not-empty) {
                $s ++= [$it.parameter_name]
            }
        } else if $it.parameter_type == 'named' {
            if ($it.parameter_name | is-empty) {
                $n = ($n | upsert $it.short_flag $it.short_flag)
            } else if ($it.short_flag | is-empty) {
                $n = ($n | upsert $it.parameter_name $it.parameter_name)
            } else {
                $n = ($n | upsert $it.short_flag $it.parameter_name)
            }
        } else if $it.parameter_type == 'positional' {
            if $it.is_optional == false {
                $p ++= [$it.parameter_name]
            } else {
                $pr ++= [$it.parameter_name]
            }
        } else if $it.parameter_type == 'rest' {
            $r ++= [$it.parameter_name]
        }
    }
    { switch: $s, name: $n, positional: ($p ++ $pr), rest: $r }
}
