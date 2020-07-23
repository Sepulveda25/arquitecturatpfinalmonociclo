`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2020 01:05:54
// Design Name: 
// Module Name: test_modulo_saltos
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


module test_modulo_saltos;
    //input
    reg [31:0] 	 E2_ReadDataA;  
    reg [31:0]   E2_ReadDataB;
    reg [31:0]   Latch_IF_ID_Adder_Out;//PC+4
    reg [25:0]   Latch_IF_ID_InstrOut_25_0;
    reg [5:0]    flags_branch_jump; //{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
    //output
    wire [31:0]  PC_salto;
    wire salto;

    // Instantiate the Unit Under Test (UUT)
    Etapa2_ID_Modulo_Saltos uut (
        .E2_ReadDataA(E2_ReadDataA),  
        .E2_ReadDataB(E2_ReadDataB),
        .Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out),//PC+4
        .Latch_IF_ID_InstrOut_25_0(Latch_IF_ID_InstrOut_25_0),
        .flags_branch_jump(flags_branch_jump), //{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
        //output
        .PC_salto(PC_salto),
        .salto(salto)
    );
//{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
    initial begin
       E2_ReadDataA=0;
       E2_ReadDataB=0;
       Latch_IF_ID_Adder_Out=0;
       Latch_IF_ID_InstrOut_25_0=0;
       flags_branch_jump=6'b000000;
       #20; //###########salto BEQ tomado
       E2_ReadDataA=9;
       E2_ReadDataB=9;
       Latch_IF_ID_Adder_Out=8;
       Latch_IF_ID_InstrOut_25_0=11;
       flags_branch_jump=6'b100000;
       #20; //###########salto BEQ no tomado
       E2_ReadDataA=9;
       E2_ReadDataB=21;
       Latch_IF_ID_Adder_Out=8;
       Latch_IF_ID_InstrOut_25_0=21;
       flags_branch_jump=6'b100000;
       #20; //###########salto BNE tomado
       E2_ReadDataA=17;
       E2_ReadDataB=9;
       Latch_IF_ID_Adder_Out=4;
       Latch_IF_ID_InstrOut_25_0=17;
       flags_branch_jump=6'b010000;
       #20; //###########salto BNE no tomado
       E2_ReadDataA=13;
       E2_ReadDataB=13;
       Latch_IF_ID_Adder_Out=4;
       Latch_IF_ID_InstrOut_25_0=25;
       flags_branch_jump=6'b010000;
       #20; //###########salto JR
       E2_ReadDataA=32;
       E2_ReadDataB=19;
       Latch_IF_ID_Adder_Out=32'h10000000;
       Latch_IF_ID_InstrOut_25_0=36;
       flags_branch_jump=6'b001000;
       #20; //###########salto JALR
       E2_ReadDataA=40;
       E2_ReadDataB=17;
       Latch_IF_ID_Adder_Out=32'h80000000;
       Latch_IF_ID_InstrOut_25_0=23;
       flags_branch_jump=6'b000100;
       #20; //###########salto J
       E2_ReadDataA=8;
       E2_ReadDataB=9;
       Latch_IF_ID_Adder_Out=32'ha0000000;
       Latch_IF_ID_InstrOut_25_0=170;
       flags_branch_jump=6'b000010;
       #20; //###########salto JAL
       E2_ReadDataA=25;
       E2_ReadDataB=30;
       Latch_IF_ID_Adder_Out=32'hba000000;
       Latch_IF_ID_InstrOut_25_0=3272;
       flags_branch_jump=6'b000001;
       #20; //###########sin salto
       E2_ReadDataA=52;
       E2_ReadDataB=74;
       Latch_IF_ID_Adder_Out=32'h0000a000;
       Latch_IF_ID_InstrOut_25_0=917;
       flags_branch_jump=6'b000000;
   end 
endmodule
