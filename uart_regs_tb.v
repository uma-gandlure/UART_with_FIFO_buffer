`timescale 1us/1ns

module uart_regs_tb;
  reg clk = 0, rst = 0;
  reg wr_i, rd_i;
  reg rx_fifo_empty_i;
  reg [7:0] rx_fifo_data_in;
  reg [2:0] addr_i;
  reg [7:0] din_i;

  reg rx_overrun_err, rx_parity_err, rx_framing_err, rx_break_int;
  wire tx_fifo_push;
  wire rx_fifo_pop;
  wire baud_pulse_out;
  wire tx_fifo_reset, rx_fifo_reset;
  wire [3:0] rx_fifo_threshold;
  wire [7:0] data_out;

  uart_regs uut (clk, rst, wr_i, rd_i, rx_fifo_empty_i, rx_overrun_err, rx_parity_err, rx_framing_err, rx_break_int, addr_i, din_i, rx_fifo_data_in, tx_fifo_push, rx_fifo_pop, baud_pulse_out, tx_fifo_reset, rx_fifo_reset, rx_fifo_threshold, data_out);

  always #5 clk = ~clk;

  initial
  begin
    rst = 1;
    wr_i = 0; rd_i = 0;
    rx_fifo_empty_i = 1;
    rx_overrun_err = 0;
    rx_parity_err = 0;
    rx_framing_err = 0;
    rx_break_int = 0;
    rx_fifo_data_in = 8'h00;
    repeat(5) @(posedge clk);
    rst = 0;

    // try to write to baud rate divisor latches

    // enable divisor latches
    @(negedge clk);
    wr_i = 1;
    addr_i = 3'h3;
    din_i = 8'b1000_0000;

    @(negedge clk);
    wr_i = 0;

    // update divisor latch lsb
    @(negedge clk);
    wr_i = 1;
    addr_i = 3'h0;
    din_i = 8'b0000_1000;

    @(negedge clk);
    wr_i = 0;

    // update divisor latch msb
    @(negedge clk);
    wr_i = 1;
    addr_i = 3'h1;
    din_i = 8'b0000_0001;

    @(negedge clk);
    wr_i = 0;

    // disable divisor latches
    @(negedge clk);
    wr_i = 1;
    addr_i = 3'h3;
    din_i = 8'b0000_0000;

    @(negedge clk);
    wr_i = 0;

    // try to read back

    // enable divisor latches
    @(negedge clk);
    wr_i = 1;
    addr_i = 3'h3;
    din_i = 8'b1000_0000;

    @(negedge clk);
    wr_i = 0;

    // read divisor latch LSB
    @(negedge clk);
    rd_i = 1;
    addr_i = 3'h0;

    @(posedge clk);
    @(posedge clk);
    $display("Divisor Latch LSB = 0x%02h", data_out);

    @(negedge clk)
    rd_i = 0;

    // read divisor latch MSB
    @(negedge clk);
    rd_i = 1;
    addr_i = 3'h1;

    @(posedge clk);
    @(posedge clk);
    $display("Divisor Latch MSB = 0x%02h", data_out);

    @(negedge clk)
    rd_i = 0;

    // disable divisor latches
    @(negedge clk);
    wr_i = 1;
    addr_i = 3'h3;
    din_i = 8'b0000_0000;

    @(negedge clk);
    wr_i = 0;
  end
endmodule