//////////////////////////////////////////////////////////////////////////////////
//END USER LICENCE AGREEMENT                                                    //
//                                                                              //
//Copyright (c) 2012, ARM All rights reserved.                                  //
//                                                                              //
//THIS END USER LICENCE AGREEMENT (“LICENCE”) IS A LEGAL AGREEMENT BETWEEN      //
//YOU AND ARM LIMITED ("ARM") FOR THE USE OF THE SOFTWARE EXAMPLE ACCOMPANYING  //
//THIS LICENCE. ARM IS ONLY WILLING TO LICENSE THE SOFTWARE EXAMPLE TO YOU ON   //
//CONDITION THAT YOU ACCEPT ALL OF THE TERMS IN THIS LICENCE. BY INSTALLING OR  //
//OTHERWISE USING OR COPYING THE SOFTWARE EXAMPLE YOU INDICATE THAT YOU AGREE   //
//TO BE BOUND BY ALL OF THE TERMS OF THIS LICENCE. IF YOU DO NOT AGREE TO THE   //
//TERMS OF THIS LICENCE, ARM IS UNWILLING TO LICENSE THE SOFTWARE EXAMPLE TO    //
//YOU AND YOU MAY NOT INSTALL, USE OR COPY THE SOFTWARE EXAMPLE.                //
//                                                                              //
//ARM hereby grants to you, subject to the terms and conditions of this Licence,//
//a non-exclusive, worldwide, non-transferable, copyright licence only to       //
//redistribute and use in source and binary forms, with or without modification,//
//for academic purposes provided the following conditions are met:              //
//a) Redistributions of source code must retain the above copyright notice, this//
//list of conditions and the following disclaimer.                              //
//b) Redistributions in binary form must reproduce the above copyright notice,  //
//this list of conditions and the following disclaimer in the documentation     //
//and/or other materials provided with the distribution.                        //
//                                                                              //
//THIS SOFTWARE EXAMPLE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS" AND ARM     //
//EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING     //
//WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR //
//PURPOSE, WITH RESPECT TO THIS SOFTWARE EXAMPLE. IN NO EVENT SHALL ARM BE LIABLE/
//FOR ANY DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES OF ANY/
//KIND WHATSOEVER WITH RESPECT TO THE SOFTWARE EXAMPLE. ARM SHALL NOT BE LIABLE //
//FOR ANY CLAIMS, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, //
//TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE    //
//EXAMPLE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE EXAMPLE. FOR THE AVOIDANCE/
// OF DOUBT, NO PATENT LICENSES ARE BEING LICENSED UNDER THIS LICENSE AGREEMENT.//
//////////////////////////////////////////////////////////////////////////////////


module AHBGPIO(
  input wire HCLK,
  input wire HRESETn,
  input wire [31:0] HADDR,
  input wire [1:0] HTRANS,
  input wire [31:0] HWDATA,
  input wire HWRITE,
  input wire HSEL,
  input wire HREADY,
  input wire [15:0] GPIOIN,
  
	
	//Output
  output wire HREADYOUT,
  output wire [31:0] HRDATA,
  output wire [15:0] GPIOOUT,
  output wire [15:0] OUTPUT_ENABLE,
  output wire GPIO_0_IRQ
  
  
  );
  
  localparam [7:0] gpio_data_addr = 8'h00;
  localparam [7:0] gpio_dir_addr = 8'h04;
  localparam [7:0] gpio_clr_intr_0 = 8'h08;
  
  reg [15:0] gpio_dataout;
  reg [15:0] gpio_datain;
  reg [15:0] gpio_dir;
  reg [15:0] gpio_data_next;
  reg [31:0] last_HADDR;
  reg [1:0] last_HTRANS;
  reg last_HWRITE;
  reg last_HSEL;
  
  //integer i;
  
  assign HREADYOUT = 1'b1;
  
// Set Registers from address phase  
  always @(posedge HCLK or negedge HRESETn)
  begin
    if(!HRESETn)
	 begin
	   last_HADDR <= 32'h00000000;
      last_HTRANS <= 2'b00;
      last_HWRITE <= 1'b0;
      last_HSEL <= 1'b0;
	 end
	 
    else if(HREADY)
    begin
      last_HADDR <= HADDR;
      last_HTRANS <= HTRANS;
      last_HWRITE <= HWRITE;
      last_HSEL <= HSEL;
    end
  end
 
  wire write_enable = last_HSEL & last_HWRITE & last_HTRANS[1];

  // Update in/out switch
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
    begin
      gpio_dir <= 16'h0000;
    end
    else if ((last_HADDR[7:0] == gpio_dir_addr) & write_enable)
      gpio_dir <= HWDATA[15:0];
  end
  
  // Update output value
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
    begin
      gpio_dataout <= 16'h0000;
    end
    else if ((last_HADDR[7:0] == gpio_data_addr) & write_enable)
      gpio_dataout <= HWDATA[15:0] & gpio_dir;
  end
  
  // Update input value
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
    
      gpio_datain <= 16'h0000;
    
	
	else 
	
	  gpio_datain <= (GPIOOUT & gpio_dir) | (GPIOIN & ~gpio_dir);
      	
  end
         
  assign HRDATA = {16'h0000,gpio_datain};  
  assign GPIOOUT = gpio_dataout;
  assign OUTPUT_ENABLE = gpio_dir;
  
  /////////////////////////////////////////
  //input pos edge interrupt for GPIO pin_0
  /////////////////////////////////////////
  
  //GPIO_0 synchronizer
  reg GPIO_0_stage_1, GPIO_0_stage_2;
  always@(posedge HCLK or negedge HRESETn)
  begin
    if(!HRESETn) 
	begin
	GPIO_0_stage_1 <= 1'b0;
	GPIO_0_stage_2 <= 1'b0;
	end
	
	else if(gpio_dir[0]==0)
	begin
	GPIO_0_stage_1 <= GPIOIN[0];
	GPIO_0_stage_2 <= GPIO_0_stage_1;
	end
  
  end
  
  //edge detector
  wire interrupt_0_pos_edge;
  
  pos_edge_det u_det 
  (.sig(GPIO_0_stage_2),  
   .clk(HCLK),  
   .pe(interrupt_0_pos_edge)
   ); 
   
   //interrupt 0
   reg intr_0_irq;
   
   always@(posedge HCLK or negedge HRESETn)
   begin
     if(!HRESETn) intr_0_irq <= 1'b0;
	 
	 else if(write_enable&(last_HADDR[7:0] == gpio_clr_intr_0)) intr_0_irq <= !HWDATA[0];
	 
	 else if(interrupt_0_pos_edge) intr_0_irq <= 1'b1;
	 
	 else intr_0_irq <= intr_0_irq;
   end
  
  assign GPIO_0_IRQ = intr_0_irq;

endmodule
