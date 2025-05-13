`ifndef CONV_INTERFACE_SV
    `define CONV_INTERFACE_SV


interface conv_interface(input clk, logic rst);

    parameter C_S00_AXI_DATA_WIDTH = 32;
    parameter C_S00_AXI_ADDR_WIDTH = 5;
    parameter ADDR = 16;
    parameter WIDTH = 8;

    // AXI4 Lite interface
    logic [C_S00_AXI_ADDR_WIDTH - 1 : 0] s00_axi_awaddr;
    logic [2 : 0] s00_axi_awprot;
    logic s00_axi_awvalid;
    logic s00_axi_awready;
    logic [C_S00_AXI_DATA_WIDTH - 1 : 0] s00_axi_wdata;
    logic [(C_S00_AXI_DATA_WIDTH/8) - 1 : 0] s00_axi_wstrb;
    logic s00_axi_wvalid;
    logic s00_axi_wready;
    logic [1 : 0] s00_axi_bresp;
    logic s00_axi_bvalid;
    logic s00_axi_bready;
    logic [C_S00_AXI_ADDR_WIDTH - 1 : 0] s00_axi_araddr;
    logic [2 : 0] s00_axi_arprot;
    logic s00_axi_arvalid;
    logic s00_axi_arready;
    logic [C_S00_AXI_DATA_WIDTH - 1 : 0] s00_axi_rdata;
    logic [1 : 0] s00_axi_rresp;
    logic s00_axi_rvalid;
    logic s00_axi_rready;
    
    
    // Convoluer2D interface
        // Input image
        logic [ADDR - 1 : 0] img_addr_o;
        logic [WIDTH - 1 : 0] img_data_i;
        logic img_wr_o;
       
        // Kernels
        logic [ADDR - 1 : 0] ker_addr1_o;
        logic [WIDTH - 1 : 0] ker_data1_i;
        logic ker_wr1_o;
         
        logic [ADDR - 1 : 0] ker_addr2_o;
        logic [WIDTH - 1 : 0] ker_data2_i;
        logic ker_wr2_o;
         
        logic [ADDR - 1 : 0] ker_addr3_o;
        logic [WIDTH - 1 : 0] ker_data3_i;
        logic ker_wr3_o;
         
        logic [ADDR - 1 : 0] ker_addr4_o;
        logic [WIDTH - 1 : 0] ker_data4_i;
        logic ker_wr4_o;
         
        // Output image
        logic [ADDR - 1 : 0] res_addr_o;
        logic [WIDTH - 1 : 0] res_data_o;
        logic res_wr_o;
        logic res_en_o; 
        
     // Interface signals for stimulus
         // Input image
         logic [ADDR - 1 : 0] mem_img_addr_o_s;
         logic [WIDTH - 1 : 0] mem_img_data_i_s;
         logic mem_img_wr_o_s;
         
         // Kernel one
         logic [ADDR - 1 : 0] mem_ker_addr1_o_s;
         logic [WIDTH - 1 : 0] mem_ker_data1_i_s;
         logic mem_ker_wr1_o_s;
         
         // Kernel one
         logic [ADDR - 1 : 0] mem_ker_addr2_o_s;
         logic [WIDTH - 1 : 0] mem_ker_data2_i_s;
         logic mem_ker_wr2_o_s;
         
         // Kernel one
         logic [ADDR - 1 : 0] mem_ker_addr3_o_s;
         logic [WIDTH - 1 : 0] mem_ker_data3_i_s;
         logic mem_ker_wr3_o_s;
         
         // Kernel one
         logic [ADDR - 1 : 0] mem_ker_addr4_o_s;
         logic [WIDTH - 1 : 0] mem_ker_data4_i_s;
         logic mem_ker_wr4_o_s;
                  
endinterface : conv_interface

     
`endif
