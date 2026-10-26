// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

input wire [bw-1:0] a;
input wire signed [bw-1:0] b;
input wire signed [psum_bw-1:0] c;
output reg signed [psum_bw-1:0] out;

reg signed [bw:0] sa;

always @(*) begin
	sa = {1'b0, a};
    out = sa * b + c;
end

endmodule
