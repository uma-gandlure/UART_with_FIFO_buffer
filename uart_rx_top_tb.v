`timescale 1us/1ns

module uart_rx_top_tb;

  reg clk, rst, baud_pulse, rx, sticky_parity, even_parity_sel;
  reg parity_en;
  reg [1:0] word_len_sel;
  wire push;
  wire parity_error, framing_error, break_interrupt;

  uart_rx_top rx_dut(clk, rst, baud_pulse, rx, sticky_parity, even_parity_sel, parity_en, word_len_sel, push, parity_error, framing_error, break_interrupt);
  
  integer i;

  initial
  begin
    clk = 0;
    rst = 0;
    baud_pulse = 0;
    rx = 1;
    sticky_parity = 0;
    even_parity_sel = 0;
    parity_en = 1'b1;
    word_len_sel = 2'b11;
  end

  always #5 clk = ~clk;

  reg [7:0] rx_reg = 8'h45;

  initial
  begin
    rst = 1'b1;
    repeat(5) @(posedge clk);

    // Start bit
    rst = 0;
    rx = 1'b0;
    repeat(16) @(posedge baud_pulse);

    // Send 8 data bits
    for (i = 0; i < 8; i = i + 1) begin
      rx = rx_reg[i];
      repeat(16) @(posedge baud_pulse);
    end

    // Parity
    rx = ~^rx_reg;
    repeat(16) @(posedge baud_pulse);

    // Stop bit
    rx = 1;
    repeat(16) @(posedge baud_pulse);
  end

  // baud pulse generation
  integer count = 5;
  always @(posedge clk) begin
    if (rst == 0) begin
      if (count != 0) begin
        count <= count - 1;
        baud_pulse <= 1'b0;
      end else begin
        count <= 5;
        baud_pulse <= 1'b1;
      end
    end
  end

endmodule