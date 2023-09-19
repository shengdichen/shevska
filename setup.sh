clone_dir="clone"
bin_dir="bin"
bin_dir_abs="$(realpath ${bin_dir})"

function clone() {
    if [ ! -d "${clone_dir}" ]; then
        mkdir "${clone_dir}"
        git clone --depth 2 https://github.com/be5invis/Iosevka.git "${clone_dir}"
    fi

    (cd "${clone_dir}" && npm install)
}

function link() {
    ln -srf "private-build-plans.toml" "${clone_dir}"

    local out_dir="${clone_dir}/dist"
    mkdir -p "${out_dir}"
    local target_dir="${out_dir}/shevska"
    if [ ! -d "${target_dir}" ]; then
        ln -srf "${bin_dir}" "${target_dir}"
    fi
}

function transport_font() {
    local font_dir="${HOME}/.local/share/fonts/shevska"
    mkdir -p "${font_dir}"

    ln -sf "${bin_dir_abs}/ttf" "${font_dir}"
    ln -sf "${bin_dir_abs}/woff2" "${font_dir}"
}

function build() {
    (cd "${clone_dir}" && npm run build -- contents::shevska)
}

function main() {
    clone
    link
    transport_font
    build
}
main

unset clone_dir bin_dir bin_dir_abs
