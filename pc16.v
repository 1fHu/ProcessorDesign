// pc16.v — RiSC-16 Program Counter (PC)
// Three types of increment: PC+1、PC+1+imm、jalr

module pc16 (
    input  logic        clk,         
    input  logic        reset,       
    input  logic        enable,      // Enable update (used for stall control,
                                     // tie to 1'b1 if unused)

    // Control and data from decode/control stage
    input  logic [15:0] imm,         // Offset already sign-extended to 16 bits (for branch: PC+1+imm)
    input  logic [15:0] alu_out,     // jalr target address (from register via ALU pass-through)
    input  logic [1:0]  pc_sel,      // 00: PC+1, 01: PC+1+imm, 10: alu_out, 11: reserved/default PC+1
  
    output logic [15:0] pc
);

    // Combinational logic: candidate next PC
    logic [15:0] pc_plus1;
    logic [15:0] pc_plus1_imm;
    logic [15:0] pc_next;

    assign pc_plus1      = pc + 16'd1;
    assign pc_plus1_imm  = pc_plus1 + imm; 
    
    // Multiplexer: select next PC based on pc_sel
    always_comb begin
        unique case (pc_sel)
            2'b00:   pc_next = pc_plus1;       // Sequential execution
            2'b01:   pc_next = pc_plus1_imm;   // Conditional/relative jump
            2'b10:   pc_next = alu_out;        // Absolute jump (jalr)
            default: pc_next = pc_plus1;       // Default
        endcase
    end

    // Sequential logic: update PC on rising clock edge
    // Asynchronous reset: @ (posedge clk or posedge reset)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 16'd0;         
        end else if (enable) begin
            pc <= pc_next;       
        end
    end

endmodule
