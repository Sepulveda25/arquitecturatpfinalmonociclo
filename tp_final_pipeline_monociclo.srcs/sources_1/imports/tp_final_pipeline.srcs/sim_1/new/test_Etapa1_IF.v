`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2019 00:17:05
// Design Name: 
// Module Name: test_Etapa1_IF
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


module test_Etapa1_IF;

    // Inputs
    reg Clk; 
    reg Reset; 
    reg [31:0] InputB_MUX; 
    reg PCScr; 
    reg Stall; 
    reg enable_pc;
    reg enable_sel;
    reg [31:0] Instr_in;
    reg enable_mem;
    reg [3:0] write_enable;
    reg [31:0] Addr_Instr;
    reg Addr_Src;
    reg pc_reset;
	// Outputs
	wire [31:0] E1_AddOut; 
    wire [31:0] E1_InstrOut; 
    wire [31:0] PC_Out;

	// Instantiate the Unit Under Test (UUT)
	Etapa1_IF uut (
		.Clk(Clk), 
        .Reset(Reset), 
        .InputB_MUX(InputB_MUX), 
        .PCScr(PCScr), 
        .Stall(Stall), 
        .enable_pc(enable_pc),
        .enable_sel(enable_sel),
        .Instr_in(Instr_in),
        .enable_mem(enable_mem),
        .write_enable(write_enable),
        .Addr_Instr(Addr_Instr),
        .Addr_Src(Addr_Src),
        .pc_reset(pc_reset),
        .E1_AddOut(E1_AddOut), 
        .E1_InstrOut(E1_InstrOut), 
        .PC_Out(PC_Out)
	);
    
    initial begin
        // Initialize Inputs
        Clk = 1;
        Reset = 1;
        pc_reset=1;
        InputB_MUX = 32'h00000000; // address branch
        PCScr = 0; 
        Stall = 0; 
        enable_pc = 0;
        enable_sel = 0;
        Instr_in = 32'h00000000;
        enable_mem = 0;
        write_enable = 4'b0000;
        Addr_Instr = 32'h00000000;
        Addr_Src = 0;
        #20;
        // addi r1 r1 0x3 ; Hex: 0x20210003
        Reset = 0;
        InputB_MUX = 32'h00000000; // address branch
        PCScr = 0; // no hay branch
        Stall = 0; // no se detecto peligros
        enable_pc = 0; // se deshabilita el modulo PC
        enable_sel = 0; // no hay debug entonces se selecciona de entrada Stall
        Instr_in = 32'h00000000; // no hay datos para grabar en memoria
        enable_mem = 0; // no hay datos para grabar en memoria
        write_enable = 4'b0000; // no hay datos para grabar en memoria
        Addr_Instr = 32'h00000000; // no hay datos para grabar en memoria
        Addr_Src = 0; // como no se graba la memoria se selecciona de address de la salida PC
        #20
        enable_mem = 1; // se habilita la memoria un ciclo antes
        write_enable = 4'b1111; // se arranca un ciclo antes la señal para grabar memoria
        #20;
        // grabado de 4 instrucciones en memoria
        // addi r1 r1 0x3 ; Hex: 0x20210003
        // addi r2 r2 0x7 ; Hex: 0x20420007
        // add r3 r1 r2  ; Hex: 0x00221820
        // halt ; Hex: 0x00000000
        Reset = 0;
        pc_reset=1;
        InputB_MUX = 32'h00000000; // address branch
        PCScr = 0; // no hay branch
        Stall = 0; // no se detecto peligros
        enable_pc = 0; // se deshabilita el modulo PC
        enable_sel = 1; // esta en modo debug se selecciona de entrada enable
        Instr_in = 32'h20210003; // 1° intruccion para grabar en memoria addi r1 r1 0x3
        enable_mem = 1; // hay datos para grabar en memoria
        write_enable = 4'b1111; // datos para grabar en memoria se graba todos los bytes
        Addr_Instr = 32'h00000000; // direccion de memoria de la 1° instruccion
        Addr_Src = 1; // se selecciona como direccion lo enviado por el debug
        #20;
        //segunda instruccion
        InputB_MUX = 32'h00000000; // address branch
        PCScr = 0; // no hay branch
        Stall = 0; // no se detecto peligros
        enable_pc = 0; // se deshabilita el modulo PC
        enable_sel = 1; // esta en modo debug se selecciona de entrada enable
        Instr_in = 32'h20420007; // 2° intruccion para grabar en memoria addi r2 r2 0x7
        enable_mem = 1; // hay datos para grabar en memoria
        write_enable = 4'b1111; // datos para grabar en memoria se graba todos los bytes
        Addr_Instr = 32'h00000004; // direccion de memoria de la 2° instruccion
        Addr_Src = 1; // se selecciona como direccion lo enviado por el debug 
        #20;
        //tercera instruccion
        InputB_MUX = 32'h00000000; // address branch
        PCScr = 0; // no hay branch
        Stall = 0; // no se detecto peligros
        enable_pc = 0; // se deshabilita el modulo PC
        enable_sel = 1; // esta en modo debug se selecciona de entrada enable
        Instr_in = 32'h00221820; // 3° intruccion para grabar en memoria add r3 r1 r2
        enable_mem = 1; // hay datos para grabar en memoria
        write_enable = 4'b1111; // datos para grabar en memoria se graba todos los bytes
        Addr_Instr = 32'h00000008; // direccion de memoria de la 3° instruccion
        Addr_Src = 1; // se selecciona como direccion lo enviado por el debug
        #20;
        //cuarta instruccion
        InputB_MUX = 32'h00000000; // address branch
        PCScr = 0; // no hay branch
        Stall = 0; // no se detecto peligros
        enable_pc = 0; // se deshabilita el modulo PC
        enable_sel = 1; // esta en modo debug se selecciona de entrada enable
        Instr_in = 32'h00000000; // 4° intruccion para grabar en memoria add r3 r1 r2
        enable_mem = 1; // hay datos para grabar en memoria
        write_enable = 4'b1111; // datos para grabar en memoria se graba todos los bytes
        Addr_Instr = 32'h0000000c; // direccion de memoria de la 4° instruccion
        Addr_Src = 1; // se selecciona como direccion lo enviado por el debug
//        #20;
//        write_enable = 4'b0000; // Se espera un ciclo antes de comenzar a leer la memoria
        #20; 
        // Arranque del modulo. Se comienzan a leer la instrucciones
        pc_reset=0;
        InputB_MUX = 32'h00000000; // address branch
        PCScr = 0; // no hay branch
        Stall = 0; // no se detecto peligros
        enable_pc = 1; // se habilita el PC
        enable_sel = 0; // no hay debug entonces se selecciona de entrada Stall
        Instr_in = 32'h00000000; // no hay datos para grabar en memoria
        enable_mem = 1; // no hay datos para grabar en memoria
        write_enable = 4'b0000; // no hay datos para grabar en memoria
        Addr_Instr = 32'h00000000; // no hay datos para grabar en memoria
        Addr_Src = 0; // como no se graba la memoria se selecciona de address de la salida PC
                    
    end
    
   always begin //clock de la placa 50Mhz
        #10 Clk=~Clk;
   end 
    
endmodule
