#!/bin/sh
# Prints the core of by-the-book as context for the hook event named in $1.
core="$(dirname "$0")/core.md"
[ -f "$core" ] || exit 0
exec python3 -c 'import json, pathlib, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": sys.argv[1], "additionalContext": pathlib.Path(sys.argv[2]).read_text()}}))' "$1" "$core"
