#!/bin/sh

set -e
# shellcheck disable=SC3040
set -o pipefail || :

MYDIR="$(cd "$(dirname -- "$0")"; echo "$PWD")"
cd "$MYDIR/public"

find -- */* -name index.html | sed -e 's,/.*$,,' | sort -u | while read -r project; do
  cd "$project" >/dev/null

  rm -f latest
  latest="$(find -- * -maxdepth 0 | grep -v -E -- "-SNAPSHOT$" | sort -u -V | tail -n 1)"
  ln -s "${latest}" latest
  echo "$project: $latest"

  cd - >/dev/null
done
