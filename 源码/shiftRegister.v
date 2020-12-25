module shiftRegister(
    input clk,rst,we,
    input [7:0]data_in,
    output [7:0]data_out,
    output reg out_vld
);
reg [63:0] shift_reg;
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        out_vld <= 0;
        shift_reg <= 0;
    end
    else if(we)
    begin
        shift_reg <= {shift_reg[55:0],data_in};
        out_vld <= 1;
    end
    else
        out_vld <= 0;
end
assign data_out = shift_reg[7:0] + shift_reg[63:0];
endmodule