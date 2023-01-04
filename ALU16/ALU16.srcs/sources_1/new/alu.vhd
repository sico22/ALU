----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2022 02:14:40 PM
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end alu;

architecture Behavioral of alu is

component multiplier is	
	Port(m : in STD_LOGIC_VECTOR(15 downto 0);
	     r : in STD_LOGIC_VECTOR(15 downto 0);
	     result : out STD_LOGIC_VECTOR(31 downto 0));		  
end component;

component divider is
    Port(dividend	: in STD_LOGIC_VECTOR (15 downto 0);
         divisor		: in STD_LOGIC_VECTOR (15 downto 0);
         quotient	: out STD_LOGIC_VECTOR (31 downto 0));
end component;

component accumulator is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           nxt : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (15 downto 0);
           dout : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component SSD is
port( clk: in STD_LOGIC;
	  digits: in STD_LOGIC_VECTOR(15 DOWNTO 0);
	  an: out STD_LOGIC_VECTOR(3 DOWNTO 0);
	  cat: out STD_LOGIC_VECTOR(6 DOWNTO 0));
end component;

component MPG is
	port ( clk: in std_logic;
	       btn: in std_logic;	
		  step: out std_logic);
end component;

signal a : STD_LOGIC_VECTOR(31 downto 0) := X"00000004"; --15
signal b : STD_LOGIC_VECTOR(31 downto 0) := X"00000002"; --2
signal multiply_res : STD_LOGIC_VECTOR(31 downto 0);
signal div_res : STD_LOGIC_VECTOR(31 downto 0);
signal res : STD_LOGIC_VECTOR(31 downto 0);
signal tmp : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
signal st1, st2 : STD_LOGIC;

begin

----------------------------------------SSD-------------------------------------------------
    display : SSD PORT MAP(clk => clk, digits => tmp, cat => cat, an => an);
    
----------------------------------------MPG-------------------------------------------------
    mpg1 : MPG PORT MAP(clk => clk, btn => btn(1), step => st1);
    
------------------------------------ACCUMULATOR---------------------------------------------
    process (clk, st2)
        begin
           if (clk'event and clk= '1') then
                if st1 = '1' then
                    tmp <= res(15 downto 0) + tmp;
                    a(15 downto 0) <= tmp;
                end if; 
           end if;
        end process;

-------------------------------------MULTIPLIER---------------------------------------------
    mul : multiplier PORT MAP(m => a(15 downto 0), r => b(15 downto 0), result => multiply_res);
    
--------------------------------------DIVIDER-----------------------------------------------
    div : divider PORT MAP(dividend => a(15 downto 0), divisor => b(15 downto 0), quotient => div_res);

-----------------------------------------ALU------------------------------------------------
    process (sw)
    begin
        case sw(3 downto 0) is
            when "0000" => res <= a + b;
            when "0001" => res <= a - b;
            when "0010" => res <= b + 1;
            when "0011" => res <= b - 1;
            when "0100" => res <= a and b;
            when "0101" => res <= a or b;
            when "0110" => res <= not b;
            when "0111" => res(31 downto 1) <= b(30 downto 0);
                           res(0) <= '0';
            when "1000" => res(30 downto 0) <= b(31 downto 1);
                           res(31) <= '0';
            when "1001" => res <= multiply_res;
            when "1010" => res <= div_res;
            when others => res <= X"FFFF" & X"FFFF";
        end case;
    end process;

    process (btn)
    begin
        case btn(0) is
            when '1' => led <= res(31 downto 16);
            when others => led <= res(15 downto 0);
        end case;
    end process;

end Behavioral;
