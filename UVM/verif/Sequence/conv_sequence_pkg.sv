`ifndef CONV_SEQUENCE_PKG_SV
    `define CONV_SEQUENCE_PKG_SV


package conv_sequence_pkg;
    
    
    // Invlude uvm packager anc uvm macros
    import uvm_pkg::*;            
    `include "uvm_macros.svh"          
    
    
    // Include seq item and sequencer
    import conv_agent_pkg::conv_item;
    import conv_agent_pkg::conv_sequencer;


    // Include sequences file
    `include "conv_base_seq.sv"
    `include "conv_simple_seq.sv"


endpackage : conv_sequence_pkg

`endif 

 