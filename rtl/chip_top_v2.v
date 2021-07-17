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
`include "iobuf.v"
`include "osc_circ.v"

module chip_top_v2(
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
output       TDO_SWO,

//pll_signals
input pll_vdd,
input pll_vss
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
BUFX20 hsync_pad_out(.Y(hsync), .A(hsync_sys)); 
BUFX20 vsync_pad_out(.Y(vsync), .A(vsync_sys)); 
BUFX20 rgb_pad_out_0(.Y(rgb[0]), .A(rgb_sys[0])); 
BUFX20 rgb_pad_out_1(.Y(rgb[1]), .A(rgb_sys[1])); 
BUFX20 rgb_pad_out_2(.Y(rgb[2]), .A(rgb_sys[2])); 
BUFX20 rgb_pad_out_3(.Y(rgb[3]), .A(rgb_sys[3])); 
BUFX20 rgb_pad_out_4(.Y(rgb[4]), .A(rgb_sys[4])); 
BUFX20 rgb_pad_out_5(.Y(rgb[5]), .A(rgb_sys[5])); 
BUFX20 rgb_pad_out_6(.Y(rgb[6]), .A(rgb_sys[6])); 
BUFX20 rgb_pad_out_7(.Y(rgb[7]), .A(rgb_sys[7])); 

BUFX20 Tx_pad_out(.Y(Tx), .A(Tx_sys)); 

BUFX20 TDO_SWO_pad_out(.Y(TDO_SWO), .A(TDO_SWO_sys)); 
///////////////////////////////////
//input
//////////////////////////////////
BUFX20 RESET_pad_in(.A(RESET), .Y(RESET_sys));

BUFX20 Rx_pad_in(.A(Rx), .Y(Rx_sys));

BUFX20 TCK_SWCLK_pad_in(.A(TCK_SWCLK), .Y(TCK_SWCLK_sys));
BUFX20 TDI_NC_pad_in(.A(TDI_NC), .Y(TDI_NC_sys));

////////////////////////
//inout special
///////////////////////

//debugger
iobuf debugger_pad_io(.PAD(TMS_SWDIO),.OEN(~dbg_swdo_en_sys),.I(dbg_swdo_sys),.C(dbg_swdi_sys));

//GPIO
iobuf gpio_pad_io_0(.PAD(gpio[0]),.OEN(~IO_OP_EN_sys[0]),.I(IO_OUT_sys[0]),.C(IO_IN_sys[0]));
iobuf gpio_pad_io_1(.PAD(gpio[1]),.OEN(~IO_OP_EN_sys[1]),.I(IO_OUT_sys[1]),.C(IO_IN_sys[1]));
iobuf gpio_pad_io_2(.PAD(gpio[2]),.OEN(~IO_OP_EN_sys[2]),.I(IO_OUT_sys[2]),.C(IO_IN_sys[2]));
iobuf gpio_pad_io_3(.PAD(gpio[3]),.OEN(~IO_OP_EN_sys[3]),.I(IO_OUT_sys[3]),.C(IO_IN_sys[3]));
iobuf gpio_pad_io_4(.PAD(gpio[4]),.OEN(~IO_OP_EN_sys[4]),.I(IO_OUT_sys[4]),.C(IO_IN_sys[4]));
iobuf gpio_pad_io_5(.PAD(gpio[5]),.OEN(~IO_OP_EN_sys[5]),.I(IO_OUT_sys[5]),.C(IO_IN_sys[5]));
iobuf gpio_pad_io_6(.PAD(gpio[6]),.OEN(~IO_OP_EN_sys[6]),.I(IO_OUT_sys[6]),.C(IO_IN_sys[6]));
iobuf gpio_pad_io_7(.PAD(gpio[7]),.OEN(~IO_OP_EN_sys[7]),.I(IO_OUT_sys[7]),.C(IO_IN_sys[7]));
iobuf gpio_pad_io_8(.PAD(gpio[8]),.OEN(~IO_OP_EN_sys[8]),.I(IO_OUT_sys[8]),.C(IO_IN_sys[8]));
iobuf gpio_pad_io_9(.PAD(gpio[9]),.OEN(~IO_OP_EN_sys[9]),.I(IO_OUT_sys[9]),.C(IO_IN_sys[9]));
iobuf gpio_pad_io_10(.PAD(gpio[10]),.OEN(~IO_OP_EN_sys[10]),.I(IO_OUT_sys[10]),.C(IO_IN_sys[10]));
iobuf gpio_pad_io_11(.PAD(gpio[11]),.OEN(~IO_OP_EN_sys[11]),.I(IO_OUT_sys[11]),.C(IO_IN_sys[11]));
iobuf gpio_pad_io_12(.PAD(gpio[12]),.OEN(~IO_OP_EN_sys[12]),.I(IO_OUT_sys[12]),.C(IO_IN_sys[12]));
iobuf gpio_pad_io_13(.PAD(gpio[13]),.OEN(~IO_OP_EN_sys[13]),.I(IO_OUT_sys[13]),.C(IO_IN_sys[13]));
iobuf gpio_pad_io_14(.PAD(gpio[14]),.OEN(~IO_OP_EN_sys[14]),.I(IO_OUT_sys[14]),.C(IO_IN_sys[14]));
iobuf gpio_pad_io_15(.PAD(gpio[15]),.OEN(~IO_OP_EN_sys[15]),.I(IO_OUT_sys[15]),.C(IO_IN_sys[15]));

//xtal special i/o pad
osc_circ xtal_pad_special(.XIN(xin),.XOUT(xout),.XC(PLL_ref_clk));

//////////////////////////
//PLL inst
////////////////////////
wire tst;
//supply1 pll_vdd;
//supply0 pll_vss;
S018PLLGS_500 PLL_inst( 
.AVDD(pll_vdd), 
.AVSS(pll_vss), 
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
//PVDD1APN avdd_pll(.SVDD1AP(avdd));
//PVSS1APN avss_pll(.SVSS1AP(avss));

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
