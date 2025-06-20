LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY TM IS 
PORT(
CLK,CLR:IN STD_LOGIC;
F:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
C:INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
DISPLAY: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)

);
END ENTITY;

ARCHITECTURE A_TM OF TM IS
CONSTANT CERO: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0000001";
CONSTANT UNO: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1001111";
CONSTANT DOS: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0010010";
CONSTANT TRES: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0000110";
CONSTANT CUATRO: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1001100";
CONSTANT CINCO: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0100100";
CONSTANT SEIS: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0100000";
CONSTANT SIETE: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0001110";
CONSTANT OCHO: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0000000";
CONSTANT NUEVE: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0000100";
CONSTANT NT: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1111111";
CONSTANT ASTERISCO: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1001000";
CONSTANT GATO: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1001000";

CONSTANT LETRAA: STD_LOGIC_VECTOR(6 DOWNTO 0) :="0001000";
CONSTANT LETRAB: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1100000";
CONSTANT LETRAC: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1110010";
CONSTANT LETRAD: STD_LOGIC_VECTOR(6 DOWNTO 0) :="1000010";


SIGNAL AUXILIAR: STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL PIPOOUT:STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL contador     : unsigned(31 DOWNTO 0) := (OTHERS => '0'); 
SIGNAL DIV_CLK      : std_logic := '0';
CONSTANT DIVISOR : INTEGER := 13500;

BEGIN
-----------------------------------------------------------
DF:PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF contador >= to_unsigned(DIVISOR, 32) THEN  
                contador <= (OTHERS => '0');
                DIV_CLK <= NOT DIV_CLK;
            ELSE
                contador <= contador + 1;
            END IF;
        END IF;
    END PROCESS;

-----------------------------------------------------------
CONTADORANILLO:PROCESS(DIV_CLK,CLR)
BEGIN
IF(CLR='0') THEN
C<="0111";
ELSIF(DIV_CLK ' EVENT AND DIV_CLK ='1')THEN
C<= TO_STDLOGICVECTOR(TO_BITVECTOR(C) ROR 1);
END IF;
END PROCESS;
-----------------------------------------------------------
DECOFC:PROCESS(C, F,PIPOOUT)
BEGIN
    IF F = "1111" THEN
       -- AUXILIAR <= NT;--REGRESA A APAGADO EL DISPLAY
       AUXILIAR <= PIPOOUT;--MANTIENE EL ESTADO DEL REGISTRO
       
    ELSE
        CASE F & C IS
            WHEN "0111" & "0111" => AUXILIAR <= UNO;
            WHEN "0111" & "1011" => AUXILIAR <= DOS;
            WHEN "0111" & "1101" => AUXILIAR <= TRES;
            WHEN "1011" & "0111" => AUXILIAR <= CUATRO;
            WHEN "1011" & "1011" => AUXILIAR <= CINCO;
            WHEN "1011" & "1101" => AUXILIAR <= SEIS;
            WHEN "1101" & "0111" => AUXILIAR <= SIETE;
            WHEN "1101" & "1011" => AUXILIAR <= OCHO;
            WHEN "1101" & "1101" => AUXILIAR <= NUEVE;
            WHEN "1110" & "1011" => AUXILIAR <= CERO;
            WHEN "0111" & "1110" => AUXILIAR <= LETRAA;
            WHEN "1011" & "1110" => AUXILIAR <= LETRAB;
            WHEN "1101" & "1110" => AUXILIAR <= LETRAC;
            WHEN "1110" & "1110" => AUXILIAR <= LETRAD;

            WHEN "1110" & "0111" => AUXILIAR <= ASTERISCO;
            WHEN "1110" & "1101" => AUXILIAR <= GATO;

            WHEN OTHERS => AUXILIAR <= NT;
        END CASE;
        
    END IF;
END PROCESS;
-----------------------------------------------------------
REGISTRO:PROCESS(DIV_CLK,CLR)
BEGIN
    IF CLR = '0' THEN
        PIPOOUT <= NT;
    ELSIF RISING_EDGE(DIV_CLK) THEN
        PIPOOUT<=AUXILIAR;
    END IF;
END PROCESS;
-----------------------------------------------------------
DISPLAY <= PIPOOUT;

END A_TM;