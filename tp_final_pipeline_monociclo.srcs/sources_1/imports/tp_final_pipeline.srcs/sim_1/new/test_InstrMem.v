`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2019 14:24:50
// Design Name: 
// Module Name: test_InstrMem
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


module test_InstrMem;

    // Inputs
    reg [31:0] addra; 
	reg clka;
	reg [31:0] dina; 
    reg ena;
    reg rsta; 
    reg [3:0] wea; 
	// Outputs
	wire [31:0] douta;

	// Instantiate the Unit Under Test (UUT)
	Instruction_memory uut (
		.addra(addra), 
		.clka(clka),
		.dina(dina),
		.ena(ena),
		.rsta(rsta),
		.wea(wea),
		.douta(douta)
	);
    
    initial begin
        // Initialize Inputs
        clka = 1;
        addra = 32'h00000000; 
        dina = 32'h00000000; 
        ena = 0;
        rsta = 0; 
        wea = 4'b0000;
        #20; // rsta = 1; todavia no escribe 
        addra = 32'h00000000; 
        dina = 32'h00000000; 
        ena = 0;
        rsta = 1; 
        wea = 4'b0000;
        #20; // rsta = 0; ena = 1; todavia no escribe
        addra = 32'h00000000; 
        dina = 32'h00000001; 
        ena = 1;
        rsta = 0; 
        wea = 4'b1111;
        // comienza la escritura
        #20; // rsta = 0; ena = 1; escribe direccion 0
        addra = 32'h00000000; 
        dina = 32'h00000001; 
        ena = 1;
        rsta = 0; 
        wea = 4'b1111;
        #20; // rsta = 0; ena = 1; escribe direccion 4
        addra = 32'h00000004; 
        dina = 32'h00000002; 
        ena = 1;
        rsta = 0; 
        wea = 4'b1111;
        #20; // rsta = 0; ena = 1; escribe direccion 8
        addra = 32'h00000008; 
        dina = 32'h00000003; 
        ena = 1;
        rsta = 0; 
        wea = 4'b1111;
        #20
        wea = 4'b0000; // se espera un ciclo antes de comenzar a leer
        #20; // rsta = 0; ena = 1; lee direccion 0
        addra = 32'h00000000; 
        dina = 32'h00000000; 
        ena = 1;
        rsta = 0; 
        wea = 4'b0000;
        #20; // rsta = 0; ena = 1; lee direccion 4
        addra = 32'h00000004; 
        dina = 32'h00000000; 
        ena = 1;
        rsta = 0; 
        wea = 4'b0000;  
        #20; // rsta = 0; ena = 1; lee direccion 8
        addra = 32'h00000008; 
        dina = 32'h00000000; 
        ena = 1;
        rsta = 0; 
        wea = 4'b0000;       
    end
    
   always begin //clock de la placa 50Mhz
        #10 clka=~clka;
    end   

endmodule
