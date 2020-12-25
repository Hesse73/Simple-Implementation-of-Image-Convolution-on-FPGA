`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 20:16:50
// Design Name: 
// Module Name: recKernel
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



module recKernel(
    input clk,rst,we,
    input rx,
    //像素和卷积核都用一个字节表示
    //卷积核为3x3
    output reg [71:0]kernel,
    output reg finished
);
reg [3:0]bit_cnt;   //when 8, finished
wire rx_vld;
wire [7:0]rx_data;
rx rxModule(.clk(clk),.rst(rst),.rx(rx),.rx_vld(rx_vld),.rx_data(rx_data));
//counter
always@(posedge clk or posedge rst)
begin
    if(rst || !we)
    begin
        bit_cnt <= 0; 
        finished <= 0;
    end
    else if(we && rx_vld)//成功接收到一个字节
    begin
        if(bit_cnt <= 7)
            bit_cnt <= bit_cnt + 4'd1;
        else if(bit_cnt == 8)//读完之后就不再更改bit_cnt的值（设置为9）
            finished <= 1'b1;
    end
end
//数据合成
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        kernel <= 0;
    end
    else if(we)
    begin
        case(bit_cnt)
            4'd0: kernel[7:0] <= rx_data;
            4'd1: kernel[15:8] <= rx_data;
            4'd2: kernel[23:16] <= rx_data;
            4'd3: kernel[31:24] <= rx_data;
            4'd4: kernel[39:32] <= rx_data;
            4'd5: kernel[47:40] <= rx_data;
            4'd6: kernel[55:48] <= rx_data;
            4'd7: kernel[63:56] <= rx_data;
            4'd8: kernel[71:64] <= rx_data;
        endcase
    end
end
endmodule