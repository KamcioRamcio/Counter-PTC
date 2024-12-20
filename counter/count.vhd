LIBRARY ieee;
USE ieee.std_logic_1164.all; 

entity AddSub8bit is
	port (
		clk : in std_logic; --zegar
		reset: in std_logic; --reset
		overflow : out std_logic; -- przepełnienie
		
		SW : in std_logic_vector(17 downto 0); --wektor wejściowy
		KEY : in std_logic_vector(3 downto 0); -- przyciski
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : out std_logic_vector(6 downto 0) -- wyświetlacze 7-segmentowe
	)
end AddSub8bit;

architecture behavioral of AddSub8bit is
	signal reg_A : std_logic_vector(7 downto 0);
	signal reg_B : std_logic_vector(7 downto 0);
	signal reg_result : std_logic_vector(7 downto 0);
	signal AddSub : std_logic;
	signal Sel : std_logic; -- select source wybór miedzy A a last_result
	signal overflow_flag : std_logic;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg_A <= (others => '0'); -- resetowanie rejestru
            reg_B <= (others => '0');
            reg_result <= (others => '0');
            overflow_flag <= '0';
        elsif rising_edge(clk) then
            if KEY(3) = '0' then
                reg_A <= SW(7 downto 0); -- ładowanie A
            elsif KEY(2) = '0' then
                reg_B <= SW(15 downto 8); -- ładowanie B
            elsif KEY(1) = '0' then
                -- Dodawanie lub odejmowanie
                if AddSub = '0' then
                    reg_result <= std_logic_vector(signed(reg_A) + signed(reg_B)); -- Dodawanie
                else
                    reg_result <= std_logic_vector(signed(reg_A) - signed(reg_B)); -- Odejmowanie
                end if;
					 -- do poprawy
                overflow_flag <= (reg_A(7) and reg_B(7) and not reg_result(7)) or
                                 (not reg_A(7) and not reg_B(7) and reg_result(7));
            end if;
        end if;
    end process;

    overflow <= overflow_flag;

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

entity mux2to1 is 
	port (
		SelR : in std_logic; -- wejście sterujące
		in1 : in std_logic_vector(7 downto 0); -- liczba A
		in2 : in std_logic_vector(7 downto 0); -- liczba last_result
		mout : out std_logic_vector(7 downto 0); -- wybrana liczba 
	)
end mux2to1;

architecture behavioral of mux2to1 is
begin
	mout <= in1 when SelR = '0' else in2;
end behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

entity nkb_to_hex is
	port(
		input: in std_logic_vector(7 downto 0); -- dane wejsciowe 
		display1 : out std_logic_vector(6 downto 0) -- wyjscie na wyświetlacz 1
		display2 : out std_logic_vector(6 downto 0)
	)
end nkb_to_hex;

architecture bahavior of nkb_to_hex is
	signal high_bit : std_logic_vector(3 downto 0);
	signal low_bit : std_logic_vector(3 downto 0);
begin


	high_bit <= input(7 downto 4);
	low_bit <= input(3 downto 0);
	
	process(high_bit) is
	begin
        case high_bit is
            when "0000" => display1 <= "0000001";
            when "0001" => display1 <= "1001111";
            when "0010" => display1 <= "0010010";
            when "0011" => display1 <= "0000110";
            when "0100" => display1 <= "1001100";
            when "0101" => display1 <= "0100100";
            when "0110" => display1 <= "0100000";
            when "0111" => display1 <= "0001111";
            when "1000" => display1 <= "0000000";
            when "1001" => display1 <= "0000100";
				when "1010" => display1 <= "0001000";
				when "1011" => display1 <= "0000000";
				when "1100" => display1 <= "0110001";
				when "1101" => display1 <= "0000001";
				when "1110" => display1 <= "0110000";
            when "1111" => display1 <= "0110000";
				when others => display1 <= "1111111";
        end case;
    end process;
	 process(low_bit) is
	begin
        case low_bit is
            when "0000" => display2 <= "0000001";
            when "0001" => display2 <= "1001111";
            when "0010" => display2 <= "0010010";
            when "0011" => display2 <= "0000110";
            when "0100" => display2 <= "1001100";
            when "0101" => display2 <= "0100100";
            when "0110" => display2 <= "0100000";
            when "0111" => display2 <= "0001111";
            when "1000" => display2 <= "0000000";
            when "1001" => display2 <= "0000100";
				when "1010" => display2 <= "0001000";
				when "1011" => display2 <= "0000000";
				when "1100" => display2 <= "0110001";
				when "1101" => display2 <= "0000001";
				when "1110" => display2 <= "0110000";
            when "1111" => display2 <= "0110000";
				when others => display2 <= "1111111";
        end case;
    end process;
end behavioral		



	