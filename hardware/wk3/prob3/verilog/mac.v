// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, x0, x1, x2, x3, w0, w1, w2, w3, psum_in);

parameter bw = 4;
parameter psum_bw = 16;
parameter inner_bw = 2 * bw + 1;

input [bw-1:0] x0, x1, x2, x3;
input signed [bw-1:0] w0, w1, w2, w3;
input signed [psum_bw-1:0] psum_in;
output reg signed [psum_bw-1:0] out;

reg signed [bw:0] sx0, sx1, sx2, sx3; // signed versions of x
reg signed [inner_bw-1:0] isum0, isum1; // inner sums 

always @(*) begin
    sx0 = {1'b0, x0};
    sx1 = {1'b0, x1};
    sx2 = {1'b0, x2};
    sx3 = {1'b0, x3};

    // 1st layer of addition
    isum0 = (sx0 * w0) + (sx1 * w1);
    isum1 = (sx2 * w2) + (sx3 * w3);

    // 2nd layer of addition
    out = isum0 + isum1 + psum_in;
end

endmodule
