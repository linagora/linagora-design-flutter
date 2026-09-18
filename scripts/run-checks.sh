#!/usr/bin/env bash

set -Eeuo pipefail

report_command_failure() {
  local exit_code="$1"
  local line_number="$2"
  local command="$3"

  printf \
    'Command failed at line %s with exit code %s: %s\n' \
    "$line_number" \
    "$exit_code" \
    "$command" \
    >&2
  exit "$exit_code"
}

trap 'report_command_failure "$?" "$LINENO" "$BASH_COMMAND"' ERR

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
package_directories=()

while IFS= read -r -d '' pubspec; do
  package_directories+=("${pubspec%/pubspec.yaml}")
done < <(
  find "$project_root" \
    \( -type d \( \
      -name .dart_tool -o \
      -name .git -o \
      -name .symlinks -o \
      -name build -o \
      -name ephemeral \
    \) -prune \) -o \
    \( -type f -name pubspec.yaml -print0 \)
)

if (( ${#package_directories[@]} == 0 )); then
  echo 'No Flutter packages found.'
  exit 1
fi

relative_directory() {
  local package_directory="$1"

  if [[ "$package_directory" == "$project_root" ]]; then
    echo '.'
  else
    echo "${package_directory#"$project_root"/}"
  fi
}

for package_directory in "${package_directories[@]}"; do
  package_name="$(relative_directory "$package_directory")"
  analysis_paths=()

  if [[ -d "$package_directory/lib" ]]; then
    analysis_paths+=(lib)
  fi
  if [[ -d "$package_directory/test" ]]; then
    analysis_paths+=(test)
  fi
  if (( ${#analysis_paths[@]} == 0 )); then
    analysis_paths+=(.)
  fi

  echo "Analyzing $package_name"

  if (
    cd "$package_directory"
    flutter analyze --no-fatal-infos "${analysis_paths[@]}"
  ); then
    echo "Analysis passed in $package_name"
  else
    exit_code="$?"
    printf \
      'Analysis failed in %s with exit code %s. See the Flutter output above for details.\n' \
      "$package_name" \
      "$exit_code" \
      >&2
    exit "$exit_code"
  fi
done

for package_directory in "${package_directories[@]}"; do
  if [[ ! -d "$package_directory/test" ]]; then
    continue
  fi

  package_name="$(relative_directory "$package_directory")"
  echo "Running tests in $package_name"

  if (
    cd "$package_directory"
    flutter test --reporter expanded
  ); then
    echo "Tests passed in $package_name"
  else
    exit_code="$?"
    printf \
      'Tests failed in %s with exit code %s. See the Flutter output above for the failing test and stack trace.\n' \
      "$package_name" \
      "$exit_code" \
      >&2
    exit "$exit_code"
  fi
done
