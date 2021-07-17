// Listing 14.4
module text_screen_gen
   (
    input wire clk, reset,
    input wire video_on,
	input wire tile_mem_wen,
    input wire [6:0] tile_mem_din,
    input wire [9:0] pixel_x, pixel_y,
    output reg [2:0] text_rgb,
	output wire super_busy
   );
   
   //tile memory write codes
   localparam ENTER_KEY = 7'hA;
   localparam BACKSPACE_KEY = 7'h8;
   
   //clean display module signals
   reg start;
   wire [6:0] clean_pix_x;
   wire [4:0] clean_pix_y;
   wire busy;
   
   //back space signals
   reg back_line;
   reg back_space;

   // signal declaration
   // font ROM
   wire [10:0] rom_addr;
   wire [6:0] char_addr;
   wire [3:0] row_addr;
   wire [2:0] bit_addr;
   wire [7:0] font_word;
   wire font_bit;
   // tile RAM
   wire we;
   wire [11:0] addr_r, addr_w;
   wire [6:0] din, dout;
   // 80-by-30 tile map
   localparam MAX_X = 7'd80;
   localparam MAX_Y = 5'd30;
   // cursor
   reg [6:0] cur_x_reg;
   reg [6:0] cur_x_next;
   reg [4:0] cur_y_reg;
   reg [4:0]cur_y_next;
   wire move_x_tick, move_y_tick, cursor_on;
   // delayed pixel count
   reg [9:0] pix_x1_reg, pix_y1_reg;
   reg [9:0] pix_x2_reg, pix_y2_reg;
   // object output signals
   wire [2:0] font_rgb, font_rev_rgb;
   
   //clean display module 
   //wire start_in = start;
   clean_disp u_clean(
   .clk(clk),
   .reset_n(!reset),
   .start(start),
   .x_pos(clean_pix_x),
   .y_pos(clean_pix_y),
   .busy(busy)
   );
   
   assign super_busy = busy | start;

   // body
   // instantiate debounce circuit for two buttons
   
   /* debounce deb_unit0
      (.clk(clk), .reset(reset), .sw(btn[0]),
       .db_level(), .db_tick(move_x_tick));
   debounce deb_unit1
      (.clk(clk), .reset(reset), .sw(btn[1]),
       .db_level(), .db_tick(move_y_tick)); */
	   
   // instantiate font ROM
   font_rom font_unit
      (.clk(clk), .addr(rom_addr), .data(font_word));
   // instantiate dual-port video RAM (2^12-by-7)
   // true_dpram_sclk
      // #(.ADDR_W(12), .DATA_W(7)) video_ram
      // (.clk(clk), .we_a(we), .addr_a(addr_w), .addr_b(addr_r),
       // .data_a(din), .q_b(dout));
	   wire [6:0] QA_TMP;
   dpram iloveu(
               .QA(QA_TMP),
               .CLKA(clk),
               .CENA(1'b0),
               .WENA(~we),
               .AA(addr_w),
               .DA(din),
               .OENA(1'b0),
               .QB(dout),
               .CLKB(clk),
               .CENB(1'b0),
               .WENB(1'b1),
               .AB(addr_r),
               .DB(7'b0),
               .OENB(1'b0)
               );


   // registers
   always @(posedge clk)
      begin
         cur_x_reg <= cur_x_next;
         cur_y_reg <= cur_y_next;
         pix_x1_reg <= pixel_x;
         pix_x2_reg <= pix_x1_reg;
         pix_y1_reg <= pixel_y;
         pix_y2_reg <= pix_y1_reg;
      end
   // tile RAM write
   
   assign addr_w = (busy)? {clean_pix_y, clean_pix_x} :
   (back_space)? {{cur_y_reg}, {cur_x_reg - 1'b1}} :
   (back_line)?  {{cur_y_reg - 1'b1}, {MAX_X - 1'b1}} : 
   {cur_y_reg, cur_x_reg};
   
   
   assign we = tile_mem_wen | busy;
   assign din = (busy)? 7'h0 :
   (back_line|back_space)? 7'h0:
   tile_mem_din;
   // tile RAM read
   // use nondelayed coordinates to form tile RAM address
   assign addr_r = {pixel_y[8:4], pixel_x[9:3]};
   assign char_addr = dout;
   // font ROM
   assign row_addr = pixel_y[3:0];
   assign rom_addr = {char_addr, row_addr};
   // use delayed coordinate to select a bit
   assign bit_addr = pix_x2_reg[2:0];
   assign font_bit = font_word[~bit_addr];
   // new cursor position
   
   /* assign cur_x_next =
      (move_x_tick && (cur_x_reg==MAX_X-1)) ? 0 : // wrap
      (move_x_tick) ? cur_x_reg + 1 :
                      cur_x_reg;
   assign cur_y_next =
      (move_y_tick && (cur_x_reg==MAX_Y-1)) ? 0 : // wrap
      (move_y_tick) ? cur_y_reg + 1 :
                      cur_y_reg; */
					  
	always@(*) begin
	cur_x_next = cur_x_reg;
	cur_y_next = cur_y_reg;
	back_line = 0;
	back_space = 0;
	start = 0;
	
	
	if(we & !busy) begin
	
	case(tile_mem_din) 
	
	ENTER_KEY:begin
	if(cur_y_reg==(MAX_Y-1)) begin
	cur_x_next = 0;
	cur_y_next = 0;
	start = 1;
	end
	
	else begin
	cur_y_next = cur_y_reg + 1'b1;
	cur_x_next = 0;
	end
	end
	
	BACKSPACE_KEY:begin
	
	if(cur_x_reg==0) begin
	
	if(cur_y_reg!=0)begin
	back_line = 1'b1;
	cur_y_next = cur_y_reg - 1'b1;
	cur_x_next = MAX_X-1'b1;
	end
	
	end
	else begin
	back_space = 1'b1;
	cur_x_next = cur_x_reg - 1'b1;
	end
	
	end
	
	default:begin
	
	if(cur_x_reg==(MAX_X-1'b1)) begin
	
	if(cur_y_reg==(MAX_Y-1'b1)) begin
	cur_x_next = 0;
	cur_y_next = 0;
	start = 1'b1;
	end
	else begin
	cur_x_next = 0;
	cur_y_next = cur_y_reg + 1'b1;
	end
	
	end
	else cur_x_next = cur_x_reg + 1'b1;
	
	end
	
	
	
	
	endcase
	
	
	
	end
	

	end
					  
   // object signals
   // green over black and reversed video for cursor
   assign font_rgb = (font_bit) ? 3'b110 : 3'b000;
   assign font_rev_rgb = (font_bit) ? 3'b000 : 3'b110;
   // use delayed coordinates for comparison
   assign cursor_on = (pix_y2_reg[8:4]==cur_y_reg) &&
                      (pix_x2_reg[9:3]==cur_x_reg);
   // rgb multiplexing circuit
   always @*
      if (~video_on)
         text_rgb = 3'b000; // blank
      else
         if (cursor_on)
            text_rgb = font_rev_rgb;
          else
            text_rgb = font_rgb;
endmodule

