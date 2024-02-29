----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 02:31:40 PM
-- Design Name: 
-- Module Name: IFunit - Behavioral
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

entity IFunit is
    Port ( clk : in STD_LOGIC;
           BranchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           JmpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Instr : out STD_LOGIC_VECTOR (15 downto 0);
           AddrNext : out STD_LOGIC_VECTOR (15 downto 0);
           load: in STD_LOGIC;
           reset: in STD_LOGIC);
end IFunit;

architecture Behavioral of IFunit is

signal PC_out: std_logic_vector(15 downto 0) := x"0000";
signal mux_out_1: std_logic_vector(15 downto 0) := x"0000";
signal mux_out_2: std_logic_vector(15 downto 0) := x"0000";
signal sum_out: std_logic_vector(15 downto 0) := x"0000";

-- memorie ROM
type mem256_16 is array(0 to 255) of std_logic_vector(15 downto 0);
-- initializare memorie
signal myROM : mem256_16 := (

    B"000_000_000_001_0_000", --X"0010"  --add $1,$0,$0           -0 
    B"001_000_100_0000101",   --X"2205"  --addi $4,$0,5           -1 
    B"000_000_000_101_0_000", --X"0050"  --add $5,$0,$0           -2 
    B"100_001_100_0000110",   --X"8606"  --beq $1,$4,6(end_loop)  -3 
    B"010_001_011_0000000",   --X"4580"  --lw $3,0($1)(A_addr)    -4
    B"000_011_011_110_0_111", --X"0DE7"  --mult $6,$3,$3          -5 
    B"011_001_110_0000000",   --X"6700"  --sw $6,0($1)(A_addr)    -6
    B"000_101_110_101_0_000", --X"1750"  --add $5,$5,$6           -7
    B"001_001_001_0000001",   --X"2481"  --addi $1,$1,1           -8
    B"111_0000000000011",     --X"E003"  --j 3(begin_loop)        -9
    B"011_000_101_0001010",   --X"628A"  --sw $5,10($0)(sum_addr) -10
    
    others => X"0000");       --NoOp                              -11

begin

-- PC care e defapt un bistabil D
process(clk)
begin
if reset = '1' then
    PC_out <= "0000000000000000";
end if;
if rising_edge(clk) then
    if load = '1' then
        PC_out <= mux_out_2;
    end if;
end if;
end process;

-- sumator 
sum_out <= PC_out + 1;

-- mux 1 
process(sum_out, BranchAddr, PCSrc)
begin
case PCSrc is 
    when '0' => mux_out_1 <= sum_out;
    when others => mux_out_1 <= BranchAddr;
end case;
end process;

-- mux 2
process(JmpAddr, mux_out_1, Jump)
begin
case Jump is 
    when '0' => mux_out_2 <= mux_out_1;
    when others => mux_out_2 <= JmpAddr;
end case;
end process;

-- Instruction Memory => ROM 
AddrNext <= sum_out;
Instr <= myROM(conv_integer(PC_out));

end Behavioral;
