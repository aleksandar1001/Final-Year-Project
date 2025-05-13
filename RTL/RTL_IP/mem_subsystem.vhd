----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2024 08:19:39 AM
-- Design Name: 
-- Module Name: mem_subsystem - Structorial
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

use work.utils_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_subsystem is
 generic (
    WIDTH : natural := 8;
    ADDR : natural := 16
   );
Port (
     clk : in std_logic;
     reset : in std_logic;
--Interfejs ka AXI kontroleru
     reg_data_i : in std_logic_vector(WIDTH - 1 downto 0);
     lines_wr_i : in std_logic;
     columns_wr_i : in std_logic;
     cmd_wr_i : in std_logic;
     
     
     lines_axi_o : out std_logic_vector(WIDTH - 1 downto 0);
     columns_axi_o : out std_logic_vector(WIDTH - 1 downto 0);
     cmd_axi_o : out std_logic;
     start_dva_from_jedan_axi_o : out std_logic;
     start_tri_from_dva_axi_o : out std_logic;
     start_cetiri_from_tri_axi_o : out std_logic;
     status_axi_o : out std_logic;

--Interfejsi ka Convolueru
     lines_o : out std_logic_vector(WIDTH - 1 downto 0);
     columns_o : out std_logic_vector(WIDTH - 1 downto 0);
     start_o : out std_logic;
     ready_i : in std_logic;
     start_dva_from_jedan_i : in std_logic;
     start_tri_from_dva_i : in std_logic;
     start_cetiri_from_tri_i : in std_logic
   );
end mem_subsystem;

architecture Structorial of mem_subsystem is

    signal lines_s, columns_s: std_logic_vector(WIDTH - 1 downto 0);
    signal status_s: std_logic;
    signal cmd_s : std_logic;
    signal start_dva_from_jedan_s, start_tri_from_dva_s, start_cetiri_from_tri_s : std_logic;
    
    signal en_img_s, en_ker_s, en_res_s: std_logic;
begin
    
    columns_o <= columns_s;
    lines_o <= lines_s;
    start_o <= cmd_s;
    
     ----------------------REGISTRI----------------------
     columns_axi_o <= columns_s;
     lines_axi_o <= lines_s;
     cmd_axi_o <= cmd_s;
     status_axi_o <= status_s;
     start_dva_from_jedan_axi_o <= start_dva_from_jedan_s;
     start_tri_from_dva_axi_o <= start_tri_from_dva_s;
     start_cetiri_from_tri_axi_o <= start_cetiri_from_tri_s;
    
--COLUMNS registar
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            columns_s <= (others => '0');
        elsif columns_wr_i = '1' then
            columns_s <= reg_data_i;
        end if;
    end if;
end process;
 
 --LINES registar
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            lines_s <= (others => '0');
        elsif lines_wr_i = '1' then
            lines_s <= reg_data_i;
        end if;
    end if;
end process;
 
 --CMD registar
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            cmd_s <= '0';
        elsif cmd_wr_i = '1' then
            cmd_s <= reg_data_i(0);
        end if;
    end if;
end process;
 
 --STATUS registar
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            status_s <= '0';
        else
            status_s <= ready_i;
        end if;
    end if;
end process;

 --Start_dva_from_jedan registar
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            start_dva_from_jedan_s <= '0';
        else
            start_dva_from_jedan_s <= start_dva_from_jedan_i;
        end if;
    end if;
end process;

 --Start_tri_from_dva registar
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            start_tri_from_dva_s <= '0';
        else
            start_tri_from_dva_s <= start_tri_from_dva_i;
        end if;
    end if;
end process;

 --Start_cetiri_from_tri registar
process(clk)
begin
    if clk'event and clk = '1' then
        if reset = '1' then
            start_cetiri_from_tri_s <= '0';
        else
            start_cetiri_from_tri_s <= start_cetiri_from_tri_i;
        end if;
    end if;
end process;
 
end Structorial;
