`timescale 1ns / 1ps

module recPixel(
    input clk,rst,we,
    input rx,
    //像素和卷积核都用一个字节表示
    output reg [7:0]Pixel,
    output reg start,
    output reg readOne, //一个脉冲信号，表示已经读取完了一个位置的数据
    output reg finished,
    output reg  [31:0]read_cnt
);
parameter FILLSIZE = 32'd1007;
parameter ALLSIZE = 32'd252004;
wire rx_vld;
wire [7:0]rx_data;
rx rxModule(.clk(clk),.rst(rst),.rx(rx),.rx_vld(rx_vld),.rx_data(rx_data));
//counter
always@(posedge clk or posedge rst)
begin
    if(rst || !we)
        readOne <= 0;
    else if(we && rx_vld)//成功接收到一个字节
    begin
        read_cnt <= read_cnt + 32'd1;
        readOne <= 1'b1;
    end
    else
        readOne <= 1'b0;
end
always@(posedge clk or posedge rst)
begin
    if(!rst && we)
        Pixel <= rx_data;
end
always@(posedge clk or posedge rst)
begin
    if(rst || !we)
    begin
        read_cnt <= 32'd0;
        finished <= 1'b0;
        start <= 1'b0;
    end
    else if(we)
    begin
        if(read_cnt < FILLSIZE)//未填满寄存器
        begin
            start <= 1'b0;
            finished <= 1'b0;
        end
        else if(read_cnt >= FILLSIZE &&read_cnt < ALLSIZE)//填满但未读取完所有的像素位置
        begin
            start <= 1'b1;
            finished <= 1'b0;
        end
        else if(read_cnt>=ALLSIZE)//读完了
        begin
            start <= 1'b0;
            finished<=1'b1;
        end
    end
end
endmodule