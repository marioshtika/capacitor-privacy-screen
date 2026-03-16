#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"

JAVA_HOME="$(bash "${script_dir}/java-home.sh")"
export JAVA_HOME
export PATH="${JAVA_HOME}/bin:${PATH}"

cd "${repo_root}/android"
./gradlew clean build test
