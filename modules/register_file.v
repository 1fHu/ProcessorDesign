// RISC-16 Register File
// eight 16-bit registers


module register_file(

    input clk,      
    
    input [1:0] MUX_tgt,
    input MUX_rf,
    input WE_rf, 

    input [15:0] mem_out, alu_out, pc,
    input [2:0] rA, rB, rC,


    output [15:0] reg_out1,     
    output [15:0] reg_out2 
);

    
    reg [15:0] registers [7:0];
    integer i;

    // Initialize all registers to 0
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            registers[i] = 16'h0000;
        end
    end

    reg [15:0] tgt_data; 
    always @(*) begin
        case (MUX_tgt)
            2'b00: tgt_data = mem_out;
            2'b01: tgt_data = alu_out;
            2'b10: tgt_data = pc + 1;
            2'b11: tgt_data = 0;
        endcase
    end

    always @(posedge clk) begin
        if (WE_rf && rA != 3'b000) begin  // avoid writing into r0
            registers[rA] <= tgt_data;
        end
        registers[0] <= 16'h0000; 
    end
    
    // read asynchronous
    assign reg_out1 = registers[rB];
    assign reg_out2 = MUX_rf ? registers[rA] : registers[rC];


endmodule