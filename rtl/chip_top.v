`include "AHB2MEM.v"
`include "AHBDCD.v"
`include "AHBGPIO.v"
`include "AHBLITE_SYS.v"
`include "AHBMUX.v"
`include "AHBTIMER.v"
`include "AHBUART.v"
`include "AHB_VGA_TEXT.v"
`include "CORTEXM0INTEGRATION.v"
`include "_4byt_RAM.v"
`include "baudgen.v"
`include "character_st_mach.v"
`include "clean_disp.v"
`include "cmsdk_ahb_to_sram.v"
`include "cortexm0ds_logic.v"
`include "fifo.v"
`include "font_rom.v"
`include "pos_edge_det.v"
`include "prescaler.v"
`include "text_screen_gen.v"
`include "true_dpram_sclk.v"
`include "uart_rx.v"
`include "uart_tx.v"
`include "vga_sync.v"

module chip_top(
//X-TAL INTERFACE
input        xin,
output       xout,

input        RESET,

//VGA INTERFACE
output       hsync,
output       vsync,
output [7:0] rgb,

//UART INTERFACE
input        Rx,
output       Tx,

//GPIO INTERFACE
inout [15:0] gpio,

//DEBUGGER INTERFACE
input        TCK_SWCLK,
input        TDI_NC,
inout        TMS_SWDIO,
output       TDO_SWO
);

wire CLK_sys;
wire RESET_sys;
wire hsync_sys;
wire vsync_sys;
wire [7:0] rgb_sys;
wire Rx_sys;
wire Tx_sys;
wire [15:0] IO_IN_sys;
wire [15:0] IO_OUT_sys;
wire [15:0] IO_OP_EN_sys;
wire TCK_SWCLK_sys;
wire TDI_NC_sys;
wire dbg_swdi_sys;
wire dbg_swdo_sys;
wire dbg_swdo_en_sys;
wire TDO_SWO_sys;
wire PLL_ref_clk;

//I/O PADS
/////////////////////////////
//output 
/////////////////////////////
PO24N hsync_pad_out(.PAD(hsync), .I(hsync_sys)); 
PO24N vsync_pad_out(.PAD(vsync), .I(vsync_sys)); 
PO24N rgb_pad_out_0(.PAD(rgb[0]), .I(rgb_sys[0])); 
PO24N rgb_pad_out_1(.PAD(rgb[1]), .I(rgb_sys[1])); 
PO24N rgb_pad_out_2(.PAD(rgb[2]), .I(rgb_sys[2])); 
PO24N rgb_pad_out_3(.PAD(rgb[3]), .I(rgb_sys[3])); 
PO24N rgb_pad_out_4(.PAD(rgb[4]), .I(rgb_sys[4])); 
PO24N rgb_pad_out_5(.PAD(rgb[5]), .I(rgb_sys[5])); 
PO24N rgb_pad_out_6(.PAD(rgb[6]), .I(rgb_sys[6])); 
PO24N rgb_pad_out_7(.PAD(rgb[7]), .I(rgb_sys[7])); 

PO24N Tx_pad_out(.PAD(Tx), .I(Tx_sys)); 

PO24N TDO_SWO_pad_out(.PAD(TDO_SWO), .I(TDO_SWO_sys)); 
///////////////////////////////////
//input
//////////////////////////////////
PINN RESET_pad_in(.PAD(RESET), .C(RESET_sys));

PINN Rx_pad_in(.PAD(Rx), .C(Rx_sys));

PINN TCK_SWCLK_pad_in(.PAD(TCK_SWCLK), .C(TCK_SWCLK_sys));
PINN TDI_NC_pad_in(.PAD(TDI_NC), .C(TDI_NC_sys));

////////////////////////
//inout special
///////////////////////

//debugger
PB24N debugger_pad_io(.PAD(TMS_SWDIO),.OEN(~dbg_swdo_en_sys),.I(dbg_swdo_sys),.C(dbg_swdi_sys));

//GPIO
PB24N gpio_pad_io_0(.PAD(gpio[0]),.OEN(~IO_OP_EN_sys[0]),.I(IO_OUT_sys[0]),.C(IO_IN_sys[0]));
PB24N gpio_pad_io_1(.PAD(gpio[1]),.OEN(~IO_OP_EN_sys[1]),.I(IO_OUT_sys[1]),.C(IO_IN_sys[1]));
PB24N gpio_pad_io_2(.PAD(gpio[2]),.OEN(~IO_OP_EN_sys[2]),.I(IO_OUT_sys[2]),.C(IO_IN_sys[2]));
PB24N gpio_pad_io_3(.PAD(gpio[3]),.OEN(~IO_OP_EN_sys[3]),.I(IO_OUT_sys[3]),.C(IO_IN_sys[3]));
PB24N gpio_pad_io_4(.PAD(gpio[4]),.OEN(~IO_OP_EN_sys[4]),.I(IO_OUT_sys[4]),.C(IO_IN_sys[4]));
PB24N gpio_pad_io_5(.PAD(gpio[5]),.OEN(~IO_OP_EN_sys[5]),.I(IO_OUT_sys[5]),.C(IO_IN_sys[5]));
PB24N gpio_pad_io_6(.PAD(gpio[6]),.OEN(~IO_OP_EN_sys[6]),.I(IO_OUT_sys[6]),.C(IO_IN_sys[6]));
PB24N gpio_pad_io_7(.PAD(gpio[7]),.OEN(~IO_OP_EN_sys[7]),.I(IO_OUT_sys[7]),.C(IO_IN_sys[7]));
PB24N gpio_pad_io_8(.PAD(gpio[8]),.OEN(~IO_OP_EN_sys[8]),.I(IO_OUT_sys[8]),.C(IO_IN_sys[8]));
PB24N gpio_pad_io_9(.PAD(gpio[9]),.OEN(~IO_OP_EN_sys[9]),.I(IO_OUT_sys[9]),.C(IO_IN_sys[9]));
PB24N gpio_pad_io_10(.PAD(gpio[10]),.OEN(~IO_OP_EN_sys[10]),.I(IO_OUT_sys[10]),.C(IO_IN_sys[10]));
PB24N gpio_pad_io_11(.PAD(gpio[11]),.OEN(~IO_OP_EN_sys[11]),.I(IO_OUT_sys[11]),.C(IO_IN_sys[11]));
PB24N gpio_pad_io_12(.PAD(gpio[12]),.OEN(~IO_OP_EN_sys[12]),.I(IO_OUT_sys[12]),.C(IO_IN_sys[12]));
PB24N gpio_pad_io_13(.PAD(gpio[13]),.OEN(~IO_OP_EN_sys[13]),.I(IO_OUT_sys[13]),.C(IO_IN_sys[13]));
PB24N gpio_pad_io_14(.PAD(gpio[14]),.OEN(~IO_OP_EN_sys[14]),.I(IO_OUT_sys[14]),.C(IO_IN_sys[14]));
PB24N gpio_pad_io_15(.PAD(gpio[15]),.OEN(~IO_OP_EN_sys[15]),.I(IO_OUT_sys[15]),.C(IO_IN_sys[15]));

//xtal special i/o pad
PX2N xtal_pad_special(.XIN(xin),.XOUT(xout),.XC(PLL_ref_clk));

//////////////////////////
//PLL inst
////////////////////////
wire tst;
wire avdd;
wire avss;
S018PLLGS_500 PLL_inst( 
.AVDD(avdd), 
.AVSS(avss), 
.PLL_K(1'b0), 
.PLL_M(8'h19), 
.PLL_N(7'h6), 
.PLL_PD(1'b0), 
.PLL_TST(2'b00), 
.RESET(1'b0), 
.XIN(PLL_ref_clk), 
.CLK_OUT(CLK_sys), 
.TST_OUT(tst) 
);

/* ///////////////////////////////////
//power i/o pads
//////////////////////////////////

//digital power pads
PVDD1N pad_vdd(); //use this for global power(VDD)
PVSS1N pad_vss(); //use this for global power(GND)

PVDD2N pad_vdd_drive();
PVSS2N pad_vss_drive();


//analog power pads
///////////////////////////////////////////////////////////////////////
// 
//  **digital**|powercut|avss|avdd|ringvss|ringvdd|powercut|**digital**
//
///////////////////////////////////////////////////////////////////////
PDIODE8N cut_0();


PDIODE8N cut_1(); */

//analog signals for PLL
PVDD1APN avdd_pll(.SVDD1AP(avdd));
PVSS1APN avss_pll(.SVSS1AP(avss));

//////////////////////////
//AHB SYSTEM
////////////////////////
AHBLITE_SYS u0(
    //CLOCKS & RESET
    .CLK(CLK_sys),
    .RESET(RESET_sys), 
	
    
    //TO VGA INTERFACE 
    .hsync(hsync_sys),
	.vsync(vsync_sys),
	.rgb(rgb_sys),
	
	//TO UART
	.Rx(Rx_sys),
	.Tx(Tx_sys),
	
	//TO GPIO
	.IO_IN(IO_IN_sys),
	.IO_OUT(IO_OUT_sys),
	.IO_OP_EN(IO_OP_EN_sys),

    // Debug
    .TCK_SWCLK(TCK_SWCLK_sys),               // SWD Clk / JTAG TCK
    .TDI_NC(TDI_NC_sys),                  // NC      / JTAG TDI
    
	.dbg_swdi(dbg_swdi_sys),
	.dbg_swdo(dbg_swdo_sys),
	.dbg_swdo_en(dbg_swdo_en_sys),
	
    .TDO_SWO(TDO_SWO_sys)                 // SW  Out / JTAG TDO
);

endmodule
