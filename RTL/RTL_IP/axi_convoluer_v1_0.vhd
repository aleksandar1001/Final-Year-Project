library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_convoluer_v1_0 is
	generic (
		-- Users to add parameters here
        WIDTH : natural := 8;
        ADDR : natural := 16;
        SIZE : natural := 12;
        kernelSize : natural := 3;
        numKernels : natural := 4;
        Kolone : natural := 12;
        Linije : natural := 12;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 5
	);
	port (
		-- Users to add ports here
        res_addr_o : out std_logic_vector(ADDR - 1 downto 0);
        res_data_o : out std_logic_vector(WIDTH - 1 downto 0);
        res_wr_o : out std_logic; 
        res_en_o : out std_logic;  
        
        img_addr_o : out std_logic_vector(ADDR - 1 downto 0);
        img_data_i : in std_logic_vector(WIDTH - 1 downto 0);
        img_wr_o : out std_logic;
    
        ker_addr1_o : out std_logic_vector(ADDR - 1 downto 0);
        ker_data1_i : in std_logic_vector(WIDTH - 1 downto 0);
        ker_wr1_o : out std_logic;
        
        ker_addr2_o : out std_logic_vector(ADDR - 1 downto 0);
        ker_data2_i : in std_logic_vector(WIDTH - 1 downto 0);
        ker_wr2_o : out std_logic;
        
        ker_addr3_o : out std_logic_vector(ADDR - 1 downto 0);
        ker_data3_i : in std_logic_vector(WIDTH - 1 downto 0);
        ker_wr3_o : out std_logic;
        
        ker_addr4_o : out std_logic_vector(ADDR - 1 downto 0);
        ker_data4_i : in std_logic_vector(WIDTH - 1 downto 0);
        ker_wr4_o : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end axi_convoluer_v1_0;

architecture arch_imp of axi_convoluer_v1_0 is

    signal reset_s : std_logic;
    
    ------------------ AXI Lite Interface ---------------------
        signal s_reg_data_o : std_logic_vector(WIDTH - 1 downto 0);
        signal s_lines_wr_o : std_logic;
        signal s_columns_wr_o : std_logic;
        signal s_cmd_wr_o : std_logic;
        
        signal s_lines_axi_i : std_logic_vector(WIDTH - 1 downto 0);
        signal s_columns_axi_i : std_logic_vector(WIDTH - 1 downto 0);
        signal s_cmd_axi_i : std_logic;
        signal s_start_dva_from_jedan_axi_i : std_logic;
        signal s_start_tri_from_dva_axi_i : std_logic;
        signal s_start_cetiri_from_tri_axi_i : std_logic;
        signal s_status_axi_i : std_logic;
        
        ------------------ Interface to IP -------------------------
        signal s_img_addr_o : std_logic_vector(ADDR - 1 downto 0);
        signal s_img_data_i : std_logic_vector(WIDTH - 1 downto 0);
        signal s_img_wr_o : std_logic;
        
        signal s_ker_addr1_o : std_logic_vector(ADDR - 1 downto 0);
        signal s_ker_data1_i : std_logic_vector(WIDTH - 1 downto 0);
        signal s_ker_wr1_o : std_logic;
        
        signal s_ker_addr2_o : std_logic_vector(ADDR - 1 downto 0);
        signal s_ker_data2_i : std_logic_vector(WIDTH - 1 downto 0);
        signal s_ker_wr2_o : std_logic;
        
        signal s_ker_addr3_o : std_logic_vector(ADDR - 1 downto 0);
        signal s_ker_data3_i : std_logic_vector(WIDTH - 1 downto 0);
        signal s_ker_wr3_o : std_logic;
        
        signal s_ker_addr4_o : std_logic_vector(ADDR - 1 downto 0);
        signal s_ker_data4_i : std_logic_vector(WIDTH - 1 downto 0);
        signal s_ker_wr4_o : std_logic;
        
        signal s_res_addr_o : std_logic_vector(ADDR - 1 downto 0);
        signal s_res_data_i : std_logic_vector(WIDTH - 1 downto 0);
        signal s_res_wr_o : std_logic;
        signal s_res_en_o : std_logic;
        
        signal s_lines : std_logic_vector(WIDTH - 1 downto 0);
        signal s_columns : std_logic_vector(WIDTH - 1 downto 0);
        
        signal s_start : std_logic;
        signal s_start_dva_from_jedan, s_start_tri_from_dva, s_start_cetiri_from_tri : std_logic;
        signal s_ready : std_logic;

	-- component declaration
	component axi_convoluer_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component axi_convoluer_v1_0_S00_AXI;

begin

    reset_s <= not s00_axi_aresetn;
    
    res_addr_o <= s_res_addr_o;
    img_addr_o <= s_img_addr_o;
    res_wr_o  <= s_res_wr_o; 
    res_en_o <= s_res_en_o;
    img_wr_o <= s_img_wr_o;
    res_data_o <= s_res_data_i;
    s_img_data_i <= img_data_i;
    s_ker_data1_i <= ker_data1_i;
    ker_addr1_o <= s_ker_addr1_o;
    ker_wr1_o <= s_ker_wr1_o;
    s_ker_data2_i <= ker_data2_i;
    ker_addr2_o <= s_ker_addr2_o;
    ker_wr2_o <= s_ker_wr2_o;
    s_ker_data3_i <= ker_data3_i;
    ker_addr3_o <= s_ker_addr3_o;
    ker_wr3_o <= s_ker_wr3_o;
    s_ker_data4_i <= ker_data4_i;
    ker_addr4_o <= s_ker_addr4_o;
    ker_wr4_o <= s_ker_wr4_o;

   -- Instantiation of Axi Bus Interface S00_AXI
AXI_LITE_KONTROLER : entity work.axi_convoluer_v1_0_S00_AXI(arch_imp)
	generic map (
	    WIDTH => WIDTH,
	    ADDR => ADDR,
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    reg_data_o => s_reg_data_o,
	    lines_wr_o => s_lines_wr_o,
	    columns_wr_o => s_columns_wr_o,
	    cmd_wr_o => s_cmd_wr_o,
	    
	    lines_axi_i => s_lines_axi_i,
	    columns_axi_i => s_columns_axi_i,
	    cmd_axi_i => s_cmd_axi_i,
	    start_dva_from_jedan_axi_i => s_start_dva_from_jedan_axi_i,
	    start_tri_from_dva_axi_i => s_start_tri_from_dva_axi_i,
	    start_cetiri_from_tri_axi_i => s_start_cetiri_from_tri_axi_i,
	    status_axi_i => s_status_axi_i,
	    
	    ------------------AXI------------------
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

    
	-- Add user logic here
    
    mem_subsystem_inst: entity work.mem_subsystem
	generic map( WIDTH => WIDTH,
	             ADDR => ADDR
	       )
	port map (
                clk => s00_axi_aclk,
                reset => reset_s,
                
                -- Interface to the AXI controllers
                reg_data_i => s_reg_data_o,
                lines_wr_i => s_lines_wr_o,
                columns_wr_i => s_columns_wr_o,
                cmd_wr_i => s_cmd_wr_o,
                
                lines_axi_o => s_lines_axi_i,
                columns_axi_o => s_columns_axi_i,
                cmd_axi_o => s_cmd_axi_i,
                status_axi_o => s_status_axi_i,
                start_dva_from_jedan_axi_o => s_start_dva_from_jedan_axi_i,
                start_tri_from_dva_axi_o => s_start_tri_from_dva_axi_i,
                start_cetiri_from_tri_axi_o => s_start_cetiri_from_tri_axi_i,
                
                -- Interface to the IP module
                lines_o => s_lines,
                columns_o => s_columns,
                start_o => s_start,
                ready_i => s_ready,
                start_dva_from_jedan_i => s_start_dva_from_jedan,
                start_tri_from_dva_i => s_start_tri_from_dva,
                start_cetiri_from_tri_i => s_start_cetiri_from_tri
	           );
    
    Convoluer2D : entity work.Convoluer2D
    generic map(
        WIDTH => WIDTH,
        ADDR => ADDR,
        kernelSize => kernelSize
        )
    port map(
        clk => s00_axi_aclk,
                reset => reset_s,
                img_addr_o => s_img_addr_o,
                img_data_i => s_img_data_i,
                img_wr_o => s_img_wr_o,
                ker_addr1_o => s_ker_addr1_o,
                ker_data1_i => s_ker_data1_i,
                ker_wr1_o => s_ker_wr1_o,
                ker_addr2_o => s_ker_addr2_o,
                ker_data2_i => s_ker_data2_i,
                ker_wr2_o => s_ker_wr2_o,
                ker_addr3_o => s_ker_addr3_o,
                ker_data3_i => s_ker_data3_i,
                ker_wr3_o => s_ker_wr3_o,               
                ker_addr4_o => s_ker_addr4_o,
                ker_data4_i => s_ker_data4_i,
                ker_wr4_o => s_ker_wr4_o,
                res_addr_o => s_res_addr_o,
                res_data_o => s_res_data_i,
                res_wr_o => s_res_wr_o,
                res_en_o => s_res_en_o,
                start => s_start,
                ready => s_ready,
                start_dva_from_jedan => s_start_dva_from_jedan,
                start_tri_from_dva => s_start_tri_from_dva,
                start_cetiri_from_tri => s_start_cetiri_from_tri,
                columns => s_columns,
                lines => s_lines
    );
	-- User logic ends

end arch_imp;
