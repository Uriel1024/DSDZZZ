library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;  

    entity p7 is
    port(
        clk, clr, sicd, sici: in std_logic;
        da : in std_logic_vector(2 downto 0);
        con: in std_logic_vector(1 downto 0);
        q : inout std_logic_vector(2 downto 0)
);
end entity;



architecture a_p7 of p7 is 
    
    signal d: std_logic_vector(2 downto 0);
    signal div_clk : std_logic := '0' ;
    signal div_con: UNSIGNED(24 DOWNTO 0) := (others => '0');
    
begin 

divisor: process(clk)
begin
    if rising_edge(clk) then
        if div_con = 26999999 then
            div_con <= (others => '0');
            div_clk <= '1';
        else
            div_con <= div_con + 1;
            div_clk <= '0';
        end if;
       end if;
end process;

M_2: Process(con,sicd,q,da)
    begin
    case con is
        when "00" => d(2) <= sicd;
        when "01" => d(2) <= q(1);
        when "10" => d(2) <= da(2);
        when others => d(2) <=q(2);
    end case;
end process M_2;

M_1: Process(con,sicd,q,da)
    begin
    case con is
        when "00" => d(1) <= sicd;
        when "01" => d(1) <= q(0);
        when "10" => d(1) <= da(1);
        when others => d(1) <=q(1);
    end case;
end process M_1;

M_0: Process(con,sici,q,da)
    begin
    case con is
        when "00" => d(0) <= q(1);
        when "01" => d(0) <= sici;
        when "10" => d(0) <= da(0);
        when others => d(0) <=q(0);
    end case;
end process M_0;

process(clk, clr)
    begin
        if(clr ='0') then
        q<= (others => '0');
    elsif rising_edge(clk) then
        q <= d;
    end if;
end process;
end architecture;
