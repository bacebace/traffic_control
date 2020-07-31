`define TRUE 1'b1
`define FALSE 1'b0
`define RED 2'd0
`define YELLOW 2'd1
`define GREEN 2'd2
		//hwy		cntr
`define S0 3'd0 //green		red
`define S1 3'd1 //yellow	red
`define S2 3'd2 //red		red
`define S3 3'd3 //red		green
`define S4 3'd4 //red		yellow

`define Y_R 3 //yellow to red delay
`define R_G 2 //red to green delay

module traffic_sigctrl(hwy, cntry, X, clock, clear);
//main highway, country road, sensor p/ country road, clock, clear

output [1:0] hwy, cntry; //2bits porque porque ha 3 estados (verde, amarelo, vermelho)
input X; //X=0 sem carro, X=1 com carro
input clock, clear;

reg [1:0] hwy, cntry;

reg [2:0] state, next_state;

//inicializar no estado S0
initial begin
	state=`S0;
	next_state=`S0;
	hwy=`GREEN;
	cntry=`RED;
end

always@(posedge clock)
	state = next_state;
//assim o estado so vai p/ o proximo na subida

always@(state)
	def_signal(state, hwy, cntry);

always@(state or clear or X)
	def_state(state, next_state, clear, X);


//TASKS
//define as cores
task def_signal;
input [2:0] estado;
output [1:0] highway, road;

begin
	case(estado)
	`S0 :	begin
		highway=`GREEN;
		road=`RED;
		end
	`S1 :	begin
		highway=`YELLOW;
		road=`RED;
		end
	`S2 :	begin
		highway=`RED;
		road=`RED;
		end
	`S3 :	begin
		highway=`RED;
		road=`GREEN;
		end
	`S4:	begin
		highway=`RED;
		road=`YELLOW;
		end
	endcase
end
endtask


//define proximo estado da maquina
task def_state;
input [2:0] estad;
output [2:0] prox;
input clr, sensor;

begin
	if(clr) prox=`S0;
	else
	case(estad)
	`S0 :	if(sensor) prox=`S1;
		else prox=`S0;

	`S1 :	begin
		repeat(`Y_R) @(posedge clock); //por algum motivo aqui funciona sem semicolon
		prox=`S2;
		end

	`S2 :	begin
		repeat (`R_G) @(posedge clock);
		prox=`S3;
		end
	
	`S3 :	if(sensor) prox=`S3;
		else prox=`S4;

	`S4 :	begin
		repeat(`Y_R) @(posedge clock);
		prox=`S0;
		end
	default : prox=`S0;
	endcase
end
endtask

endmodule
