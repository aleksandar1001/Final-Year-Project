library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ker_mem is
 generic (
 WIDTH: natural := 8;
 SIZE: natural := 3;
 ADDR : natural := 16);
 port (
 clk: in std_logic;
 reset: in std_logic;
 --Pristup 1
 p1_addr_i: in std_logic_vector(ADDR - 1 downto 0);
 p1_data_i: in std_logic_vector(WIDTH - 1 downto 0);
 p1_data_o: out std_logic_vector(WIDTH - 1 downto 0);
 p1_wr_i: in std_logic;
 --Pristup 2
 p2_addr_i: in std_logic_vector(ADDR - 1 downto 0);
 p2_data_i: in std_logic_vector(WIDTH - 1 downto 0);
 p2_data_o: out std_logic_vector(WIDTH - 1 downto 0);
 p2_wr_i: in std_logic);
end ker_mem;

architecture Behavioral of ker_mem is

  type mem_t is array (0 to (SIZE * SIZE * 4 - 1)) of std_logic_vector(WIDTH - 1 downto 0);
  signal mem_s: mem_t;

begin

 process (clk)
 begin
 if (clk'event and clk = '1') then
    if (reset = '1') then
    mem_s <= (others => (others => '0'));
 else
    if (p1_wr_i = '1') then
        mem_s(conv_integer(p1_addr_i)) <= p1_data_i;
    end if;
    if (p2_wr_i = '1') then
        mem_s(conv_integer(p2_addr_i)) <= p2_data_i;
    end if;
    p1_data_o <= mem_s(conv_integer(p1_addr_i));
    p2_data_o <= mem_s(conv_integer(p2_addr_i));
    end if;
 end if;
 end process;

end Behavioral;
