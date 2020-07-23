`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 11:26:52
// Design Name: 
// Module Name: Etapa1_IF
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


module Etapa1_IF( //Inputs 13
                  input Clk, 
                  input Reset, 
                  input [31:0] InputB_MUX, 
                  input PCScr, 
                  input Stall, 
                  input enable_pc, //para debug
                  input enable_sel, // para degug
                  input [31:0] Instr_in, // instruccion para cargar desde UART
                  input enable_mem, // activar memoria
                  input [3:0] write_enable, // activar escritura
                  input [31:0] Addr_Instr, // direccion de memoria para escribir
                  input Addr_Src, // elegir si el a addr de la unidad de debug o desde el pc
                  input pc_reset,
                  //Outputs 3
				  output [31:0] E1_AddOut, 
				  output [31:0] E1_InstrOut, 
				  output [31:0] PC_Out);
				  
//Cables de interconexion
  wire [31:0] addr_mux_to_InstrMem;
  wire [31:0] Stall_mux_to_PC;
  wire Stall_mux_to_Enable_PC; 
  //Variables
  reg [31:0] InputB_Adder=4;
  
  
  //Contador de Programa (PC)
  ProgramCounter PC(.Clk(Clk), .Reset(pc_reset), .enable(Stall_mux_to_Enable_PC),.In(Stall_mux_to_PC), .Out(PC_Out));
  
  //Mux de la etapa 1: Selector del PC
  //(SEL --> PCScr dado por Unidad de Control
  // SEL = 0 --> Instruccion dada  por el PC previo + 4
  // SEL = 1 --> Instruccion dada por LATCH "EX/MEM"
  MUX #(.LEN(32)) branch_mux(.InputA(E1_AddOut), .InputB(InputB_MUX), .SEL(PCScr), .Out(Stall_mux_to_PC));
  
  
  //Mux de Stall de la etapa 1:
  //Pone una burbuja en el caso de haya riesgo
  //Esto se hace manteniedo el PC anterior en vez del sumado por el adder. [PC(i) = PC(i-1)] en vez de [C(i) = PC(i+1)]
//  MUX #(.LEN(1)) stall_mux(.InputA(!Stall), .InputB(enable_pc), .SEL(enable_sel), .Out(Stall_mux_to_Enable_PC));
  assign Stall_mux_to_Enable_PC= (!Stall)&(enable_pc);
  
  //Mux selector de direcciones:
  //Desde la unidad de debug se elige que direccion darle la memoria  
  //Direccion desde el PC o desde la unidad de debug para programar las instrucciones
  MUX #(.LEN(32)) addr_mux(.InputA(PC_Out), .InputB(Addr_Instr), .SEL(Addr_Src), .Out(addr_mux_to_InstrMem));
  
 
  //Adder de la etapa 1: Suma 4 al PC previo. Su salida va al Mux y al Latch "IF/ID"
  Adder #(.LEN(32)) adder_IF(.InputA(PC_Out), .InputB(InputB_Adder), .Out(E1_AddOut));
  
  //Registro de Instrucciones de la etapa 1: Su entrada es la salida del PC
  Instruction_memory InstrMem (
    .addra(addr_mux_to_InstrMem), 
    .clka(Clk),
    .dina(Instr_in),
    .ena(enable_mem),
    .rsta(Reset),
    .wea(write_enable),
    .douta(E1_InstrOut)
    
  );
				 
endmodule
