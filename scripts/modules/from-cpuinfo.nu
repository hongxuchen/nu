# Convert from contents of /proc/cpuinfo to structured data
export def "from cpuinfo" [fpath] {
    open $fpath
    | lines
    | split list ''
    | each {
        split column ':'
        | str trim
        | update column1 { str replace -a ' ' '_' }
        | transpose -r -d
        | update flags { split row ' ' }
        | update bugs { split row ' ' }
    }
}
