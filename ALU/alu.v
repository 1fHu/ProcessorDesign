// ALU Module for RiSC-16 Processor
// Handles four inputs selection and basic arithmetic/logic operations

module alu (
    input MUX_alu1,        
    input MUX_alu2,        
    input [1:0]  FUNC_alu,
    input [15:0] src1_reg, src2_reg,  
    input [9:0] imm, 

    output reg [15:0] alu_out,
    output reg EQ
);

    // ALU Operation Codes
    parameter ADD  = 2'b00;   // Addition
    parameter NAND = 2'b01;   // Bitwise NAND
    parameter PASS1 = 2'b10;  // Pass through src1_reg
    parameter EQL  = 2'b11;   // Equality check

    wire [15:0] a;
    wire [15:0] b;

    assign a = MUX_alu1 ? (imm << 6) : src1_reg;
    assign b = MUX_alu2 ? ({{9{imm[6]}}, imm[6:0]}) : src2_reg;


    always @(*) begin
        alu_out = 16'b0;
        EQ = (a == b);

        case (FUNC_alu)
            ADD: begin
                alu_out = a + b;
            end
            
            NAND: begin
                alu_out = ~ (a & b);
            end
            
            PASS1: begin
                alu_out = a;
            end
            
            EQL: begin
                alu_out = 16'b0;
            end

            // default: begin
            //     alu_out = 16'b0;
            //     EQ = 1'b0;
            // end
        endcase
        

    end

endmodule
