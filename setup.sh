clone_dir="clone"
bin_dir="bin"
bin_dir_abs="$(realpath ${bin_dir})"

function clone() {
    if [ ! -d "${clone_dir}" ]; then
        mkdir "${clone_dir}"
        git clone --depth 2 https://github.com/be5invis/Iosevka.git "${clone_dir}"
    fi
}

function setup() {
    (cd "${clone_dir}" && npm install)
    local package_ttfautohint="ttfautohint"
    if ! npm list -g --depth=0 | grep "${package_ttfautohint}" 1>/dev/null 2>&1; then
        npm install -g "${package_ttfautohint}"
    fi

    ln -srf "private-build-plans.toml" "${clone_dir}"

    local out_dir="${clone_dir}/dist"
    mkdir -p "${out_dir}"
    local target_dir="${out_dir}/shevska"
    if [ ! -d "${target_dir}" ]; then
        ln -srf "${bin_dir}" "${target_dir}"
    fi
}

function install() {
    local font_dir="${HOME}/.local/share/fonts/shevska"
    mkdir -p "${font_dir}"

    ln -sf "${bin_dir_abs}/ttf" "${font_dir}"
    ln -sf "${bin_dir_abs}/woff2" "${font_dir}"
}

function build() {
    (cd "${clone_dir}" && npm run build -- contents::shevska)
}

function dev() {
    clone
    setup
    install
}

function main() {
    case "$1" in
        "dev")
            dev
            ;;
        "build")
            dev
            build
            ;;
        *)
            install
            ;;
    esac
}
main "$@"

unset clone_dir bin_dir bin_dir_abs
unset main dev build install setup clone
