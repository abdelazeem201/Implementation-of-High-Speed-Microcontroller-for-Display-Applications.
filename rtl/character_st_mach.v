module character_st_mach(
input clk,
input reset_n,
input start,
output reg [7:0] data,
output reg wen
);

//ZAG SYSTEMS

localparam IDLE = 0;
localparam CH0 =  1;
localparam CH1 =  2;
localparam CH2 =  3;
localparam CH3 =  4;
localparam CH4 =  5;
localparam CH5 =  6;
localparam CH6 =  7;
localparam CH7 =  8;
localparam CH8 =  9;
localparam CH9 =  10;
localparam CH10 = 11;
localparam CH11 = 12;
localparam CH12 = 13;

reg [3:0] current_state;
reg [3:0] next_state;

always@(posedge clk or negedge reset_n)
if(!reset_n) current_state <= IDLE;
else current_state <= next_state;

always@(*) begin
 next_state = IDLE;
 case(current_state)
 IDLE: if(start) next_state = CH0;
 else next_state = IDLE;
 CH0:next_state = CH1;
 CH1:next_state = CH2;
 CH2:next_state = CH3;
 CH3:next_state = CH4;
 CH4:next_state = CH5;
 CH5:next_state = CH6;
 CH6:next_state = CH7;
 CH7:next_state = CH8;
 CH8:next_state = CH9;
 CH9:next_state = CH10;
 CH10:next_state = CH11;
 CH11:next_state = CH12;
 CH12:next_state = IDLE;
 endcase

end

//assign wen = (current_state==(CH0|CH1|CH2|CH3|CH4|CH5|CH6|CH7|CH8|CH9|CH10|CH11|CH12));

always@(*) begin
data = 0;
wen = 0;

case(current_state)

CH0: begin data = 90; wen = 1; end
CH1:begin data = 65; wen = 1; end
CH2:begin data = 71; wen = 1; end
CH3:begin data = 32; wen = 1; end
CH4:begin data = 83; wen = 1; end
CH5:begin data = 89; wen = 1; end
CH6:begin data = 83; wen = 1; end
CH7:begin data = 84; wen = 1; end
CH8:begin data = 69; wen = 1; end
CH9:begin data = 77; wen = 1; end
CH10:begin data = 83; wen = 1; end
CH11:begin data = 32; wen = 1; end
CH12:begin data = 32; wen = 1; end


endcase

end

endmodule