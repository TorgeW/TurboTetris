markdown
# Turbo Tetris

A simple **Tetris** implementation written in **x86 Assembly** for the **DOS operating system**. This project demonstrates low-level programming techniques and classic DOS graphics and sound handling using Turbo Assembler.

## Features

- Classic Tetris gameplay
- Written entirely in x86 Assembly
- Runs in DOSBox for modern compatibility
- Lightweight and easy to understand

## Prerequisites

To build and run this project, you will need:

- Turbo Assembler (TASM)
- DOSBox or any DOS emulator

## Build Instructions

1. Open DOSBox and mount your project directory:

   ```dos
   mount C C:\path\to\TurboTetris
   C:
   ```

2. Assemble the source code using Turbo Assembler:

   ```dos
   TASM TT.asm
   ```

   This will generate an executable file `TT.EXE`.


## Run Instructions

Within DOSBox, simply run:

```dos
TT
```

You should see the Tetris game launch in the DOS environment.
