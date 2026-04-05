#!/bin/bash
set -euo pipefail

# Legacy helper name, but the Pocket core now expects separate BIOS and
# cartridge slots. This script creates an APF instance JSON that binds both.
#
# Usage: ./build_rom.sh boot.rom game.bin Astrocade.json

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <bios-path> <cart-path> <output-instance.json>" >&2
  exit 1
fi

python3 - "$1" "$2" "$3" <<'PY'
import json
import sys

bios_path, cart_path, output_path = sys.argv[1:4]

instance = {
    "instance": {
        "magic": "APF_VER_1",
        "data_slots": [
            {"id": 0, "filename": bios_path},
            {"id": 1, "filename": cart_path},
        ],
    }
}

with open(output_path, "w", encoding="utf-8") as handle:
    json.dump(instance, handle, indent=2)
    handle.write("\n")
PY

echo "Created $3"
echo "  BIOS slot: $1"
echo "  Cart slot: $2"
