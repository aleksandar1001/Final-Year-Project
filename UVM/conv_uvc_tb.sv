module conv_uvc_tb;
   
  
    // Include uvm package and uvm macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"  

 
    // Include test package
    import test_pkg::*; 
 
 
    // Standard signals
    reg clk;
    reg rst;    
    
    
    // Interface
    conv_interface vif (clk, rst);    
 
  
    axi_convoluer_v1_0 DUT(  
        .s00_axi_aclk (clk),
        .s00_axi_aresetn (rst),
        .s00_axi_awaddr (vif.s00_axi_awaddr),
        .s00_axi_awprot (vif.s00_axi_awprot),
        .s00_axi_awvalid (vif.s00_axi_awvalid),
        .s00_axi_awready (vif.s00_axi_awready),
        .s00_axi_wdata (vif.s00_axi_wdata),
        .s00_axi_wstrb (vif.s00_axi_wstrb),
        .s00_axi_wvalid (vif.s00_axi_wvalid),
        .s00_axi_wready (vif.s00_axi_wready),
        .s00_axi_bresp (vif.s00_axi_bresp),
        .s00_axi_bvalid (vif.s00_axi_bvalid),
        .s00_axi_bready (vif.s00_axi_bready),
        .s00_axi_araddr (vif.s00_axi_araddr),
        .s00_axi_arprot (vif.s00_axi_arprot),
        .s00_axi_arvalid (vif.s00_axi_arvalid),
        .s00_axi_arready (vif.s00_axi_arready),
        .s00_axi_rdata   (vif.s00_axi_rdata),
        .s00_axi_rresp (vif.s00_axi_rresp),
        .s00_axi_rvalid (vif.s00_axi_rvalid),
        .s00_axi_rready (vif.s00_axi_rready),       
              
        .img_addr_o (vif.img_addr_o),
        .img_data_i (vif.img_data_i),
        .img_wr_o (vif.img_wr_o),
      
        .ker_addr1_o (vif.ker_addr1_o),
        .ker_data1_i (vif.ker_data1_i),
        .ker_wr1_o (vif.ker_wr1_o),
       
        .ker_addr2_o (vif.ker_addr2_o),
        .ker_data2_i (vif.ker_data2_i),
        .ker_wr2_o (vif.ker_wr2_o),

        .ker_addr3_o (vif.ker_addr3_o),
        .ker_data3_i (vif.ker_data3_i),
        .ker_wr3_o (vif.ker_wr3_o),

        .ker_addr4_o (vif.ker_addr4_o),
        .ker_data4_i (vif.ker_data4_i),
        .ker_wr4_o (vif.ker_wr4_o),
     
        .res_addr_o (vif.res_addr_o),
        .res_data_o (vif.res_data_o),
        .res_wr_o (vif.res_wr_o),
        .res_en_o (vif.res_en_o)
    );


    BRAM img_mem(
        .clka (clk),
        .reseta (rst),
        .addra (vif.mem_img_addr_o_s),
        .dia (vif.mem_img_data_i_s),
        .doa (),
        .wea (vif.mem_img_wr_o_s),
        .addrb (vif.img_addr_o),
        .dib (0),
        .dob (vif.img_data_i),
        .web (vif.img_wr_o)
    );


    BRAM ker1_mem(
        .clka (clk),
        .reseta (rst),
        .addra (vif.mem_ker_addr1_o_s),
        .dia (vif.mem_ker_data1_i_s),
        .doa (),
        .wea (vif.mem_ker_wr1_o_s),
        .addrb (vif.ker_addr1_o),
        .dib (0),
        .dob (vif.ker_data1_i),
        .web (vif.ker_wr1_o)
    );

  
    BRAM ker2_mem(
        .clka (clk),
        .reseta (rst),
        .addra (vif.mem_ker_addr2_o_s),
        .dia (vif.mem_ker_data2_i_s),
        .doa (),
        .wea (vif.mem_ker_wr2_o_s),
        .addrb (vif.ker_addr2_o),
        .dib (0),
        .dob (vif.ker_data2_i),
        .web (vif.ker_wr2_o)
    );

    BRAM ker3_mem(
        .clka (clk),
        .reseta (rst),
        .addra (vif.mem_ker_addr3_o_s),
        .dia (vif.mem_ker_data3_i_s),
        .doa (),
        .wea (vif.mem_ker_wr3_o_s),
        .addrb (vif.ker_addr3_o),
        .dib (0),
        .dob (vif.ker_data3_i),
        .web (vif.ker_wr3_o)
    );

   

    BRAM ker4_mem(
        .clka (clk),
        .reseta (rst),
        .addra (vif.mem_ker_addr4_o_s),
        .dia (vif.mem_ker_data4_i_s),
        .doa (),
        .wea (vif.mem_ker_wr4_o_s),
        .addrb (vif.ker_addr4_o),
        .dib (0),
        .dob (vif.ker_data4_i),
        .web (vif.ker_wr4_o)
    );
    
                 

    // UVM Initial block: Interface wrapping & run_test()
    initial begin
        uvm_config_db#(virtual conv_interface)::set(null, "*", "vif", vif);
        run_test("conv_simple_test");
    end
     
    
    // UVM initial block: clock and reset initialization
    initial begin
    
        clk = 0;
        rst = 0; 

        #100ns;

        rst = 1; 
    end

  
    // UVM always block: clk generator
    always #25ns clk = ~clk;
    
    

    
endmodule : conv_uvc_tb        