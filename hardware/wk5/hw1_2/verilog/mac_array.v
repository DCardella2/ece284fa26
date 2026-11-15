// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  input  [row*bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  output [col-1:0] valid;

  reg [(row * 2)-1:0] inst_temp; // only 1 vector input?
  assign inst_temp[1:0] = inst_w;

  reg [(row * col)-1:0] valid_temp;

  assign valid = valid_temp[(row * col)-1:(row-1) * col];

  // Temporary stored values (row by row) - north inputs and south outputs
  reg [(psum_bw * col * row + 1)-1:0] temp_ns;

  // Note +1 since we have have an all 0 row at the top
  assign temp[(psum_bw * col)-1:0] = 'b0;

  for (i=1; i < row+1 ; i=i+1) begin : row_num
      mac_row #(.bw(bw), .psum_bw(psum_bw)) mac_row_instance (
        .clk(clk), 
        .out_s(temp_ns[(psum_bw*col*i+1)-1:(psum_bw*col*(i))]),
        .in_w(in_w[i*bw-1:(i-1)*bw]),
        .in_n(temp_ns[(psum_bw*col*i)-1:psum_bw*col*(i-1)]), 
        .valid(valid_temp[(col*i)-1:col*(i-1)]), // TODO: valid is an output, not sure what for yet though
        .inst_w(inst_temp[(i*2)-1:2*(i-1)]), // Not yet, need a temp inst_w
        .reset(reset)
      );
  end

  always @ (posedge clk) begin
   // inst_w flows to row0 to row7
    // Enter into row 0, then move down 1 row per clk cycle
    for (integer i = 1; i < row; ++i) begin
        inst_temp[2*i+1:2*i] <= inst_temp[2*i-1:2*(i-1)];
    end
  end



endmodule
