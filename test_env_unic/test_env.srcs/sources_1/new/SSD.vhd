----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2023 02:26:31 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
    Port ( digits : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSD;

architecture Behavioral of SSD is

signal count_int: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; -- iesire counter
signal s: STD_LOGIC_VECTOR(1 downto 0) := "00"; -- selectie mux
signal seg_in: STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- intrare 7 segment
begin

-- counter pe 16 biti 
process(clk)
begin
    if(clk'event and clk='1') then
        count_int <= count_int + 1;
    end if;
end process;

-- mux 4:1 catod
s <= count_int(15 downto 14);
process(s,digits)
begin
    case s is 
        when "00" => seg_in <= digits(15 downto 12);
        when "01" => seg_in <= digits(11 downto 8);
        when "10" => seg_in <= digits(7 downto 4); 
        when others => seg_in <= digits(3 downto 0);
    end case;
end process;

-- mux 4:1 an 
process(s)
begin
    case s is 
        when "00" => an <= "0111";
        when "01" => an <= "1011";
        when "10" => an <= "1101";
        when others => an <= "1110";
     end case;
end process;

-- hex to 7 seg dcd 

 with seg_in SELect
   cat <= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0


end Behavioral;
