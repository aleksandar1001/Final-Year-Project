`ifndef CONV_AXI_AGENT_PKG_SV
    `define CONV_AXI_AGENT_PKG_SV

package conv_axi_agent_pkg;

    // Include uvm package and uvm macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // Include agent config package    
    import conv_configuration_pkg::*;

    // Include axi_agent file and axi_agent subcomponent files
    `include "conv_axi_item.sv"
    `include "conv_axi_agent_monitor.sv"
    `include "conv_axi_agent.sv"

endpackage : conv_axi_agent_pkg

`endif
