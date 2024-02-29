----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2023 12:34:03 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end ALU;

architecture Behavioral of ALU is

-- semnale ALU
signal en: STD_LOGIC;
signal cnt: STD_LOGIC_VECTOR(1 downto 0) := "00";
signal a: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal b: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal c: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal digits: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; --iesire 

-- includ MPG ca si componenta
component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

-- includ SSD ca si componenta 
component SSD is
    Port ( digits : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

begin

-- conectez MPG
conectare_MPG : MPG
port map (btn => btn(0),
          clk => clk,
          en => en);
          
 -- conectare SSD         
conectare_SSD: SSD
port map (digits => digits,
            clk => clk,
            an => an,
            cat => cat); 

-- operatori 
a(3 downto 0) <= sw(3 downto 0);
b(3 downto 0) <= sw(7 downto 4);
c(7 downto 0) <= sw(7 downto 0); 

-- counter pe 2 biti
process(clk)
begin
if(clk = '1' and clk'event)then
if (en = '1') then
  --  if (sw(0) = '1') then
        cnt <= cnt + 1;
   -- else 
       -- cnt <= cnt - 1;
    end if;
end if;
-- end if;
end process;

-- mux 4:1 
process(cnt,a,b,c)
begin
case cnt is 
    when "00" => digits <= a+b;
    when "01" => digits <= a-b;
    when "10" => digits <= c(13 downto 0) & "00"; -- shift left
    when others => digits <= "00" & c(15 downto 2); -- shift right 
                    --digits(15 downto 14) <= "00";
end case;
end process;

-- zero detector 
process(digits)
begin
if (digits = 0) then
        led(7) <= '1';
else led(7) <= '0';
end if;
end process;

end Behavioral;
