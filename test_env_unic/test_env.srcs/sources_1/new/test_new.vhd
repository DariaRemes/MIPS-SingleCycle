----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 09:32:48 PM
-- Design Name: 
-- Module Name: test_new - Behavioral
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

entity test_new is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_new;

architecture Behavioral of test_new is

signal counter: STD_LOGIC_VECTOR(2 downto 0) := "000";
signal RES: STD_LOGIC_VECTOR(7 downto 0):= "00000000";

-- includ MPG ca si componenta
component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;
-- iesire din MPG
signal en:std_logic;

begin

conectare : MPG
port map (btn => btn(0),
          clk => clk,
          en => en);


-- counter pe 3 biti 
process(clk)
begin
if(clk = '1' and clk'event)then
    if (en = '1') then
     if (sw(0) = '1') then
        counter <= counter + 1;
     else 
        counter <= counter - 1;
     end if;
    end if;
end if;
end process;

-- decodificator 3:8 biti
-- counter intrare pe 3 biti
-- RES iesire decodificata pe 8 biti
process(counter)
begin
    case counter is
        when "000" => RES <="00000001";
        when "001" => RES <= "00000010";
        when "010" => RES <= "00000100";
        when "011" => RES <= "00001000";
        when "100" => RES <= "00010000";
        when "101" => RES <= "00100000";
        when "110" => RES <= "01000000";
        when others => RES <= "10000000";
 end case;
end process;

led(7 downto 0) <= RES;
end Behavioral;

