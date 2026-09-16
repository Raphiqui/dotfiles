function commit-types --description "Print a reminder of Conventional Commit prefixes and what they mean"
    set_color --bold
    echo "Conventional Commit types"
    set_color normal
    echo

    set -l types \
        "feat:|A new feature for the user" \
        "fix:|A bug fix" \
        "docs:|Documentation only changes" \
        "style:|Formatting, whitespace, missing semicolons - no code meaning change" \
        "refactor:|Code change that neither fixes a bug nor adds a feature" \
        "perf:|Code change that improves performance" \
        "test:|Adding or correcting tests" \
        "build:|Changes to the build system or external dependencies" \
        "ci:|Changes to CI configuration files and scripts" \
        "chore:|Other changes that don't modify src or test files" \
        "revert:|Reverts a previous commit"

    for entry in $types
        set -l parts (string split "|" $entry)
        set_color cyan
        printf "%-10s" $parts[1]
        set_color normal
        echo $parts[2]
    end

    echo
    echo "Example: "(set_color yellow)"feat(auth): add password reset flow"(set_color normal)
end
