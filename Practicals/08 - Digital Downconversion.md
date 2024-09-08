# Practical &ndash; Digital Downconversion

Prerequisite: Day 4 lectures

This practical increases the data rate of the injector and
implements the digital down-conversion.

![Local Block Diagram](DigitalDownconversion/SpectrumAnalyser.svg)

--------------------------------------------------------------------------------

## Task List

- Modify the injection module to inject 8-bit data at 100&nbsp;MSps
- Implement a complex NCO (100 MSps, 12-bit phase, 9-bit amplitude) and verify through simulation
- Implement a complex mixer (real input; complex output) and verify through simulation
- Ensure that the design meets timing requirements
- Use JTAG to control the NCO frequency (Your choice of Source-and-Probes, Virtual JTAG, JTAG to Avalon Bridge, etc.)
- Use injection data and mixer settings that result in low frequency components (<20 kHz) and display using the Oscilloscope

--------------------------------------------------------------------------------

