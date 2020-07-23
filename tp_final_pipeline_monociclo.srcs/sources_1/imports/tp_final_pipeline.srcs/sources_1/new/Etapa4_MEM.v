`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2019 01:25:03
// Design Name: 
// Module Name: Etapa4_MEM
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


module Etapa4_MEM(  //Inputs
                    input Clk, Reset, Latch_Ex_MEM_Zero,
                    input [3:0]		Mem_FLAGS,//{MemRead,MemWrite} 
                    input [31:0]	Latch_Ex_MEM_ALUOut,    //Addr a Mux, luego a DataMem
                    input [31:0]	dirMem, 			    //Addr a Mux, luego a DataMem
                    input 			memDebug,				//Selector de los 3 Mux
                    input [31:0] 	Latch_Ex_MEM_ReadDataB,	 //DataIn a DataMem
                    //Outputs
                    output [31:0]   E4_DataOut
//                    output Branch //ex PCScr		
                );
//Variables
//localparam BranchNE = 0;
//localparam BranchEQ = 1;
localparam MemWrite = 0; // localparam MemWrite = 2;
localparam MemRead = 1; // localparam MemRead = 3;

//Cables de Interconexion
wire [31:0] Mux_Add_To_Mem;
wire        Mux_Enable_To_Mem;
wire [3:0]  Mux_RW_To_Mem;
wire [3:0]  read;
assign read = 4'b 0000;
wire [3:0] memWrite_4bits;
assign memWrite_4bits = (Mem_FLAGS[MemWrite]) ? 4'b 1111: 4'b 0000; //mux implicito
reg enableMem = 1;


//BRANCH And
//assign PCScr = Latch_Ex_MEM_Zero & Mem_FLAGS[Branch];
//assign Branch= !(Latch_Ex_MEM_Zero)& Mem_FLAGS[BranchNE]|Latch_Ex_MEM_Zero & Mem_FLAGS[BranchEQ];

//Multiplexor Address desde ALU o desde Debug. Si memDebug es 1 esta en modo debug
MUX #(.LEN(32)) Mux_Address(.InputA(Latch_Ex_MEM_ALUOut), 
                            .InputB(dirMem), 
                            .SEL(memDebug), 
                            .Out(Mux_Add_To_Mem));

//Multiplexor Mem_Enable
MUX #(.LEN(1)) Mux_Enable(  .InputA(Mem_FLAGS[MemWrite]||Mem_FLAGS[MemRead]), 
                            .InputB(enableMem), 
                            .SEL(memDebug), 
                            .Out(Mux_Enable_To_Mem));
                                
//Multiplexor Mem_Read/Write
MUX #(.LEN(4)) Mux_RW(  .InputA(memWrite_4bits), 
                        .InputB(read), 
                        .SEL(memDebug), 
                        .Out(Mux_RW_To_Mem));                                
                                
//Memoria de Datos
Data_Memory DataMemory( //Inputs
                        .clka(Clk), 
                        .rsta(Reset), 
                        .ena(Mux_Enable_To_Mem),
                        .wea(Mux_RW_To_Mem), 
                        .addra(Mux_Add_To_Mem),
                        .dina(Latch_Ex_MEM_ReadDataB),
                        //Output
                        .douta(E4_DataOut)
                        );
endmodule
