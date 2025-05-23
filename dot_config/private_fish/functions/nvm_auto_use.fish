function nvm_auto_use --on-variable PWD
    if test -f .nvmrc
        set node_version (string trim (cat .nvmrc))
        if nvm list $node_version >/dev/null 2>&1
            nvm use $node_version
            echo (set_color green)"[nvm] Node version '$node_version'"(set_color normal)
        else
            echo (set_color yellow)"[nvm] Node version '$node_version' not installed."(set_color normal)
        end
    end
end
