`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/24 18:33:08
// Design Name: 
// Module Name: shiftCal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module shiftCal(
    input clk,rst,we,
    input [71:0]kernel,
    input [7:0]data_in,
    output [7:0]data_out
);
reg [8055:0] shift_reg;
always@(posedge clk or posedge rst)
begin
    if(rst)
        shift_reg <= 0;
    else if(we)
        shift_reg <= {shift_reg[8048:0],data_in};
end
wire [7:0]mul1;
wire [7:0]mul2;
wire [7:0]mul3;
wire [7:0]mul4;
wire [7:0]mul5;
wire [7:0]mul6;
wire [7:0]mul7;
wire [7:0]mul8;
wire [7:0]mul9;
wire [7:0]add1;
wire [7:0]add2;
wire [7:0]add3;
wire [7:0]add4;
wire [7:0]add5;
wire [7:0]add6;
wire [7:0]add7;
wire [7:0]add8;
assign mul1 = shift_reg[8055:8048] * kernel[7:0];
assign mul2 = shift_reg[8047:8040] * kernel[15:8];
assign mul3 = shift_reg[8039:8032] * kernel[23:16];
assign mul4 = shift_reg[4039:4032] * kernel[31:24];
assign mul5 = shift_reg[4031:4024] * kernel[39:32];
assign mul6 = shift_reg[4023:4016] * kernel[47:40];
assign mul7 = shift_reg[23:16] * kernel[55:48];
assign mul8 = shift_reg[15:8] * kernel[63:56];
assign mul9 = shift_reg[7:0] * kernel[71:64];
assign add1 = mul1 + mul2;
assign add2 = mul3 + mul4;
assign add3 = add1 + add2;
assign add4 = mul6 + mul7;
assign add5 = mul8 + mul9;
assign add6 = add4 + add5;
assign add7 = add3 + mul5;
assign add8 = add6 + add7;  //add8即为计算的结果
assign data_out = add8;
endmodule
