# **NES MMC5 Demo**

A demo to test and show features that could be integrated in a NES game using the MMC5 chip.

----------------

## Compile

`make`

----------------

## Run

`make run_a`


**Important**: Because this demo use more than 32K of PRG RAM and none of the ExROM boards was made with this amount of RAM,
**Some emulator may not be able to run the demo**. The game will stop and blink red if it cannot access more than 32K of RAM.

----------------

### FCEUX emulator

FCEUX can natively emulate a MMC5 with more than 32K of RAM and will run the demo without problems.

FCEUX download link: <https://fceux.com/web/download.html>

----------------

### Mesen emulator

If you want to use Mesen for his debugging capability. You can still use it by "making some modification". For this, you will need to:

1. Download the source of Mesen-X (fork of Mesen and most up-to-date version that I am aware of): <https://github.com/NovaSquirrel/Mesen-X>
2. Follow the instruction on how to compile Mesen: <https://github.com/NovaSquirrel/Mesen-X/blob/master/COMPILING.md>
3. Change some lines of code in the file named "MMC5.h" located in the "Core" folder:

    - Change line 80 from:

        ```c++
        bankNumber &= 0x07;
        ```

        to:

        ```c++
        bankNumber &= 0x0F;
        ```

    - Change around line 100 from:

        ```c++
        if(realSaveRamSize + realWorkRamSize != 0x4000 && bankNumber >= 4) {
            //When not 2x 8kb (=16kb), banks 4/5/6/7 select the empty socket and return open bus
            accessType = MemoryAccessType::NoAccess;
        }
        ```

        to:

        ```c++
        // if(realSaveRamSize + realWorkRamSize != 0x4000 && bankNumber >= 4) {
        //  //When not 2x 8kb (=16kb), banks 4/5/6/7 select the empty socket and return open bus
        //  accessType = MemoryAccessType::NoAccess;
        // }
        ```

4. Recompile Mesen and if everything was done correctly, the demo should not blink red anymore and start normally.
