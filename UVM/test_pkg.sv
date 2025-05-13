`ifndef TEST_PKG_SV
    `define TEST_PKG_SV
    
    
package test_pkg; 
    
   
    // Include uvm package and uvm macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"
           
               
    // Include other smaller packages
    import conv_agent_pkg::*;
    import conv_axi_agent_pkg::*;
    import conv_sequence_pkg::*;
    import conv_configuration_pkg::*;


    // Include files that are not in package
    `include "conv_scoreboard.sv"
    `include "conv_env.sv"
    `include "conv_base_test.sv"
    `include "conv_simple_test.sv"
    //`include "conv_defines.sv"

 
endpackage : test_pkg

    
    // Include interface file
    `include "conv_interface.sv"
    
   
`endif