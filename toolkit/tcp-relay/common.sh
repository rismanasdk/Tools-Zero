#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/../shared/common.sh"

TCP_RELAY_SOURCE="${BASE_DIR}/src/local_tcp_relay.cpp"
TCP_RELAY_BINARY="${BASE_DIR}/bin/local_tcp_relay"

build_tcp_relay() {
  mkdir -p "${BASE_DIR}/bin"

  if [ -x "${TCP_RELAY_BINARY}" ] && [ "${TCP_RELAY_BINARY}" -nt "${TCP_RELAY_SOURCE}" ]; then
    return 0
  fi

  tools_zero_run_command \
    "TCP Relay Build" \
    "g++" \
    g++ -std=c++17 -O2 -Wall -Wextra -pedantic \
    "${TCP_RELAY_SOURCE}" \
    -o "${TCP_RELAY_BINARY}"
}

run_tcp_relay() {
  build_tcp_relay || return 1
  tools_zero_run_command "TCP Relay" "${TCP_RELAY_BINARY}" "${TCP_RELAY_BINARY}" "$@"
}
