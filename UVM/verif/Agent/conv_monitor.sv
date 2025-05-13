`ifndef CONV_MONITOR_SV
    `define CONV_MONITOR_SV
    
    
class conv_monitor extends uvm_monitor;


    // Factory registratiom
    `uvm_component_utils(conv_monitor)
                   
                  
    // Monitor fields
    virtual conv_interface vif;
    conv_config cfg;
    uvm_analysis_port #(conv_item) analysis_port_collected;
    protected conv_item req;
    
    // Constructor
    function new(string name = "conv_monitor", uvm_component parent = null);
        super.new(name, parent);
                    
        // Analysis port instance
        analysis_port_collected = new("analysis_port_collected", this);
    endfunction : new
                               
                 
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
               
        if(!uvm_config_db#(virtual conv_interface)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ", get_full_name(), ".vif"})
        end
                
        if(!uvm_config_db#(conv_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal(get_full_name(), "Failed to get config object")
        end
    endfunction : build_phase

    
    // Run phase
    task run_phase(uvm_phase phase);
        @(posedge vif.clk)
        wait(vif.res_wr_o == 1'b1)

        forever begin
            @(posedge vif.res_wr_o)
                        
             req = conv_item::type_id::create("req", this);
            `uvm_info(get_type_name(), $sformatf("[Monitor] Gathering information..."), UVM_MEDIUM);

            if(vif.res_en_o) begin
                req.res_en = vif.res_en_o;
                req.res_addr = vif.res_addr_o;
                req.res_data = vif.res_data_o;
                
                $display("MONITOR: 'Monitoruje' izlazni piksel res_data_o = %d ", req.res_data);
                $display("MONITOR: 'Monitoruje' izlaznu magistralu -> res_addr_o = %d", req.res_addr);
                
                analysis_port_collected.write(req);
            end
        end
    endtask : run_phase

endclass : conv_monitor
    
    
`endif