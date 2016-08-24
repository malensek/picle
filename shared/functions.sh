
info() {
    echo_color 34 "[>] ${@}"
}

info_delay() {
    info "${@}"
    sleep 1
}

echo_color() {
    color="${1}"
    shift 1
    echo -e "\e[0;${color}m${@}\e[0m"
}

die() {
    echo_color 31 "[X] ${@}"
    exit 1
}

load_config() {
    if [[ -z "${PICLE_CONF}" ]]; then
        PICLE_CONF="${PICLE_HOME}/config/config.sh"
    fi

    source "${PICLE_CONF}" \
        || die "Could not load configuration: ${PICLE_CONF}"

    git submodule status  | grep '^-' &> /dev/null && ( \
        info "Initializing submodules..."
        git submodule init
        git submodule update
    )
}
