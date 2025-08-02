function update
    set -l now

    # Status variables
    set -l status_bun "fail"
    set -l status_fish_plugins "fail"
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

    # Update fish plugins
    print_header "plugins"
    if type -q fisher
      set -l plugins (fisher list)
      set -l all_plugins_ok 1

      if test (count $plugins) -eq 0
          echo "(set_color red)No fish plugins found. Please install some plugins first." (set_color normal)
          return 0
      end
        
      for plugin in $plugins
        printf "%s updating…  %s%s\n" (set_color blue) (set_color normal) $plugin

        if fisher update $plugin >/dev/null 2>&1
            printf "%s updated    %s%s\n" (set_color green) (set_color normal) $plugin
        else
            printf "%s failed    %s%s\n" (set_color red) (set_color normal) $plugin
            set all_plugins_ok 0
        end

        if test $all_plugins_ok -eq 1
            set status_fish_plugins "ok"
        else
            set status_fish_plugins "fail"
        end
      end
    else
      echo (set_color red) "fisher not found, please install fisher first." (set_color normal)
      set status_fish_plugins "fail"
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

    printf " plugins:        %s%s%s\n" \
        (test "$status_fish_plugins" = "ok"; and echo $green; or echo $red) \
        "$status_fish_plugins" \
        $normal

    printf " homebrew:       %s%s%s\n" \
        (test "$status_homebrew" = "ok"; and echo $green; or echo $red) \
        "$status_homebrew" \
        $normal

    echo
end
