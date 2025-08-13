function clear-cache
    set -l folders_to_delete \
        "$HOME/.bun/install" \
        "$HOME/.npm" \
        "$HOME/Movies/TV" \
        "$HOME/Music/Music" \
        "$HOME/Library/Application Support/Code/Cache" \
        "$HOME/Library/Application Support/Code/CachedConfigurations" \
        "$HOME/Library/Application Support/Code/CachedData" \
        "$HOME/Library/Application Support/Code/CachedExtensionVSIXs" \
        "$HOME/Library/Application Support/Code/CachedProfilesData" \
        "$HOME/Library/Application Support/Code/Code Cache" \
        "$HOME/Library/Application Support/Code/GPUCache" \
        "$HOME/Library/Caches/BraveSoftware" \
        "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/extensions_crx_cache" \
        "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/component_crx_cache" \
        "$HOME/Library/Caches/Homebrew" \
        "$HOME/Library/Application Support/discord/logs" \
        "$HOME/Library/Application Support/discord/cache" \
        "$HOME/Library/Application Support/discord/component_crx_cache" \
        "$HOME/Library/Logs/DiagnosticReports" \
        "$HOME/Library/Logs/CrashReporter" \
        "$HOME/Library/Caches/SiriTTS" \
        "$HOME/Library/Containers/com.apple.Safari" \
        "$HOME/Library/Containers/com.apple.helpviewer" \
        "$HOME/Library/Containers/com.apple.AppStore" \
        "$HOME/Library/Containers/com.apple.Maps" \
        "$HOME/Library/Containers/com.apple.podcasts.widget" \
        "$HOME/Library/Containers/com.apple.clock.WorldClockWidget" \
        "$HOME/Library/Containers/com.apple.mediaanalysisd" \
        "$HOME/Library/Group Containers/group.com.apple.tips" \
        "$HOME/Library/Group Containers/group.com.apple.reminders" \
        "$HOME/Library/Group Containers/group.com.apple.gamecenter" \
        "$HOME/Library/Group Containers/243LU875E5.groups.com.apple.podcasts" \
        "$HOME/Library/Group Containers/group.com.apple.notes" \
        "$HOME/Library/Group Containers/group.com.apple.news"

    # "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default/Service Worker" \

    set -l yellow (set_color yellow)
    set -l green  (set_color green)
    set -l red    (set_color red)
    set -l normal (set_color normal)

    print_header "Cache Cleanup"

    echo "$yellow Starting folder cleanup... $normal"
    echo " Number of folders to process: "(count $folders_to_delete)

    if not type -q trash
        echo "$red No available tools to move to trash. $normal"
        echo "Install 'trash' with: brew install trash"
        return 1
    end

    set -l deleted_count 0
    set -l missing_count 0

    for folder in $folders_to_delete
        if test -d "$folder"
            printf "%s Moving to trash: %s%s\n" $green "$folder" $normal
            if trash "$folder"
                set deleted_count (math $deleted_count + 1)
            else
                printf "%s Failed to move to trash: %s%s\n" $red "$folder" $normal
            end
        else
            printf "%s Folder does not exist: %s%s\n" $yellow "$folder" $normal
            set missing_count (math $missing_count + 1)
        end
    end

    print_header "Summary"
    printf " Folders moved to trash: %s%s%s\n" $green $deleted_count $normal
    printf " Folders not found:      %s%s%s\n" $yellow $missing_count $normal
    printf " Total processed:        %s\n" (count $folders_to_delete)

    echo
    echo "$green Folder cleanup completed! $normal"
end
