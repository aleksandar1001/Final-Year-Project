`ifndef CONV_AGENT_SV
    `define CONV_AGENT_SV
    

class conv_agent extends uvm_agent;


    // Config object
    conv_config cfg;
    
    
    // Conv_agent's subcomponents
    conv_driver drv;
    conv_sequencer sqr;
    conv_monitor mon;
    
    // Conv agents's fields
    uvm_active_passive_enum is_active; 
    
    // Factory registration
    `uvm_component_utils(conv_agent)
  
    
    // Constructor
    function new(string name = "conv_agent", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
                          
        uvm_config_db#(conv_config)::set(this, "", "cfg" , cfg);
            
        //if(is_active == UVM_ACTIVE) begin
            drv = conv_driver::type_id::create("conv_driver", this);
            sqr = conv_sequencer::type_id::create("conv_sequencer", this);
        //end
                      
        mon = conv_monitor::type_id::create("conv_monitor", this);
    endfunction : build_phase


    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //if(is_active == UVM_ACTIVE) 
            drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction : connect_phase
    

endclass : conv_agent    
    
    
`endif