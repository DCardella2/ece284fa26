// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

wire signed [psum_bw-1:0] mult;

always @(*) begin
    mult = a * signed(b);
    out = mult + c;
end

endmodule
