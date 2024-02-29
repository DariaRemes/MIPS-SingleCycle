----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2023 02:25:51 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

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

component IFunit is
    Port ( clk : in STD_LOGIC;
           BranchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           JmpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Instr : out STD_LOGIC_VECTOR (15 downto 0);
           AddrNext : out STD_LOGIC_VECTOR (15 downto 0);
           load: in STD_LOGIC;
           reset: in STD_LOGIC);
end component;

component IDunit is 
     Port (RegWrite : in STD_LOGIC;
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
end component;

component EX is 
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           Zero : out STD_LOGIC;
           ALUResult : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           en : in std_logic);
end component;

signal Instruction, PCinc, WD, RD1, RD2, Ext_imm, Ext_func, Ext_sa, ALURes, MemData, BranchAddr, JumpAddr: std_logic_vector(15 downto 0) := x"0000";
signal func: std_logic_vector(2 downto 0) := "000";
signal sa: std_logic := '0';
signal digits: std_logic_vector(15 downto 0) := x"0000";
signal en, res, zero: std_logic := '0'; 

-- main controls
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite, PCSrc: std_logic := '0';
signal ALUOp: std_logic_vector(2 downto 0) := "000";

begin

-- M I P S-----------------------------------------------------------------------------------------------

-- buton reset si enable 
monopulse1: MPG port map(btn(0),clk, en);
monopulse2: MPG port map(btn(1),clk, res);

-- main unit 
inst_IF: IFunit port map(clk, BranchAddr, JumpAddr, Jump, PCSrc, Instruction,PCinc, en, res); 
inst_ID: IDunit port map(RegWrite, Instruction(15 downto 0), RegDst, ExtOp, RD1, RD2, WD, Ext_imm, func, sa, clk, en);
inst_EX: EX port map(RD1, ALUSrc, RD2, Ext_imm, sa, func, ALUOp, zero, ALURes);
inst_MEM: MEM port map(MemWrite, ALURes, RD2, clk, MemData, en);

-- UC --------------------------------------------------------------------------------------------------
process(Instruction)
begin
RegDst <= '0';
ExtOp <= '0';
ALUSrc <= '0';
Branch <= '0';
Jump <= '0';
MemWrite <= '0';
MemtoReg <= '0';
RegWrite <= '0';
ALUOp <= "000";
    case Instruction(15 downto 13) is 
        when "000" => RegDst <= '1';
                      RegWrite <= '1';
                      ALUOp <= "010";
        when "001" => ExtOp <= '1';
                      ALUSrc <= '1';
                      RegWrite <= '1';
        when "010" => ExtOp <= '1';
                      ALUSrc <= '1';
                      MemtoReg <= '1';
                      RegWrite <= '1';
        when "011" => ExtOp <= '1';
                      ALUSrc <= '1';
                      MemWrite <= '1';
        when "100" => ExtOp <= '1';
                      Branch <= '1';
                      ALUOp <= "001";
        when "111" => Jump <= '1'; 
        when others => RegDst <= '0';
                      ExtOp <= '0';
                      ALUSrc <= '0';
                      Branch <= '0';
                      Jump <= '0';
                      MemWrite <= '0';
                      MemtoReg <= '0';
                      RegWrite <= '0';
                      ALUOp <= "000";
    end case;
end process;

--Adrese----------------------------------------------

BranchAddr <= PCinc + Ext_immm;
JumpAddr <= PCinc(15 downto 13) & Instruction(12 downto 0);
PCSrc <= Branch and zero;

--SSD display MUX------------------------------------------------------------
with sw(7 downto 5) select
    digits <= Instruction when "000",
              PCinc when "001",
              RD1 when "010",
              RD2 when "011",
              WD when "100",
              ALURes when "101",
              (others => 'X') when others;

display: SSD port map (digits, clk, an, cat);

---WB-------------------------------------------------------------------------
process(MemtoReg)
begin 
case MemtoReg is 
    when '0' => WD <= ALURes;
    when others => WD <= MemData;
end case;
end process;
-- main controls on the leds 
led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg &RegWrite;
end Behavioral;
