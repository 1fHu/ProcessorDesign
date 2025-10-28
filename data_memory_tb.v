`timescale 1ns / 1ps
module data_memory_tb;

    // Inputs
    reg clk;
    reg WE_dmem;
    reg [15:0] reg_out;
    reg [15:0] alu_out;

    // Outputs
    wire [15:0] mem_out;

    // Instantiate the data_memory module
    data_memory uut ( // uut = Unit Under Test
        .clk(clk),
        .WE_dmem(WE_dmem),
        .reg_out(reg_out),
        .alu_out(alu_out),
        .mem_out(mem_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // verify memory connection
    task check_memory;
        begin
            // Write some values to memory
            WE_dmem = 1;
            reg_out = 16'h1234; alu_out = 16'h000A; #10; // Write 0x1234 to address 0x000A
            reg_out = 16'hABCD; alu_out = 16'h00FF; #10; // Write 0xABCD to address 0x00FF
            reg_out = 16'hFFFF; alu_out = 16'hFFFF; #10; // Write 0xFFFF to address 0xFFFF

            // Disable write enable for read operations
            WE_dmem = 0;

            // Read back the values and check
            alu_out = 16'h000A; #10;
            if (mem_out !== 16'h1234) $display("ERROR: Memory read mismatch at address 0x000A");
            else $display("PASSED: Address 0x000A = 0x%h", mem_out);

            alu_out = 16'h00FF; #10;
            if (mem_out !== 16'hABCD) $display("ERROR: Memory read mismatch at address 0x00FF");
            else $display("PASSED: Address 0x00FF = 0x%h", mem_out);

            alu_out = 16'hFFFF; #10;
            if (mem_out !== 16'hFFFF) $display("ERROR: Memory read mismatch at address 0xFFFF");
            else $display("PASSED: Address 0xFFFF = 0x%h", mem_out);

            $display("Memory check completed.");
        end
    endtask

    // Test sequence
    initial begin
        $display("Starting data_memory testbench...");
        
        // Initialize inputs
        WE_dmem = 0;
        reg_out = 16'h0000;
        alu_out = 16'h0000;
        
        // Wait for a few clock cycles
        #20;
        
        // Run the memory check
        check_memory;
        
        // Wait a bit more
        #50;
        
        $display("\nAll tests completed.");
        $finish;
    end

    // Timeout protection
    initial begin
        #100000;
        $display("\n[TIMEOUT] Simulation timeout - possible infinite loop!");
        $finish;
    end

endmodule