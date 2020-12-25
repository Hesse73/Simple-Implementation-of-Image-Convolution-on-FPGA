`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 21:16:17
// Design Name: 
// Module Name: top
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
//parameter kSize <= 8'd71;    //卷积核为3x3,即9posedge clk or posedge rst8 <= 72bits 
//parameter singleK <= 4'd8;   //卷积核一共有0~8个数
//输入文件为测试字节+卷积核（27Bytes）+像素（502*502*3 Bytes）
module	top(
input clk,rst,
input rx,
output tx,
output reg led0,
output reg led1
);
reg startRec;
reg kernelWE;
reg pixelWE;
wire sendWE;
wire calWE;
wire [71:0]kernel;
wire [7:0]Pixel_read;
wire [7:0]Pixel_send;
wire readOne;
wire kernelFinished;
wire calStart;
wire readFinished;
wire sentFlag;
wire read_cnt;
//调用
//需要修改posedge we or negedge we
//(似乎已经完成)需要修改设置，每一个读取和发送过程都会产生信号延迟，需要将这一部分考虑到
recKernel recKernel(.clk(clk),.rst(rst),.we(kernelWE),.rx(rx),.finished(kernelFinished),.kernel(kernel));
recPixel recPixel(.clk(clk),.rst(rst),.read_cnt(read_cnt),.we(pixelWE),.rx(rx),.readOne(readOne),.start(calStart),.finished(readFinished),.Pixel(Pixel_read));
shiftCal shiftCal(.clk(clk),.rst(rst),.we(calWE),.kernel(kernel),.data_in(Pixel_read),.data_out(Pixel_send));
send send(.clk(clk),.rst(rst),.we(sendWE),.tx(tx),.sentFlag(sentFlag),.Pixel(Pixel_send));
//WE
always@(posedge clk or posedge rst)
begin
    if(rst)
        startRec <= 0;
    else if(rx != 0 && startRec == 0)
        startRec = 1;
end
always@(posedge clk or posedge rst)
begin
    if(rst)
        kernelWE <= 0;
    else if(startRec && kernel == 0)
        kernelWE <= 1;
    else if(kernelFinished == 1)
        kernelWE <= 0;
end
always@(posedge clk or posedge rst)
begin
    if(rst)
        pixelWE <= 0;
    else if(kernelFinished ==1 && readFinished != 1)
        pixelWE <= 1;
end
//每当读入了一个数据，就写入寄存器
assign calWE = readOne && !rst;
assign sendWE = calStart && !rst;
//为了避免重复发送，sendWE在发送完一个信号之后就不再发送，除非此时又有了新的输入（即readOne == 1）
//sendFlag不需要通过shiftcal返回，因为整个系统的时延完全是由UART控制的
//所以只需要在输入的数据填满寄存器之后，就可以输出
//输出使能的管理：直接产生一个脉冲信号
always@(posedge clk or posedge rst)
begin
    if(rst)
        led0 <= 0;
    else if(sendWE)
        led0 <= 1; 
end
always@(posedge clk or posedge rst)
begin
    if(rst)
        led1 <= 0;
    else if(read_cnt[3])
        led1 <= 1; 
end
endmodule

