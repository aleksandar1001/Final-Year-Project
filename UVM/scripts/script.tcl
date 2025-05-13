cd ..
set root_dir [pwd]
cd scripts
set resultDir ../uvm_project

file mkdir $resultDir

create_project uvm_project $resultDir -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo:part0:2.0 [current_project]


# ===================================================================================
# Ukljucivanje svih izvornih i simulacionih fajlova u projekat
# ===================================================================================

add_files -norecurse ../dut/BRAM.vhd
add_files -norecurse ../dut/Convoluer2D.vhd
add_files -norecurse ../dut/axi_convoluer_v1_0_S00_AXI.vhd
add_files -norecurse ../dut/axi_convoluer_v1_0.vhd
add_files -norecurse ../dut/mem_subsystem.vhd

update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/axi_agent/conv_axi_agent_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/agent/conv_agent_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/configuration/conv_configuration_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/sequence/conv_sequence_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/test_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/conv_interface.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/conv_uvc_tb.sv

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Ukljucivanje uvm biblioteke

set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.xsim.more_options} -value {-testplusarg UVM_TESTNAME=conv_test_simple -testplusarg UVM_VERBOSITY=UVM_LOW} -objects [get_filesets sim_1]


set_property target_language VHDL [current_project]
set_property -name {xsim.simulate.runtime} -value {200 ms} -objects [get_filesets sim_1]