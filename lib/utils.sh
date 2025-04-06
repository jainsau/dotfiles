#!/bin/sh

is_curl_installed() {
    command -v curl &> /dev/null
}

is_kitty_installed() {
    command -v kitty &> /dev/null
}
