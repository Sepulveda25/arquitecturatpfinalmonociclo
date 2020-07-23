`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2019 18:09:11
// Design Name: 
// Module Name: test_unidad_de_cortocircuito
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
module test_unidad_de_cortocircuito;

	// Inputs
	reg [4:0] Latch_ID_EX_RS;
    reg [4:0] Latch_ID_EX_RT;
    reg [4:0] Latch_EX_MEM_MUX;
    reg [4:0] Latch_MEM_WB_MUX;
    reg Latch_Ex_MEM_WriteBack_FLAGS_Out;
    reg Latch_MEM_WB_WriteBack_FLAGS_Out;
	// Outputs
	wire [1:0] ForwardA;
    wire [1:0] ForwardB;

	// Instantiate the Unit Under Test (UUT)
	unidad_de_cortocircuito uut (
		.Latch_ID_EX_RS(Latch_ID_EX_RS), 
		.Latch_ID_EX_RT(Latch_ID_EX_RT), 
		.Latch_EX_MEM_MUX(Latch_EX_MEM_MUX),
		.Latch_MEM_WB_MUX(Latch_MEM_WB_MUX),
		.Latch_Ex_MEM_WriteBack_FLAGS_Out(Latch_Ex_MEM_WriteBack_FLAGS_Out),
		.Latch_MEM_WB_WriteBack_FLAGS_Out(Latch_MEM_WB_WriteBack_FLAGS_Out),
		.ForwardA(ForwardA), 
		.ForwardB(ForwardB)
	);

	initial begin
	    // ADD r1, r2, r3 #etapa MEM
	    // AND r4, r5, r6 #etapa EX
	    // ForwardA=2'b00
	    // ForwardB=2'b00
        Latch_ID_EX_RS=5'b00101;//r5
        Latch_ID_EX_RT=5'b00110;//r6
        Latch_EX_MEM_MUX=5'b00001;//rd.EX/MEM
        Latch_MEM_WB_MUX=5'b00000;//rd.MEM/WB
        Latch_Ex_MEM_WriteBack_FLAGS_Out=1;
        Latch_MEM_WB_WriteBack_FLAGS_Out=0;
        #10;
        // ADD r1, r2, r3 #etapa MEM
        // AND r4, r1, r6 #etapa EX
        // ForwardA=2'b10
        // ForwardB=2'b00
        Latch_ID_EX_RS=5'b00001;//r1
        Latch_ID_EX_RT=5'b00110;//r6
        Latch_EX_MEM_MUX=5'b00001;//rd.EX/MEM
        Latch_MEM_WB_MUX=5'b00000;//rd.MEM/WB
        Latch_Ex_MEM_WriteBack_FLAGS_Out=1;
        Latch_MEM_WB_WriteBack_FLAGS_Out=0;
        #10;
        // ADD r1, r2, r3 #etapa MEM
        // AND r4, r5, r1 #etapa EX
        // ForwardA=2'b00
        // ForwardB=2'b10
        Latch_ID_EX_RS=5'b00101;//r5
        Latch_ID_EX_RT=5'b00001;//r1
        Latch_EX_MEM_MUX=5'b00001;//rd.EX/MEM
        Latch_MEM_WB_MUX=5'b00000;//rd.MEM/WB
        Latch_Ex_MEM_WriteBack_FLAGS_Out=1;
        Latch_MEM_WB_WriteBack_FLAGS_Out=0;
        #10;
        // ADD r1, r2, r3 #etapa WB
        // AND r4, r5, r6 #etapa MEM
        // SUB r7, r1, r9 #etapa EX
        // ForwardA=2'b01
        // ForwardB=2'b00
        Latch_ID_EX_RS=5'b00001;//r1
        Latch_ID_EX_RT=5'b01001;//r9
        Latch_EX_MEM_MUX=5'b00110;//rd.EX/MEM
        Latch_MEM_WB_MUX=5'b00001;//rd.MEM/WB
        Latch_Ex_MEM_WriteBack_FLAGS_Out=1;
        Latch_MEM_WB_WriteBack_FLAGS_Out=1;
        #10;
        // ADD r1, r2, r3 #etapa WB
        // AND r4, r5, r6 #etapa MEM
        // SUB r7, r8, r1 #etapa EX
        // ForwardA=2'b00
        // ForwardB=2'b01
        Latch_ID_EX_RS=5'b01000;//r8
        Latch_ID_EX_RT=5'b00001;//r1
        Latch_EX_MEM_MUX=5'b00100;//rd.EX/MEM
        Latch_MEM_WB_MUX=5'b00001;//rd.MEM/WB
        Latch_Ex_MEM_WriteBack_FLAGS_Out=1;
        Latch_MEM_WB_WriteBack_FLAGS_Out=1;
        #10;
        // ADD r1, r2, r3 #etapa WB
        // AND r1, r5, r6 #etapa MEM
        // SUB r7, r1, r1 #etapa EX
        // ForwardA=2'b10
        // ForwardB=2'b10
        Latch_ID_EX_RS=5'b00001;//r1
        Latch_ID_EX_RT=5'b00001;//r1
        Latch_EX_MEM_MUX=5'b00001;//rd.EX/MEM
        Latch_MEM_WB_MUX=5'b00001;//rd.MEM/WB
        Latch_Ex_MEM_WriteBack_FLAGS_Out=1;
        Latch_MEM_WB_WriteBack_FLAGS_Out=1;
	end
	
	
endmodule   

