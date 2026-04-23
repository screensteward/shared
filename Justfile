# Build and development commands for screensteward-shared.

default: help

help:
    @just --list

# Regenerate Dart + Python from .proto sources
generate:
    ./scripts/generate.sh

# Lint all sources
lint:
    cd dart && dart format --output=none --set-exit-if-changed .
    cd python && uv run ruff check .

# Run all tests (Dart + Python). Regenerates code first.
test: generate
    cd dart && dart test
    cd python && uv run pytest -v

# Clean generated code and build artifacts
clean:
    rm -rf dart/lib/src/generated python/src/screensteward_shared/generated
    rm -rf dart/.dart_tool dart/build
    rm -rf python/.pytest_cache python/build python/dist python/*.egg-info

# Install Dart deps
build-dart: generate
    cd dart && dart pub get

# Build Python wheel + sdist
build-python: generate
    cd python && uv build

# Publish Dart package (requires dart pub login)
publish-dart: build-dart
    cd dart && dart pub publish

# Publish Python package (requires PyPI token)
publish-python: build-python
    cd python && uv run twine upload dist/*

# Create/refresh the Python uv venv
sync:
    cd python && uv sync --extra dev
