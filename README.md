# UART_with_FIFO_buffer
This project explores a UART (Universal Asynchronous Receiver/Transmitter) design written in Verilog HDL, with FIFO buffering and parity-related logic.
The documented design is intended to demonstrate parallel-to-serial data transmission, buffering, and basic parity error detection concepts.
The source code and testbench in this repository were extracted and formatted from the project's report, Sections 5.3 and 5.4.
Design Summary
The documented RTL contains:
- A top-level module named uart_with_fifo_parity
- An 8-bit input data interface
- Write and read enable signals
- A four-entry, 8-bit FIFO array
- A serial transmit output (tx)
- A data output (data_out)
- A parity error output (parity_error)
The transmitter logic forms a serial sequence containing a start bit, eight data bits, a parity bit, and a stop/idle bit. The report describes this as an 11-bit UART frame.
Testbench
The testbench is named tb_uart_with_fifo_parity. It generates a clock, applies reset, writes example bytes, toggles the read enable, monitors output signals, and includes a force/release operation on the transmit parity register to exercise the parity-related logic.
The testbench is stimulus-based; it does not contain comprehensive self-checking assertions.
Tools
The project report identifies the following tools and technologies:
- Verilog HDL
- Xilinx Vivado
Running a Simulation
Using Xilinx ISE/Vivado
1. Create or open a Verilog project.
2. Add design/uart_with_fifo_parity.v as a design source.
3. Add tb/tb_uart_with_fifo_parity.v as a simulation source.
4. Set tb_uart_with_fifo_parity as the simulation top module.
5. Run behavioral simulation and inspect data_out, tx, and parity_error in the waveform viewer.
This repository contains a cleaned and formatted extraction of the RTL documented in the project report; it has not been independently verified as a correct UART implementation.
Known concerns in the documented source include:
- The count register is assigned in two separate clocked processes, which may lead to conflicting FIFO count behavior.
- The parity-related block does not implement a conventional serial receiver that samples the tx line.
- The RTL does not clearly implement a separate receive FIFO.
- The testbench uses waveform monitoring and stimulus but does not comprehensively check expected outputs.
- The testbench's internal force/release of a design register is simulator-specific and should not be treated as a normal external verification interface.
Simulation results should therefore be treated as exploratory until these issues are reviewed and the design is corrected and tested.
Possible Future Improvements
- Separate FIFO control logic from transmitter and receiver control logic.
- Implement explicit FIFO full and empty flags.
- Implement a receiver FSM that detects the start bit and samples serial data at the configured baud rate.
- Add a distinct RX FIFO if receive buffering is required.
- Define parity behavior clearly and test both matching and mismatching parity cases.
- Replace internal force/release testing with controllable testbench-level serial stimulus.
- Add self-checking tests for data transfer, FIFO boundaries, reset behavior, and parity error cases.
Project Context
This is an academic Verilog HDL project titled “UART with FIFO Buffer and Parity Error Detection.” The repository documents the implementation as presented in the supplied project report and explicitly records limitations that should be resolved before describing the design as fully verified.
