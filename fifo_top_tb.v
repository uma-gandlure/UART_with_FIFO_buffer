`timescale 1us/1ns

module fifo_top_tb;
  reg clk, rst, en, push_en, pop_en;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire empty, full, overrun, underrun;
  reg [3:0] thresh_level;
  wire thresh_reached;

  initial
  begin
    rst = 0;
    clk = 0;
    en = 0;
    data_in = 0;
  end

  fifo_top dut_fifo(clk, rst, en, push_en, pop_en, data_in, data_out, empty, full, overrun, underrun, thresh_level, thresh_reached);

  integer i;

  always #5 clk = ~clk;

  initial
  begin
    rst = 1'b1;
    repeat(5) @(posedge clk);

    // Write
    for (i = 0; i < 20; i = i + 1)
    begin
      rst = 1'b0;
      push_en = 1'b1;
      data_in = $urandom();
      pop_en = 1'b0;
      en = 1'b1;
      thresh_level = 4'ha;
      @(posedge clk);
    end

    // Read
    for (i = 0; i < 20; i = i + 1)
    begin
      rst = 1'b0;
      push_en = 1'b0;
      data_in = 0;
      pop_en = 1'b1;
      en = 1'b1;
      thresh_level = 4'ha;
      @(posedge clk);
    end
  end
endmodule
