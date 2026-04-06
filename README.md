# [Bally Astrocade](https://en.wikipedia.org/wiki/Bally_Astrocade) for MiSTer Platform

### This is an FPGA implementation of the Bally Astrocade based on a project by MikeJ.

## Features
 * Supports full keypad.
 * Supports paddle control as analog stick.

## Installation
Copy the Astrocade_\*.rbf file to the root of the SD card. Create an **Astrocade** folder on the root of the card, and place Astrocade roms (\*.BIN) inside this folder. Search the web for a copy of the Bally Astrocade BIOS and rename it **boot.rom** and then place it in the **Astrocade** folder. Use the keyboard to select the game if prompted.

For the Analogue Pocket build, load the BIOS and cartridge as separate files:

* Slot `BIOS`: `boot.rom` in `/Assets/astrocade/common` (`.rom`/`.bin`, 8KB max)
* Slot `Cartridge`: game ROM (`.rom`/`.bin`, 8KB max)

If you want one launchable Pocket instance that pre-selects both files, run `pocket/build_rom.sh boot.rom GAME.bin Astrocade.json` and place the generated instance JSON alongside the referenced files on the SD card.

To stage the current Pocket package onto an SD card root after rebuilding the FPGA bitstream, run `pocket/stage_core.sh path/to/Astrocade_Pocket.rbf /path/to/SD_ROOT`. That copies the current `core.json`, `data.json`, `input.json`, `video.json`, and platform metadata together with a freshly generated `bitstream.rbf_r`.

Default Pocket controls:

* D-pad: joystick directions
* `A`: trigger
* `B`: `CH`
* `X`: `C`
* `Y`: `CE`
* `L`: keypad `1`
* `R`: keypad `2`
* `Select`: keypad `3`
* `Start`: keypad `4`

## Astrocade Controls
The Astrocade had a very unusual controller. It was a gun-grip style handle with a joystick on the top, which had an integrated pot switch serving as a paddle control. This translates poorly to modern controllers. MiSTer only offers analog data for the first two axes of the controller, which is most often the left analog stick. For games which require paddle controls, directional movement, and the trigger button used together, I suggest mapping the controller such that the right analog stick is dpad motion, one of the shoulder buttons is the trigger button, and the left analog stick is the paddle.

## Cart Expansions
No cart expansions are implemented at this time.

## Known Issues
The video timings of the Astrocade seem to create problems with the first and last lines of each field. This seems to work okay on actual CRTs, but scandoublers like OSSC may be confused by it.
