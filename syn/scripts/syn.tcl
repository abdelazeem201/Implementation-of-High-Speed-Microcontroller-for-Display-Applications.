set design chip_top_v2

set search_path [list . \
[format "%s%s" SynopsysInstall /libraries/syn] \
[format "%s%s" SynopsysInstall /dw/sim_ver] \
/home/ahmedabdelazeem/soc/db/io \
/home/ahmedabdelazeem/soc/db/pll \
/home/ahmedabdelazeem/soc/db/std_cell \
/home/ahmedabdelazeem/soc/db/sram/dual_fix \
/home/ahmedabdelazeem/soc/db/sram/single \
/home/ahmedabdelazeem/soc/syn/ref_flow/rtl]

set_app_var link_library "* typical.db fast.db slow.db SP018N_V1p0_max.db SP018N_V1p0_typ.db SP018N_V1p0_min.db SMIC_PLL_18.db RA1SHD_fast@0C_syn.db RA1SHD_typical_syn.db RA1SHD_slow_syn.db dpram_fast@0C_syn.db dpram_typical_syn.db dpram_slow_syn.db"
set_app_var target_library "typical.db fast.db slow.db"
#set_app_var enable_keep_signal true

sh rm -rf work
sh mkdir -p work
define_design_lib work -path ./work


analyze -library work -format verilog ../rtl/${design}.v
elaborate $design -lib work
current_design 

check_design
source ./cons/cons.tcl
link

#compile -map_effort low
compile_ultra

report_area > ./report/synth_area.rpt
report_cell > ./report/synth_cells.rpt
report_qor  > ./report/synth_qor.rpt
report_resources > ./report/synth_resources.rpt
report_timing -max_paths 10 > ./report/synth_timing.rpt 
 
write_sdc  output/${design}.sdc 

define_name_rules  no_case -case_insensitive
change_names -rule no_case -hierarchy
change_names -rule verilog -hierarchy
set verilogout_no_tri	 true
set verilogout_equation  false

write -hierarchy -format verilog -output output/${design}.v 
write -f ddc -hierarchy -output output/${design}.ddc   

exit
