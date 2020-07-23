`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2019 15:36:19
// Design Name: 
// Module Name: test_unidad_de_deteccion_de_riesgos
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
// 
//////////////////////////////////////////////////////////////////////////////////
module test_unidad_de_deteccion_de_riesgos;

	// Inputs
	reg Latch_ID_Ex_Mem_FLAGS_MemRead;
	reg [4:0] Latch_ID_Ex_InstrOut_20_16_Rt;
    reg [4:0] Latch_IF_ID_RS;
    reg [4:0] Latch_IF_ID_RT;
	
	// Outputs
	wire Stall;

	// Instantiate the Unit Under Test (UUT)
	unidad_de_deteccion_de_riesgos uut (
		.Latch_ID_Ex_Mem_FLAGS_MemRead(Latch_ID_Ex_Mem_FLAGS_MemRead), 
		.Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt), 
		.Latch_IF_ID_RS(Latch_IF_ID_RS),
		.Latch_IF_ID_RT(Latch_IF_ID_RT), 
		.Stall(Stall)
	);

	initial begin
	   //la instruccion en EX no lee en memoria
	   Latch_ID_Ex_Mem_FLAGS_MemRead=0;
	   Latch_ID_Ex_InstrOut_20_16_Rt=0;
	   Latch_IF_ID_RS=0;
	   Latch_IF_ID_RT=0;	
	   #10;
	   //la instruccion en EX lee en memoria y es rt.ex=rt.id
	   Latch_ID_Ex_Mem_FLAGS_MemRead=1;
	   Latch_ID_Ex_InstrOut_20_16_Rt=5'b00010;
	   Latch_IF_ID_RS=5'b00011;
	   Latch_IF_ID_RT=5'b00010;
	   #10;
	   //la instruccion en EX lee en memoria y es rt.ex=rs.id
       Latch_ID_Ex_Mem_FLAGS_MemRead=1;
       Latch_ID_Ex_InstrOut_20_16_Rt=5'b00010;
       Latch_IF_ID_RS=5'b00010;
       Latch_IF_ID_RT=5'b00011;
       #10;
       //la instruccion en EX no lee en memoria y es rt.ex=rs.id
       Latch_ID_Ex_Mem_FLAGS_MemRead=0;
       Latch_ID_Ex_InstrOut_20_16_Rt=5'b00010;
       Latch_IF_ID_RS=5'b00010;
       Latch_IF_ID_RT=5'b00011;
       #10;
       //la instruccion en EX lee en memoria y es rt.ex!=rs.id rt.ex!=rt.id
       Latch_ID_Ex_Mem_FLAGS_MemRead=1;
       Latch_ID_Ex_InstrOut_20_16_Rt=5'b01010;
       Latch_IF_ID_RS=5'b00010;
       Latch_IF_ID_RT=5'b00011;
	end
	
	
endmodule      
