`timescale 1us/1ns

module uart_tx_top_tb;
  reg clk, rst, baud_pulse, parity_en, tx_fifo_empty, stop_bit_sel, sticky_parity, even_parity_sel, set_break;
  reg [7:0] data_in;
  reg [1:0] word_len_sel;
  wire pop, shift_reg_empty, tx;

  uart_tx_top tx_dut(clk, rst, baud_pulse, parity_en, tx_fifo_empty, stop_bit_sel, sticky_parity, even_parity_sel, set_break, data_in, word_len_sel, pop, shift_reg_empty, tx);

  initial
  begin
    rst = 0;
    clk = 0;
    baud_pulse = 0;
    parity_en = 1'b1;
    tx_fifo_empty = 0;
    stop_bit_sel = 1;
    sticky_parity = 0;
    even_parity_sel = 1;
    set_break = 0;
    data_in = 8'b00010011;
    word_len_sel = 2'b11;
  end

  always #5 clk = ~clk;

  initial
  begin
    rst = 1'b1;
    repeat(5) @(posedge clk);
    rst = 0;
  end

  // baud pulse generation
  integer count = 5;
  always @(posedge clk)
  begin
    if (rst == 0)
    begin
      if (count != 0)
      begin
        count <= count - 1;
        baud_pulse <= 1'b0;
      end
      else
      begin
        count <= 5;
        baud_pulse <= 1'b1;
      end
    end
  end
endmodule