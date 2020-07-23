`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2019 22:22:17
// Design Name: 
// Module Name: test_pipeline
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
// SUB r5,r3,r1; en etapa IF => Hex: 0x00612822
// HALT ; proximo en memoria
//////////////////////////////////////////////////////////////////////////////////


module test_pipeline;

    // Inputs
    reg Clk;
    reg Latch_Reset;
    reg Latch_enable;
    //Etapa IF
    reg Etapa_IF_Reset;
    //reg Etapa_IF_PCScr;
    reg Etapa_IF_enable_pc;
    reg Etapa_IF_enable_sel;
    reg [31:0] Etapa_IF_Instr_in;
    reg Etapa_IF_enable_mem;
    reg [3:0] Etapa_IF_write_enable;
    reg [31:0] Etapa_IF_Addr_Instr;
    reg Etapa_IF_Addr_Src;
    reg Etapa_IF_pc_reset;
    reg halt_reset;
   
    //Etapa ID
    reg Etapa_ID_Reset;
    reg [4:0] Etapa_ID_posReg; // address para leer registros en modo debug
    reg Etapa_ID_posSel; // selecion de address para Register
    //Etapa MEM
    reg Etapa_MEM_Reset;
    reg [31:0] dirMem;                 //Addr a Mux; luego a DataMem
    reg memDebug;
    //Contador de ciclos
    reg enable_count;
    reg reset_contador_clk;
	// Outputs
	//Etapa IF
    wire [31:0] E1_AddOut;
    wire [31:0] E1_InstrOut;
    wire [31:0] PC_Out;
    wire        halt;
    wire        stall_or_halt;
    //Outputs del Latch "IF/ID"
    wire [31:0] Latch_IF_ID_Adder_Out;
    wire [31:0] Latch_IF_ID_InstrOut;
    wire        Latch_IF_ID_halt;
    //Etapa ID
    wire [31:0] E2_ReadDataA;    
    wire [31:0] E2_ReadDataB;
    wire [7:0]  ControlFLAGS; // [13:0]  ControlFLAGS;     
    wire [31:0] SignExtendOut;
    wire [2:0]  E2_InmCtrl;
    wire [5:0]  flags_branch_jump; //nuevo
    wire [31:0] ADDER_E2_PC_JALR_JAL;
    wire [4:0]  E2_Rd_mux;
    wire [31:0] E2_PC_salto; // Valor de PC para saltos
    wire        E2_salto; 
    //Outputs del Latch "ID/EX"
    wire [1:0]   Latch_ID_Ex_WriteBack_FLAGS;
    wire [1:0]   Latch_ID_Ex_Mem_FLAGS;//ex [3:0]   Latch_ID_Ex_Mem_FLAGS;
    wire [3:0]   Latch_ID_Ex_FLAGS;
    wire [31:0]  Latch_ID_Ex_PC_JALR_JAL; //ex Latch_ID_Ex_Adder_Out;
    wire [31:0]  Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB;
    wire [31:0]  Latch_ID_Ex_SignExtendOut; 
    wire [4:0]   Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd;    
    wire [2:0]   Latch_ID_Ex_InmCtrl;
    wire [1:0]   Latch_ID_Ex_flags_JALR_JAL; // {JALR,JAL}
    wire         Latch_ID_Ex_halt;
    //Etapa EX
    wire [31:0] E3_ALUOut;
    wire [4:0]  E3_MuxOut;
    wire [31:0] MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB;
    //Output del Latch "Ex/MEM"
    wire [1:0]     Latch_Ex_MEM_Mem_FLAGS_Out;//ex [3:0]     Latch_Ex_MEM_Mem_FLAGS_Out;
    wire [31:0]    Latch_Ex_MEM_ReadDataB;
    wire [31:0]    Latch_Ex_MEM_PC_JALR_JAL; //ex Latch_Ex_MEM_E3_Adder_Out;
    wire [1:0]     Latch_Ex_MEM_WriteBack_FLAGS_Out;
    wire [4:0]     Latch_Ex_MEM_Mux;
    wire [31:0]    Latch_Ex_MEM_E3_ALUOut;
    wire [1:0]     Latch_Ex_MEM_flags_JALR_JAL; // {JALR,JAL}
    wire           Latch_Ex_MEM_halt;
    //Etapa MEM
    wire [31:0] E4_DataOut_to_Latch_MEM_WB;
    //Outputs del Latch MEM/WB
    wire [31:0]	Latch_MEM_WB_DataOut;
    wire [31:0] Latch_MEM_WB_ALUOut;
    wire [4:0]  Latch_MEM_WB_Mux;
    wire [1:0]  Latch_MEM_WB_WriteBack_FLAGS_Out;
    wire [1:0]  Latch_MEM_WB_flags_JALR_JAL; // {JALR,JAL}
    wire [31:0] Latch_MEM_WB_PC_JALR_JAL;
    wire        Latch_MEM_WB_halt;
    //Etapa WB
    wire [31:0] Mux_WB;
    wire [31:0] Mux_WB_JALR_JAL;
    //Outputs de la Unidad de Cortocircuito
    wire [1:0] ForwardA, ForwardB;
    //Outputs de la Unidad de Deteccion de Riesgos
    wire Stall;
    //Contador de ciclos
    wire [31:0] count;
    wire Latch_MEM_WB_halt_and_enable_count;
    
    // Instantiate the Unit Under Test (UUT)
    pipeline uut (
        //Inputs
        .Clk(Clk), 
        .Latch_Reset(Latch_Reset),
        .Latch_enable(Latch_enable),
        //Etapa IF
        .Etapa_IF_Reset(Etapa_IF_Reset),
        //.Etapa_IF_PCScr(Etapa_IF_PCScr),
        .Etapa_IF_enable_sel(Etapa_IF_enable_sel),
        .Etapa_IF_Instr_in(Etapa_IF_Instr_in),
        .Etapa_IF_enable_mem(Etapa_IF_enable_mem),
        .Etapa_IF_write_enable(Etapa_IF_write_enable),
        .Etapa_IF_Addr_Instr(Etapa_IF_Addr_Instr),
        .Etapa_IF_Addr_Src(Etapa_IF_Addr_Src),
        .Etapa_IF_pc_reset(Etapa_IF_pc_reset),
        .halt_reset(halt_reset),
        .Etapa_IF_enable_pc(Etapa_IF_enable_pc),
        .stall_or_halt(stall_or_halt),
        //Etapa ID
        .Etapa_ID_Reset(Etapa_ID_Reset),
        .Etapa_ID_posReg(Etapa_ID_posReg), 
        .Etapa_ID_posSel(Etapa_ID_posSel),
         //Etapa MEM 
        .Etapa_MEM_Reset(Etapa_MEM_Reset),
        .dirMem(dirMem),                 
        .memDebug(memDebug),
        //Contador de ciclos
        .enable_count(enable_count),
        .reset_contador_clk(reset_contador_clk),
        //Outputs
        //Etapa IF 
        .E1_AddOut(E1_AddOut),
        .E1_InstrOut(E1_InstrOut),
        .PC_Out(PC_Out),
        .halt(halt),
        //Outputs del Latch "IF/ID"
        .Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out),
        .Latch_IF_ID_InstrOut(Latch_IF_ID_InstrOut),
        .Latch_IF_ID_halt(Latch_IF_ID_halt),
        //Etapa ID
        .E2_ReadDataA(E2_ReadDataA),    
        .E2_ReadDataB(E2_ReadDataB),
        .ControlFLAGS(ControlFLAGS),      
        .SignExtendOut(SignExtendOut),
        .E2_InmCtrl(E2_InmCtrl),
        .flags_branch_jump(flags_branch_jump),
        .ADDER_E2_PC_JALR_JAL(ADDER_E2_PC_JALR_JAL),
        .E2_Rd_mux(E2_Rd_mux),
        .E2_PC_salto(E2_PC_salto),
        .E2_salto(E2_salto),
        //Outputs del Latch "ID/EX"
        .Latch_ID_Ex_WriteBack_FLAGS(Latch_ID_Ex_WriteBack_FLAGS),
        .Latch_ID_Ex_Mem_FLAGS(Latch_ID_Ex_Mem_FLAGS),
        .Latch_ID_Ex_FLAGS(Latch_ID_Ex_FLAGS),
        .Latch_ID_Ex_PC_JALR_JAL(Latch_ID_Ex_PC_JALR_JAL),//.Latch_ID_Ex_Adder_Out(Latch_ID_Ex_Adder_Out),
        .Latch_ID_Ex_ReadDataA(Latch_ID_Ex_ReadDataA), 
        .Latch_ID_Ex_ReadDataB(Latch_ID_Ex_ReadDataB),
        .Latch_ID_Ex_SignExtendOut(Latch_ID_Ex_SignExtendOut),
        .Latch_ID_Ex_InstrOut_25_21_Rs(Latch_ID_Ex_InstrOut_25_21_Rs), 
        .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt),
        .Latch_ID_Ex_InstrOut_15_11_Rd(Latch_ID_Ex_InstrOut_15_11_Rd),   
        .Latch_ID_Ex_InmCtrl(Latch_ID_Ex_InmCtrl),
        .Latch_ID_Ex_flags_JALR_JAL(Latch_ID_Ex_flags_JALR_JAL),
        .Latch_ID_Ex_halt(Latch_ID_Ex_halt),
        //Etapa EX
        //.E3_Adder_Out(E3_Adder_Out),
        //.E3_ALU_Zero(E3_ALU_Zero),
        .E3_ALUOut(E3_ALUOut),
        .E3_MuxOut(E3_MuxOut),
        .MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB),
        //Output del Latch "Ex/MEM"
        .Latch_Ex_MEM_Mem_FLAGS_Out(Latch_Ex_MEM_Mem_FLAGS_Out),
        .Latch_Ex_MEM_ReadDataB(Latch_Ex_MEM_ReadDataB),
        .Latch_Ex_MEM_PC_JALR_JAL(Latch_Ex_MEM_PC_JALR_JAL),//ex .Latch_Ex_MEM_E3_Adder_Out(Latch_Ex_MEM_E3_Adder_Out),
        //.Latch_Ex_MEM_Zero(Latch_Ex_MEM_Zero),
        .Latch_Ex_MEM_WriteBack_FLAGS_Out(Latch_Ex_MEM_WriteBack_FLAGS_Out),
        .Latch_Ex_MEM_Mux(Latch_Ex_MEM_Mux),
        .Latch_Ex_MEM_E3_ALUOut(Latch_Ex_MEM_E3_ALUOut),
        .Latch_Ex_MEM_flags_JALR_JAL(Latch_Ex_MEM_flags_JALR_JAL),
        .Latch_Ex_MEM_halt(Latch_Ex_MEM_halt),
        //Etapa MEM
        .E4_DataOut_to_Latch_MEM_WB(E4_DataOut_to_Latch_MEM_WB),
        //Outputs del Latch MEM/WB
        .Latch_MEM_WB_DataOut(Latch_MEM_WB_DataOut),
        .Latch_MEM_WB_ALUOut(Latch_MEM_WB_ALUOut),
        .Latch_MEM_WB_Mux(Latch_MEM_WB_Mux),
        .Latch_MEM_WB_WriteBack_FLAGS_Out(Latch_MEM_WB_WriteBack_FLAGS_Out),
        .Latch_MEM_WB_flags_JALR_JAL(Latch_MEM_WB_flags_JALR_JAL),
        .Latch_MEM_WB_PC_JALR_JAL(Latch_MEM_WB_PC_JALR_JAL),
        .Latch_MEM_WB_halt(Latch_MEM_WB_halt),
        //Etapa WB
        .Mux_WB(Mux_WB),
        .Mux_WB_JALR_JAL(Mux_WB_JALR_JAL),
        //Outputs de la Unidad de Cortocircuito
        .ForwardA(ForwardA), 
        .ForwardB(ForwardB),
        //Output de la Unidad de Deteccion de Riesgos
        .Stall(Stall),
        //Contador de ciclos
        .count(count),
        .Latch_MEM_WB_halt_and_enable_count(Latch_MEM_WB_halt_and_enable_count)
    );
    
    initial begin
        // Initialize Inputs
        Clk = 0;
        // Puesta a punto inicial 
        Latch_Reset = 1; // se reinicia todos los latch
        Latch_enable = 0; // se deshabilita los latch
        //Etapa IF
        Etapa_IF_Reset = 0; // no se reinicia la memoria de programa!! (programa ya cargado en coefile)
        //Etapa_IF_PCScr = 0; //POR AHORA NO HAY SALTOS
        Etapa_IF_enable_pc = 0; //program counter deshabilitado
        Etapa_IF_enable_sel = 0; //no esta en modo debug
        Etapa_IF_Instr_in = 32'h00000000; // puede ser x porque no se ingresan instrucciones
        Etapa_IF_enable_mem = 1; // se habilita la memoria de Instrucciones 
        Etapa_IF_write_enable = 4'b0000; // se deja en 0 porque no se van a ingresar instrucciones
        Etapa_IF_Addr_Instr = 32'h00000000; // puede ser x porque no se van a ingresar instrucciones
        Etapa_IF_Addr_Src = 0; //se deja en 0 porque no se van a ingresar instrucciones
        Etapa_IF_pc_reset = 1; // se renicia el program counter
        halt_reset=1; // se reinicia la unidad de halt para que arranque en  cero
        //Etapa ID
        Etapa_ID_Reset = 1; // se reinician todos los registros 
        Etapa_ID_posReg = 5'b0000; // no esta en modo debug
        Etapa_ID_posSel = 0; // no esta en modo debug
        //Etapa MEM
        Etapa_MEM_Reset = 1; // se reinician los registros
        dirMem = 32'h00000000; // puede ser x porque no se van a leer los registros      
        memDebug = 0; //no esta en modo debug
        //Contador de ciclos
        enable_count=1;
        reset_contador_clk=1;
     
        #20;// arranca la ejecucion
        Latch_Reset = 0; //  no se reinicia todos los latch
        Latch_enable = 1; // se habilita los latch
        //Etapa IF
        Etapa_IF_Reset = 0; // no se reinicia la memoria de programa!! (programa ya cargado en coefile)
        Etapa_IF_enable_pc = 1; //program counter habilitado
        Etapa_IF_enable_sel = 0; //no esta en modo debug
        Etapa_IF_Instr_in = 32'h00000000; // puede ser x porque no se ingresan instrucciones
        //Etapa_IF_enable_mem = 1; // se habilita la memoria de Instrucciones
        Etapa_IF_write_enable = 4'b0000; // se deja en 0 porque no se van a ingresar instrucciones
        Etapa_IF_Addr_Instr = 32'h00000000; // puede ser x porque no se van a ingresar instrucciones
        Etapa_IF_Addr_Src = 0; //se deja en 0 porque no se van a ingresar instrucciones
        Etapa_IF_pc_reset = 0; // no se renicia el program counter
        halt_reset=0; // la unidad esta preparada para detectar un salto
        //Etapa ID
        Etapa_ID_Reset = 0; // no se reinician todos los registros 
        Etapa_ID_posReg = 5'b0000; // no esta en modo debug
        Etapa_ID_posSel = 0; // no esta en modo debug
        //Etapa MEM
        Etapa_MEM_Reset = 0; // no se reinician los registros
        dirMem = 32'h00000000; // puede ser x porque no se van a leer los registros      
        memDebug = 0; //no esta en modo debug
        //Contador de ciclos
        enable_count=1;
        reset_contador_clk=0;
//        $display("At Simulation",$time," pc_out: %h",PC_Out);           
    end
    
    always begin //clock de la placa 50Mhz
        #10 Clk=~Clk;
        if((Clk==1)&& (halt!=1)) $display("Etapa IF: ","PC_out: %h",PC_Out," Instruccion: %h",E1_InstrOut," Tiempo simulacion ",$time);
    end 
    
endmodule
