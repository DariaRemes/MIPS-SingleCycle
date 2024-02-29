----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2023 02:31:50 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           Zero : out STD_LOGIC;
           ALUResult : out STD_LOGIC_VECTOR (15 downto 0));
end EX;

architecture Behavioral of EX is

-- semnal out mux
signal mux_out: std_logic_vector(15 downto 0);
signal ALUCtrl : std_logic_vector(2 downto 0);
--semnal inmultire 
signal mul :std_logic_vector(31 downto 0);
signal ALURes:std_logic_vector(15 downto 0);

begin

--MUX pt ALU---------------------------------------------------------------- 
with ALUSrc select
    mux_out <= RD2 when '0',
               Ext_Imm when '1',
               (others => 'X') when others;

--ALUCtrl-------------------------------------------------------------------
process(ALUOp, func)
begin
    case ALUOp is 
        when "010" => --tip R 
            case func is 
                when "000" => ALUCtrl <= "000"; --ADD
                when "001" => ALUCtrl <= "001"; --SUB 
                when "010" => ALUCtrl <= "010"; --SLL  
                when "011" => ALUCtrl <= "010"; --SRL 
                when "100" => ALUCtrl <= "011"; --AND
                when "101" => ALUCtrl <= "100"; --OR 
                when "110" => ALUCtrl <= "101"; --XOR 
                when "111" => ALUCtrl <= "110"; --MULT    
                when others => ALUCtrl <= (others => 'X'); --unknown 
             end case;
         when "000" => ALUCtrl <= "000"; --ADDI/LW/SW --add
         when "001" => ALUCtrl <= "001"; --BEQ/BGTZ --sub
         when "011" => ALUCtrl <= "101"; --ORI --or
         when others => ALUCtrl <= "111"; --J 
     end case;
end process;

--ALU------------------------------------------------------------------
mul <= RD1 * mux_out;
process(ALUCtrl, RD1, mux_out, sa)
begin
    case ALUCtrl is 
        when "000" => ALURes <= RD1 + mux_out; --ADD
        when "001" => ALURes <= RD1 - mux_out; --SUB
        when "010" => if func = "010" then
                        if sa = '1' then
                             ALURes <= RD1(14 downto 0) & '0'; --SLL 
                        else  ALURes <= RD1;
                       end if;
                       
                       elsif func = "011" then
                        if sa = '1' then
                             ALURes <= '0' & RD1(15 downto 1); --SRL 
                        else  ALURes <= RD1;
                       end if;
                       end if;
        when "011" => ALURes <= RD1 and mux_out; --AND 
        when "100" => ALURes <= RD1 or mux_out; --OR
        when "101" => ALURes <= RD1 xor mux_out; --XOR 
        when "110" => ALURes <= mul(15 downto 0); --MULT 
        when others => ALURes <= X"0000";
   end case;
end process;

--out Zero 
Zero <= '1' when ALURes = "0000000000000000" else '0';  
ALUResult <= ALURes; 

end Behavioral;
