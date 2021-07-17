module clean_disp(
input clk,
input reset_n,
input start,
output [6:0] x_pos,
output [4:0] y_pos,
output busy
);

parameter IDLE = 1'b0;
parameter BUSY = 1'b1;

parameter MAX_X = 80;
parameter MAX_Y = 30;

reg [6:0] cur_x_reg;
reg [4:0] cur_y_reg;

reg [6:0] cur_x_nxt;
reg [4:0] cur_y_nxt;

reg current_state;
reg next_state;

always@(posedge clk or negedge reset_n) begin

 if(!reset_n) begin
 cur_x_reg <= 0;
 cur_y_reg <= 0;
 current_state <= IDLE;
 end
 
 else begin
 cur_x_reg <= cur_x_nxt;
 cur_y_reg <= cur_y_nxt;
 current_state <= next_state;
 end

end

always@(*) begin

cur_x_nxt = cur_x_reg;
cur_y_nxt = cur_y_reg;
next_state = current_state;

case(current_state) 

 IDLE: begin
 if(start) next_state = BUSY;
 
 else next_state = current_state;
 
 
 end
 
 BUSY: begin
 if((cur_x_reg==MAX_X-1)&&(cur_y_reg==MAX_Y-1)) begin
 next_state = IDLE;
 cur_x_nxt = 0;
 cur_y_nxt = 0;
 end
 
 else begin
 
 if(cur_x_reg==MAX_X-1) begin
 cur_x_nxt = 0;
 cur_y_nxt = cur_y_reg + 1;
 end
 
 else cur_x_nxt = cur_x_reg + 1;
   
 next_state = BUSY;
 end
 
 
 end


endcase



end


assign busy = current_state;
assign x_pos = cur_x_reg;
assign y_pos = cur_y_reg;

endmodule