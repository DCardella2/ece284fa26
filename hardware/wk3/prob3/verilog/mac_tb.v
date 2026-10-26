// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] x0, x1, x2, x3;
reg  [bw-1:0] w0, w1, w2, w3;
reg  [psum_bw-1:0] psum_in;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x0_dec, x1_dec, x2_dec, x3_dec;
integer w0_dec, w1_dec, w2_dec, w3_dec;
integer i; 
integer u; 

// Looks like w_bin = 2s comp version of weight
function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction


// Unsigned number 
function [3:0] x_bin ;
    input integer x;
    begin
        if (x > 7) begin
            x_bin[3] = 1;
            x -= 8;
        end else begin
            x_bin[3] = 0;
        end
        if (x > 3) begin
            x_bin[2] = 1;
            x -= 4;
        end else begin
            x_bin[2] = 0;
        end
        if (x > 1) begin
            x_bin[1] = 1;
            x -= 2;
        end else begin
            x_bin[1] = 0;
        end
        x_bin[0] = x > 0 ? 1 : 0;
    end
endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
    input reg [bw-1:0] x0, x1, x2, x3;
    input reg signed [bw-1:0] w0, w1, w2, w3;
    input reg signed [psum_bw-1:0] psum_in;

	reg signed [bw:0] sx0, sx1, sx2, sx3;
    begin
        // Just the same thing as mac.v? 
		sx0 = {1'b0, x0};
        sx1 = {1'b0, x1};
        sx2 = {1'b0, x2};
        sx3 = {1'b0, x3};

        mac_predicted = ((sx0 * w0) + (sx1 * w1) + 
						 (sx2 * w2) + (sx3 * w3) + psum_in);
    end
endfunction



mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
	.x0(x0), .x1(x1), .x2(x2), .x3(x3), 
	.w0(w0), .w1(w1), .w2(w2), .w3(w3),
	.psum_in(psum_in),
	.out(out)
); 
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<5; i=i+1) begin  // Data lenght is 10 in the data files

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     w_scan_file = $fscanf(w_file, "%d\n%d\n%d\n%d\n", 
                           w0_dec, w1_dec, w2_dec, w3_dec);

     x_scan_file = $fscanf(x_file, "%d\n%d\n%d\n%d\n", 
                           x0_dec, x1_dec, x2_dec, x3_dec);

     x0 = x_bin(x0_dec);
     x1 = x_bin(x1_dec);
     x2 = x_bin(x2_dec);
     x3 = x_bin(x3_dec);

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     w0 = w_bin(w0_dec);
     w1 = w_bin(w1_dec);
     w2 = w_bin(w2_dec);
     w3 = w_bin(w3_dec);
     
     psum_in = expected_out;

     expected_out = mac_predicted(x0, x1, x2, x3, 
                                  w0, w1, w2, w3, 
                                  psum_in);

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




