#!/bin/sh

set -e
# shellcheck disable=SC3040
set -o pipefail || :

MYDIR="$(cd "$(dirname -- "$0")"; echo "$PWD")"
cd "$MYDIR/public"

find -- */* -name index.html | sed -e 's,/.*$,,' | sort -u | while read -r project; do
  echo "Processing $project"
  cd "$project" >/dev/null
  
  rm -f latest
  if [ -z "$(find -- * -maxdepth 0 | grep -v -E -- "-SNAPSHOT$")" ]; then
    latest="$(find -- * -maxdepth 0 | sort -u -V | tail -n 1)"
  else
    latest="$(find -- * -maxdepth 0 | grep -v -E -- "-SNAPSHOT$" | sort -u -V | tail -n 1)"
  fi
  ln -s "${latest}" latest
  echo "Created latest link for $project and it points to $latest"

  cd - >/dev/null
done

