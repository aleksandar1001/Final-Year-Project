`ifndef CONV_DRIVER_SV
    `define CONV_DRIVER_SV
    

class conv_driver extends uvm_driver #(conv_item);


    // Factory registration
    `uvm_component_utils(conv_driver)
    
    
    // CONV_driver fields
    virtual conv_interface vif;
    conv_config cfg;
    conv_item req_item;
    
    
    // Constructor
    function new(string name = "conv_driver", uvm_component parent); 
        super.new(name, parent);    
    endfunction : new


    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

     if(!uvm_config_db#(virtual conv_interface)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ", get_full_name(), ".vif"})

    if(!uvm_config_db#(conv_config)::get(this, "", "cfg", cfg))
         `uvm_fatal(get_full_name(), "Failed to get config object")
    endfunction : build_phase
    
    
    // Run phase
    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk)
            if(vif.rst) begin
                seq_item_port.get_next_item(req_item);
                `uvm_info(get_type_name(), $sformatf("Driver sending...\\n%s", req.sprint()), UVM_HIGH)
                                 
                if(req_item.bram_axi == 3'd0) begin
                    $display("DRIVER: Usao u transakciju za pisanje ulazne slike, BRAM_AXI = 0");
                    vif.mem_img_addr_o_s = req_item.img_addr;
                    vif.mem_img_data_i_s = req_item.img_data;
                    $display("DRIVER: Upisan je podatak ->  %d", req_item.img_data);
                    vif.mem_img_wr_o_s = req_item.img_wr;

                end else if(req_item.bram_axi == 3'd2) begin
                    $display("DRIVER: Usao u transakciju za pisanje prvog kernela, BRAM_AXI = 2");
                    vif.mem_ker_addr1_o_s = req_item.ker_one_addr;
                    vif.mem_ker_data1_i_s = req_item.ker_one_data;
                    $display("DRIVER: Upisan je podatak ->  %d", req_item.ker_one_data);
                    vif.mem_ker_wr1_o_s = req_item.ker_one_wr;
                                    
                end else if(req_item.bram_axi == 3'd3) begin
                    $display("DRIVER: Usao u transakciju za pisanje drugog kernela, BRAM_AXI = 3");
                    vif.mem_ker_addr2_o_s = req_item.ker_two_addr;
                    vif.mem_ker_data2_i_s = req_item.ker_two_data;
                    $display("DRIVER: Upisan je podatak ->  %d", req_item.ker_two_data);
                    vif.mem_ker_wr2_o_s = req_item.ker_two_wr;
                
                end else if(req_item.bram_axi == 3'd4) begin
                    $display("DRIVER: Usao u transakciju za pisanje treceg kernela, BRAM_AXI = 4");
                    vif.mem_ker_addr3_o_s = req_item.ker_three_addr;
                    vif.mem_ker_data3_i_s = req_item.ker_three_data;
                    $display("DRIVER: Upisan je podatak ->  %d", req_item.ker_three_data);
                    vif.mem_ker_wr3_o_s = req_item.ker_three_wr;
                                                       
                end else if(req_item.bram_axi == 3'd5) begin
                    $display("DRIVER: Usao u transakciju za pisanje cetvrtog kernela, BRAM_AXI = 5");
                    vif.mem_ker_addr4_o_s = req_item.ker_four_addr;
                    vif.mem_ker_data4_i_s = req_item.ker_four_data;
                    $display("DRIVER: Upisan je podatak ->  %d", req_item.ker_four_data);
                    vif.mem_ker_wr4_o_s = req_item.ker_four_wr;
                    
               end else if(req_item.bram_axi == 3'd6) begin
                   $display("DRIVER: Usao u transakciju za testiranje koncepta protocne obrade, BRAM_AXI = 6");
                   
                    vif.s00_axi_awaddr = req_item.s00_axi_awaddr;
                    vif.s00_axi_wdata = req_item.s00_axi_wdata;
                    vif.s00_axi_wstrb = 4'b1111;
                    vif.s00_axi_awvalid = 1'b1;
                    vif.s00_axi_wvalid = 1'b1;
                    vif.s00_axi_bready = 1'b1;

                    @(posedge vif.clk iff vif.s00_axi_awready);
                    @(posedge vif.clk iff !vif.s00_axi_awready);

                    vif.s00_axi_awvalid = 1'b0;
                    vif.s00_axi_awaddr = 1'b0;
                    vif.s00_axi_wdata = 1'b0;
                    vif.s00_axi_wvalid = 1'b0;
                    vif.s00_axi_wstrb = 4'b0000;  
    
                    @(posedge vif.clk iff !vif.s00_axi_bvalid);       
                    vif.s00_axi_bready = 1'b0;
                   
                   if(req_item.s00_axi_awaddr == AXI_BASE + CMD_REG_OFFSET && req_item.s00_axi_wdata == 1) begin 
                       // Trigger the start bit again
                        vif.s00_axi_arprot = 3'b000;
                        vif.s00_axi_araddr = AXI_BASE + STATUS_REG_OFFSET;
                        vif.s00_axi_arvalid = 1'b1;
                        vif.s00_axi_rready = 1'b1;
                                                  
                        @(posedge vif.clk iff vif.s00_axi_arready == 0);
                        @(posedge vif.clk iff vif.s00_axi_arready == 1);
                                        
                        vif.s00_axi_araddr = 4'd0;
                        vif.s00_axi_arvalid = 1'b0;
                                                   
                        wait(vif.s00_axi_rdata == 0)
                                       
                        // clear the start bit
                        vif.s00_axi_awaddr = AXI_BASE + CMD_REG_OFFSET;
                        vif.s00_axi_wdata = 32'd0;
                        vif.s00_axi_wstrb = 4'b1111;
                        vif.s00_axi_awvalid = 1'b1;
                        vif.s00_axi_wvalid = 1'b1;
                        vif.s00_axi_bready = 1'b1;

                        @(posedge vif.clk iff vif.s00_axi_awready);
                        @(posedge vif.clk iff !vif.s00_axi_awready);
            
                                         
                        vif.s00_axi_awvalid = 1'b0;
                        vif.s00_axi_awaddr = 1'b0;
                        vif.s00_axi_wdata = 1'b0;
                        vif.s00_axi_wvalid = 1'b0;
                        vif.s00_axi_wstrb = 4'b0000;

                        @(posedge vif.clk iff !vif.s00_axi_bvalid); 
                        vif.s00_axi_bready = 1'b0;
                        
                        // Wait till ready
                        vif.s00_axi_rdata = 32'b0;
                        vif.s00_axi_arprot = 3'b000;
                        vif.s00_axi_araddr = AXI_BASE + STATUS_REG_OFFSET;
                        vif.s00_axi_arvalid = 1'b1;
                        vif.s00_axi_rready  = 1'b1;  

                        @(posedge vif.clk iff vif.s00_axi_arready == 0);
                        @(posedge vif.clk iff vif.s00_axi_arready == 1);
        
                        wait(vif.s00_axi_rdata == 1)
                        //$display("Trenutno sim vreme je: %0t", $time);
                        vif.s00_axi_araddr = 5'd0;
                        vif.s00_axi_arvalid = 1'b0;
                        vif.s00_axi_rdata = 32'b0;
                        
                        $display("DRIVER: gotovo testiranje protocne obrade");
                   end          
                                               
                end else begin
                    // Axi write transaction
                    if(req_item.s00_axi_awaddr != AXI_BASE + CMD_REG_OFFSET)
                        $display("DRIVER: Usao u Inicijalizaciju AXI-ja -> BRAM_AXI = 1");
                    
                    vif.s00_axi_awaddr = req_item.s00_axi_awaddr;
                    vif.s00_axi_wdata = req_item.s00_axi_wdata;
                    vif.s00_axi_wstrb = 4'b1111;
                    vif.s00_axi_awvalid = 1'b1;
                    vif.s00_axi_wvalid = 1'b1;
                    vif.s00_axi_bready = 1'b1;

                    @(posedge vif.clk iff vif.s00_axi_awready);
                    @(posedge vif.clk iff !vif.s00_axi_awready);

                    vif.s00_axi_awvalid = 1'b0;
                    vif.s00_axi_awaddr = 1'b0;
                    vif.s00_axi_wdata = 1'b0;
                    vif.s00_axi_wvalid = 1'b0;
                    vif.s00_axi_wstrb = 4'b0000;  
    
                    @(posedge vif.clk iff !vif.s00_axi_bvalid);       
                    vif.s00_axi_bready = 1'b0;

                    if(req_item.s00_axi_awaddr == AXI_BASE + CMD_REG_OFFSET && req_item.s00_axi_wdata == 1) begin  // when sequence gives the start bit
                        $display("DRIVER: Okidanje startnog signala, awaddr = CMD_REG_OFFSET...");
                        vif.s00_axi_arprot = 3'b000;
                        vif.s00_axi_araddr = AXI_BASE + STATUS_REG_OFFSET;
                        vif.s00_axi_arvalid = 1'b1;
                        vif.s00_axi_rready = 1'b1;
                                                  
                        @(posedge vif.clk iff vif.s00_axi_arready == 0);
                        @(posedge vif.clk iff vif.s00_axi_arready == 1);
                                        
                        vif.s00_axi_araddr = 4'd0;
                        vif.s00_axi_arvalid = 1'b0;
                                                   
                        wait(vif.s00_axi_rdata == 0)
                                       
                        // clear the start bit
                        vif.s00_axi_awaddr = AXI_BASE + CMD_REG_OFFSET;
                        vif.s00_axi_wdata = 32'd0;
                        vif.s00_axi_wstrb = 4'b1111;
                        vif.s00_axi_awvalid = 1'b1;
                        vif.s00_axi_wvalid = 1'b1;
                        vif.s00_axi_bready = 1'b1;

                        @(posedge vif.clk iff vif.s00_axi_awready);
                        @(posedge vif.clk iff !vif.s00_axi_awready);
            
                                         
                        vif.s00_axi_awvalid = 1'b0;
                        vif.s00_axi_awaddr = 1'b0;
                        vif.s00_axi_wdata = 1'b0;
                        vif.s00_axi_wvalid = 1'b0;
                        vif.s00_axi_wstrb = 4'b0000;

                        @(posedge vif.clk iff !vif.s00_axi_bvalid); 
                        vif.s00_axi_bready = 1'b0;

                        // Reading ready_status register
                        $display("DRIVER: Cekanje na ready == 1");
                        
                        vif.s00_axi_arprot = 3'b000;
                        vif.s00_axi_araddr = AXI_BASE + STATUS_REG_OFFSET;
                        vif.s00_axi_arvalid = 1'b1;
                        vif.s00_axi_rready  = 1'b1;  

                        @(posedge vif.clk iff vif.s00_axi_arready == 0);
                        @(posedge vif.clk iff vif.s00_axi_arready == 1);
        
                        wait(vif.s00_axi_rdata == 1)
                        $display("Trenutno sim vreme je: %0t", $time);
                        vif.s00_axi_araddr = 5'd0;
                        vif.s00_axi_arvalid = 1'b0;

                        $display("DRIVER: Faza jedan se zavrsila, ostale faze ce se same okidati/zaustavlajti!");
                        $display("vif.s00_axi_rdata = %b", vif.s00_axi_rdata);
                        vif.s00_axi_rdata = 32'b0;
                        $display("vif.s00_axi_rdata = %b", vif.s00_axi_rdata);
                        
 
 //*************************************************************************************************//
 
                        // Reading start_tri_from_dva_status register
                        $display("DRIVER: Cekanje na start_tri_from_dva == 1");
                        vif.s00_axi_arprot = 3'b000;
                        vif.s00_axi_araddr = AXI_BASE + START_CETIRI_FROM_TRI_REG_OFFSET;
                        vif.s00_axi_arvalid = 1'b1;
                        vif.s00_axi_rready  = 1'b1;  

                        @(posedge vif.clk iff vif.s00_axi_arready == 0);
                        @(posedge vif.clk iff vif.s00_axi_arready == 1);
                         
                        wait(vif.s00_axi_rdata == 1)
                        
                        $display("vif.s00_axi_rdata = %b", vif.s00_axi_rdata);
                        
                        vif.s00_axi_araddr = 5'd0;
                        vif.s00_axi_arvalid = 1'b0;

                        $display("DRIVER: Faza dva se zavrsila");
                       
                    end                  
                end
                seq_item_port.item_done();
            end    // end if->rst
        end        // end forever
    endtask : run_phase
    

endclass : conv_driver
    
    
`endif