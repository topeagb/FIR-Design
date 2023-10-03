`default_nettype none
`include "RTL.svh"

module multiplier #(
    parameter WIDTH = 10
) (
    input clk,
    input rst_n,
    input signed [WIDTH-1:0] data_in1,
    input signed [WIDTH-1:0] data_in2,
    output signed [WIDTH-1:0] mul_out
);
    logic signed [WIDTH+WIDTH-1:0] mul_reg;

    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        mul_reg <= '0;
      end else begin
        mul_reg <= data_in1 * data_in2;
      end
    end

    assign mul_out = mul_reg;
endmodule

module summer #(
    parameter WIDTH = 10
) (
    input clk,
    input rst_n,
    input signed [WIDTH-1:0] data_in1,
    input signed [WIDTH:0] data_in2,
    output signed [WIDTH-1:0] sum_out
);
    logic signed [WIDTH-1:0] sum_reg;

    always_ff @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
            sum_reg <= '0;
          end else begin
            sum_reg <= (data_in1 + data_in2);
          end
        end    
    
    assign sum_out = sum_reg;
endmodule

module FIR_TAP64 #(
    parameter NUMBER_OF_TAPS = 8,
    parameter DATA_WIDTH = 10
) (
    input logic clk,
    input logic rst_n,
    input signed [DATA_WIDTH-1:0] data_in,
    input signed [DATA_WIDTH-1:0] h [0:NUMBER_OF_TAPS-1],
    output signed [DATA_WIDTH-1:0] data_out
);
    logic signed [DATA_WIDTH+DATA_WIDTH-1:0] product [0:NUMBER_OF_TAPS-1];
    logic signed [DATA_WIDTH-1:0] delay_line [0:NUMBER_OF_TAPS-1];
    logic signed [DATA_WIDTH-1:0] data_in_reg;
    logic signed [DATA_WIDTH-1:0] sum [0:NUMBER_OF_TAPS-1];
    logic signed [DATA_WIDTH-1:0] accumulator;
    localparam DIVISOR = 2**DATA_WIDTH-1;

    logic en = 1;

    always_ff @( posedge clk or negedge rst_n ) begin
      if (!rst_n) begin
        data_in_reg <= '0;
      end else begin
          data_in_reg <= data_in;
      end
    end
    
    `FF(data_in_reg, delay_line[0], clk, en, rst_n, '0);
    assign product[0] = h[0] * data_in_reg; 
    assign sum[0] = product[0];

    genvar i;
    generate
      for(i=1; i<NUMBER_OF_TAPS; i=i+1) begin
        `FF(delay_line[i-1], delay_line[i], clk, en, rst_n, '0);
        multiplier mul0 (.clk(clk), .rst_n(rst_n), .data_in1(h[i]), .data_in2(delay_line[i]), .mul_out(product[i]));
        summer sum0 (.clk(clk), .rst_n(rst_n), .data_in1(product[i]), .data_in2(sum[i-1]), .sum_out(sum[i]));
      end
    endgenerate

    
    assign data_out = sum[NUMBER_OF_TAPS-1];
    
endmodule