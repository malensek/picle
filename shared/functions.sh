
echo_info() {
    echo_color 34 "[>] ${@}"
}

echo_info_delay() {
    echo_info "${@}"
    sleep 1
}

echo_color() {
    color="${1}"
    shift 1
    echo -e "\e[0;${color}m${@}\e[0m"
}

load_config() {
    if [[ -z "${PICLE_CONF}" ]]; then
        PICLE_CONF="${PICLE_HOME}/config/config.sh"
    fi

    source "${PICLE_CONF}" \
        || die "Could not load configuration: ${PICLE_CONF}"

    git submodule status  | grep '^-' &> /dev/null && ( \
        echo_info "Initializing submodules..."
        git submodule init
        git submodule update
    )
}
