# CHANGELOG

The format of this CHANGELOG is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

This project try to follow the [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

-----------------

## **[0.4.0-7]** - _2022-08-06_

### **Added**

#### Global

- A GIF of the demo in the README.
- Sprites draw buffer.
- 3 CHR ROM of 256K:
  - empty: just zeroes.
  - text: with a short compressed text.
  - ui: contain a font and 2 tiles for the dialog box borders.
- Some constants.
- Some variables (many about the dialog box).

#### Data

- Huffman code for each text characters.
- A little dictionary and the pointers for the 2 example dialogs.

#### Module

- A dialog module which:
  - Split the screen for x scanlines to the other VRAM screen and draw the (still compressed) text.
  - Functions to be able to read and process raw text data (load_raw_data, next_bit, next_char).
  - Add a function for each stage of the dialog box (init, clear, border, main, next, end)

#### Python

- empty_char.py: Generate an empty CHR ROM.
- encode.py: Encode a text file into binary using dictionary compression. Return dictionary as txt and asm.
- huffman_encode.py: Encode the dictionary compressed text into a Huffman form. Return char code and dialog pointer as txt and asm.
- decode.py: decode the Huffman compressed text and print the result.
- gen_lorem.py: generate a lorem ipsum text file.
- A bat file to run the 2 encoder scripts.

#### Vector

- NMI flag to read from PPU.
- The variable "nmi_mmc5_nametable" to set nametables before any NMI actions.

### **Changed**

#### Global

- Entity buffer by adding a state attribute.
- Refactor entity buffer.
- Sprite variables.
- CHR size to the max of 1024K (1M).
- Gitignore for python generated files.
- Some constants.

#### Data

- Player object data.
- Screen object to have the random mask.
- Last background palette in the level.
- Lower chance of random tile in the screen object.

#### Module

- Reorganize the code into more files.
- Move entity action into a separate module.
- Modules priority (tile_anim + 1, load_screens - 1)
- Refactor:
  - Screen fill objects loading mainly to not tell animating empty tiles
    and be faster for fill with no random.
  - How entities are loaded and drawn.
  - The "draw_player_move" function.
  - Screen draw function to also clear the second VRAM screen.
  - Sprites to be 8\*8 instead of 8\*16 (take less space in CHR)

#### Vector

- Refactor scanline IRQs to handle UI separation.
- NMI flags order.
- Reset to set attributes to last palette.

### **Removed**

- C part in Makefile.

### **Fixed**

- (Maybe ?) objects not being drawn at the correct location or having some wrong tiles.
- Reset not clearing the last RAM bank.
- Game state not waiting for the load level module to finished.
- The taskTime script drawing the graph too high when scanline was above 240.

-----------------

## **[0.3.0]** - _2022-07-21_

The _Player movements and collisions_ update

### **Added**

#### Global

- A Lua script to show the current loaded screens and another to show modules working time.
- An infinite loop that make the screen blink red if the game cannot access more than 32K of PRG RAM.
- Entity buffers and 3 other variables (sprite_banks, global_entity_spr_counter and entity_load_counter).
- Some constants (RAM_MAX_BNK, PRGRAM_SPR_BANK, SCANLINE_BOT, SCANLINE_TOP and SCANLINE_MID).
- A macro (res_entity_buf).
- A basic player texture in CHR.

#### Data

- A player entity that can move and control the scroll.
- 1 player entity in the first screen of the level.

#### Module

- A function to load global entity with a position.
- In control module:
  - 4 functions "check_scroll_XXX" to check if the player can move in each direction.
    It is also checking if the front tile has a collision.
  - Functions to get and set the player position.
  - A "draw_player_move" function to update the animation of the player.
  - A "setScroll2PlayerPos" subroutine to help with collisions.
- A new module "draw_global_sprites" that draw global entities on the screen.

#### Utils

- New operations: dec_tmp, sub_tmp and sub_16 (16 bits sub).

### **Changed**

#### Global

- Makefile and MMC5_Demo_mmc5.cfg file.
- Update [README](README.md).
- PRG RAM to 64K (_if the game blink red, check the [README](README.md)_).
- Maximum number of lower module to 8 and maximum priority to 4.
- Change BTN_TIMER to 8.
- Enable sprites.
- In CHR ROM:
  - Water tiles.
  - All tiles position to fit the collision system.

#### Data

- The level sprite palettes and add sprite banks data to fit the new level structure.
- All object tiles to fit the collision system.

#### Module

- Modules priority.
- Object pos-size code to another file.
- Draw object function to also "draw" (load) entities.
- Move "scroll2scrBufAdr" out of the world module.
- Control module by:
  - Making the input subroutine run by the player entity and not the control module anymore.
  - Ticking global entity and run the "draw global entity" module.
  - Refactoring "input" function to "player_input".
  - Changing scroll functions to take into account player position and update its position and sprites.
- In loading modules:
  - The loading screen module to load entities and reset the screen entity buffers.
  - The loading level to load the level sprite banks and reset global entity buffer.

#### Vector

- Scanline IRQs to:
  - Use the new constants.
  - Hide the first row of tiles instead of the last one.
  - Hide sprites for the first row of tiles.
  - Bottom scanline state to be after scanline 232 instead of 239.
- Reset to enable 8*16 sprite and 1K CHR mode.
- NMI to disable sprites (will be reactivated by scanline IRQs).

### **Fixed**

- Random tile animation being wrong for 1 frame (due to writing to extended RAM when not in-frame).
- Blinking screen (due to checking the in-frame flag of the MMC5 register and clearing the scanline IRQ at the same time).
- Draw sprite module being call too many times.
- Maybe fix a potential bug if the frame ends just after a MMC5 bank switch and just before recording it to last_frame_BNK variable.
- An incorrect index to last_frame_BNK in function "mdl_world_load_screen_one".
- Incorrect level loading when drawing sprites because of MMC5 multiplication registers not being restored after returning to module
  (fix by not doing the multiplication at the end of the frame and wait for next frame).
- Player position offset when moving between screens in scroll functions.
- Incorrect bank when returning from entity action.

-----------------

## **[0.2.0]** - _2022-07-05_

The _Real Level and tile animation_ update

### **Added**

#### Global

- CHR textures:
  - 3 useless image :)
  - Water and path tiles.
  - Wooden shaft, log and gate tiles.
  - Change some tile location.
- Screen variables.
- A frame counter and an animation frame counter.
- 2 constant for animation (ANIM_BASE_SPD_MASK and ANIM_MAX_FRAME_MASK).
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
