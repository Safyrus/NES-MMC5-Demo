# CHANGELOG

The format of this CHANGELOG is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

This project try to follow the [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

-----------------

## **[0.2.0-2]** - _2022-07-05_

The _Real Level and tile animation_ update

### **Added**

- CHR textures:
  - 3 useless image :)
  - Water and path tiles.
  - Wooden shaft, log and gate tiles.
  - Change some tile location.
- Screen variables.
- A frame counter and an animation frame counter.
- 2 constant for animation (ANIM_BASE_SPD_MASK and ANIM_MAX_FRAME_MASK).

#### Global

- Nametable constants.

#### Data

- A real level with 3\*4 unique screens.
- More objects (forest, cliff, etc.).
- Size objects (path, water, and cliff).
- "INC_X" and "INC_Y" screen object to add 1 to future object positions.
- Object tiles to fit the new location in CHR.

#### Module

- The animation module.
- In world modules:
  - The RLE command can now be interpreted when loading a screen.
  - Subtype position objects can now be interpreted.
  - Subtype pos-size objects (or box object for now) can now be interpreted.
- In Control module:
  - A debug input (A or B) to align the scroll position with tiles.
  - Plan the animation module at a constant rate when in normal game state.

#### Vector

- An in-frame flag with the scanline IRQ that is set between scanline 1 to 232

### **Changed**

- CHR ROM size to 256 KB

#### Data

- Position objects into subtype position object.
- Palette 0.
- Screen object of type "fill random".

#### Module

- Scrolling now only take one nametable.
- In the control module:
  - When to load new screens during scrolling.
  - Priority of the "load screens" module.
- In the world module:
  - The seed in the "load_screen_one" function.
  - "load_screens" function to check if new screen has been ordered during his task and load them.
- In drawing modules:
  - Tiles (high or low) equal to 0 will be ignored when drawing an object.
  - Screen object of type "fill random" to have a base chance to place a random tile.
  - Change functions to also update the animation buffer when updating the screen.

### **Fixed**

- Crash due to a stack underflow when returning from NMI when interrupt occurred during main function.
- Crash due to too many modules being run because of running more than one loading screen module.
- Crash when pressing input during initial screens loading.
- Glitch tiles when scrolling into a partially loaded screen.
- Screen not loading when "skipping loading screen collision".

### **Removed**

- The dummy level

-----------------

## **[0.1.0]** - _2022-06-20_

The _Level and Scrolling_ update

### **Added**

#### Global

- NES Boilerplate features (<https://github.com/Safyrus/NES-Boilerplate-Game>).
- CHR texture (grass and tree)
- Main loop capable of running 'modules' (self contain code in a bank)
  and execute them by priority. (similar to a simple scheduler)

#### Data

- 1 world with 1 level (5\*5) with multiple basic screens.
- 4 palettes.
- 2 basic screen objects (one with post-process).
- 6 positional object (trees and bush).

#### Module

- A control module to know which other modules to run.
- Some scroll control functions in the control module.
- Multiple world modules:
  - A load level module.
  - A load screen module with:
    - A function to load all starting screens.
    - A function to load selected screen.
  - A draw object module.
  - A draw screen module with:
    - A function to draw an entire screen.
    - 4 functions to draw one column/row for each scroll direction.
  - Some utils subroutines to convert scroll position to various addresses.

#### Utils

- A PRNG functions and another function to read inputs from the NESdev wiki
  (<https://www.nesdev.org/wiki/Random_number_generator> and <https://www.nesdev.org/wiki/Controller_reading_code>)
- Some math functions (div, mod_sign, pwr_2).
- Other subroutines for address operation and conversion.
