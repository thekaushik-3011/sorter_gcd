`timescale 1ns/1ps

module gcd_tb;

    reg clk, rst, start;
    reg [31:0] a, b;
    wire [31:0] result;
    wire done;

    // All integers declared at module level
    integer infile, outfile;
    integer scan, pair_count, batch_count;
    integer timeout;

    // Instantiate the GCD module
    gcd uut (
        .clk(clk),
        .rst(rst),    // Added reset input
        .start(start),
        .a(a),
        .b(b),
        .result(result),
        .done(done)
    );

    // Clock generator: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Testbench main
    initial begin
        // Initialize signals
        rst = 1;
        start = 0;
        a = 0;
        b = 0;

        // Apply reset
        #20 rst = 0;

        // Open input file
        infile = $fopen("pairs.txt", "r");
        if (infile == 0) begin
            $display("Error: Cannot open pairs.txt!");
            $finish;
        end

        // Open output file
        outfile = $fopen("gcd_results.txt", "w");
        if (outfile == 0) begin
            $display("Error: Cannot open gcd_results.txt!");
            $finish;
        end

        $fwrite(outfile, "=== GCD Results ===\n");

        batch_count = 1;
        pair_count = 0;

        // Process each pair
        while (!$feof(infile)) begin
            scan = $fscanf(infile, "%d %d\n", a, b);
            if (scan == 2) begin
                // Set inputs and start signal
                a = a;
                b = b;
                @(posedge clk);  // Sync with clock
                start = 1;
                @(posedge clk);  // Allow module to sample start
                start = 0;

                // Wait for done with timeout
                timeout = 1000;  // Increased to 200 clock cycles for larger numbers
                while (!done && timeout > 0) begin
                    @(posedge clk);
                    timeout = timeout - 1;
                end

                if (!done) begin
                    $display("Warning: GCD not finished for %0d, %0d after %0d cycles", a, b, 1000 - timeout);
                end else begin
                    pair_count = pair_count + 1;
                    $display("Batch %0d, Pair %0d: GCD(%0d, %0d) = %0d",
                             batch_count, pair_count, a, b, result);
                    $fwrite(outfile, "Batch %0d, Pair %0d: %0d %0d -> GCD = %0d\n",
                             batch_count, pair_count, a, b, result);
                end

                // After 10 pairs or end of file, move to next batch
                if (pair_count == 10 || $feof(infile)) begin
                    $fwrite(outfile, "-----------------------------\n");
                    batch_count = batch_count + 1;
                    pair_count = 0;
                end
            end else if (scan == -1) begin
                // Skip invalid lines or end of file, let $feof handle loop exit
            end
        end

        $fclose(infile);
        $fclose(outfile);
        $display("Simulation complete. Results saved to gcd_results.txt");
        $finish;
    end

    // Monitor for debugging
    initial begin
        $monitor("Time=%0t rst=%b start=%b a=%0d b=%0d done=%b result=%0d",
                 $time, rst, start, a, b, done, result);
    end

endmodule