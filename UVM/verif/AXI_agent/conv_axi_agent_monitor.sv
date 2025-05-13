`ifndef CONV_AXI_AGENT_MONITOR_SV
    `define CONV_AXI_AGENT_MONITOR_SV
               
           
class conv_axi_agent_monitor extends uvm_monitor;
    
    
    // Factory registratiom
    `uvm_component_utils(conv_axi_agent_monitor)


    // Monitor fields
    virtual conv_interface vif;
    conv_config cfg;
    uvm_analysis_port #(conv_axi_item) axi_analysis_port_collected;
    protected conv_axi_item req;
    
    
    // Coverage for AXI LITE
    covergroup axi_write_transaction;
        option.per_instance = 1;
        option.goal = 9;

        write_address : coverpoint vif.s00_axi_awaddr{
            bins BASE_ADDRESS ={AXI_BASE};
            bins LINES_REG_INPUT = {AXI_BASE + LINES_REG_OFFSET};
            bins COLUMNS_REG_INPUT = {AXI_BASE + COLUMNS_REG_OFFSET};
            bins CMD_REG_INPUT = {AXI_BASE + CMD_REG_OFFSET};
        }

        write_data : coverpoint vif.s00_axi_wdata{
            bins AXI_WDATA_LOW = {0};
            bins AXI_WDATA_HIGH = {1};
            bins AXI_WDATA_PARAMETERS = {[2:442]};
        }
    endgroup
    
    covergroup axi_read_transaction;
        option.per_instance = 1;
        option.goal = 3;
                     
        read_address : coverpoint vif.s00_axi_araddr{
            bins STATUS_REG_INPUT = {AXI_BASE + STATUS_REG_OFFSET};
            bins START_DVA_FROM_JEDAN_REG_INPUT = {AXI_BASE + START_DVA_FROM_JEDAN_REG_OFFSET};
            bins START_TRI_FROM_DVA_REG_INPUT = {AXI_BASE + START_TRI_FROM_DVA_REG_OFFSET};
            bins START_CETIRI_FROM_TRI_REG_INPUT = {AXI_BASE + START_CETIRI_FROM_TRI_REG_OFFSET};
        }
                   
        read_data : coverpoint vif.s00_axi_rdata{
            bins READY_RDATA_LOW = {0};
            bins READY_RDATA_HIGH = {1};
        }
    endgroup
    
    
    
    // Constructor
    function new(string name = "conv_axi_agent_monitor", uvm_component parent = null);
        super.new(name, parent);
                    
        // Analysis port instance
        axi_analysis_port_collected = new("axi_analysis_port_collected", this);

        // Coverage groups instances
        axi_write_transaction = new();
        axi_read_transaction = new();
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
        $display("\\nin UVM AXI_AGENT_MONITOR\\n");
        forever begin
            @(posedge vif.clk);
            if(vif.rst) begin
                req = conv_axi_item::type_id::create("req", this);
                               
                // Monitor an AXI write transaction
                 if(vif.s00_axi_awvalid == 1 && vif.s00_axi_awready == 1) begin 
                     if(vif.s00_axi_wstrb == 15) begin
                         axi_write_transaction.sample();
                        `uvm_info(get_type_name(),$sformatf("[AXI_Monitor] Gathering information..."), UVM_MEDIUM);
                        req.s00_axi_awaddr = vif.s00_axi_awaddr;
                        req.s00_axi_wdata = vif.s00_axi_wdata;    
                     end
                 end

                 // Monitor and AXI read transaction
                 if(vif.s00_axi_arvalid == 1 && vif.s00_axi_arready == 1) begin
                    axi_read_transaction.sample();
                    req.s00_axi_rdata = vif.s00_axi_rdata;
                    req.s00_axi_araddr = vif.s00_axi_araddr;
                 end

                 // Send the item on transaction level to scoreboard
                 axi_analysis_port_collected.write(req);
            end
        end
    endtask : run_phase
 
    
endclass : conv_axi_agent_monitor
    
    
`endif