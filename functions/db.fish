function db
    if test (count $argv) -eq 0
        echo "Usage: db <display_name> [connection_string]"
        return 1
    end

    set display_name $argv[1]
    set db_dir ~/Developer/.db/$display_name
    
    set -g DB_ORIGINAL_DIR (pwd)

    if test -d $db_dir
        echo "Database '$display_name' already exists. Entering directory and launching drizzle-kit studio..."
        z $db_dir
        bun update && bun drizzle-kit studio; and z $DB_ORIGINAL_DIR; or z $DB_ORIGINAL_DIR
        return 0
    end

    if test (count $argv) -ne 2
        echo "Database '$display_name' does not exist. Please provide connection_string to create it."
        echo "Usage: db <display_name> <connection_string>"
        return 1
    end

    set connection_string $argv[2]

    mkdir -p $db_dir >/dev/null 2>&1
    z $db_dir

    printf '%s\n' \
    'import { defineConfig } from "drizzle-kit"' \
    '' \
    'export default defineConfig({' \
    '  out: "./drizzle",' \
    '  dialect: "postgresql",' \
    '  dbCredentials: {' \
    "    url: \"$connection_string\"" \
    '  }' \
    '})' \
    > drizzle.config.ts

    bun a drizzle-orm pg >/dev/null 2>&1
    bun a -d drizzle-kit >/dev/null 2>&1

    bun update && bun drizzle-kit studio; and z $DB_ORIGINAL_DIR; or z $DB_ORIGINAL_DIR
end

function fish_preexec --on-event fish_preexec
    if set -q DB_ORIGINAL_DIR
    end
end

function fish_postexec --on-event fish_postexec
    if set -q DB_ORIGINAL_DIR
        if test (pwd) != $DB_ORIGINAL_DIR
            z $DB_ORIGINAL_DIR
        end
        set -e DB_ORIGINAL_DIR
    end
end

function fish_cancel --on-event fish_cancel
    if set -q DB_ORIGINAL_DIR
        z $DB_ORIGINAL_DIR
        set -e DB_ORIGINAL_DIR
    end
end
