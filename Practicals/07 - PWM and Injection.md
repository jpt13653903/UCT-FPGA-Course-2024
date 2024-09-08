# Practical &ndash; PWM and Data Injection

Prerequisite: Day 4 lectures

This practical implements the PWM and data injection modules.

![Local Block Diagram](PWMandInjection/SpectrumAnalyser.svg)

--------------------------------------------------------------------------------

## PWM Module

- Write a PWM module (optionally with noise shaping) Use a 100&nbsp;MHz master clock and 390.625&nbsp;kHz PWM (8-bit)
- Simulate the PWM module to verify functionality

--------------------------------------------------------------------------------

## Simple Injection Module

- Pre-load a RAM block (1024 &times; 8-bit) with a MIF file (Generated by Python / Octave / Matlab / Excel / etc.)
- Play back the RAM block data through the PWM module; Inject at 48.828&nbsp;125&nbsp;kSps

![Simple Audio Player (1)](PWMandInjection/AudioPlayer_Simple1.svg)

--------------------------------------------------------------------------------

## SDRAM Injection Module

- Move data injection to the external memory
- Use the RAM block as a FIFO cache

![Simple Audio Player (2)](PWMandInjection/AudioPlayer_Simple2.svg)

- Add the provided `VirtualJTAG_MM_Write.v` module to the project and create an instance in the top-level entity
- Connect the Avalon interface of this module to the `Master` interface of the Qsys instance
- Use the provided "CreateData.m" Matlab script to create test data files
- Use the provided "WriteData.tcl" TCL script to load data into the memory (the transfer takes between 2 and 5 minutes &ndash; it is useful to display the high bits of the SDRAM address on the LEDs as a progress indication)
- Read the source code of these 3 parts and make sure you understand what each does &ndash; ask if you don't
- You can use the same QSys `Master` interface to read the SDRAM, but make sure that you never try to read and write at the same time.

--------------------------------------------------------------------------------

## Audio Player

You now have all the infrastructure in place to make an audio player.

![Audio Player](PWMandInjection/AudioPlayer.svg)

--------------------------------------------------------------------------------
