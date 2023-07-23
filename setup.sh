clone_dir="clone"
bin_dir="bin"

function clone() {
    if [ ! -d "${clone_dir}" ]; then
        mkdir "${clone_dir}"
        git clone --depth 2 https://github.com/be5invis/Iosevka.git "${clone_dir}"
    fi

    cd "${clone_dir}"
    npm install
    cd ..
}

function link() {
    ln -srf "private-build-plans.toml" "${clone_dir}"

    out_dir="${clone_dir}/dist"
    mkdir -p "${out_dir}"
    target_dir="${out_dir}/shevska"
    if [ ! -d "${target_dir}" ]; then
        ln -srf "${bin_dir}" "${target_dir}"
    fi

    unset out_dir target_dir
}

function transport_font() {
    font_dir="${HOME}/.local/share/fonts/shevska"
    mkdir -p "${font_dir}"

    ln -sf "$(realpath ${bin_dir}/ttf)" "${font_dir}"
    ln -sf "$(realpath ${bin_dir}/woff2)" "${font_dir}"

    unset font_dir
}

function main() {
    clone
    link
    transport_font
}
main

unset clone_dir
