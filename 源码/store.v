module store(
    input clk,rst,we,
    input [7:0]Pixel_read,
    output reg [71:0]Pixel_in
);
reg [3:0]bit_cnt;
reg [9:0]address;
reg [15:0]data_store;
reg storeWE;
wire [15:0]data_read;
c_shift_ram_0 c_shift_ram_0(.A(address),.D(data_store),.CE(storeWE),.CLK(clk),.Q(data_read));
always@(posedge clk or posedge rst or posedge we)
begin
    if(rst)
    begin
        storeWE <= 0;
        Pixel_in <= 0;
    end
    else if(we)//有使能时更新数据
    begin
        storeWE <=1;
        data_store <= Pixel_read;
    end
    else
        storeWE <= 0;
end
always@(posedge clk or posedge rst or negedge we)
begin
    if(rst)
    begin
        bit_cnt <= 0;
        Pixel_in <= 0;
    end
    else if(!we)
    begin
        
    end
end
endmodule