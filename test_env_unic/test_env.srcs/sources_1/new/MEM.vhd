----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2023 02:23:22 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           en : in std_logic);
end MEM;

architecture Behavioral of MEM is

type mem_type is array (0 to 31) of std_logic_vector (15 downto 0);
signal MEM: mem_type := (x"0001", x"0002", x"0003", x"0004", x"0005", others => x"0000");

begin
--scriere sincrona cu activare en 
process (clk, MemWrite)
begin
if rising_edge(clk) then
    if en = '1' and MemWrite = '1' then
            MEM(conv_integer(ALURes(4 downto 0))) <= RD2;
        end if;
end if;
end process;
--citire asincrona
MemData <= MEM(conv_integer(ALURes(4 downto 0)));

end Behavioral;
