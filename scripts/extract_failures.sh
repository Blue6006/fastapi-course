#!/usr/bin/env bash

set -euo pipefail
[[ -n "${DEBUG:-}" ]] && set -x

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_LOG="$REPO_ROOT/test_output.log"
EXTRACTED_DIR="$REPO_ROOT/tests/extracted"

cd "$REPO_ROOT"

echo "Running tests, output saved to $OUTPUT_LOG ..."
set +e
bash scripts/test.sh "$@" 2>&1 | tee "$OUTPUT_LOG"
TEST_EXIT=${PIPESTATUS[0]:-$?}
set -e

echo ""
echo "Parsing failed test files from $OUTPUT_LOG ..."

# Extract unique file paths from lines like:
#   FAILED tests/test_foo.py::SomeClass::test_name - ...
FAILED_FILES=()
while IFS= read -r line; do
    FAILED_FILES+=("$line")
done < <(sed $'s/\033\[[0-9;?]*[a-zA-Z]//g; s/\033]8;;[^\a]*\a//g' "$OUTPUT_LOG" | grep -Eo 'FAILED tests/[^:]+\.py' | sed 's/^FAILED //' | sort -u)

if [ ${#FAILED_FILES[@]} -eq 0 ]; then
    echo "No failed test files found."
    exit 0
fi

echo "Failed test files:"
printf '  %s\n' "${FAILED_FILES[@]}"

mkdir -p "$EXTRACTED_DIR"

for FILE in "${FAILED_FILES[@]}"; do
    SRC="$REPO_ROOT/$FILE"
    REL="${FILE#tests/}"
    DEST="$EXTRACTED_DIR/$REL"
    if [ -f "$SRC" ]; then
        mkdir -p "$(dirname "$DEST")"
        echo "Moving $FILE -> tests/extracted/$REL"
        mv "$SRC" "$DEST"
    else
        echo "Warning: $SRC not found, skipping."
    fi
done

echo ""
echo "Done. ${#FAILED_FILES[@]} file(s) moved to $EXTRACTED_DIR."
exit "$TEST_EXIT"
