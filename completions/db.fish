# Completions for db command
complete -c db -f

# Complete first argument with directory names from ~/.db
complete -c db -n "test (count (commandline -opc)) -eq 1" -a "(ls ~/Developer/.db 2>/dev/null)"
