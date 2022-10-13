let prefix_line = search('^" Prefix: \([a-z]\+\)', 'bnw')

if prefix_line > 0
    let b:syntax_prefix = matchlist(getline(prefix_line), '^" Prefix: \([a-z]\+\)')[1]
end
