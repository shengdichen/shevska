clone_dir="clone"
out_dir="${clone_dir}/dist"

function clone() {
    mkdir "${clone_dir}"

    cd "${clone_dir}"
    git clone --depth 2 https://github.com/be5invis/Iosevka.git ./
    npm install

    cd ..
}

function link() {
    ln -srf "private-build-plans.toml" "${clone_dir}"

    mkdir "${out_dir}"
    ln -srf "bin" "${out_dir}/shevska"
}

function main() {
    clone
    link
}
main

unset clone_dir out_dir
