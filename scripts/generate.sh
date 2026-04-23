#!/usr/bin/env bash
# Regenerates Dart and Python code from .proto sources.
# Requires: protoc, protoc-gen-dart (via ~/.pub-cache/bin), uv.

set -euo pipefail

# Ensure protoc-gen-dart is on PATH (installed by `dart pub global activate protoc_plugin`)
export PATH="$HOME/.pub-cache/bin:$PATH"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DART_OUT="$ROOT/dart/lib/src/generated"
PYTHON_OUT="$ROOT/python/src/screensteward_shared/generated"

rm -rf "$DART_OUT" "$PYTHON_OUT"
mkdir -p "$DART_OUT" "$PYTHON_OUT"

shopt -s nullglob
PROTO_FILES=(proto/*.proto)
shopt -u nullglob
if [ ${#PROTO_FILES[@]} -eq 0 ]; then
  echo "No .proto files found in proto/. Nothing to generate."
  exit 0
fi

# Dart
protoc \
  --dart_out="$DART_OUT" \
  --proto_path=proto \
  "${PROTO_FILES[@]}"

# Python — grpc_tools.protoc runs inside the project uv venv
cd "$ROOT/python"
uv run python -m grpc_tools.protoc \
  --python_out="$PYTHON_OUT" \
  --pyi_out="$PYTHON_OUT" \
  --proto_path="$ROOT/proto" \
  "${PROTO_FILES[@]/#/$ROOT/}"

# Python imports relatifs : grpc_tools génère des imports absolus `import family_pb2`.
# On les convertit en imports relatifs pour fonctionner depuis le package.
uv run python - <<'PY'
import pathlib, re
gen = pathlib.Path("src/screensteward_shared/generated")
for py in gen.glob("*_pb2.py"):
    text = py.read_text()
    fixed = re.sub(r'^import (\w+_pb2)', r'from . import \1', text, flags=re.MULTILINE)
    py.write_text(fixed)
PY

# Create __init__.py for generated subpackage
cat > "$PYTHON_OUT/__init__.py" <<EOF
"""Generated protobuf modules. Do not edit by hand — regenerate via scripts/generate.sh."""
EOF

echo "Generated Dart in $DART_OUT"
echo "Generated Python in $PYTHON_OUT"
