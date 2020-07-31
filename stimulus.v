`timescale 1ns/1ns
`define FALSE 1'b0
`define TRUE 1'b1

module stimulus;
wire [1:0] MAIN_SIG, CNTRY_SIG;
reg CAR_ON, CLK, CLEAR;

traffic_sigctrl sinal(MAIN_SIG, CNTRY_SIG, CAR_ON, CLK, CLEAR);

initial begin
	CLK=`FALSE;
	forever #10 CLK=~CLK;
end

initial begin
	CLEAR=`TRUE;
	repeat(5) @(negedge CLK)
	CLEAR=`FALSE;
end

initial begin
$recordfile("teste_task");
$recordvars();
$timeformat(-9,0,"ns",9);
$display("\n\t - - - - - - - - - - inicio da simulacao - - - - - - - - - -");
$display("%t	CLOCK	MAIN HIGHWAY	COUNTRY ROAD	CAR ON COUNTRY ROAD?", $time);
$monitor("%t	%b	%d		%d		%b", $time, CLK, MAIN_SIG, CNTRY_SIG, CAR_ON);

CAR_ON=`FALSE;

#200 CAR_ON=`TRUE;
#200 CAR_ON=`FALSE;

#300 CAR_ON=`TRUE;
#400 CAR_ON=`FALSE;

#500 CAR_ON=`TRUE;
#300 CAR_ON=`FALSE;

#100 $finish;

end

endmodule
