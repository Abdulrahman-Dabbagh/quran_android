#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
command -v java >/dev/null || { echo 'Java is required.' >&2; exit 1; }
if [[ -z "${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}" && ! -f local.properties ]]; then
  echo 'Android SDK missing: set ANDROID_HOME or configure sdk.dir in local.properties.' >&2
  exit 1
fi
./gradlew :app:assembleMadaniDebug :app:lintMadaniDebug testMadaniDebug testReleaseUnitTest verifySqlDelightMigration -PdisableFirebase --no-daemon
