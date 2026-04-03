#!/bin/bash
# Concatenate Astrocade BIOS + cartridge ROM into one file
# BIOS must be first 8KB, cart follows
# Usage: ./build_rom.sh bios.bin cart.bin output.bin
cat "$1" "$2" > "$3"
echo "Created $3 ($(wc -c < "$3") bytes)"
echo "  BIOS: $(wc -c < "$1") bytes"
echo "  Cart: $(wc -c < "$2") bytes"
