----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2022 03:14:49 PM
-- Design Name: 
-- Module Name: multiplicator - Behavioral
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
USE ieee.std_logic_signed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier is	
	Port ( m : in STD_LOGIC_VECTOR(15 downto 0);
	       r : in STD_LOGIC_VECTOR(15 downto 0);
	       result : out STD_LOGIC_VECTOR(31 downto 0));	  
end multiplier;

architecture Behavior of multiplier is

begin
	
	process(m, r)
		
		constant X_ZEROS : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
		constant Y_ZEROS : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');	
		variable a, s, p : STD_LOGIC_VECTOR(33 downto 0);
		variable mn      : STD_LOGIC_VECTOR(15 downto 0);
	
	begin
		
		a := (others => '0');
		s := (others => '0');
		p := (others => '0');
		
		if (m /= X_ZEROS and r /= Y_ZEROS) then
			
			a(32 downto 17) := m;
			a(33) := m(15);
			
			mn := (not m) + 1;
			
			s(32 downto 17) := mn;
			s(33) := not(m(15));
			
			p(16 downto 1) := r;
			
			for i in 1 to 16 loop
				
				if (p(1 downto 0) = "01") then
					p := p + a;
				elsif (p(1 downto 0) = "10") then
					p := p + s;
				end if;
				
				-- Shift Right Arithmetic
				p(32 downto 0) := p(33 downto 1);
			
			end loop;
			
		end if;
		
		result <= p(32 downto 1);
		
	end process;
	
end Behavior;
