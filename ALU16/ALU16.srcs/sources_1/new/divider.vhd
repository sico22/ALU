library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
    Port ( dividend : in STD_LOGIC_VECTOR (15 downto 0);
           divisor	: in STD_LOGIC_VECTOR (15 downto 0);
           quotient: out STD_LOGIC_VECTOR (31 downto 0));
end divider;

architecture Behavioral of divider is

begin

    quotient <= X"0000" & CONV_STD_LOGIC_VECTOR( (CONV_INTEGER(dividend) / CONV_INTEGER(divisor)), 16);

end Behavioral;