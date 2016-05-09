#!/usr/bin/env bash

#
# This script is meant for quick & easy install/upgrade via:
#   bash <(curl -sL http://armada.sh/install)
# or:
#   bash <(wget -qO- http://armada.sh/install)
#

latest_tag_url=https://api.github.com/repos/armadaplatform/armada/releases/latest

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

fetch_latest_tag() {
    if command_exists curl; then
        response=$(curl -qSfs ${latest_tag_url}) 2>/dev/null
    elif command_exists wget; then
        response=$(wget -S -q -O - ${latest_tag_url})
    fi

    return_code=$?
    if [ $return_code -ne 0 ]; then
        echo 1>&2 "Error while fetching: ${latest_tag_url}"
        exit $return_code
    fi

    regex='"tag_name": "([^"]+)"'
    [[ $response =~ $regex ]]
    latest_tag=${BASH_REMATCH[1]}
}

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

sh_c='sh -c'
fetch_latest_tag
if [ $? = 0 ]; then
    installation_file_url="https://raw.githubusercontent.com/armadaplatform/armada/${latest_tag}/install/install.sh"
    echo "Downloading installation script (ver. ${latest_tag})."
    download_file ${installation_file_url} /tmp/install_armada.sh
    ${sh_c} "chmod u+x /tmp/install_armada.sh"
    /tmp/install_armada.sh ${latest_tag}
fi
