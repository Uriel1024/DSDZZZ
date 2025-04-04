        LIBRARY IEEE;
        USE IEEE.STD_LOGIC_1164.ALL;
        USE IEEE.STD_LOGIC_ARITH.ALL;
        USE IEEE.STD_LOGIC_UNSIGNED.ALL;

        ENTITY CONDEC IS
            PORT(
                CLK_27M : IN STD_LOGIC;  -- Reloj de 27MHz
                CLR     : IN STD_LOGIC;
                C       : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
                E       : IN STD_LOGIC_VECTOR(9 DOWNTO 0); --para el comparador de mag
                DISPLAY : INOUT STD_LOGIC_VECTOR(6 DOWNTO 0)
            );
        END ENTITY;

        ARCHITECTURE A_CONDEC OF CONDEC IS
            CONSTANT DIG0 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1000000";
            CONSTANT DIG1 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111001";
            CONSTANT DIG2 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100100";  
            CONSTANT DIG3 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110000";
            CONSTANT DIG4 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0011001";
            CONSTANT DIG5 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010010";
            CONSTANT DIG6 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000010";
            CONSTANT DIG7 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111000";
            CONSTANT DIG8 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
            CONSTANT DIG9 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010000";
            CONSTANT APAG : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111";
            
            SIGNAL CLK_1S : STD_LOGIC := '0';
            SIGNAL COUNT  : INTEGER RANGE 0 TO 27000000:= 0;
            SIGNAL INDEX  : INTEGER RANGE 0 TO 9 :=0; 
        BEGIN
            
            PROCESS (CLK_27M)
            BEGIN
                IF RISING_EDGE(CLK_27M) THEN
                    IF COUNT = 27000000 THEN
                        CLK_1S <= NOT CLK_1S;
                        COUNT <= 0;
                    ELSE
                        COUNT <= COUNT + 1;
                    END IF;
                END IF;
            END PROCESS;
            
            -- Lógica del contador
            PROCESS (CLK_1S, CLR, DISPLAY, C)
            BEGIN
                IF (CLR = '1') THEN
                    DISPLAY <= DIG0;
                ELSIF (CLK_1S'EVENT AND CLK_1S = '1') THEN
                    CASE C IS
                        WHEN "10" => -- Retener dato
                        CASE DISPLAY IS
                                WHEN DIG0 => DISPLAY <= DIG0;
                                WHEN DIG1 => DISPLAY <= DIG1;
                                WHEN DIG2 => DISPLAY <= DIG2;
                                WHEN DIG3 => DISPLAY <= DIG3;
                                WHEN DIG4 => DISPLAY <= DIG4;
                                WHEN DIG5 => DISPLAY <= DIG5;
                                WHEN DIG6 => DISPLAY <= DIG6;
                                WHEN DIG7 => DISPLAY <= DIG7;
                                WHEN DIG8 => DISPLAY <= DIG8;
                                WHEN DIG9 => DISPLAY <= DIG9;
                                WHEN OTHERS => DISPLAY <= DIG0;
                            END CASE;
                        WHEN "00" => -- Incrementar
                            CASE DISPLAY IS
                                WHEN DIG0 => DISPLAY <= DIG1;
                                WHEN DIG1 => DISPLAY <= DIG2;
                                WHEN DIG2 => DISPLAY <= DIG3;
                                WHEN DIG3 => DISPLAY <= DIG4;
                                WHEN DIG4 => DISPLAY <= DIG5;
                                WHEN DIG5 => DISPLAY <= DIG6;
                                WHEN DIG6 => DISPLAY <= DIG7;
                                WHEN DIG7 => DISPLAY <= DIG8;
                                WHEN DIG8 => DISPLAY <= DIG9;
                                WHEN DIG9 => DISPLAY <= DIG0;
                                WHEN OTHERS => DISPLAY <= DIG0;
                            END CASE;
                        WHEN "01" => -- Decrementar
                            CASE DISPLAY IS
                                WHEN DIG0 => DISPLAY <= DIG9;
                                WHEN DIG9 => DISPLAY <= DIG8;
                                WHEN DIG8 => DISPLAY <= DIG7;
                                WHEN DIG7 => DISPLAY <= DIG6;
                                WHEN DIG6 => DISPLAY <= DIG5;
                                WHEN DIG5 => DISPLAY <= DIG4;
                                WHEN DIG4 => DISPLAY <= DIG3;
                                WHEN DIG3 => DISPLAY <= DIG2;
                                WHEN DIG2 => DISPLAY <= DIG1;
                                WHEN DIG1 => DISPLAY <= DIG0;
                                WHEN OTHERS => DISPLAY <= DIG0;
                            END CASE;
                        WHEN OTHERS => -- Cargar el dato "11"
                                IF E(9) = '1' THEN
                                    INDEX<=9;
                                ELSIF E(8) = '1' THEN
                                    INDEX<=8;
                                ELSIF E(7) = '1' THEN
                                    INDEX<=7;
                                ELSIF E(6) = '1' THEN
                                    INDEX<=6;
                                ELSIF E(5) = '1' THEN
                                    INDEX<=5;
                                ELSIF E(4) = '1' THEN
                                    INDEX<=4;
                                ELSIF E(3) = '1' THEN
                                    INDEX<=3;
                                ELSIF E(2) = '1' THEN
                                    INDEX<=2;
                                ELSIF E(1) = '1' THEN
                                    INDEX<=1;
                                ELSE 
                                    INDEX <=0;
                            END IF;

                        CASE INDEX IS 
                            WHEN 0 => DISPLAY <= DIG0;
                            WHEN 1 => DISPLAY <= DIG1;
                            WHEN 2 => DISPLAY <= DIG2;
                            WHEN 3 => DISPLAY <= DIG3;
                            WHEN 4 => DISPLAY <= DIG4;
                            WHEN 5 => DISPLAY <= DIG5;
                            WHEN 6 => DISPLAY <= DIG6;
                            WHEN 7 => DISPLAY <= DIG7;
                            WHEN 8 => DISPLAY <= DIG8;
                            WHEN 9 => DISPLAY <= DIG9;
                        END CASE;           

                    END CASE;
                END IF;
            END PROCESS;


        END A_CONDEC;
