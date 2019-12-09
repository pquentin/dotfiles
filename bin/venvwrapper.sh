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
    # tmux seems to copy env vars when doing splits so we can't rely on
    # $VIRTUAL_ENV to know if we should deactivate
    deactivate 2> /dev/null
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
    "/usr/local/bin/python3" -m venv "$env_path"
    . "$env_path/bin/activate"
    pip install -U pip wheel setuptools
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

    rm -rf "$env_path"
}
