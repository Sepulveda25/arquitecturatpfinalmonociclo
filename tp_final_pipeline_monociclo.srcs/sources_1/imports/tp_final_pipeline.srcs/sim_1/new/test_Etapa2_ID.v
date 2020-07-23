`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2019 22:01:08
// Design Name: 
// Module Name: test_Etapa2_ID
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
// El test es la siguiente ejecucion de instrucciones
// ADDI r1, r1, 0x3 ; en etapa WB => Hex: 0x20210003
// ADDI r2, r2, 0x7 ; en etapa MEM => Hex: 0x20420007
// ADD r3, r1, r2 ; en etapa EX => Hex: 0x00221820
// LW r4,0x0(r1) ; en etapa ID => Hex: 0x8C240000
// SUB r5,r4,r1; en etapa IF => Hex: 0x00812822
// HALT ; proximo en memoria
//////////////////////////////////////////////////////////////////////////////////


module test_Etapa2_ID;

    // Inputs
    reg Clk; 
    reg Reset;
    reg Stall; 
    reg [31:0] Latch_IF_ID_InstrOut; 
    reg [4:0] posReg;
    reg posSel;
    reg [4:0] Latch_MEM_WB_Mux;
    reg [31:0] Mux_WB;
    reg Latch_MEM_WB_RegWrite;
	// Outputs
    wire [31:0] E2_ReadDataA;
    wire [31:0] E2_ReadDataB; 
    wire [8:0] Mux_ControlFLAGS_Out;
    wire [31:0] SignExtendOut;
    wire [2:0] E2_InmCtrl;
    
    // Instantiate the Unit Under Test (UUT)
    Etapa2_ID uut (
        .Clk(Clk), 
        .Reset(Reset), 
        .Stall(Stall), 
        .Latch_IF_ID_InstrOut(Latch_IF_ID_InstrOut), 
        .posReg(posReg),
        .posSel(posSel),
        .Latch_MEM_WB_Mux(Latch_MEM_WB_Mux),
        .Mux_WB(Mux_WB),
        .Latch_MEM_WB_RegWrite(Latch_MEM_WB_RegWrite),
        .E2_ReadDataA(E2_ReadDataA),
        .E2_ReadDataB(E2_ReadDataB), 
        .Mux_ControlFLAGS_Out(Mux_ControlFLAGS_Out),
        .SignExtendOut(SignExtendOut),
        .E2_InmCtrl(E2_InmCtrl)
    );
    
    initial begin
        // Initialize Inputs
        Clk = 1;
        Reset = 1; //1: pone a 0s los 32 registros
        Stall = 1; // 0: pasa los FLAGS de Control_Unit 1: inyectar 0s en ID/EX flags
        Latch_IF_ID_InstrOut = 32'h00000000; //instruccion
        posReg = 5'b00000; // direccion Read_Register_A para debug
        posSel = 0; //entrada a memoria por Read_Register_A (0: Latch_IF_ID_InstrOut[25:21]| 1: posReg debug)
        Latch_MEM_WB_Mux = 5'b00000; // direccion para Write_Register
        Mux_WB = 32'h00000000;// dato para escribir en direccion Write_Register
        Latch_MEM_WB_RegWrite=0; //señal RegWrite 1:se permite la escritura   
        
        #20;// Intruccion tipo-I
        // LW r4,0x0(r1) ; en etapa ID => Hex: 0x8C240000
        Reset = 0; //1: pone a 0s los 32 registros
        Stall = 0; // 0: pasa los FLAGS de Control_Unit 1: inyectar 0s en ID/EX flags
        Latch_IF_ID_InstrOut = 32'h8C240000; //instruccion
        posReg = 5'b00000; // direccion Read_Register_A para debug
        posSel = 0; //entrada a memoria por Read_Register_A (0: Latch_IF_ID_InstrOut[25:21]| 1: posReg debug)
        Latch_MEM_WB_Mux = 5'b00001; // direccion para Write_Register
        Mux_WB = 32'h00000003;// dato para escribir en direccion Write_Register
        Latch_MEM_WB_RegWrite=1; //señal RegWrite 1:se permite la escritura
        
//        #20;// Intruccion tipo-I
//        // ADDI r2, r2, 0x7 ; en etapa MEM
//        // Con esta instruccion lo que se hace implicitamente es guardar un valor inmediato
//        //en un registro
//        Reset = 0; //1: pone a 0s los 32 registros
//        Stall = 0; // 0: pasa los FLAGS de Control_Unit 1: inyectar 0s en ID/EX flags
//        Latch_IF_ID_InstrOut = 32'h00000000; //instruccion
//        posReg = 5'b00000; // direccion Read_Register_A para debug
//        posSel = 0; //entrada a memoria por Read_Register_A (0: Latch_IF_ID_InstrOut[25:21]| 1: posReg debug)
//        Latch_MEM_WB_Mux = 5'b00000; // direccion para Write_Register
//        Mux_WB = 32'h00000000;// dato para escribir en direccion Write_Register
//        Latch_MEM_WB_RegWrite=0; //señal RegWrite 1:se permite la escritura
        
//        #20;// Intruccion tipo-R
//        // ADD r3, r1, r2 ; r3=r1 + r2
//        Reset = 1; //1: pone a 0s los 32 registros
//        Stall = 1; // 0: pasa los FLAGS de Control_Unit 1: inyectar 0s en ID/EX flags
//        Latch_IF_ID_InstrOut = 32'h00000000; //instruccion
//        posReg = 5'b00000; // direccion Read_Register_A para debug
//        posSel = 0; //entrada a memoria por Read_Register_A (0: Latch_IF_ID_InstrOut[25:21]| 1: posReg debug)
//        Latch_MEM_WB_Mux = 5'b00000; // direccion para Write_Register
//        Mux_WB = 32'h00000000;// dato para escribir en direccion Write_Register
//        Latch_MEM_WB_RegWrite=0; //señal RegWrite 1:se permite la escritura
           
    end

    always begin //clock de la placa 50Mhz
        #10 Clk=~Clk;
    end 

endmodule
