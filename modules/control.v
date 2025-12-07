// Rsic 16 control unit

module control(
    input [2:0] op,
    input       EQ,
    
    output reg [1:0] FUNC_alu, // AND, NAND, PASS1, EQL
    output reg       MUX_alu1,
    output reg       MUX_alu2,
    output reg [1:0] MUX_pc,
    output reg       MUX_rf,
    output reg [1:0] MUX_tgt,
    output reg       WE_rf,
    output reg       WE_dmem
    );

    // Parameters for opcodes
    parameter ADD  = 3'b000;
    parameter ADDI = 3'b001;
    parameter NAND = 3'b010;
    parameter LUI  = 3'b011;
    parameter LW   = 3'b100;
    parameter SW   = 3'b101;
    parameter BEQ  = 3'b110;
    parameter JALR = 3'b111;

    always @(*) begin
        // Default values for all control signals
        FUNC_alu = 2'b00; // ADD
        MUX_alu1 = 1'b0; // Src1
        MUX_alu2 = 1'b0; // Src2
        MUX_pc   = 2'b00; // pc + 1
        MUX_rf   = 1'b0;  // rC
        MUX_tgt  = 2'b00; // data memory
        WE_rf    = 1'b0; // disable reg file
        WE_dmem  = 1'b0; // disable data memory


        // Set control signals based on opcode
        case(op)
            ADD: begin // ADD
                FUNC_alu = 2'b00; 
                MUX_alu1 = 1'b0;
                MUX_alu2 = 1'b0;
                MUX_pc   = 2'b00;
                MUX_rf   = 1'b0;
                MUX_tgt  = 2'b01; 
                WE_rf    = 1'b1;
                WE_dmem  = 1'b0;
            end
            ADDI: begin // ADDI
                FUNC_alu = 2'b00; 
                MUX_alu1 = 1'b0;
                MUX_alu2 = 1'b1; 
                MUX_pc   = 2'b00;
                MUX_rf   = 1'b0;
                MUX_tgt  = 2'b01; 
                WE_rf    = 1'b1;
                WE_dmem  = 1'b0;
            end
            NAND: begin // NAND
                FUNC_alu = 2'b01; 
                MUX_alu1 = 1'b0;
                MUX_alu2 = 1'b0; 
                MUX_pc   = 2'b00;
                MUX_rf   = 1'b0;
                MUX_tgt  = 2'b01; 
                WE_rf    = 1'b1;
                WE_dmem  = 1'b0;
            end
            LUI: begin // LUI
                FUNC_alu = 2'b10; 
                MUX_alu1 = 1'b1; 
                MUX_alu2 = 1'b0; 
                MUX_pc   = 2'b00;
                MUX_rf   = 1'b0;
                MUX_tgt  = 2'b01; 
                WE_rf    = 1'b1;
                WE_dmem  = 1'b0;
            end
            LW: begin // LW
                FUNC_alu = 2'b00; 
                MUX_alu1 = 1'b0;
                MUX_alu2 = 1'b1; 
                MUX_pc   = 2'b00;
                MUX_rf   = 1'b0; 
                MUX_tgt  = 2'b00; 
                WE_rf    = 1'b1;
                WE_dmem  = 1'b0;
            end
            SW: begin // SW
                FUNC_alu = 2'b00; 
                MUX_alu1 = 1'b0;
                MUX_alu2 = 1'b1; 
                MUX_pc   = 2'b00;
                MUX_rf   = 1'b1; 
                MUX_tgt  = 2'b00; 
                WE_rf    = 1'b0;
                WE_dmem  = 1'b1;
            end
            BEQ: begin // BEQ
                FUNC_alu = 2'b11; 
                MUX_alu1 = 1'b0;
                MUX_alu2 = 1'b0; 
                MUX_pc   = EQ ? 2'b01 : 2'b00; 
                MUX_rf   = 1'b1;
                MUX_tgt  = 2'b00; 
                WE_rf    = 1'b0;
                WE_dmem  = 1'b0;
            end
            JALR: begin // JALR
                FUNC_alu = 2'b10; 
                MUX_alu1 = 1'b0;
                MUX_alu2 = 1'b0; 
                MUX_pc   = 2'b10; 
                MUX_rf   = 1'b0;
                MUX_tgt  = 2'b10; 
                WE_rf    = 1'b1;
                WE_dmem  = 1'b0;
            end
        endcase
    end


endmodule