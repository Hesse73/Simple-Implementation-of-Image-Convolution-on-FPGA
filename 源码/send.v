`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 21:14:53
// Design Name: 
// Module Name: send
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
module send(
    input clk,rst,we,
    //像素和卷积核都用一个字节表示
    input [7:0]Pixel,
    output tx,
    output sentFlag
);
//reg [7:0]tx_data;改为直接用pixel接上输出
wire tx_rd;
tx txModule(
    .clk(clk),
    .rst(rst),
    .tx_ready(we),
    .tx_data(Pixel),
    .tx(tx),
    .tx_rd(tx_rd)
);
assign sentFlag = tx_rd;
/*
//counter
//sentFlag需要修改
always@(posedge clk or posedge rst or negedge we)
begin
    if(rst || !we)
        sentFlag <= 0;
    else if(we && tx_rd)//已经成功发送了一个字节
        sentFlag <= 1'b1;
    else
        sentFlag <= 1'b0;
end*/
/*
always@(posedge clk or posedge rst)
begin
    if(!rst)
        tx_data <= Pixel;
end*/
endmodule
