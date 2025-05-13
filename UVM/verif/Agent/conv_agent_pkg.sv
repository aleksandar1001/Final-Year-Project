`ifndef CONV_AGENT_PKG_SV
    `define CONV_AGENT_PKG_SV
    
    
package conv_agent_pkg; 
    
   
    // Include uvm package and uvm macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"
           
               
    // Include agent config package    
    import conv_configuration_pkg::*;


    // Include files that are not in package
    `include "conv_item.sv"
    `include "conv_sequencer.sv"
    `include "conv_driver.sv"
    `include "conv_monitor.sv"
    `include "conv_agent.sv"


endpackage : conv_agent_pkg
    
   
`endif
