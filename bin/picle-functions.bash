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

info_error() {
    echo_color 31 "[X] ${@}"
}

info_warn() {
    echo_color 31 "[!] ${@}"
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
    info_error "${@}"
    exit 1
}

prompt_bool() {
    yn="[y/N]"
    default=1
    if [[ -n "${2}" ]]; then
        default="${2}"
    fi
    if [[ ${default} -eq 0 ]]; then
        yn="[Y/n]"
    fi
    while true; do
        read -p "${1} ${yn} " answer
        case ${answer} in
            [Yy]*) return 0;;
            [Nn]*) return 1;;
            "") return ${default};;
        esac
    done
}

is_master() {
    [[ "${PRIMARY_NODE}" == "$(hostname)" ]] || return 1 && return 0
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

# Provisioning-related Functions ###############################################

partition_disk() {
    # Partitions a given disk for a 100MB boot and the remainder of the disk
    # allocated to root.
cat <<EOM | fdisk "${1}"
p
o
n
p
1

+100M
t
c
n
p
2


w
EOM
}

create_fs() {
    mkfs.vfat "${1}1"
    mkfs.f2fs "${1}2"
}

mount_sd() {
    dev="${1}"
    dir="${2}"
    mkdir -v "${dir}"
    mount -v "${dev}2" "${dir}"
    root_ok=${?}
    mkdir -v "${dir}/boot"
    mount -v "${dev}1" "${dir}/boot"
    boot_ok=${?}
    if [[ "${boot_ok}" -ne 0 || "${root_ok}" -ne 0 ]]; then
        return 1
    else
        return 0
    fi
}


################################################################################

# Set up environment upon sourcing
initialize_picle

################################################################################
