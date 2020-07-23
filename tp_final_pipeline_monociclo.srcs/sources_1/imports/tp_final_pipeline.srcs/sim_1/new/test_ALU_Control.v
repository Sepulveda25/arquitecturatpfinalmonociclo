`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2019 21:07:31
// Design Name: 
// Module Name: test_ALU_Control
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


module test_ALU_Control;

    // Inputs
    reg Clk;
    reg Reset;
    reg [1:0] Ex_FLAGS_ALUOp;
    reg [5:0] Func;
    reg [4:0] ShiftIn;   
    reg [2:0] InmCtrl;
	// Outputs
	wire [4:0] Shift;
    wire [5:0] ALU_Control_Out;
    
    // Instantiate the Unit Under Test (UUT)
    ALU_Control uut (
        .Clk(Clk), 
       // .Reset(Reset),
        .Ex_FLAGS_ALUOp(Ex_FLAGS_ALUOp),
        .Func(Func),
        .ShiftIn(ShiftIn),
        .InmCtrl(InmCtrl),
        .Shift(Shift),
        .ALU_Control_Out(ALU_Control_Out)
    );


    initial begin
        // Initialize Inputs
        Clk=1;
        Reset=1;
        Ex_FLAGS_ALUOp=2'b00;
        Func=6'b000000;
        ShiftIn=5'b00000;   
        InmCtrl=3'b000;
        #20; //Suma para LW: rt ? memory[rs+inm] o ST: memory[rs+inm] ? rt
        Reset=0;
        Ex_FLAGS_ALUOp=2'b00;
        Func=6'b000000;
        ShiftIn=5'b00000;   
        InmCtrl=3'b000; //bits para seleccionar el tipo de operacion inmediata
        #20; //Resta para BEQ. Si (rs = rt) se ejecuta branch. Se activa flag Zero
        Ex_FLAGS_ALUOp=2'b01;
        Func=6'b000000; // no importa 
        ShiftIn=5'b00000; // no importa   
        InmCtrl=3'b000; //bits para seleccionar el tipo de operacion inmediata
        #20; //Es una R-type y el codigo de funcion pasa directo
        Ex_FLAGS_ALUOp=2'b10;
        Func=6'b100100; //operacion AND
        ShiftIn=5'b00000; // como AND es una operacion and shamt es 0  
        InmCtrl=3'b000; //bits para seleccionar el tipo de operacion inmediata
        #20;//Immediate
        Ex_FLAGS_ALUOp=2'b11;
        Func=6'b000000; // no importa 
        ShiftIn=5'b00000; // no importa    
        InmCtrl=3'b000; //ADDI
        #20;//Immediate
        Func=6'b000000; // no importa 
        ShiftIn=5'b00000; // no importa  
        InmCtrl=3'b100; //ANDI
        #20;//Immediate
        Func=6'b000000; // no importa 
        ShiftIn=5'b00000; // no importa  
        InmCtrl=3'b101; //ORI
        #20;//Immediate
        Func=6'b000000; // no importa 
        ShiftIn=5'b00000; // no importa  
        InmCtrl=3'b110; //XORI
        #20;//Immediate
        Func=6'b000000; // no importa 
        ShiftIn=5'b00000; // no importa  
        InmCtrl=3'b010; //SLIT
        #20;//Immediate
        Func=6'b000000; // no importa 
        ShiftIn=5'b00000; // no importa  
        InmCtrl=3'b111; //LUI
    end
    
   always begin //clock de la placa 50Mhz
        #10 Clk=~Clk;
    end  
endmodule
