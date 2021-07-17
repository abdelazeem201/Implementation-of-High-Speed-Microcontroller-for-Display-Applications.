module AHB_VGA_TEXT(
//AHBLITE INTERFACE
		//Slave Select Signals
			input wire HSEL,
		//Global Signal
			input wire HCLK,
			input wire HRESETn,
		//Address, Control & Write Data
			input wire HREADY,
			input wire [31:0] HADDR,
			input wire [1:0] HTRANS,
			input wire HWRITE,
			input wire [2:0] HSIZE,
			
			input wire [31:0] HWDATA,
		// Transfer Response & Read Data
			output wire HREADYOUT,
			output wire [31:0] HRDATA,
		//VGA Interface Signals
		output wire hsync,
		output wire vsync,
		output wire [2:0] rgb
);

//Address Phase Sampling Registers
  reg rHSEL;
  reg [31:0] rHADDR;
  reg [1:0] rHTRANS;
  reg rHWRITE;
  reg [2:0] rHSIZE;
  
  //Address Phase Sampling
  always @(posedge HCLK or negedge HRESETn)
  begin
	 if(!HRESETn)
	 begin
		rHSEL   <= 1'b0;
		rHADDR	<= 32'h0;
		rHTRANS	<= 2'b00;
		rHWRITE	<= 1'b0;
		rHSIZE	<= 3'b000;
	 end
    else if(HREADY)
    begin
        rHSEL	<= HSEL;
		rHADDR	<= HADDR;
		rHTRANS	<= HTRANS;
		rHWRITE	<= HWRITE;
		rHSIZE	<= HSIZE;
    end
  end

 wire wen = rHSEL & rHWRITE & rHTRANS[1];
 wire video_on, super_busy;
 wire [9:0] pixel_x, pixel_y;

 
 
  vga_sync u_sync(
   .clk(HCLK),
   .hsync(hsync), 
   .vsync(vsync), 
   .video_on(video_on), 
   .pixel_x(pixel_x), 
   .pixel_y(pixel_y)
 );
 
 
 text_screen_gen u_gen
   (
    .clk(HCLK), 
	.reset(!HRESETn),
    .video_on(video_on),
	.tile_mem_wen(wen),
    .tile_mem_din(HWDATA[6:0]),
    .pixel_x(pixel_x), 
	.pixel_y(pixel_y),
    .text_rgb(rgb),
	.super_busy(super_busy)
   );
   
   assign HREADYOUT = !super_busy;
   assign HRDATA = 32'd0;


endmodule 