#!/usr/bin/env bash
set -ex

#
# This script is meant for quick & easy install/upgrade via:
#   bash <(curl -sL http://armada.sh/install)
# or:
#   bash <(wget -qO- http://armada.sh/install)
#

REPO='armadaplatform/armada'
LATEST_TAG_URL="https://api.github.com/repos/${REPO}/releases/latest"
PACKAGE_BASE_URL="https://github.com/${REPO}/releases/download"

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

fetch_latest_tag() {
    if command_exists curl; then
        response=$(curl -qSfs ${LATEST_TAG_URL}) 2>/dev/null
    elif command_exists wget; then
        response=$(wget -q -O - ${LATEST_TAG_URL})
    fi

    return_code=$?
    if [ $return_code -ne 0 ]; then
        echo 1>&2 "Error while fetching: ${LATEST_TAG_URL}"
        exit $return_code
    fi

    regex='"tag_name": "([^"]+)"'
    if ! [[ $response =~ $regex ]]; then
        echo 1>&2 "Invalid response format"
        return 1
    fi
    echo ${BASH_REMATCH[1]}
}

sh_c='sh -c'
if [ "$user" != 'root' ]; then
    if command_exists sudo; then
        sh_c='sudo sh -c'
    elif command_exists su; then
        sh_c='su -c'
    else
        echo >&2 'Error: this installer needs the ability to run commands as root.'
        echo >&2 'We are unable to find either "sudo" or "su" available to make this happen.'
        exit 1
    fi
fi
download_file()
{
    url=$1
    local_path=$2

    $sh_c "rm -f ${local_path}"

    http_status_code='0'
    if command_exists curl; then
        http_status_code=$($sh_c "curl -sL -w \"%{http_code}\" -o ${local_path} ${url}")
    elif command_exists wget; then
        http_status_code=$($sh_c "wget -qS -O ${local_path} ${url} 2>&1 | awk '/^  HTTP/{print \$2}'")
    fi

    if [ ${http_status_code} -ne '200' ]; then
        echo >&2 "Error downloading file: ${url}"
        exit 1
    fi
}

VERSION=$(fetch_latest_tag)

set +e
if ( uname -a | grep --quiet 'amzn' ) ; then
    PACKAGE_FILENAME="armada-amzn-${VERSION}-1.x86_64.rpm"
    INSTALL_COMMAND='yum -y --nogpgcheck localinstall'

elif command_exists yum; then
    PACKAGE_FILENAME="armada-${VERSION}-1.x86_64.rpm"
    INSTALL_COMMAND='yum -y --nogpgcheck localinstall'

elif command_exists apt-get; then
    PACKAGE_FILENAME="armada_${VERSION}_amd64.deb"
    INSTALL_COMMAND='dpkg -i'
    $sh_c "apt-get install -y python python-pip conntrack jq netcat-openbsd"
else
    echo "Either your platform is not easily detectable or is not supported by this installer script."
    exit 1
fi
set -e

PACKAGE_URL="${PACKAGE_BASE_URL}/${VERSION}/${PACKAGE_FILENAME}"
echo "Downloading package (ver. ${VERSION})."
download_file ${PACKAGE_URL} ${PACKAGE_FILENAME}

echo "Installing armada"
$sh_c "${INSTALL_COMMAND} ${PACKAGE_FILENAME}"

echo "Cleanup"
$sh_c "rm ${PACKAGE_FILENAME}"
