let menus = [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 5
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: description
                columns: 5
                col_width: 20
                col_padding: 2
                selection_rows: 5
                description_rows: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
        {
            name: vars_menu
            only_buffer_difference: true
            marker: "# "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                scope variables
                | where name =~ $buffer
                | sort-by name
                | each { |it| {value: $it.name description: $it.type} }
            }
        }
        {
            name: zoxide_menu
            only_buffer_difference: false # set to true will auto select prefix
            marker: "| "
            type: {
                layout: columnar
                page_size: 20
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                zoxide query -ls $buffer
                | parse -r '(?P<description>[0-9]+) (?P<value>.+)'
            }
        }
        {
            name: abbr_menu
            only_buffer_difference: false
            marker: "👀 "
            type: {
                layout: columnar
                columns: 1
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                scope aliases
                | where name == $buffer
                | each { |elt| {value: $elt.expansion }}
            }
        }
    ]
