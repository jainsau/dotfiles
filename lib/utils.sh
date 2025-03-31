#!/bin/sh

is_curl_installed() {
    command -v curl > /dev/null 2>&1
}

has_sudo_privileges() {
    sudo -n true 2>/dev/null
}
