#!/bin/bash
source "../.lib/include.sh"
set -e
function main {
    if go help &> /dev/null; then
        go get github.com/gopasspw/gopass
    else
        os="$(get_os)"
        case "${os}" in
            CentOS*)
                yum copr enable daftaupe/gopass
                install_package_centos gnupg2 rng-tools gopass
            ;;
            Ubuntu*)
                install_package_ubuntu gnupg rng-tools
                wget -q -O- https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key | sudo apt-key add -
                echo "deb https://dl.bintray.com/gopasspw/gopass trusty main" | sudo tee /etc/apt/sources.list.d/gopass.list
                install_package_ubuntu gopass
            ;;
            Darwin*)
                brew cask install gnupg2 gopass
            ;;
            *)
                echo "Operating system > ${os} < is not supported" && exit 1
            ;;
        esac
    fi
}

main