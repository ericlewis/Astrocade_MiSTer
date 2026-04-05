#!/bin/bash
set -euo pipefail

# Stage the current Pocket core package onto an SD card root or local staging
# directory. This keeps the bitstream and JSON metadata in sync.
#
# Usage:
#   ./pocket/stage_core.sh <input.rbf> <output-root>
#
# Example:
#   ./pocket/stage_core.sh output_files/Astrocade_Pocket.rbf /Volumes/POCKET

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input.rbf> <output-root>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INPUT_RBF="$1"
OUTPUT_ROOT="$2"

CORE_SRC_DIR="$REPO_ROOT/pkg/Cores/ericlewis.Astrocade"
PLATFORM_SRC_DIR="$REPO_ROOT/pkg/Platforms"
CORE_DST_DIR="$OUTPUT_ROOT/Cores/ericlewis.Astrocade"
PLATFORM_DST_DIR="$OUTPUT_ROOT/Platforms"

mkdir -p "$CORE_DST_DIR" "$PLATFORM_DST_DIR"

cp "$CORE_SRC_DIR"/*.json "$CORE_DST_DIR"/
cp "$PLATFORM_SRC_DIR"/astrocade.json "$PLATFORM_DST_DIR"/

python3 "$SCRIPT_DIR/reverse_bitstream.py" "$INPUT_RBF" "$CORE_DST_DIR/bitstream.rbf_r"

echo "Staged core package to $OUTPUT_ROOT"
echo "  Core metadata: $CORE_DST_DIR"
echo "  Platform metadata: $PLATFORM_DST_DIR"
echo "  Bitstream: $CORE_DST_DIR/bitstream.rbf_r"
