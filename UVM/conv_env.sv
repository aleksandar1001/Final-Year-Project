`ifndef CONV_ENV_SV
    `define CONV_ENV_SV
    
    
class conv_env extends uvm_env;


    // Factory registration
    `uvm_component_utils(conv_env)
    
    
    // Environment fields
    conv_config cfg;
    conv_axi_agent axi_agent;
    conv_agent agent;
    conv_scoreboard scbd;
    
    
    // Constructor
    function new(string name = "conv_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new
    
    
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
               
        if(!uvm_config_db #(conv_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal("conv_env - build_phase", "Unable to get configuration object for environment ");
    end 
                
        uvm_config_db#(int)::set(this, "agent", "is_active", UVM_ACTIVE);        
                
        agent = conv_agent::type_id::create("conv_agent", this);
        axi_agent = conv_axi_agent::type_id::create("conv_axi_agent", this);
        scbd = conv_scoreboard::type_id::create("conv_scoreboard", this);
    endfunction : build_phase
    
    
    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
                       
        agent.mon.analysis_port_collected.connect(scbd.item_collected_import);
    endfunction

endclass : conv_env
    
    
`endif