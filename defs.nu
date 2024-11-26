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

export def kill-all [name: string] {
  ps | where name == $name | get pid | each { |it| kill -9 $it }
}

export def exec-async [commands: string] {
    bash -c $"nu -c '($commands)' &"
}
