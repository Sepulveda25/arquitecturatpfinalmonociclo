`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2020 00:28:55
// Design Name: 
// Module Name: test_pipeline_por_pasos
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


module test_pipeline_por_pasos;
    // Inputs
    reg Clk;
    reg Step;
    reg Step_flag;
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
    wire [31:0]  Latch_ID_Ex_InstrOut;
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
    wire [31:0]    Latch_Ex_MEM_InstrOut;
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
    wire [31:0] Latch_MEM_WB_InstrOut;
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
        .Latch_ID_Ex_PC_JALR_JAL(Latch_ID_Ex_PC_JALR_JAL),
        .Latch_ID_Ex_ReadDataA(Latch_ID_Ex_ReadDataA), 
        .Latch_ID_Ex_ReadDataB(Latch_ID_Ex_ReadDataB),
        .Latch_ID_Ex_SignExtendOut(Latch_ID_Ex_SignExtendOut),
        .Latch_ID_Ex_InstrOut_25_21_Rs(Latch_ID_Ex_InstrOut_25_21_Rs), 
        .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt),
        .Latch_ID_Ex_InstrOut_15_11_Rd(Latch_ID_Ex_InstrOut_15_11_Rd),   
        .Latch_ID_Ex_InmCtrl(Latch_ID_Ex_InmCtrl),
        .Latch_ID_Ex_flags_JALR_JAL(Latch_ID_Ex_flags_JALR_JAL),
        .Latch_ID_Ex_halt(Latch_ID_Ex_halt),
        .Latch_ID_Ex_InstrOut(Latch_ID_Ex_InstrOut),
        //Etapa EX
        .E3_ALUOut(E3_ALUOut),
        .E3_MuxOut(E3_MuxOut),
        .MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB),
        //Output del Latch "Ex/MEM"
        .Latch_Ex_MEM_Mem_FLAGS_Out(Latch_Ex_MEM_Mem_FLAGS_Out),
        .Latch_Ex_MEM_ReadDataB(Latch_Ex_MEM_ReadDataB),
        .Latch_Ex_MEM_PC_JALR_JAL(Latch_Ex_MEM_PC_JALR_JAL),
        .Latch_Ex_MEM_WriteBack_FLAGS_Out(Latch_Ex_MEM_WriteBack_FLAGS_Out),
        .Latch_Ex_MEM_Mux(Latch_Ex_MEM_Mux),
        .Latch_Ex_MEM_E3_ALUOut(Latch_Ex_MEM_E3_ALUOut),
        .Latch_Ex_MEM_flags_JALR_JAL(Latch_Ex_MEM_flags_JALR_JAL),
        .Latch_Ex_MEM_halt(Latch_Ex_MEM_halt),
        .Latch_Ex_MEM_InstrOut(Latch_Ex_MEM_InstrOut),
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
        .Latch_MEM_WB_InstrOut(Latch_MEM_WB_InstrOut),
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
    
    integer  file, status=0,addr_instruccion=0;
    reg [31:0] data=0;
    //flag de Branch/Jump
    localparam BranchEQ = 5;
    localparam BranchNE = 4;
    localparam JR = 3;
    localparam JALR = 2;
    localparam Jmp = 1; 
    localparam JAL = 0;
    //Señal EX
    localparam RegDst=3;
    localparam ALUSrc=2; 
    localparam ALUOp1=1; 
    localparam ALUOp0=0;
    //Señal MEM
    localparam MemRead = 1;
    localparam MemWrite =0;
    //Señales WB
    localparam MemtoReg = 0;
    localparam RegWrite = 1;
    
    initial begin
        // Initialize Inputs
        Clk = 0;
        Step = 0;
        Step_flag=0;
        // Puesta a punto inicial 
        Latch_Reset = 1; // se reinicia todos los latch
        Latch_enable = 0; // se deshabilita los latch
        //Etapa IF
        Etapa_IF_Reset = 0; //<= ############# No se reinicia la memoria ya arranca en 0
        Etapa_IF_enable_pc = 0; //program counter deshabilitado
        Etapa_IF_enable_sel = 0; //no esta en modo debug
        Etapa_IF_Instr_in = 32'h00000000; //<= ############# Todavia no se ingresa ninguna instruccion
        Etapa_IF_enable_mem = 1; //<= ############# Se activa la memoria
        Etapa_IF_write_enable = 4'b1111; //<= ############# Se habilita la escritura 
        Etapa_IF_Addr_Instr = 32'h00000000; //<= ############# Todavia no se ingresa la direccion en memoria
        Etapa_IF_Addr_Src = 1; //<= ############# Se indica que la direccion de se va a pasar desde Etapa_IF_Addr_Instr y no desde el PC
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
        reset_contador_clk=1;
        enable_count=1;
        // Se carga en la memoria de instrucciones los datos
        $display("#### Escribiendo instrucciones en memoria ####");
//        file = $fopen("E:/Facultad/Arquitectura de Computadoras/Practicos Vivado/tp_final_pipeline/test_lectura_hex.txt","r");
        file = $fopen("C:/Users/Fede/Desktop/compilador_y_codigos/Salida_HEX.txt","r");
        if (file == 0) $error("Salida_HEX.txt no se pudo abrir");
        #20;
        //escritura en memoria
        while(!$feof(file)) begin
            status = $fscanf(file,"%h",data);
            Etapa_IF_Addr_Instr = addr_instruccion; 
            Etapa_IF_Instr_in = data;
            $display("Dato: %h | Direccion %h",Etapa_IF_Instr_in,Etapa_IF_Addr_Instr,"; Tiempo simulacion (ns)",$time);
            addr_instruccion = addr_instruccion+4;
            #20;  
        end
        //va 240ns
        $fclose(file);
        $display("\n#### Escritura de instrucciones finalizada ####");
        Etapa_IF_write_enable = 4'b0000; // se deja en 0 porque no se van a ingresar mas instrucciones
        Etapa_IF_Addr_Instr = 0;// puede ser x porque no se van a ingresar mas instrucciones
        Etapa_IF_Instr_in=0; // puede ser x porque no se ingresan mas instrucciones
        ////################################ ESTADO INICIAL ##########################################
        #20;
        $display("\n################################## CICLO NUMERO: %d #############################################\n",count);
                    
        $display("#########################################################################################################");
        $display("######################### Etapa IF salidas #########################");
        $display("* E1_Instr: %h| PC: %h",E1_InstrOut, PC_Out);
        $display("* E1 AddOut: %h| Unidad halt: %b| Stall or Halt: %b \n", E1_AddOut, halt, stall_or_halt);
        
        $display("#########################################################################################################");
        $display("######################### Contenido de Latch IF/ID #########################");
        $display("#### Instruccion Etapa ID: %h| ####", Latch_IF_ID_InstrOut);
        $display("* Adder Out: %h| InstrOut: %h| Flag halt: %b \n",Latch_IF_ID_Adder_Out, Latch_IF_ID_InstrOut,Latch_IF_ID_halt);
        
        $display("#########################################################################################################");
        $display("######################### Etapa ID salidas #########################"); //{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
        $display("* Read DataA: %d| Read DataB: %d| Operaciones Inmediatos InmCtrl: %b| Sign Extend: %h", E2_ReadDataA, E2_ReadDataB, E2_InmCtrl, SignExtendOut);
        $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b", ControlFLAGS[7], ControlFLAGS[6]);
        $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",ControlFLAGS[5],ControlFLAGS[4]);
        $display("* FLAG EX RegDst: %b| FLAG EX ALUSrc: %b| FLAG EX ALUOp1: %b| FLAG EX ALUOp0: %b",ControlFLAGS[3],ControlFLAGS[2],ControlFLAGS[1],ControlFLAGS[0]);
        $display("* PC JALR JAL (PC+8): %h| Mux JAL Rd (dir retorno): %b \n", ADDER_E2_PC_JALR_JAL, E2_Rd_mux);
        
        $display("=========================================================================================================");
        $display("#### Unidad de Saltos ####");
        $display("#### Entradas ####");
        $display("* BranchEQ: %b| BranchNE: %b| JR: %b| JALR: %b| Jmp: %b| JAL: %b ",flags_branch_jump[BranchEQ],flags_branch_jump[BranchNE],flags_branch_jump[JR],flags_branch_jump[JALR],flags_branch_jump[Jmp],flags_branch_jump[JAL]);
        $display("* Read DataA: %d| Read DataB: %d",E2_ReadDataA,E2_ReadDataB);
        $display("* Adder Etapa IF: %h| Instr Index (J y JAL): %h", Latch_IF_ID_Adder_Out, Latch_IF_ID_InstrOut[25:0]);
        $display("#### Salida ####");
        $display("* PC branch/jump: %h| Flag de salto tomado: %b \n",E2_PC_salto, E2_salto);
        
        $display("=========================================================================================================");
        $display("#### Unidad de Deteccion de Riesgos ####");
        $display("#### Entradas ####");
        $display("* Latch IF/ID out Rs: %b| Latch IF/ID out Rt: %b", Latch_IF_ID_InstrOut[25:21], Latch_IF_ID_InstrOut[20:16]);
        $display("* Latch ID/EX out Rt: %b| Latch ID/EX Flag MemRead: %b", Latch_ID_Ex_InstrOut_20_16_Rt,Latch_ID_Ex_Mem_FLAGS[MemRead]);
        $display("#### Salidas ####");
        $display("* Stall: %b \n" ,Stall);    
        
        $display("#########################################################################################################");
        $display("######################### Contenido de Latch ID/EX #########################"); 
        $display("#### Instruccion Etapa EX: %h| ####", Latch_ID_Ex_InstrOut);
        $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b",Latch_ID_Ex_WriteBack_FLAGS[RegWrite], Latch_ID_Ex_WriteBack_FLAGS[MemtoReg]);
        $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",Latch_ID_Ex_Mem_FLAGS[MemRead], Latch_ID_Ex_Mem_FLAGS[MemWrite]);
        $display("* FLAG EX RegDst: %b| FLAG EX ALUSrc: %b| FLAG EX ALUOp1: %b| FLAG EX ALUOp0: %b",Latch_ID_Ex_FLAGS[RegDst] , Latch_ID_Ex_FLAGS[ALUSrc], Latch_ID_Ex_FLAGS[ALUOp1], Latch_ID_Ex_FLAGS[ALUOp0]);
        $display("* InmCtrl: %b", Latch_ID_Ex_InmCtrl);
        $display("* Read DataA: %d| Read DataB: %d| Sign Extend: %h| Flag halt: %b",Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB,Latch_ID_Ex_SignExtendOut,Latch_ID_Ex_halt);
        $display("* InstrOut Rs: %b| InstrOut Rt: %b| InstrOut Rd: %b",Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd);
        $display("* PC JALR JAL: %h| JALR JAL Flags: %b \n",Latch_ID_Ex_PC_JALR_JAL,Latch_ID_Ex_flags_JALR_JAL);
        
        $display("#########################################################################################################");
        $display("######################### Etapa EX salidas #########################");
        $display("* E3_ALUOut: %h| Mux Rt/Rd: %b| Dato a escribir MEM: %h \n",E3_ALUOut, E3_MuxOut, MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB);
        
        $display("=========================================================================================================");
        $display("#### Unidad de Cortocircuito ####");
        $display("#### Entradas ####");
        $display("* Latch ID/EX Rs: %b| Latch ID/EX Rt: %b",Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt);
        $display("* Latch EX/MEM Rd: %b| Latch EX/MEM Flag RegWrite: %b", Latch_Ex_MEM_Mux, Latch_Ex_MEM_WriteBack_FLAGS_Out[RegWrite]);
        $display("* Latch MEM/WB Rd: %b| Latch MEM/WB Flag RegWrite: %b", Latch_MEM_WB_Mux, Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite]);
        $display("#### Salidas ####");
//            $display("* Forward A: %b| Forward B: %b \n" ,ForwardA, ForwardB); 
        if(ForwardA==0)$display("* Forward A: %b" ,ForwardA);
        else if(ForwardA==1)$display("* Forward A: %b ==> Dato desde Etapa WB \n" ,ForwardA);
        else if (ForwardA==2)$display("* Forward A: %b ==> Dato desde Etapa MEM \n" ,ForwardA);
        if(ForwardB==0)$display("* Forward B: %b" ,ForwardB);
        else if(ForwardB==1)$display("* Forward B: %b ==> Dato desde Etapa WB \n" ,ForwardB);
        else if (ForwardB==2)$display("* Forward B: %b ==> Dato desde Etapa MEM \n" ,ForwardB);
        
        $display("#########################################################################################################");
        $display("######################### Contenido de Latch EX/MEM #########################");
        $display("#### Instruccion Etapa MEM: %h| ####", Latch_Ex_MEM_InstrOut);
        $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b",Latch_Ex_MEM_WriteBack_FLAGS_Out[RegWrite], Latch_Ex_MEM_WriteBack_FLAGS_Out[MemtoReg]);
        $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",Latch_Ex_MEM_Mem_FLAGS_Out[MemRead], Latch_Ex_MEM_Mem_FLAGS_Out[MemWrite]);
        $display("* Write Data: %d| E3_ALUOut: %h",Latch_Ex_MEM_ReadDataB,Latch_Ex_MEM_E3_ALUOut,);
        $display("* E3 MUX RegDst: %b| PC JALR JAL: %h| JALR JAL Flags: %b| Flag halt: %b \n",Latch_Ex_MEM_Mux,Latch_Ex_MEM_PC_JALR_JAL,Latch_Ex_MEM_flags_JALR_JAL,Latch_Ex_MEM_halt);
        
        $display("#########################################################################################################");
        $display("######################### Etapa MEM salidas #########################");
        $display("* Salida de memoria (DataOut): %h \n",E4_DataOut_to_Latch_MEM_WB);
        
        $display("#########################################################################################################");
        $display("######################### Contenido de Latch MEM/WB #########################");
        $display("#### Instruccion Etapa WB: %h| ####", Latch_MEM_WB_InstrOut);
        $display("* E4 DataOut: %d| E3_ALUOut: %h| E3 MUX RegDst: %b| WB Flag RegWrite: %b| WB Flag MemtoReg: %b",Latch_MEM_WB_DataOut, Latch_MEM_WB_ALUOut, Latch_MEM_WB_Mux, Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite],Latch_MEM_WB_WriteBack_FLAGS_Out[MemtoReg]);
        $display("* PC JALR JAL: %h| JALR JAL Flags: %b| Flag halt (FIN de programa): %b \n",Latch_MEM_WB_PC_JALR_JAL, Latch_MEM_WB_flags_JALR_JAL,Latch_MEM_WB_halt);
        
        $display("#########################################################################################################");
        $display("######################### Etapa WB salidas #########################");
        $display("* Mux WB E3_ALUout/E4_DataOut: %h| Mux E4_Mux_out/PC_JALR_JAL: %h \n", Mux_WB,Mux_WB_JALR_JAL);
        
        $display("#########################################################################################################");
        $display("######################### Se lee el banco de registros (Etapa ID) #########################");
        for(addr_instruccion=0;addr_instruccion<32;addr_instruccion=addr_instruccion+1) begin          
            Etapa_ID_posReg = addr_instruccion;
            #20;
            $display("+ Registro: %d | Dato: %h", addr_instruccion, E2_ReadDataA,"; Tiempo simulacion (ns)",$time);
        end
        
        $display("\n#########################################################################################################");
        $display("######################### Se lee la memoria de datos (Etapa MEM) #########################");
        for(addr_instruccion=0;addr_instruccion<128;addr_instruccion=addr_instruccion+4) begin          
            dirMem = addr_instruccion;
            #20;
            $display("- Direccion: %d | Dato: %h", addr_instruccion, E4_DataOut_to_Latch_MEM_WB,"; Tiempo simulacion (ns)",$time);       
        end
        
        ////################################### FIN ####################################################
        #20;// arranca la ejecucion
        Latch_Reset = 0; //  no se reinicia todos los latch
        Latch_enable = 1; // se habilita los latch
        //Etapa IF
        Etapa_IF_enable_pc = 1; //program counter habilitado
        Etapa_IF_enable_sel = 0; //no esta en modo debug
        Etapa_IF_enable_mem = 1; // se habilita la memoria de Instrucciones
        Etapa_IF_Addr_Src = 0; //se pone en 0 para indicar que las direcciones las va a dar el PC y no Etapa_IF_Addr_Instr 
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
        reset_contador_clk=0;   
        enable_count=1;
        //Flag para step
        Step_flag=1; 
    end
    
    
    always@(posedge Step) begin 
        if((Latch_enable == 1) && (~Latch_MEM_WB_halt))begin 
            Step_flag=0;
            // se detiene los Latch y el PC
            Latch_enable=0;
            /// Se detiene el contador de ciclos
            enable_count=0;

            #20;
            $display("\n################################## CICLO NUMERO: %d #############################################\n",count);
            
            $display("#########################################################################################################");
            $display("######################### Etapa IF salidas #########################");
            $display("* E1_Instr: %h| PC: %h",E1_InstrOut, PC_Out);
            $display("* E1 AddOut: %h| Unidad halt: %b| Stall or Halt: %b \n", E1_AddOut, halt, stall_or_halt);
            
            $display("#########################################################################################################");
            $display("######################### Contenido de Latch IF/ID #########################");
            $display("#### Instruccion Etapa ID: %h| ####", Latch_IF_ID_InstrOut);
            $display("* Adder Out: %h| InstrOut: %h| Flag halt: %b \n",Latch_IF_ID_Adder_Out, Latch_IF_ID_InstrOut,Latch_IF_ID_halt);
            
            $display("#########################################################################################################");
            $display("######################### Etapa ID salidas #########################"); //{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
            $display("* Read DataA: %d| Read DataB: %d| Operaciones Inmediatos InmCtrl: %b| Sign Extend: %h", E2_ReadDataA, E2_ReadDataB, E2_InmCtrl, SignExtendOut);
            $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b", ControlFLAGS[7], ControlFLAGS[6]);
            $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",ControlFLAGS[5],ControlFLAGS[4]);
            $display("* FLAG EX RegDst: %b| FLAG EX ALUSrc: %b| FLAG EX ALUOp1: %b| FLAG EX ALUOp0: %b",ControlFLAGS[3],ControlFLAGS[2],ControlFLAGS[1],ControlFLAGS[0]);
            $display("* PC JALR JAL (PC+8): %h| Mux JAL Rd (dir retorno): %b \n", ADDER_E2_PC_JALR_JAL, E2_Rd_mux);
            
            $display("=========================================================================================================");
            $display("#### Unidad de Saltos ####");
            $display("#### Entradas ####");
            $display("* BranchEQ: %b| BranchNE: %b| JR: %b| JALR: %b| Jmp: %b| JAL: %b ",flags_branch_jump[BranchEQ],flags_branch_jump[BranchNE],flags_branch_jump[JR],flags_branch_jump[JALR],flags_branch_jump[Jmp],flags_branch_jump[JAL]);
            $display("* Read DataA: %d| Read DataB: %d",E2_ReadDataA,E2_ReadDataB);
            $display("* Adder Etapa IF: %h| Instr Index (J y JAL): %h", Latch_IF_ID_Adder_Out, Latch_IF_ID_InstrOut[25:0]);
            $display("#### Salida ####");
            $display("* PC branch/jump: %h| Flag de salto tomado: %b \n",E2_PC_salto, E2_salto);
            
            $display("=========================================================================================================");
            $display("#### Unidad de Deteccion de Riesgos ####");
            $display("#### Entradas ####");
            $display("* Latch IF/ID out Rs: %b| Latch IF/ID out Rt: %b", Latch_IF_ID_InstrOut[25:21], Latch_IF_ID_InstrOut[20:16]);
            $display("* Latch ID/EX out Rt: %b| Latch ID/EX Flag MemRead: %b", Latch_ID_Ex_InstrOut_20_16_Rt,Latch_ID_Ex_Mem_FLAGS[MemRead]);
            $display("#### Salidas ####");
            $display("* Stall: %b \n" ,Stall);    
            
            $display("#########################################################################################################");
            $display("######################### Contenido de Latch ID/EX #########################");
            $display("#### Instruccion Etapa EX: %h| ####", Latch_ID_Ex_InstrOut);
            $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b",Latch_ID_Ex_WriteBack_FLAGS[RegWrite], Latch_ID_Ex_WriteBack_FLAGS[MemtoReg]);
            $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",Latch_ID_Ex_Mem_FLAGS[MemRead], Latch_ID_Ex_Mem_FLAGS[MemWrite]);
            $display("* FLAG EX RegDst: %b| FLAG EX ALUSrc: %b| FLAG EX ALUOp1: %b| FLAG EX ALUOp0: %b",Latch_ID_Ex_FLAGS[RegDst] , Latch_ID_Ex_FLAGS[ALUSrc], Latch_ID_Ex_FLAGS[ALUOp1], Latch_ID_Ex_FLAGS[ALUOp0]);
            $display("* InmCtrl: %b", Latch_ID_Ex_InmCtrl);
            $display("* Read DataA: %d| Read DataB: %d| Sign Extend: %h| Flag halt: %b",Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB,Latch_ID_Ex_SignExtendOut,Latch_ID_Ex_halt);
            $display("* InstrOut Rs: %b| InstrOut Rt: %b| InstrOut Rd: %b",Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd);
            $display("* PC JALR JAL: %h| JALR JAL Flags: %b \n",Latch_ID_Ex_PC_JALR_JAL,Latch_ID_Ex_flags_JALR_JAL);
            
            $display("#########################################################################################################");
            $display("######################### Etapa EX salidas #########################");
            $display("* E3_ALUOut: %h| Mux Rt/Rd: %b| Dato a escribir MEM: %h \n",E3_ALUOut, E3_MuxOut, MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB);
            
            $display("=========================================================================================================");
            $display("#### Unidad de Cortocircuito ####");
            $display("#### Entradas ####");
            $display("* Latch ID/EX Rs: %b| Latch ID/EX Rt: %b",Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt);
            $display("* Latch EX/MEM Rd: %b| Latch EX/MEM Flag RegWrite: %b", Latch_Ex_MEM_Mux, Latch_Ex_MEM_WriteBack_FLAGS_Out[RegWrite]);
            $display("* Latch MEM/WB Rd: %b| Latch MEM/WB Flag RegWrite: %b", Latch_MEM_WB_Mux, Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite]);
            $display("#### Salidas ####");
//            $display("* Forward A: %b| Forward B: %b \n" ,ForwardA, ForwardB); 
            if(ForwardA==0)$display("* Forward A: %b" ,ForwardA);
            else if(ForwardA==1)$display("* Forward A: %b ==> Dato desde Etapa WB \n" ,ForwardA);
            else if (ForwardA==2)$display("* Forward A: %b ==> Dato desde Etapa MEM \n" ,ForwardA);
            if(ForwardB==0)$display("* Forward B: %b" ,ForwardB);
            else if(ForwardB==1)$display("* Forward B: %b ==> Dato desde Etapa WB \n" ,ForwardB);
            else if (ForwardB==2)$display("* Forward B: %b ==> Dato desde Etapa MEM \n" ,ForwardB);
            
            $display("#########################################################################################################");
            $display("######################### Contenido de Latch EX/MEM #########################");
            $display("#### Instruccion Etapa MEM: %h| ####", Latch_Ex_MEM_InstrOut);
            $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b",Latch_Ex_MEM_WriteBack_FLAGS_Out[RegWrite], Latch_Ex_MEM_WriteBack_FLAGS_Out[MemtoReg]);
            $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",Latch_Ex_MEM_Mem_FLAGS_Out[MemRead], Latch_Ex_MEM_Mem_FLAGS_Out[MemWrite]);
            $display("* Write Data: %d| E3_ALUOut: %h",Latch_Ex_MEM_ReadDataB,Latch_Ex_MEM_E3_ALUOut,);
            $display("* E3 MUX RegDst: %b| PC JALR JAL: %h| JALR JAL Flags: %b| Flag halt: %b \n",Latch_Ex_MEM_Mux,Latch_Ex_MEM_PC_JALR_JAL,Latch_Ex_MEM_flags_JALR_JAL,Latch_Ex_MEM_halt);
            
            $display("#########################################################################################################");
            $display("######################### Etapa MEM salidas #########################");
            $display("* Salida de memoria (DataOut): %h \n",E4_DataOut_to_Latch_MEM_WB);
            
            $display("#########################################################################################################");
            $display("######################### Contenido de Latch MEM/WB #########################");
            $display("#### Instruccion Etapa WB: %h| ####", Latch_MEM_WB_InstrOut);
            $display("* E4 DataOut: %d| E3_ALUOut: %h| E3 MUX RegDst: %b| WB Flag RegWrite: %b| WB Flag MemtoReg: %b",Latch_MEM_WB_DataOut, Latch_MEM_WB_ALUOut, Latch_MEM_WB_Mux, Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite],Latch_MEM_WB_WriteBack_FLAGS_Out[MemtoReg]);
            $display("* PC JALR JAL: %h| JALR JAL Flags: %b| Flag halt (FIN de programa): %b \n",Latch_MEM_WB_PC_JALR_JAL, Latch_MEM_WB_flags_JALR_JAL,Latch_MEM_WB_halt);
            
            $display("#########################################################################################################");
            $display("######################### Etapa WB salidas #########################");
            $display("* Mux WB E3_ALUout/E4_DataOut: %h| Mux E4_Mux_out/PC_JALR_JAL: %h \n", Mux_WB,Mux_WB_JALR_JAL);
            
            /// Control de señales para leer registros y memoria
            //Etapa ID
            Etapa_ID_posReg = 5'b0000; // direcciones a recorrer 
            Etapa_ID_posSel = 1; //esta en modo debug

            $display("#########################################################################################################");
            $display("######################### Se lee el banco de registros (Etapa ID) #########################");
            
            for(addr_instruccion=0;addr_instruccion<10;addr_instruccion=addr_instruccion+1) begin          
               Etapa_ID_posReg = addr_instruccion;
               #20;
               $display("+ Registro: %d | Dato: %h", addr_instruccion, E2_ReadDataA,"; Tiempo simulacion (ns)",$time);
            end
            
            //Etapa MEM    
            memDebug = 1; //esta en modo debug 
            dirMem = 32'h00000000; // direcciones a recorrer 
            #20;
            $display("\n#########################################################################################################");
            $display("######################### Se lee la memoria de datos (Etapa MEM) #########################");
            for(addr_instruccion=0;addr_instruccion<36;addr_instruccion=addr_instruccion+4) begin          
               dirMem = addr_instruccion;
               #40;
               $display("- Direccion: %d | Dato: %h", addr_instruccion, E4_DataOut_to_Latch_MEM_WB,"; Tiempo simulacion (ns)",$time);       
            end
            
            //Etapa ID
            Etapa_ID_posReg = 5'b0000; // direcciones a recorrer 
            Etapa_ID_posSel = 0; //no esta en modo debug
            //Etapa MEM
            dirMem = 32'h00000000; // direcciones a recorrer     
            memDebug = 0; //no esta en modo debug
            #20;
            Latch_enable=1;
            Step_flag=1;
            enable_count=1;
            
            end 
    end 
    
    always@(posedge Latch_MEM_WB_halt) begin
        Latch_enable=0;
        enable_count=0;
        //Etapa ID
        Etapa_ID_posReg = 5'b0000; // direcciones a recorrer 
        Etapa_ID_posSel = 1; //esta en modo debug
        //Etapa MEM
        dirMem = 32'h00000000; // direcciones a recorrer     
        memDebug = 1; //esta en modo debug 
        enable_count=0;
        
        $display("\n################################## CICLO NUMERO: %d #############################################\n",count);
                    
        $display("#########################################################################################################");
        $display("######################### Etapa IF salidas #########################");
        $display("* E1_Instr: %h| PC: %h",E1_InstrOut, PC_Out);
        $display("* E1 AddOut: %h| Unidad halt: %b| Stall or Halt: %b \n", E1_AddOut, halt, stall_or_halt);
        
        $display("#########################################################################################################");
        $display("######################### Contenido de Latch IF/ID #########################");
        $display("#### Instruccion Etapa ID: %h| ####", Latch_IF_ID_InstrOut);
        $display("* Adder Out: %h| InstrOut: %h| Flag halt: %b \n",Latch_IF_ID_Adder_Out, Latch_IF_ID_InstrOut,Latch_IF_ID_halt);
        
        $display("#########################################################################################################");
        $display("######################### Etapa ID salidas #########################"); //{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
        $display("* Read DataA: %d| Read DataB: %d| Operaciones Inmediatos InmCtrl: %b| Sign Extend: %h", E2_ReadDataA, E2_ReadDataB, E2_InmCtrl, SignExtendOut);
        $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b", ControlFLAGS[7], ControlFLAGS[6]);
        $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",ControlFLAGS[5],ControlFLAGS[4]);
        $display("* FLAG EX RegDst: %b| FLAG EX ALUSrc: %b| FLAG EX ALUOp1: %b| FLAG EX ALUOp0: %b",ControlFLAGS[3],ControlFLAGS[2],ControlFLAGS[1],ControlFLAGS[0]);
        $display("* PC JALR JAL (PC+8): %h| Mux JAL Rd (dir retorno): %b \n", ADDER_E2_PC_JALR_JAL, E2_Rd_mux);
        
        $display("=========================================================================================================");
        $display("#### Unidad de Saltos ####");
        $display("#### Entradas ####");
        $display("* BranchEQ: %b| BranchNE: %b| JR: %b| JALR: %b| Jmp: %b| JAL: %b ",flags_branch_jump[BranchEQ],flags_branch_jump[BranchNE],flags_branch_jump[JR],flags_branch_jump[JALR],flags_branch_jump[Jmp],flags_branch_jump[JAL]);
        $display("* Read DataA: %d| Read DataB: %d",E2_ReadDataA,E2_ReadDataB);
        $display("* Adder Etapa IF: %h| Instr Index (J y JAL): %h", Latch_IF_ID_Adder_Out, Latch_IF_ID_InstrOut[25:0]);
        $display("#### Salida ####");
        $display("* PC branch/jump: %h| Flag de salto tomado: %b \n",E2_PC_salto, E2_salto);
        
        $display("=========================================================================================================");
        $display("#### Unidad de Deteccion de Riesgos ####");
        $display("#### Entradas ####");
        $display("* Latch IF/ID out Rs: %b| Latch IF/ID out Rt: %b", Latch_IF_ID_InstrOut[25:21], Latch_IF_ID_InstrOut[20:16]);
        $display("* Latch ID/EX out Rt: %b| Latch ID/EX Flag MemRead: %b", Latch_ID_Ex_InstrOut_20_16_Rt,Latch_ID_Ex_Mem_FLAGS[MemRead]);
        $display("#### Salidas ####");
        $display("* Stall: %b \n" ,Stall);    
        
        $display("#########################################################################################################");
        $display("######################### Contenido de Latch ID/EX #########################"); 
        $display("#### Instruccion Etapa EX: %h| ####", Latch_ID_Ex_InstrOut);
        $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b",Latch_ID_Ex_WriteBack_FLAGS[RegWrite], Latch_ID_Ex_WriteBack_FLAGS[MemtoReg]);
        $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",Latch_ID_Ex_Mem_FLAGS[MemRead], Latch_ID_Ex_Mem_FLAGS[MemWrite]);
        $display("* FLAG EX RegDst: %b| FLAG EX ALUSrc: %b| FLAG EX ALUOp1: %b| FLAG EX ALUOp0: %b",Latch_ID_Ex_FLAGS[RegDst] , Latch_ID_Ex_FLAGS[ALUSrc], Latch_ID_Ex_FLAGS[ALUOp1], Latch_ID_Ex_FLAGS[ALUOp0]);
        $display("* InmCtrl: %b", Latch_ID_Ex_InmCtrl);
        $display("* Read DataA: %d| Read DataB: %d| Sign Extend: %h| Flag halt: %b",Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB,Latch_ID_Ex_SignExtendOut,Latch_ID_Ex_halt);
        $display("* InstrOut Rs: %b| InstrOut Rt: %b| InstrOut Rd: %b",Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd);
        $display("* PC JALR JAL: %h| JALR JAL Flags: %b \n",Latch_ID_Ex_PC_JALR_JAL,Latch_ID_Ex_flags_JALR_JAL);
        
        $display("#########################################################################################################");
        $display("######################### Etapa EX salidas #########################");
        $display("* E3_ALUOut: %h| Mux Rt/Rd: %b| Dato a escribir MEM: %h \n",E3_ALUOut, E3_MuxOut, MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB);
        
        $display("=========================================================================================================");
        $display("#### Unidad de Cortocircuito ####");
        $display("#### Entradas ####");
        $display("* Latch ID/EX Rs: %b| Latch ID/EX Rt: %b",Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt);
        $display("* Latch EX/MEM Rd: %b| Latch EX/MEM Flag RegWrite: %b", Latch_Ex_MEM_Mux, Latch_Ex_MEM_WriteBack_FLAGS_Out[RegWrite]);
        $display("* Latch MEM/WB Rd: %b| Latch MEM/WB Flag RegWrite: %b", Latch_MEM_WB_Mux, Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite]);
        $display("#### Salidas ####");
//            $display("* Forward A: %b| Forward B: %b \n" ,ForwardA, ForwardB); 
        if(ForwardA==0)$display("* Forward A: %b" ,ForwardA);
        else if(ForwardA==1)$display("* Forward A: %b ==> Dato desde Etapa WB \n" ,ForwardA);
        else if (ForwardA==2)$display("* Forward A: %b ==> Dato desde Etapa MEM \n" ,ForwardA);
        if(ForwardB==0)$display("* Forward B: %b" ,ForwardB);
        else if(ForwardB==1)$display("* Forward B: %b ==> Dato desde Etapa WB \n" ,ForwardB);
        else if (ForwardB==2)$display("* Forward B: %b ==> Dato desde Etapa MEM \n" ,ForwardB);
        
        $display("#########################################################################################################");
        $display("######################### Contenido de Latch EX/MEM #########################");
        $display("#### Instruccion Etapa MEM: %h| ####", Latch_Ex_MEM_InstrOut);
        $display("* FLAG WB RegWrite: %b| FLAG WB MemtoReg: %b",Latch_Ex_MEM_WriteBack_FLAGS_Out[RegWrite], Latch_Ex_MEM_WriteBack_FLAGS_Out[MemtoReg]);
        $display("* FLAG MEM MemRead: %b| FLAG MEM MemWrite: %b",Latch_Ex_MEM_Mem_FLAGS_Out[MemRead], Latch_Ex_MEM_Mem_FLAGS_Out[MemWrite]);
        $display("* Write Data: %d| E3_ALUOut: %h",Latch_Ex_MEM_ReadDataB,Latch_Ex_MEM_E3_ALUOut,);
        $display("* E3 MUX RegDst: %b| PC JALR JAL: %h| JALR JAL Flags: %b| Flag halt: %b \n",Latch_Ex_MEM_Mux,Latch_Ex_MEM_PC_JALR_JAL,Latch_Ex_MEM_flags_JALR_JAL,Latch_Ex_MEM_halt);
        
        $display("#########################################################################################################");
        $display("######################### Etapa MEM salidas #########################");
        $display("* Salida de memoria (DataOut): %h \n",E4_DataOut_to_Latch_MEM_WB);
        
        $display("#########################################################################################################");
        $display("######################### Contenido de Latch MEM/WB #########################");
        $display("#### Instruccion Etapa WB: %h| ####", Latch_MEM_WB_InstrOut);
        $display("* E4 DataOut: %d| E3_ALUOut: %h| E3 MUX RegDst: %b| WB Flag RegWrite: %b| WB Flag MemtoReg: %b",Latch_MEM_WB_DataOut, Latch_MEM_WB_ALUOut, Latch_MEM_WB_Mux, Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite],Latch_MEM_WB_WriteBack_FLAGS_Out[MemtoReg]);
        $display("* PC JALR JAL: %h| JALR JAL Flags: %b| Flag halt (FIN de programa): %b \n",Latch_MEM_WB_PC_JALR_JAL, Latch_MEM_WB_flags_JALR_JAL,Latch_MEM_WB_halt);
        
        $display("#########################################################################################################");
        $display("######################### Etapa WB salidas #########################");
        $display("* Mux WB E3_ALUout/E4_DataOut: %h| Mux E4_Mux_out/PC_JALR_JAL: %h \n", Mux_WB,Mux_WB_JALR_JAL);
        
        #20;
        $display("#########################################################################################################");
        $display("######################### Se lee el banco de registros (Etapa ID) #########################");
        for(addr_instruccion=0;addr_instruccion<32;addr_instruccion=addr_instruccion+1) begin          
           Etapa_ID_posReg = addr_instruccion;
           #20;
           $display("+ Registro: %d | Dato: %h", addr_instruccion, E2_ReadDataA,"; Tiempo simulacion (ns)",$time);
        end
        
        $display("\n#########################################################################################################");
        $display("######################### Se lee la memoria de datos (Etapa MEM) #########################");
        for(addr_instruccion=0;addr_instruccion<128;addr_instruccion=addr_instruccion+4) begin          
           dirMem = addr_instruccion;
           #20;
           $display("- Direccion: %d | Dato: %h", addr_instruccion, E4_DataOut_to_Latch_MEM_WB,"; Tiempo simulacion (ns)",$time);       
        end
        
        $display("\n#### Fin de Ejecucion del programa ####\n");
        Latch_enable=1;
        enable_count=1;
        //Etapa ID
        Etapa_ID_posReg = 5'b0000; // direcciones a recorrer 
        Etapa_ID_posSel = 0; //no esta en modo debug
        //Etapa MEM
        dirMem = 32'h00000000; // direcciones a recorrer     
        memDebug = 0; //no esta en modo debug
        
         
    end
    
    always @(posedge Clk)begin //simula señal de paso
        if(Step_flag)Step=~Step;
    end 
    
    always begin //clock de la placa 50Mhz
        #10 Clk=~Clk;
    end 
    
endmodule
