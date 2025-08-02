function print_header
    set -l line_width 70

    set -l now (date +"%H:%M:%S")
    set -l name $argv[1]

    set -l text_len (math (string length -- $now) + 3 + (string length -- $name))

    set -l dash_count (math $line_width - $text_len)
    if test $dash_count -lt 0
        set dash_count 0
    end

    set -l dashes (printf '─%.0s' (seq $dash_count))

    echo -e "\n── $now ─ $name $dashes"
end
