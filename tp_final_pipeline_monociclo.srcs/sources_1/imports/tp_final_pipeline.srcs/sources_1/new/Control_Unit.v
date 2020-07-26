`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2019 20:14:23
// Design Name: 
// Module Name: Control_Unit
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
//Inputs:			R-Format		LW		SW		BEQ		BNE      JR      JALR      Jmp         JAL         Ime            
//			- Op5 		0 			1 		1 		0		0	      0        0        0           0            0
//			- Op4 		0 			0 		0 		0		0	      0        0        0           0            0
//			- Op3 		0 			0 		1 		0		0	      0        0        0           0            1
//			- Op2 		0 			0 		0 		1		1	      0        0        0           0            0
//			- Op1 		0 			1	 	1 		0		0		  0        0        1           1            0
//			- Op0 		0 			1 		1 		0		1	      0        0        0	        1            0
//  funcion:
//          - Func5     X           X       X       X       X         0        0        X           X            X
//          - Func4     X           X       X       X       X         0        0        X           X            X
//          - Func3     X           X       X       X       X         1        1        X           X            X
//          - Func2     X           X       X       X       X         0        0        X           X            X
//          - Func1     X           X       X       X       X         0        0        X           X            X
//          - Func0     X           X       X       X       X         0        1        X           X            X
//Outputs:
//			- RegWrite 	1 			1		0 		0		0		  0        1        0           1            1
//			- MemtoReg 	0 			1 		X 		X		X		  0        0        0           0            0
//			- MemRead 	0 			1 		0 		0	    0     	  0        0        0           0            0
//			- MemWrite 	0 			0 		1 		0		0		  0        0        0           0            0
//			- BranchEQ  0           0       0       1       0         0        0        0           0            0  
//          - BranchNE  0           0       0       0       1         0        0        0           0            0
//          - JR        0           0       0       0       0         1        0        0           0            0
//          - JALR      0           0       0       0       0         0        1        0           0            0
//          - Jmp       0           0       0       0       0         0        0        1           0            0
//          - JAL       0           0       0       0       0         0        0        0           1            0
//			- RegDst 	1 			0 		X 		X		0		  0        1        0           X            0
//			- ALUSrc 	0 			1 		1 		0		0		  0	       0        0           0            1
//			- ALUOp1 	1 			0 		0 		0		0		  0        0        0           0            1
//			- ALUOp0 	0 			0 		0 		1		1		  0        0        0           0            1
//			- InmCtrl	0			0		0		0		0         0        0        0           0           OpCode[2:0]
//			
//
//////////////////////////////////////////////////////////////////////////////////////////////


module Control_Unit(        
                            input       Clk,
                            input 		[5:0] OpCode,
                            input       [5:0] funcion, 
							output 		[13:0] ControlFLAGS,
							output reg	[2:0] InmCtrl
                    );

//reg RegWrite, MemtoReg,  MemRead, MemWrite, BranchEQ, BranchNE, JR , JALR, Jmp, JAL, RegDst, ALUSrc, ALUOp1, ALUOp0;

reg BranchEQ, BranchNE, JR , JALR, Jmp, JAL, RegWrite, MemtoReg,  MemRead, MemWrite, RegDst, ALUSrc, ALUOp1, ALUOp0;

always@(OpCode) begin
//always@* begin
	case(OpCode)
		//R-Format
		6'b000000: 	begin
                    case(funcion)
                                        
                        6'b001000: begin //JR
                                            BranchEQ     <=  0;
                                            BranchNE     <=  0;
                                            JR           <=  1;
                                            JALR         <=  0;
                                            Jmp          <=  0;
                                            JAL          <=  0;
                                            RegWrite     <=  0;
                                            MemtoReg     <=  0;
                                            MemRead      <=  0;
                                            MemWrite     <=  0;
                                            RegDst       <=  0;
                                            ALUSrc       <=  0;
                                            ALUOp1       <=  0;
                                            ALUOp0       <=  0; 
                                            InmCtrl      <=  0;
                                            
                                    end
                        6'b001001: begin //JALR
                                            BranchEQ     <=  0;
                                            BranchNE     <=  0;
                                            JR           <=  0;
                                            JALR         <=  1;
                                            Jmp          <=  0;
                                            JAL          <=  0;
                                            RegWrite     <=  1;
                                            MemtoReg     <=  0;
                                            MemRead      <=  0;
                                            MemWrite     <=  0;
                                            RegDst       <=  1;
                                            ALUSrc       <=  0;
                                            ALUOp1       <=  0;
                                            ALUOp0       <=  0; 
                                            InmCtrl      <=  0;
                                    end
                        6'b000000: begin //NOP
                                            BranchEQ     <=  0;
                                            BranchNE     <=  0;
                                            JR           <=  0;
                                            JALR         <=  0;
                                            Jmp          <=  0;
                                            JAL          <=  0;
                                            RegWrite     <=  0;
                                            MemtoReg     <=  0;
                                            MemRead      <=  0;
                                            MemWrite     <=  0;
                                            RegDst       <=  0;
                                            ALUSrc       <=  0;
                                            ALUOp1       <=  0;
                                            ALUOp0       <=  0; 
                                            InmCtrl      <=  0;
                                    end
          
                        default:    begin // Operancion aritmetica
                                            BranchEQ    <=  0;
                                            BranchNE    <=  0;
                                            JR          <=  0;
                                            JALR        <=  0;
                                            Jmp         <=  0;
                                            JAL         <=  0; 
                                            RegWrite    <=  1;
                                            MemtoReg    <=  0;
                                            MemRead     <=  0;
                                            MemWrite    <=  0;                         
                                            RegDst      <=  1;
                                            ALUSrc      <=  0;
                                            ALUOp1      <=  1;
                                            ALUOp0      <=  0; 
                                            InmCtrl     <=  0;
                                    end
                    endcase
                    end
		//LoadW
		6'b100011: 	begin
		                    BranchEQ 	<=	0;
                            BranchNE    <=  0;
                            JR          <=  0;
                            JALR        <=  0;
                            Jmp         <=  0;
                            JAL         <=  0;
                            RegWrite 	<=	1;
                            MemtoReg 	<=	1;
                            MemRead 	<=	1;
                            MemWrite    <=  0;          
							RegDst 		<=	0;
                            ALUSrc      <=  1;
							ALUOp1 		<=	0;
							ALUOp0 		<=  0; 
							InmCtrl		<=	0;
					end
		//StoreW
		6'b101011: 	begin
		                    BranchEQ 	<=	0;
                            BranchNE    <=  0;
                            JR          <=  0;
                            JALR        <=  0;
                            Jmp         <=  0;
                            JAL         <=  0;
							RegWrite 	<=	0;
							MemtoReg 	<=	1; // Es X (indistinto)
							MemRead 	<=	0;
							MemWrite 	<=	1;
							RegDst 		<=	0; // Es X (indistinto)
                            ALUSrc      <=  1;							
							ALUOp1 		<=	0;
							ALUOp0 		<=  0; 
							InmCtrl		<=	0;
					end
		//BranchEQ (Branch on Equal)
		6'b000100: 	begin
		                    BranchEQ 	<=	1;
                            BranchNE    <=  0;
                            JR          <=  0;
                            JALR        <=  0;
                            Jmp         <=  0;
                            JAL         <=  0;
							RegWrite 	<=	0;
							MemtoReg 	<=	0; // Es X (indistinto)
							MemRead 	<=	0;
							MemWrite 	<=	0;
                            RegDst 		<=	0; // Es X (indistinto)
                            ALUSrc      <=  0;
							ALUOp1 		<=	0;
							ALUOp0 		<=  1; 
							InmCtrl 	<=  0; 
						end
						
		//BranchNE (Branch on Not Equal)
        6'b000101:  begin
                            BranchEQ    <=  0;
                            BranchNE    <=  1;
                            JR          <=  0;
                            JALR        <=  0;
                            Jmp         <=  0;
                            JAL         <=  0;
                            RegWrite    <=  0;
                            MemtoReg    <=  0; // Es X (indistinto)
                            MemRead     <=  0;
                            MemWrite    <=  0;
                            RegDst      <=  0; // Es X (indistinto)
                            ALUSrc      <=  0;
                            ALUOp1      <=  0;
                            ALUOp0      <=  1; 
                            InmCtrl     <=  0; //101
                        end
		//J 
		6'b000010: 	begin
		                    BranchEQ 	<=	0;
                            BranchNE    <=  0;
                            JR          <=  0;
                            JALR        <=  0;
                            Jmp         <=  1;
                            JAL         <=  0;
							RegWrite 	<=  0;
                            MemtoReg    <=  0; 
                            MemRead     <=  0;
                            MemWrite    <=  0;
                            RegDst      <=  0; 
                            ALUSrc      <=  0;                            
                            ALUOp1      <=  0;
                            ALUOp0      <=  0; 
                            InmCtrl     <=  0;
					end
		//JAL
        6'b000011:     begin
                            BranchEQ    <=  0;
                            BranchNE    <=  0;
                            JR          <=  0;
                            JALR        <=  0;
                            Jmp         <=  0;
                            JAL         <=  1;
                            RegWrite    <=  1;
                            MemtoReg    <=  0; 
                            MemRead     <=  0;
                            MemWrite    <=  0;
                            RegDst      <=  1; 
                            ALUSrc      <=  0;                            
                            ALUOp1      <=  0;
                            ALUOp0      <=  0; 
                            InmCtrl     <=  0;
                    end
		//Immediate Operations
		default: 	begin
							if(OpCode[5:3] == 3'b 001) begin
							    BranchEQ 	<=	0;
                                BranchNE    <=  0;
                                JR          <=  0;
                                JALR        <=  0;
                                Jmp         <=  0;
                                JAL         <=  0;
								RegWrite 	<=	1;
								MemtoReg 	<=	0; // Es X (indistinto)
								MemRead 	<=	0;
								MemWrite 	<=	0;
								RegDst 		<=	0; // Es X (indistinto)
                                ALUSrc      <=  1;
								ALUOp1 		<=	1;
								ALUOp0 		<=  1;
								InmCtrl 	<=  OpCode[2:0]; 
							end
							else begin
							    BranchEQ 	<=	0;
                                BranchNE    <=  0;
                                JR          <=  0;
                                JALR        <=  0;
                                Jmp         <=  0;
                                JAL         <=  0;
								RegWrite 	<=	0;
								MemtoReg 	<=	0;
								MemRead 	<=	0;
								MemWrite 	<=	0;
								RegDst 		<=	0;
                                ALUSrc      <=  0;								
								ALUOp1 		<=	0;
								ALUOp0 		<=  0;
								InmCtrl 	<=  0;
						end
				end
		endcase
end

//assign ControlFLAGS = {RegWrite, MemtoReg,  MemRead, MemWrite, BranchEQ, BranchNE, JR , JALR, Jmp, JAL, RegDst, ALUSrc, ALUOp1, ALUOp0}; //Se arma la salida

assign ControlFLAGS = {BranchEQ, BranchNE, JR , JALR, Jmp, JAL, RegWrite, MemtoReg,  MemRead, MemWrite, RegDst, ALUSrc, ALUOp1, ALUOp0}; //nuevo                  
                    
endmodule
