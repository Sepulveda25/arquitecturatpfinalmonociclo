`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2019 20:48:19
// Design Name: 
// Module Name: ALU_Control
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
// Input:   Ex_FLAGS_ALUOp: toma los dos primeros bits ALUOp del output Ex_FLAGS Latch ID_EX 
//									 	00: Load o Store
//										01: Branch				
//										10: R-type				
//			Func: 6 bits de Funcion del registro de instrucciones
//			ShiftIn: 5 bits para funciones R-Type con Shift
//			InmCtrl: 3 bits para Control para las operaciones con inmediatos. 
//			           Identifica si es una suma, add, etc inmediata,a partir de los 3 LSB del Opcode
//                     [28:26] InmCtrl los 3 bits menos sig del Opcode
// Output:
//			Shift: 5 bits para funciones R-Type con Shift
//			ALU_Control_Out: Salida de ALU CONTROL a ALU con la Funcion propiamente dicha
//
//////////////////////////////////////////////////////////////////////////////////


module ALU_Control(     //Inputs
                        input [1:0] Ex_FLAGS_ALUOp, 
                        input [5:0] Func, //add, sub, etc
                        input [4:0] ShiftIn, //Shift Amount
                        input [2:0] InmCtrl, //Control para las operaciones con inmediatos
                        //Output
                        output reg [4:0] Shift,
                        output reg [5:0] ALU_Control_Out

                    );

always@* 
begin
    //Suma para LW: rt ? memory[rs+inm] o ST: memory[rs+inm] ? rt
    if (Ex_FLAGS_ALUOp == 2'b00) begin
        ALU_Control_Out = 6'b100000; 
        Shift = 0;
    end

    //Resta para BEQ y BNE. Si (rs = rt) o (rs != rt) se ejecuta branch segun el caso. Se activa flag Zero
    else if (Ex_FLAGS_ALUOp == 2'b01) begin
        ALU_Control_Out = 6'b100010; 
        Shift = 0;
    end

    //Es una R-type y el codigo de funcion pasa directo
    else if (Ex_FLAGS_ALUOp == 2'b10) begin
        ALU_Control_Out = Func; 
        Shift = ShiftIn;
    end

    //Immediate
    else if (Ex_FLAGS_ALUOp == 2'b11) begin
        Shift = 0;
        if(InmCtrl == 3'b000) ALU_Control_Out = 6'b100000; //ADDI
        else if(InmCtrl == 3'b100) ALU_Control_Out = 6'b100100; //ANDI
        else if(InmCtrl == 3'b101) ALU_Control_Out = 6'b100101; //ORI
        else if(InmCtrl == 3'b110) ALU_Control_Out = 6'b100110; //XORI
        else if(InmCtrl == 3'b010) ALU_Control_Out = 6'b101010; //SLTI
        else 	begin //Load Upper Inmediate - shift 16 bits LUI
                    ALU_Control_Out = 6'b000000; //Shift Left
                    Shift = 16; //Shift 16 posiciones
                end
    end
	
end

endmodule
