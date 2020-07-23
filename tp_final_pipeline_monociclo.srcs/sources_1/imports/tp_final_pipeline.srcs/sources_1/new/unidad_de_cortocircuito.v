`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2019 16:35:25
// Design Name: 
// Module Name: unidad_de_cortocircuito
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
// Chequea si hay algun riesgo de: 	- LDE
// Inputs:	- Latch_ID_EX_RS	"Rs"
//			- Latch_ID_EX_RT	"Rt"
//			- Latch_EX_MEM_MUX "Rd Etapa 4"
//			- Latch_MEM_WB_MUX "Rd Etapa 5"
//			- Latch_Ex_MEM_WriteBack_FLAGS_Out "Solo Flag de RegWrite"
//			- Latch_MEM_WB_WriteBack_FLAGS_Out "Solo Flag de RegWrite"
// Outputs: - ForwardA
//			- ForwardB
//
// Se verifica si se va a escribir en registros (instruccion tipo R) Latch_Ex_MEM_WriteBack_FLAGS_Out=1 y Latch_MEM_WB_WriteBack_FLAGS_Out=1
// Se verifica si existe rd en los latch EX/MEM y MEM/WB con Latch_EX_MEM_MUX!=0 y Latch_MEM_WB_MUX!=0 
// Se compara si los registros rd en los latch EX/MEM y MEM/WB son iguales a rs y rt del latch ID/EX (Latch_EX_MEM_MUX = Latch_ID_EX_RS y Latch_EX_MEM_MUX = Latch_ID_EX_RT)
// Finalmente se verifica si rs y rt del latch ID/EX son distinto que rd en latch EX/MEM (Latch_EX_MEM_MUX != Latch_ID_EX_RS y Latch_EX_MEM_MUX != Latch_ID_EX_RT) 
//////////////////////////////////////////////////////////////////////////////////


module unidad_de_cortocircuito(	//Inputs
                                input [4:0] Latch_ID_EX_RS,
                                input [4:0] Latch_ID_EX_RT,
                                input [4:0] Latch_EX_MEM_MUX,
                                input [4:0] Latch_MEM_WB_MUX, 
                                input Latch_Ex_MEM_WriteBack_FLAGS_Out,
                                input Latch_MEM_WB_WriteBack_FLAGS_Out,
                                //Outputs
                                output reg [1:0] ForwardA,
                                output reg [1:0] ForwardB
                                 );

always@* begin
	if(Latch_Ex_MEM_WriteBack_FLAGS_Out && (Latch_EX_MEM_MUX != 0) && (Latch_EX_MEM_MUX == Latch_ID_EX_RS)) ForwardA = 2'b 10;
	else if(Latch_MEM_WB_WriteBack_FLAGS_Out && (Latch_MEM_WB_MUX != 0) && (Latch_MEM_WB_MUX == Latch_ID_EX_RS) && (Latch_EX_MEM_MUX != Latch_ID_EX_RS)) ForwardA = 2'b 01;
	else ForwardA = 2'b 00;

	if(Latch_Ex_MEM_WriteBack_FLAGS_Out && (Latch_EX_MEM_MUX != 0) && (Latch_EX_MEM_MUX == Latch_ID_EX_RT)) ForwardB = 2'b 10;
	else if(Latch_MEM_WB_WriteBack_FLAGS_Out && (Latch_MEM_WB_MUX != 0) && (Latch_MEM_WB_MUX == Latch_ID_EX_RT) && (Latch_EX_MEM_MUX != Latch_ID_EX_RT)) ForwardB = 2'b 01;
	else ForwardB = 2'b 00;
end

endmodule
