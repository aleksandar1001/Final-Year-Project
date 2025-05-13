`ifndef CONV_AXI_AGENT_SV
    `define CONV_AXI_AGENT_SV
    

class conv_axi_agent extends uvm_agent;


    // AXI monitor instance
    conv_axi_agent_monitor mon;
    
    
    // Config object
    conv_config cfg;
    
    
    // Factory registration
    `uvm_component_utils(conv_axi_agent)
    
    
    // Constructor
    function new(string name = "conv_axi_agent", uvm_component parent);
        super.new(name, parent);
    endfunction : new 
    
    
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
                    
        uvm_config_db#(conv_config)::set(this, "", "cfg" , cfg);
          
        mon = conv_axi_agent_monitor::type_id::create("axi_monitor", this);
    endfunction : build_phase
    
    
    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase
    
    
endclass : conv_axi_agent
    
    
`endif   