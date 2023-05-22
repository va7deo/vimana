
# Toaplan (Vimana) FPGA Implementation

FPGA compatible core of Toaplan Version 1 arcade hardware for [**MiSTerFPGA**](https://github.com/MiSTer-devel/Main_MiSTer/wiki) written by [**Darren Olafson**](https://twitter.com/Darren__O). Based on schematics and verified against Vimana (TP-019).

The intent is for this core to be a 1:1 implementation of Toaplan V1 hardware. Currently in beta state, this core is in active development with assistance from [**atrac17**](https://github.com/atrac17).


## Supported Titles

| Title                                                               | PCB<br>Number | Status      | Released | ROM Set     |
|---------------------------------------------------------------------|---------------|-------------|----------|-------------|
| [**Same! Same! Same!**](https://en.wikipedia.org/wiki/Fire_Shark  ) | TP-017        | Implemented | No       | .254 merged |
| [**Vimana**](https://en.wikipedia.org/wiki/Vimana_%28video_game%29) | TP-019        | Implemented | No       | .254 merged |

## External Modules

| Module                                                                                | Function                                                                    | Author                                         |
|---------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|------------------------------------------------|
| [**fx68k**](https://github.com/ijor/fx68k)                                            | [**Motorola 68000 CPU**](https://en.wikipedia.org/wiki/Motorola_68000)      | Jorge Cwik                                     |
| [**tms320c1x**](https://github.com/srg320/TMS320C1X)                                  | [**Texas Instruments TMS320 DSP**](https://en.wikipedia.org/wiki/Zilog_Z80) | srg320                                         |
| [**t80**](https://opencores.org/projects/t80)                                         | [**Zilog Z80 CPU**](https://en.wikipedia.org/wiki/Zilog_Z80)                | Daniel Wallner                                 |
| [**jtopl2**](https://github.com/jotego/jtopl)                                         | [**Yamaha OPL2**](https://en.wikipedia.org/wiki/Yamaha_OPL#OPL2)            | Jose Tejada                                    |
| [**yc_out**](https://github.com/MikeS11/MiSTerFPGA_YC_Encoder)                        | [**Y/C Video Module**](https://en.wikipedia.org/wiki/S-Video)               | Mike Simone                                    |
| [**mem**](https://github.com/MiSTer-devel/Arcade-Rygar_MiSTer/tree/master/src/mem)    | SDRAM Controller / Rom Downloader                                           | Josh Bassett, modified by Darren Olafson       |
| [**core_template**](https://github.com/MiSTer-devel/Template_MiSTer)                  | MiSTer Framework Template                                                   | sorgelig, modified by Darren Olafson / atrac17 |

# Known Issues / Tasks

- [**OPL2 Audio**](https://github.com/jotego/jtopl/issues/11)  **[Issue]**  
- Timing issues with jtframe_mixer module; false paths added to sdc (may need refactor?)  **[Task]**  
- Attempt usage of y80e core for HD647180X CPU  **[Task]**  

# PCB Check List

### Clock Information

| H-Sync       | V-Sync      | Source    | PCB<br>Number |
|--------------|-------------|-----------|---------------|
| 15.556938kHz | 57.612182Hz | DSLogic + | TP-019        |

### Crystal Oscillators

| Freq (MHz) | Use                                                            |
|------------|----------------------------------------------------------------|
| 10.00      | M68000 CLK (10 MHz)                                            |
| 28.000     | Z80 CLK (3.5 MHz)<br>YM3812 CLK (3.5 MHz)<br>Pixel CLK (7 MHz) |

**Pixel clock:** 7.00 MHz

**Estimated geometry:**

_(Horror Story)_

    450 pixels/line  
  
    270 lines/frame  

### Main Components

| Chip                                                                   | Function         | Alternate Chip                          |
| -----------------------------------------------------------------------|------------------|-----------------------------------------|
| [**Motorola 68000 CPU**](https://en.wikipedia.org/wiki/Motorola_68000) | Main CPU         | N/A                                     |
| [**Zilog Z80 CPU**](https://en.wikipedia.org/wiki/Zilog_Z80)           | Sound CPU        | In lieu of HD647180X for sound playback |
| [**Yamaha YM3812**](https://en.wikipedia.org/wiki/Yamaha_OPL#OPL2)     | OPL2 Audio       | N/A                                     |

### Custom Components

| Chip                                             | Function           |
| -------------------------------------------------|--------------------|
| **NEC D65081R077**                               | Custom Gate-Array  |
| **FCU-02**                                       | Sprite RAM         |
| **FDA MN53007T0A / TOAPLAN-02 M70H005 / GXL-02** | Sprite Counter     |
| **BCU-02**                                       | Tile Map Generator | <br>

### Additional Components

| Chip                                                      | Function                 | PCB<br>Number        | Status          |
|-----------------------------------------------------------|--------------------------|----------------------|-----------------|
| [**HD647180X**](https://en.wikipedia.org/wiki/Zilog_Z180) | Sound CPU & I/O Handling | **TP-017<br>TP-019** | Not Implemented |

# Core Features

### Refresh Rate Compatibility Option

- Video timings can be modified if you experience sync issues with CRT or modern displays; this will alter gameplay from it's original state.

| Refresh Rate      | Timing Parameter     | HTOTAL | VTOTAL |
|-------------------|----------------------|--------|--------|
| 15.56kHz / 57.6Hz | TP-019               | 450    | 270    |
| 15.73kHz / 59.8Hz | NTSC                 | 445    | 264    |

### P1/P2 Input Swap Option

- There is a toggle to swap inputs from Player 1 to Player 2. This only swaps inputs for the joystick, it does not effect keyboard inputs.

### Audio Options

- There is a toggle to disable playback of OPL2 audio.

### Overclock Options

- There is a toggle to increase the M68000 frequency from 10MHz to 17.5MHz; this will alter gameplay from it's original state.

### Native Y/C Output

- Native Y/C ouput is possible with the [**analog I/O rev 6.1 pcb**](https://github.com/MiSTer-devel/Main_MiSTer/wiki/IO-Board). Using the following cables, [**HD-15 to BNC cable**](https://www.amazon.com/StarTech-com-Coax-RGBHV-Monitor-Cable/dp/B0033AF5Y0/) will transmit Y/C over the green and red lines. Choose an appropriate adapter to feed [**Y/C (S-Video)**](https://www.amazon.com/MEIRIYFA-Splitter-Extension-Monitors-Transmission/dp/B09N19XZJQ) to your display.

### H/V Adjustments

- There are two H/V toggles, H/V-sync positioning adjust and H/V-sync width adjust. Positioning will move the display for centering on CRT display. The sync width adjust can be used to for sync issues (rolling) without modifying the video timings.

### Scandoubler Options

- Additional toggle to enable the scandoubler without changing ini settings and new scanline option for 100% is available, this draws a black line every other frame. Below is an example.

<table><tr><th>Scandoubler Fx</th><th>Scanlines 25%</th><th>Scanlines 50%</th><th>Scanlines 75%</th><th>Scanlines 100%</th><tr><td><br> <p align="center"><img width="160" height="120" src="FILL"></td><td><br> <p align="center"><img width="160" height="120" src="FILL"></td><td><br> <p align="center"><img width="160" height="120" src="FILL"></td><td><br> <p align="center"><img width="160" height="120" src="FILL"></td><td><br> <p align="center"><img width="160" height="120" src="FILL"></td></tr></table> <br>

# PCB Information / Control Layout

| Title                 | Joystick | Service Menu                                                                                                 | Dip Switches                                                                                              | Shared Controls | Dip Default | PCB Information |
|-----------------------|----------|--------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|-----------------|-------------|-----------------|
| **Same! Same! Same!** | 8-Way    | [**Service Menu**](FILL) | [**Dip Sheet**](FILL) | No              | N/A         | WIP             |
| **Vimana**            | 8-Way    | [**Service Menu**](FILL) | [**Dip Sheet**](FILL) | No              | N/A         | WIP             |

<br>

- Push button 3 may have no function in game, but corresponds to the original hardware and service menu.<br><br>

### Keyboard Handler

<br>

- Keyboard inputs mapped to mame defaults for Player 1 / Player 2.

<br>

| Services                                                                                                                                                                                           | Coin/Start                                                                                                                                                                                              |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>Test</td><td>F2</td></tr><tr><td>Reset</td><td>F3</td></tr><tr><td>Service</td><td>9</td></tr><tr><td>Pause</td><td>P</td></tr> </table> | <table><tr><th>Functions</th><th>Keymap</th><tr><tr><td>P1 Start</td><td>1</td></tr><tr><td>P2 Start</td><td>2</td></tr><tr><td>P1 Coin</td><td>5</td></tr><tr><td>P2 Coin</td><td>6</td></tr> </table> |

| Player 1                                                                                                                                                                                                                                                                                                                                      | Player 2                                                                                                                                                                                                                                                                                                              |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>P1 Up</td><td>Up</td></tr><tr><td>P1 Down</td><td>Down</td></tr><tr><td>P1 Left</td><td>Left</td></tr><tr><td>P1 Right</td><td>Right</td></tr><tr><td>P1 Bttn 1</td><td>L-CTRL</td></tr><tr><td>P1 Bttn 2</td><td>L-ALT</td></tr><tr><td>P1 Bttn 3</td><td>Space</td></tr> </table> | <table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>P2 Up</td><td>R</td></tr><tr><td>P2 Down</td><td>F</td></tr><tr><td>P2 Left</td><td>D</td></tr><tr><td>P2 Right</td><td>G</td></tr><tr><td>P2 Bttn 1</td><td>A</td></tr><tr><td>P2 Bttn 2</td><td>S</td></tr><tr><td>P2 Bttn 3</td><td>Q</td></tr> </table> |

# Acknowledgments

Thank you to the following below who loaned hardware used during development:<br>

[**@90s_cyber_thriller**](https://www.instagram.com/90s_cyber_thriller/) for loaning Vimana (TP-019)<br>

# Support

Please consider showing support for this and future projects via [**Darren's Ko-fi**](https://ko-fi.com/darreno) and [**atrac17's Patreon**](https://www.patreon.com/atrac17). While it isn't necessary, it's greatly appreciated.<br>

# Licensing

Contact the author for special licensing needs. Otherwise follow the GPLv2 license attached.
