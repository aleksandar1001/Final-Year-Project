library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity BRAM is
 generic (
     WIDTH: integer := 8;
     SIZE : integer := 12;
     ADDR : natural := 16
 );
 port (
     clka : in std_logic;
     
     reseta : in std_logic;
     
     wea : in std_logic;
     web : in std_logic;
     
     addra : in std_logic_vector(ADDR - 1 downto 0);
     addrb : in std_logic_vector(ADDR - 1 downto 0);
     
     dia : in std_logic_vector(WIDTH - 1 downto 0);
     dib : in std_logic_vector(WIDTH - 1 downto 0);
     
     doa : out std_logic_vector(WIDTH - 1 downto 0);
     dob : out std_logic_vector(WIDTH - 1 downto 0)
 );
end BRAM;

architecture beh of BRAM is
     type mem_t is array (0 to (SIZE * SIZE - 1)) of std_logic_vector(WIDTH-1 downto 0);
     signal mem_s : mem_t;
begin
     process (clka)
    begin
        if (clka'event and clka = '1') then
            if (reseta = '0') then
                mem_s <= (others => (others => '0'));
            else
                if (wea = '1') then
                    mem_s(conv_integer(addra)) <= dia;
                end if;
                if (web = '1') then
                    mem_s(conv_integer(addrb)) <= dib;
                end if;
                doa <= mem_s(conv_integer(addra));
                dob <= mem_s(conv_integer(addrb));
    end if;
 end if;
 end process;
 
end beh;