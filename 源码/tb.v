module	testbench();
reg clk,rst,we,start;
reg [7:0]data_store;
wire [7:0]data_out;
testShift testShift(.clk(clk),.rst(rst),.we(we),.start(start),.data_store(data_store),.data_out(data_out));
initial
begin
    rst = 1;
    #100 rst = 0;
    #2000 $stop;
end
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end
initial
begin
    start = 0;
    #200 start = 1;
end
initial
begin
    we = 0;
    #200 we = 1;
    #10  we = 0;
    #200 we = 1;
    #10  we = 0;
    #200 we = 1;
    #10  we = 0;
    #200 we = 1;
    #10  we = 0;
    #200 we = 1;
    #10  we = 0;
    #200 we = 1;
    #10  we = 0;
    #200 we = 1;
    #10  we = 0;
end
initial
begin
    data_store = 0;
    #200 data_store = 8'hff;
    #210 data_store = 8'h0c;
    #210 data_store = 8'h1b;
    #210 data_store = 8'h2a;
    #210 data_store = 8'h6d;
    #210 data_store = 8'h88;
    #210 data_store = 8'h93;
end
endmodule

