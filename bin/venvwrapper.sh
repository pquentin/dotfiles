if [ -z "$WORKON_HOME" ]; then
    export WORKON_HOME="$HOME/.virtualenvs"
fi

workon () {
    virtualenv="$1"
    if [ -z "$virtualenv" ]; then
        echo "Usage: workon env_name" >&2
        return 1
    fi
    if ! [ -e "$WORKON_HOME/$virtualenv" ]; then
        echo "Virtualenv '$virtualenv' does not exist" >&2
        return 1
    fi
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
    fi
    . "$WORKON_HOME/$virtualenv/bin/activate"
}

mkvirtualenv () {
    name="$1"
    shift
    if [ -z "$name" ]; then
        echo "Usage: mkvirtualenv name [args]" >&2
        return 1
    fi
    env_path="$WORKON_HOME/$name"
    if [ -e "$env_path" ]; then
        echo "virtualenv '$env_path' already exists" >&2
        return 1
    fi
    mkdir -p "$env_path"
    "$(pyenv prefix)/bin/python3" -m venv "$env_path"
}

rmvirtualenv () {
    name="$1"
    if [ -z "$name" ]; then
        echo "Usage: rmvirtualenv name" >&2
        return 1
    fi
    env_path="$WORKON_HOME/$name"
    if [ ! -e "$env_path" ]; then
        echo "virtualenv '$env_path' does not exists" >&2
        return 1
    fi

    read -q "REPLY?Delete virtualenv '$env_path'? [y/N] " -c -n 1
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        rm -rf "$env_path"
    else
        echo "action aborted" >&2
        return 1
    fi
}