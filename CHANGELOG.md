# CHANGELOG

The format of this CHANGELOG is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

This project try to follow the [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
