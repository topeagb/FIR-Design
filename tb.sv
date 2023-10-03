`include "FIR_tap64.sv"
// AGBOOLA TOLULOPE 

module FIR64_tb ();
    parameter NUMBER_OF_TAPS = 63;
    parameter DATA_WIDTH = 10;
    logic clk = 0;
    logic rst_n;
    logic signed [DATA_WIDTH-1:0] data_in;
    logic signed [DATA_WIDTH-1:0] data_out;
    logic signed [DATA_WIDTH-1:0] h [0:NUMBER_OF_TAPS-1];
    int i;
    int file;
    

    logic signed [DATA_WIDTH-1:0] data_in_import [0:1999];

    FIR_TAP64 #(.NUMBER_OF_TAPS(NUMBER_OF_TAPS), .DATA_WIDTH(DATA_WIDTH)) FIR_0 (
        .clk(clk),
        .rst_n(rst_n),
        .h(h),
        .data_in(data_in),
        .data_out(data_out)
    );

    always begin
        #10 clk = ~clk;
        $fwrite(file, "%h\n", FIR64_tb.data_out);
    end

    initial begin
        for ( i=0 ; i<1999; i++) begin
            #10 data_in = data_in_import[i];
        end
    end

    initial begin
      #10 $readmemh("./filter_taps.hex", h);
    end

    initial begin       
       rst_n = 0;
       #10;
       rst_n = 1;
        file = $fopen("./output.hex", "w");
        $readmemh("./input_samples.hex", data_in_import);
        $monitor("Output Data=%h, Input Data=%h", data_out, data_in);
        #21300 $finish;
    end

    initial begin
        $dumpfile("fir64.vcd");
        $dumpvars(0, FIR64_tb.clk, FIR64_tb.rst_n, FIR64_tb.data_in, FIR64_tb.data_out);
    end

    // initial begin
    //     file = $fopen("./output.hex", "w");
    //     $fwrite(file, "%h", FIR64_tb.data_out);
    // end
endmodule