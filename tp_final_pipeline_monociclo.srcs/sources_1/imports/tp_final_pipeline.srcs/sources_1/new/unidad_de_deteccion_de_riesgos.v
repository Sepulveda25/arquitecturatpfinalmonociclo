`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2019 15:29:53
// Design Name: 
// Module Name: unidad_de_deteccion_de_riesgos
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Con Latch_ID_Ex_Mem_FLAGS_MemRead = 1 significa que se quiere hacer una lectura a memoria (lw)
// Se verifica que Latch_ID_Ex_InstrOut_20_16_Rt sea igua a Latch_IF_ID_RS o Latch_IF_ID_RT
// Quiere decir que la instruccion que se esta ejecutando en la etapa EX si se trata de una LW
// se verifica que el registro rt de esta sea igual a los registros rs o rt en la etapa ID
//////////////////////////////////////////////////////////////////////////////////


module unidad_de_deteccion_de_riesgos(	//Inputs
                                        input Latch_ID_Ex_Mem_FLAGS_MemRead,
                                        input [4:0] Latch_ID_Ex_InstrOut_20_16_Rt,
                                        input [4:0] Latch_IF_ID_RS,
                                        input [4:0] Latch_IF_ID_RT,
                                        //Output
                                        output reg Stall
                                     );
													 
initial begin
	Stall = 0;
end

always@* begin
	if(Latch_ID_Ex_Mem_FLAGS_MemRead && ((Latch_ID_Ex_InstrOut_20_16_Rt == Latch_IF_ID_RS) || (Latch_ID_Ex_InstrOut_20_16_Rt == Latch_IF_ID_RT))) Stall = 1;
	else Stall = 0;
end

endmodule
