###################################################################

# Created by write_sdc on Tue Apr 18 00:10:37 2017

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -power mW -voltage V       \
-current mA
create_clock [get_ports xin]  -period 80  -waveform {0 40}
set_clock_uncertainty 0.2  [get_clocks xin]
create_generated_clock [get_pins PLL_inst/CLK_OUT]  -name pllClk  -source [get_pins PLL_inst/XIN]  -master_clock xin  -multiply_by 8  -add
set_clock_uncertainty 0.2  [get_clocks pllClk]
set_false_path -hold   -from [list [get_ports RESET] [get_ports Rx] [get_ports {gpio[15]}]           \
[get_ports {gpio[14]}] [get_ports {gpio[13]}] [get_ports {gpio[12]}]           \
[get_ports {gpio[11]}] [get_ports {gpio[10]}] [get_ports {gpio[9]}] [get_ports \
{gpio[8]}] [get_ports {gpio[7]}] [get_ports {gpio[6]}] [get_ports {gpio[5]}]   \
[get_ports {gpio[4]}] [get_ports {gpio[3]}] [get_ports {gpio[2]}] [get_ports   \
{gpio[1]}] [get_ports {gpio[0]}] [get_ports TCK_SWCLK] [get_ports TDI_NC]      \
[get_ports TMS_SWDIO] [get_ports pll_vdd] [get_ports pll_vss]]
set_false_path -hold   -to [list [get_ports xout] [get_ports hsync] [get_ports vsync] [get_ports     \
{rgb[7]}] [get_ports {rgb[6]}] [get_ports {rgb[5]}] [get_ports {rgb[4]}]       \
[get_ports {rgb[3]}] [get_ports {rgb[2]}] [get_ports {rgb[1]}] [get_ports      \
{rgb[0]}] [get_ports Tx] [get_ports {gpio[15]}] [get_ports {gpio[14]}]         \
[get_ports {gpio[13]}] [get_ports {gpio[12]}] [get_ports {gpio[11]}]           \
[get_ports {gpio[10]}] [get_ports {gpio[9]}] [get_ports {gpio[8]}] [get_ports  \
{gpio[7]}] [get_ports {gpio[6]}] [get_ports {gpio[5]}] [get_ports {gpio[4]}]   \
[get_ports {gpio[3]}] [get_ports {gpio[2]}] [get_ports {gpio[1]}] [get_ports   \
{gpio[0]}] [get_ports TMS_SWDIO] [get_ports TDO_SWO]]
set_input_delay -clock pllClk  -max 1  [get_ports RESET]
set_input_delay -clock pllClk  -max 1  [get_ports Rx]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[15]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[14]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[13]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[12]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[11]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[10]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[9]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[8]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[7]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[6]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[5]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[4]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[3]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[2]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[1]}]
set_input_delay -clock pllClk  -max 1  [get_ports {gpio[0]}]
set_input_delay -clock pllClk  -max 1  [get_ports TCK_SWCLK]
set_input_delay -clock pllClk  -max 1  [get_ports TDI_NC]
set_input_delay -clock pllClk  -max 1  [get_ports TMS_SWDIO]
set_input_delay -clock pllClk  -max 1  [get_ports pll_vdd]
set_input_delay -clock pllClk  -max 1  [get_ports pll_vss]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[15]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[14]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[13]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[12]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[11]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[10]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[9]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[8]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[7]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[6]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[5]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[4]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[3]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[2]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[1]}]
set_output_delay -clock pllClk  -max 1  [get_ports {gpio[0]}]
set_output_delay -clock pllClk  -max 1  [get_ports TMS_SWDIO]
set_output_delay -clock pllClk  -max 1  [get_ports xout]
set_output_delay -clock pllClk  -max 1  [get_ports hsync]
set_output_delay -clock pllClk  -max 1  [get_ports vsync]
set_output_delay -clock pllClk  -max 1  [get_ports {rgb[7]}]
set_output_delay -clock pllClk  -max 1  [get_ports {rgb[6]}]
set_output_delay -clock pllClk  -max 1  [get_ports {rgb[5]}]
set_output_delay -clock pllClk  -max 1  [get_ports {rgb[4]}]
set_output_delay -clock pllClk  -max 1  [get_ports {rgb[3]}]
set_output_delay -clock pllClk  -max 1  [get_ports {rgb[2]}]
set_output_delay -clock pllClk  -max 1  [get_ports {rgb[1]}]
set_output_delay -clock pllClk  -max 1  [get_ports {rgb[0]}]
set_output_delay -clock pllClk  -max 1  [get_ports Tx]
set_output_delay -clock pllClk  -max 1  [get_ports TDO_SWO]
