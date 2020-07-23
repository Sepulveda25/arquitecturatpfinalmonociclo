`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2020 23:50:44
// Design Name: 
// Module Name: Etapa2_ID_Modulo_Saltos
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Este modulo se encarga de calcular los PC de los saltos Branch y Jump. En caso de ser un salto condicional
// tambien se encarga de evaluar la condicion de salto
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Etapa2_ID_Modulo_Saltos(
                                 input          Clk,
                                 input [31:0] 	E2_ReadDataA,  
                                 input [31:0]   E2_ReadDataB,
                                 input [31:0]   Latch_IF_ID_Adder_Out,//PC+4
                                 input [25:0]   Latch_IF_ID_InstrOut_25_0,
                                 input [5:0]    flags_branch_jump, //{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
                                 output reg [31:0]  PC_salto,
                                 output reg salto //flag que indica si el salto se toma

    );

// Conexiones interna
wire [31:0] pc_jmp_jal;
wire [31:0] pc_beq_bne;
wire [31:0] se_offset;
wire es_igual;
wire no_igual;

///##################################  J y JAL PC address ####################################################
// Modulo para calculo de PC de J y JAL, que se encarga de concatenar los 4 bits mas significativos del PC con los bits del 25 a 0 (instr_index)
// de una instruccion J o JAL y finalmente los ultimos dos bits menos significativos con 0.
// Todo esto forma el PC a donde debe saltar la instruccion
pc_jump PC_J_JAL_ID(  //input
                     .pc_31_28(Latch_IF_ID_Adder_Out[31:28]), 
                     .instr_index(Latch_IF_ID_InstrOut_25_0),
                     //output
                     .pc_jmp_jal(pc_jmp_jal) 
                  ); 

///##################################  BEQ y BNE PC address ####################################################
// Modulo para calculo de PC de BEQ y BNE, que se encarga de sumar los 16 bits mas bajos de la instruccion (offset)
// primero se le hace un sign extend de 32 bits luego al resultado se lo desplaza 2 lugares a la izquierda
// y finalmente se le suma al PC+4 y el resultado sera la direccion de PC para saltar si se cumple la condicion.
Sign_Extend #(.LEN_output(32),.LEN_input(16)) 
            Sign_Ext_beq_bne( .SignExtendIn(Latch_IF_ID_InstrOut_25_0[15:0]), 
                              .SignExtendOut(se_offset));
                    
Adder #(.LEN(32)) adder_id( .InputA(Latch_IF_ID_Adder_Out), 
                            .InputB(se_offset<<2), // se dezplaza 2 lugares a la derecha
                            .Out(pc_beq_bne));                   

//---------------- Coparador para branch
Comparador_registros #(.LEN(32)) comparador_reg_ID(
                               .E2_ReadDataA(E2_ReadDataA),  
                               .E2_ReadDataB(E2_ReadDataB),
                               .es_igual(es_igual),
                               .no_igual(no_igual)
);
///##################################  JR y JALR PC address ####################################################
// Se obtienen de E2_ReadDataA 

///##################################  Señales de control ####################################################  
//{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
always@*begin
    salto=0;
	if((flags_branch_jump[1] == 1) || (flags_branch_jump[0] == 1)) //detecta si el salto es por J o JAL
	   begin
	       PC_salto = pc_jmp_jal;
	       salto=1;
	   end
	else if ((flags_branch_jump[3] == 1) || (flags_branch_jump[2] == 1)) //detecta si el salto es por JR o JALR
	   begin
	       PC_salto = E2_ReadDataA;
           salto=1;
       end
    else if ((flags_branch_jump[4] == 1)&&(no_igual==1)) //detecta si el salto es por BranchNE
       begin
           PC_salto = pc_beq_bne;
           salto=1;
       end
    else if ((flags_branch_jump[5] == 1)&&(es_igual==1)) //detecta si el salto es por BranchEQ
       begin
           PC_salto = pc_beq_bne;
           salto=1;
       end
    else
       begin
           PC_salto=0;
           salto=0;
       end
end
 
endmodule
