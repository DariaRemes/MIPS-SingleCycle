----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2023 09:17:52 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
    Port ( clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           ra : in STD_LOGIC_vector(3 downto 0);
           wa : in STD_LOGIC_VECTOR (3 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd : out STD_LOGIC_VECTOR (15 downto 0));
end RAM;

architecture Behavioral of RAM is

type ram_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal RAM: ram_type := (x"0000", x"0001", x"0002", x"0003", x"0004", x"0005", x"0006", x"0007", others => x"0000");


begin

process (clk, MemWrite)
begin
if clk'event and clk = '1' then
    if MemWrite = '1' then
            RAM(conv_integer(wa)) <= wd;
            rd <= wd;
        else
            rd <= RAM(conv_integer(ra));
     end if;
end if;
end process;

end Behavioral;
