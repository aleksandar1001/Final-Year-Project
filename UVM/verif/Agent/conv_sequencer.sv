`ifndef CONV_SEQUENCER_SV
    `define CONV_SEQUENCER_SV
    
    
class conv_sequencer extends uvm_sequencer#(conv_item);

    // Factory registration\par
    `uvm_component_utils (conv_sequencer)
      
    
    // Virtual interface and config instance\par
    virtual conv_interface vif;
    conv_config cfg;
    

    // Constructor\par
    function new(string name = "conv_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction : new


    // Build phase\par
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual conv_interface)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ", get_full_name(), ".vif"})

        if(!uvm_config_db#(conv_config)::get(this, "", "cfg", cfg))
            `uvm_fatal(get_full_name(), "Failed to get config object")

    endfunction : build_phase 


endclass : conv_sequencer
    
    
`endif