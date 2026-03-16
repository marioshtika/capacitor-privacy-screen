#!/usr/bin/env bash
set -euo pipefail

if command -v /usr/libexec/java_home >/dev/null 2>&1; then
  jdk_home="$(/usr/libexec/java_home -v 21 2>/dev/null || true)"
  if [[ -n "${jdk_home}" && -x "${jdk_home}/bin/java" ]]; then
    printf '%s\n' "${jdk_home}"
    exit 0
  fi
fi

if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix openjdk@21 2>/dev/null || true)"
  if [[ -n "${brew_prefix}" ]]; then
    brew_jdk_home="${brew_prefix}/libexec/openjdk.jdk/Contents/Home"
    if [[ -x "${brew_jdk_home}/bin/java" ]]; then
      printf '%s\n' "${brew_jdk_home}"
      exit 0
    fi
  fi
fi

if [[ -n "${JAVA_HOME:-}" && -x "${JAVA_HOME}/bin/java" ]]; then
  printf '%s\n' "${JAVA_HOME}"
  exit 0
fi

android_studio_jbr="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
if [[ -x "${android_studio_jbr}/bin/java" ]]; then
  printf '%s\n' "${android_studio_jbr}"
  exit 0
fi

echo "Unable to locate a Java 21 home. Set JAVA_HOME before running Android verification." >&2
exit 1
