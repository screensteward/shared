#!/usr/bin/env bash
# Regenerates Dart and Python code from .proto sources.
# Requires: protoc, protoc-gen-dart (via ~/.pub-cache/bin), uv.
#
# Usage:
#   generate.sh                 # Dart + Python
#   generate.sh --python-only   # Python only (skip Dart codegen)
#   generate.sh --dart-only     # Dart only (skip Python codegen)

set -euo pipefail

SKIP_DART=0
SKIP_PYTHON=0
for arg in "$@"; do
  case "$arg" in
    --python-only) SKIP_DART=1 ;;
    --dart-only)   SKIP_PYTHON=1 ;;
    *) echo "Unknown arg: $arg" >&2 ; exit 2 ;;
  esac
done

# Ensure protoc-gen-dart is on PATH (installed by `dart pub global activate protoc_plugin`)
export PATH="$HOME/.pub-cache/bin:$PATH"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DART_OUT="$ROOT/dart/lib/src/generated"
PYTHON_OUT="$ROOT/python/src/screensteward_shared/generated"

[ "$SKIP_DART" -eq 0 ] && { rm -rf "$DART_OUT"; mkdir -p "$DART_OUT"; }
[ "$SKIP_PYTHON" -eq 0 ] && { rm -rf "$PYTHON_OUT"; mkdir -p "$PYTHON_OUT"; }

shopt -s nullglob
PROTO_FILES=(proto/*.proto)
shopt -u nullglob
if [ ${#PROTO_FILES[@]} -eq 0 ]; then
  echo "No .proto files found in proto/. Nothing to generate."
  exit 0
fi

# Dart
if [ "$SKIP_DART" -eq 0 ]; then
  protoc \
    --dart_out="$DART_OUT" \
    --proto_path=proto \
    "${PROTO_FILES[@]}"
fi

# Python — grpc_tools.protoc runs inside the project uv venv
if [ "$SKIP_PYTHON" -eq 0 ]; then
  cd "$ROOT/python"
  uv run python -m grpc_tools.protoc \
    --python_out="$PYTHON_OUT" \
    --pyi_out="$PYTHON_OUT" \
    --proto_path="$ROOT/proto" \
    "${PROTO_FILES[@]/#/$ROOT/}"

  # Convert generated absolute imports (import family_pb2) to relative (from . import family_pb2)
  uv run python - <<'PY'
import pathlib, re
gen = pathlib.Path("src/screensteward_shared/generated")
for py in gen.glob("*_pb2.py"):
    text = py.read_text()
    fixed = re.sub(r'^import (\w+_pb2)', r'from . import \1', text, flags=re.MULTILINE)
    py.write_text(fixed)
PY

  cat > "$PYTHON_OUT/__init__.py" <<EOF
"""Generated protobuf modules. Do not edit by hand — regenerate via scripts/generate.sh."""
EOF
fi

[ "$SKIP_DART" -eq 0 ]   && echo "Generated Dart in $DART_OUT"
[ "$SKIP_PYTHON" -eq 0 ] && echo "Generated Python in $PYTHON_OUT"
