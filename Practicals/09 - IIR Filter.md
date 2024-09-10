# Practical &ndash; IIR Filter and Energy Counter

Prerequisite: Day 5 lectures

This practical implements the infinite impulse response filter.

![Local Block Diagram](IIR_Filter/SpectrumAnalyser.svg)

--------------------------------------------------------------------------------

## Task List

- Design the IIR filter in Matlab / Python / Whatever (pay careful attention to potential rounding errors and the resolution required)
- Implement the IIR filter on the 781.25&nbsp;kSps clock
- Verify by means of simulation (use cut-off frequencies of 10&nbsp;Hz, 100&nbsp;Hz, 1&nbsp;kHz, 10&nbsp;kHz and 100&nbsp;kHz)
- Integrate the IIR filter into the system (simulate the FIR filter's decimation by simply re-sampling the 100&nbsp;MSps data into the 781.25&nbsp;kHz clock domain)
- Implement the energy-counter module (verify through simulation)
- Implement a control module to automatically sweep the NCO frequency and generate a "start-of-sweep" pulse for use as the oscilloscope trigger
- Control the system by means of registers (Your choice of Source-and-Probes, Virtual JTAG, JTAG to Avalon Bridge, etc.)

--------------------------------------------------------------------------------

## Notes

- To get the IIR filter to work at low pass-band frequencies, you need LARGE internal word-lengths
- Be careful with overflows &ndash; perform a limit operation
- Be careful when working with signed numbers; Verilog defaults to unsigned unless ALL operants are signed
- To help you keep track of what bit represents what in fixed-point representations, use negative indices:

```systemverilog
// Constants are in the range [0, 2), but
// Verilog still thinks they're unsigned integers
wire [0:-32]B = 33'd8_589_446_092;
// Internal registers are in the range [-1, 1)
reg  [0:-39]y_1;
// Products are in the range [-2, 2)
wire [1:-71]B_y_1;
```

--------------------------------------------------------------------------------

## IIR Filter Testing

### ADC Test (Optional)

![ADC_Test](IIR_Filter/ADC_Test.svg)

![ADC_Test2](IIR_Filter/ADC_Test2.svg)

The MAX10 FPGA has a built-in multi-channel ADC.  Create an IP instance of the
ADC (use the "ADC control core only" option in the IP wizard parameters).

The DE10-Lite board includes a dedicated 10 MHz clock to be used for the ADC.
It also includes an external 2.5 V reference. Include the temperature sensor
when enabling the channels.

You'll need to write a controller that issues commands to the ADC core and
routes the results to the appropriate data stream.

### Injection Test

- $f_s$ = 781.25 kHz
- $x$ = 60 kHz square wave (injected or NCO)
- Make the resolution bandwidth 2&nbsp;kHz (1&nbsp;kHz low-pass filter)
- Sweep the complex NCO from DC to 360&nbsp;kHz

--------------------------------------------------------------------------------

