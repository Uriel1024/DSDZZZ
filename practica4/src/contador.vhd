library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador is
    port(
        CLK, CLR, C: in std_logic;
        Q: out std_logic_vector(9 downto 0)
    );
end entity;

architecture a_contador of contador is
    signal clkout   : std_logic := '0';
    constant div    : integer := 27000000;
    signal contador : unsigned(24 downto 0) := (others => '0');
    signal intq     : std_logic_vector(9 downto 0) := (others => '0'); 
begin  
    -- Proceso para el reloj divisor de frecuencia
    reloj: process (CLK, CLR)
    begin
        if CLR = '0' then
            contador <= (others => '0');
            clkout <= '0';
        elsif rising_edge(CLK) then
            if contador = div - 1 then
                contador <= (others => '0');
                clkout <= not clkout;
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;

    -- Contador JK
    process(CLK, CLR)
        variable J, K : std_logic_vector(9 downto 0);
    begin 
        if CLR = '0' then   
            intq <= (others => '0');
        elsif rising_edge(CLK) then
            if clkout = '1' and C = '1' then
                for i in 0 to 9 loop    
                    if i = 0 then       
                        J(i) := C;
                    else
                        J(i) := J(i-1) and intq(i-1);
                    end if;
                    K(i) := J(i);
                    
                    -- Corregido: Usar std_logic_vector explícito para el case
                    case std_logic_vector'(J(i) & K(i)) is
                        when "00" => null;
                        when "01" => intq(i) <= '0';
                        when "10" => intq(i) <= '1';
                        when "11" => intq(i) <= not intq(i);
                        when others => null;
                    end case;
                end loop;
            end if;
        end if;
    end process;
    
    Q <= intq;
end architecture;