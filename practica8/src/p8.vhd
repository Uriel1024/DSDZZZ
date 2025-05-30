library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity p8 is
    port( clk,clr,ECD, ECI: in std_logic;
        c: in std_logic_vector(2 downto 0);
        e: in std_logic_vector(7 downto 0);
        q: inout std_logic_vector(7 downto 0);
        CLKOUT : buffer std_logic
);

end entity;

architecture a_p8 of p8 is 
SIGNAL CRISTAL : STD_LOGIC;
SIGNAL CONTADOR : UNSIGNED (31 DOWNTO 0) := (OTHERS => '0');
CONSTANT DIVISOR1 : INTEGER := 13500000;
SIGNAL Qs   : std_logic_vector (7 downto 0) := (OTHERS => '0');
SIGNAL Gray : std_logic_vector (7 downto 0) := (OTHERS => '0'); 
 
begin
--divisor de frecuencia
process  (CLK)
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

--Logica principal del programa
process(clk, clr, c)    
    begin
        if (clr = '0') then
            q <= (others => '0');
            Qs <= (others => '0');
        elsif rising_edge(clk) then
        case c is 
            when "000" => 
                Qs <= e;
                q <= e; 
            when "001" =>
                Qs <= std_logic_vector(unsigned(Qs) + 1);   
                q <= std_logic_vector(unsigned(Q) + 1);
            when "010" => 
                Qs <= std_logic_vector(unsigned(Qs) - 1); 
                q <= Qs;               
            when "011" => 
                Qs <= ECD & Qs(7 downto 1);
                q <= Qs;
            when "100" => 
                Qs <= Qs(6 downto 0) & ECI;
                q <= Qs;
            when "101" => 
                Qs <= Qs;
                q <= Qs;
            when "110" =>
                Qs <= Qs(6 downto 0) & Qs(7);
                q <= Qs;
            when others => 
                Gray(0) <= Qs(0) xor Qs(1);
                Gray(1) <= Qs(1) xor Qs(2);
                Gray(2) <= Qs(2) xor Qs(3); 
                Gray(3) <= Qs(3) xor Qs(4);
                Gray(4) <= Qs(4) xor Qs(5); 
                Gray(5) <= Qs(5) xor Qs(6);
                Gray(6) <= Qs(6) xor Qs(7);
                Gray(7) <= Qs(7);
                q <= Gray;
        end case;
    end if;
    end process;
end architecture;

