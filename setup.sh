#!/usr/bin/env dash

SCRIPT_PATH="$(realpath "$(dirname "${0}")")"
cd "${SCRIPT_PATH}" || exit 3

CLONE_DIR="clone"
BIN_DIR="bin"

__clone_upstream() {
    if [ ! -d "${CLONE_DIR}" ]; then
        mkdir -p "${CLONE_DIR}"
        git clone --depth 1 https://github.com/be5invis/Iosevka.git "${CLONE_DIR}"
    else
        (cd "${CLONE_DIR}" && git pull --depth 1)
    fi
}

__setup() {
    (cd "${CLONE_DIR}" && npm install)
    local package_ttfautohint="ttfautohint"
    if ! npm list -g --depth=0 | grep "${package_ttfautohint}" >/dev/null 2>&1; then
        npm install -g "${package_ttfautohint}"
    fi

    ln -srf "private-build-plans.toml" "${CLONE_DIR}"

    local out_dir="${CLONE_DIR}/dist"
    mkdir -p "${out_dir}"
    local target_dir="${out_dir}/shevska"
    if [ ! -d "${target_dir}" ]; then
        ln -srf "${BIN_DIR}" "${target_dir}"
    fi
}

link_fonts() {
    local font_dir="${HOME}/.local/share/fonts/shevska"
    mkdir -p "${font_dir}"

    for ftype in "ttf" "woff2"; do
        ln -sf "$(realpath ${BIN_DIR})/${ftype}" "${font_dir}"
    done
}

build_setup() {
    __clone_upstream
    __setup
    link_fonts
}

build() {
    (cd "${CLONE_DIR}" && npm run build -- contents::shevska)
}

main() {
    case "${1}" in
        "dev")
            build_setup
            ;;
        "build")
            build_setup
            build
            ;;
        *)
            link_fonts
            ;;
    esac

    unset SCRIPT_PATH CLONE_DIR BIN_DIR
    unset -f __clone_upstream __setup link_fonts build_setup build
}
main "$@"
unset -f main
