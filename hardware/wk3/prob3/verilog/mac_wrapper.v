// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, out, x0, x1, x2, x3, w0, w1, w2, w3, psum_in);

parameter bw = 4;
parameter psum_bw = 16;
parameter inner_bw = 2 * bw + 1;

input [bw-1:0] x0, x1, x2, x3;
input signed [bw-1:0] w0, w1, w2, w3;
input signed [psum_bw-1:0] psum_in;
output [psum_bw-1:0] out;
input  clk;

reg    [bw-1:0] x0_q, x1_q, x2_q, x3_q;
reg    [bw-1:0] w0_q, w1_q, w2_q, w3_q;
reg    [psum_bw-1:0] psum_q;

mac #(.bw(bw), .psum_bw(psum_bw), .inner_bw(inner_bw)) mac_instance (
        .x0(x0_q), .x1(x1_q), .x2(x2_q), .x3(x3_q),
        .w0(w0_q), .w1(w1_q), .w2(w2_q), .w3(w3_q),
        .psum_in(psum_q),
	.out(out)
); 

always @ (posedge clk) begin
    x0_q <= x0;
    x1_q <= x1;
    x2_q <= x2;
    x3_q <= x3;
    w0_q <= w0;
    w1_q <= w1;
    w2_q <= w2;
    w3_q <= w3;
    psum_q <= psum_in;
end

endmodule
