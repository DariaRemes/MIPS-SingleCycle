----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2023 02:34:16 PM
-- Design Name: 
-- Module Name: IDunit - Behavioral
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

entity IDunit is
    Port ( RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC);
end IDunit;

architecture Behavioral of IDunit is

-- includ REGfile ca si componenta 
component REGfile is
    Port ( clk : in STD_LOGIC;
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           RegWr : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           en : in std_logic);
end component;

--iesire mux
signal wa_mux: std_logic_vector(2 downto 0);

begin

-- conectare REGfile 
conectare_REGfile: REGfile
port map (clk => clk,
           ra1 => Instr(12 downto 10),
           ra2 => Instr(9 downto 7),
           wa => wa_mux,
           wd => WD,
           RegWr => RegWrite,
           rd1 => RD1,
           rd2 => RD2,
           en => en);

-- mux 2:1 
with RegDst select
    wa_mux <= Instr(6 downto 4) when '1', 
              Instr(9 downto 7) when '0',  
              (others => 'X') when others; --unknown 

--Ext Unit 
process(ExtOp)
begin 
if(ExtOp = '1') then
    if(Instr(6) = '1') then
        Ext_Imm <= "111111111" & Instr(6 downto 0);
    else
        Ext_Imm <= "000000000" & Instr(6 downto 0);
    end if;
else
    Ext_Imm <= "000000000" & Instr(6 downto 0);
end if;
end process;

func <= Instr(2 downto 0);
sa <= Instr(3);
    
end Behavioral;
