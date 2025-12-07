module instruction_memory (
    input wire [15:0] address,
    output wire [15:0] instruction
);

    parameter MEM_FILE = "program.mem"; // Defines name of file from which programs will be loaded onto

    // Internal storage for the 65535 memory locations
    reg [15:0] memory [0:65535];

    assign instruction = memory[address];

    initial begin
        $readmemh(MEM_FILE, memory);
    end

endmodule 