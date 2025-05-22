library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

entity p8 is
    port( clk,clr,eco, eci: in std_logic;
        c: in std_logic_vector(2 downto 0);
        e: in std_logic_vector(7 downto 0);
        q: inout std_logic_vector(7 downto 0);
        CLKOUT : buffer std_logic
);

end entity;

architecture a_p8 of p8 is 
SIGNAL CRISTAL : STD_LOGIC;
SIGNAL CONTADOR : UNSIGNED (24 DOWNTO 0) := (OTHERS => '0');
CONSTANT DIVISOR1 : INTEGER := 27000000;
begin

divisor:process  (CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            CRISTAL <= CLK;
            IF CONTADOR = DIVISOR1 THEN
                CONTADOR <= (OTHERS => '0');
                CLKOUT <= NOT CLKOUT;
            ELSE
                CONTADOR <= CONTADOR + 1;
            END IF;
        END IF;
    END PROCESS;

process(clk, clr, c)    
    begin
        if (clr = '0') then
            q <= "00000000";
        elsif rising_edge(clk) then
    case c is
    when "000" => q <= e;
    when "001" => q <= std_logic_vector(unsigned(q) +1);
    when "010" => q <= std_logic_vector(unsigned(q) -1);
    when "011" => q(7) <= eco;
        q<= to_stdlogicvector(to_bitvector(q) srl 1);
    when "100"  => q(0) <= eci;
        q<= to_stdlogicvector(to_bitvector(q) sll 1); 
    when "101" => q <= q;
    when "110" => 
        q <= q(0) & q(7 downto 1);
    when others =>  
            q(7) <= q(7); -- el bit mas significativo se mantiene igual 
            for i in 6 downto 0 loop   
                q(i) <= q(i + 1) xor q(i);
    end loop;
    end case;
    end if;
    end process;
end a_p8;

