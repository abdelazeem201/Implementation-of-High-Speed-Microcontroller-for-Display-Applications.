//  --========================================================================--
//  Version and Release Control Information:
//
//  File Name           : AHB2BRAM.v
//  File Revision       : 1.60
//
//  ----------------------------------------------------------------------------
//  Purpose             : Basic AHBLITE Internal Memory Default Size = 16KB
//                        
//  --========================================================================--
module AHB2MEM
#(parameter AW=14, parameter filename="code.hex")					// SIZE[Bytes] = 2 ^ MEMWIDTH[Bytes] = 2 ^ MEMWIDTH / 4[Entries]
  (
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
  output wire [31:0] HRDATA
  );

  // wires for ROM/SRAM interface
  wire  [AW-3:0] SRAMADDR;
  wire    [31:0] SRAMWDATA;
  wire    [31:0] SRAMRDATA;
  wire     [3:0] SRAMWEN;
  wire           SRAMCS;

  // AHB to SRAM bridge
  cmsdk_ahb_to_sram
    #(.AW(AW)
   ) u_ahb_to_sram
  (
    // AHB Inputs
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HSEL       (HSEL),  // AHB inputs
    .HADDR      (HADDR[13:0]),
    .HTRANS     (HTRANS),
    .HSIZE      (HSIZE),
    .HWRITE     (HWRITE),
    .HWDATA     (HWDATA),
    .HREADY     (HREADY),

    // AHB Outputs
    .HREADYOUT  (HREADYOUT), // Outputs
    .HRDATA     (HRDATA),
    .HRESP      (),

   // SRAM input
    .SRAMRDATA  (SRAMRDATA),
   // SRAM Outputs
    .SRAMADDR   (SRAMADDR),
    .SRAMWDATA  (SRAMWDATA),
    .SRAMWEN    (SRAMWEN),
    .SRAMCS     (SRAMCS)
   );

  // RAM model
  _4byt_RAM #(.AW(AW-2), .filename(filename)) u_asic_rom
   (
   // SRAM Inputs
    .clk        (HCLK),
    .addr       (SRAMADDR),
    .din        (SRAMWDATA),
    .we         (SRAMWEN),
    .cs         (SRAMCS),
   // SRAM Outputs
    .dout      (SRAMRDATA)
   );


endmodule
