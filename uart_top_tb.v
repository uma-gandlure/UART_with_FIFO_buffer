`timescale 1us/1ns

module uart_top_tb;
  reg clk, rst, wr_i, rd_i;
  reg rx;
  reg [2:0] addr_i;
  reg [7:0] din_i;

  wire tx;
  wire [7:0] data_out;

  uart_top dut(clk, rst, wr_i, rd_i, rx, addr_i, din_i, tx, data_out);

  initial
  begin
    rst = 0;
    clk = 0;
    wr_i = 0;
    rd_i = 0;
    addr_i = 0;
    din_i = 0;
    rx = 1;
  end

  always #5 clk = ~clk;

  initial
  begin
    rst = 1'b1;
    repeat(5)@(posedge clk);
    rst = 0;

    // dlab = 1;
    @(negedge clk);
    wr_i   = 1;
    addr_i = 3'h3;
    din_i  = 8'b1000_0000;

    // divisor lsb = 08
    @(negedge clk);
    addr_i = 3'h0;
    din_i  = 8'b0000_1000;

    // divisor msb = 01
    @(negedge clk);
    addr_i = 3'h1;
    din_i  = 8'b0000_0001;

    // dlab = 0, wls = 00(5-bits), stb = 1 (single bit dur), pen = 1, eps = 0 (odd), sp = 0
    @(negedge clk);
    addr_i = 3'h3;
    din_i  = 8'b0000_1100;

    // push f4 in fifo (thr, dlab = 0)
    @(negedge clk);
    addr_i = 3'h0;
    din_i  = 8'b1111_0100;

    // remove wr
    @(negedge clk);
    wr_i = 0;
  end

endmodule