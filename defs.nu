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

export def cat [file: string] = {
    bat -p --paging=never ($file | path expand)
}

