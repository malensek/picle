################################################################################

# Set up environment upon sourcing
initialize_picle

################################################################################

picle_version() {
    echo "1.0"
}

picle_splash() {
cat <<EOM
          __        __
  .-----.|__|.----.|  |.-----.
  |  _  ||  ||  __||  ||  -__|
  |   __||__||____||__||_____|
  |__|
          Version $(picle_version)
EOM
}

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
    echo -e $'\e[0;'${color}'m'${@}$'\e[0m'
}

require() {
    type "${1}" &> /dev/null
    if [[ ${?} -ne 0 ]]; then
        die "Could not find required utility: ${1}"
    fi
}

die() {
    echo_color 31 "[X] ${@}"
    exit 1
}

initialize_picle() {
    if [[ -z "${PICLE_HOME}" ]]; then
        PICLE_HOME="$(cd "$(dirname "$0")" && pwd)/.."
    fi

    if [[ -z "${PICLE_CONF}" ]]; then
        PICLE_CONF="${PICLE_HOME}/config"
    fi

    source "${PICLE_CONF}/main.sh" \
        || die "Could not load main configuration file: ${PICLE_CONF}/main.sh"

    if ! type picle-info &> /dev/null; then
        PATH="${PICLE_HOME}/bin:${PATH}"
    fi
    if ! type picle-info &> /dev/null; then
        # Still can't find it!
        die "Failed to locate picle executables!"
    fi

    git submodule status  | grep '^-' &> /dev/null && ( \
        info "Initializing submodules..."
    git submodule init
    git submodule update
    )
}

# Set up environment upon sourcing
initialize_picle

