function update
    set -l now

    # Status variables
    set -l status_bun "fail"
    set -l status_homebrew "fail"

    # Kolory
    set -l green (set_color green)
    set -l red   (set_color red)
    set -l normal (set_color normal)

    # Update bun
    print_header "bun"
    if type -q bun
        if bun upgrade
            set status_bun "ok"
        else
            set status_bun "fail"
        end
    else
        echo "bun not found"
        set status_bun "fail"
    end

    # Update homebrew
    print_header "homebrew"
    if type -q brew
        if brew update; and brew upgrade; and brew cleanup -s; and brew doctor
            set status_homebrew "ok"
        else
            set status_homebrew "fail"
        end
    else
        echo "homebrew not found"
        set status_homebrew "fail"
    end

    # Summary
    print_header "Summary"
    printf " bun:            %s%s%s\n" \
        (test "$status_bun" = "ok"; and echo $green; or echo $red) \
        "$status_bun" \
        $normal

    printf " homebrew:       %s%s%s\n" \
        (test "$status_homebrew" = "ok"; and echo $green; or echo $red) \
        "$status_homebrew" \
        $normal

    echo
end
