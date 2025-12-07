// pc_se.v — RiSC-16 Program Counter with Sign Extension
// Three types of increment: PC+1、PC+1+imm、jalr
// standard verilog style

module pc (
    input  clk,         
    input  rst_n,       

    // Control and data from decode/control stage
    input  [6:0] imm,        // 7-bit immediate value (sign-extended to 16 bits)
    input  [15:0] alu_out,     // jalr target address
    input  [1:0]  MUX_output,      // 00: PC+1, 01: PC+1+imm, 10: alu_out, 11: reserved/default PC+1

    output [15:0] nxt_instr     // Wire type for continuous assignment
);

    // Wire declarations for combinational logic
    wire [15:0] pc_plus1;
    wire [15:0] se_imm;
    wire [15:0] pc_plus1_imm;
    
    // Reg declaration for multiplexer output
    reg [15:0] pc_next;
    reg [15:0] pc;

    assign nxt_instr = pc;
    // Combinational logic: candidate next PC
    assign pc_plus1      = pc + 16'd1;
    assign se_imm        = {{9{imm[6]}}, imm[6:0]};
    assign pc_plus1_imm  = pc_plus1 + se_imm; 
    
    // Multiplexer: select next PC based on MUX_output
    always @(*) begin
        case (MUX_output)
            2'b00:   pc_next = pc_plus1;      
            2'b01:   pc_next = pc_plus1_imm;   
            2'b10:   pc_next = alu_out;       
            default: pc_next = pc_plus1;
        endcase
    end

    // Sequential logic: update PC on rising clock edge
    // Asynchronous reset: @ (posedge clk or negedge rst_n)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 16'd0;         
        end else begin
            pc <= pc_next;       
        end
    end
endmodule

