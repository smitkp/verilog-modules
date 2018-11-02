module fifo_test();
    // Clock  and reset gen
    reg clk, rst;
    always  #1 clk = !clk;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,fifo_test);
        clk = 1;
        rst = 1;
        #4 rst = 0;
        #45 $finish;
    end

    reg wr_e, rd_e;
    wire busy;
    reg [1:0] wr_data;
    wire [1:0]  rd_data;

    initial begin
        wr_e = 1'b0;
        rd_e = 1'b0;
        wr_data = 2'b0;
        #10
        wr_e = 1'b1;
        wr_data = 2'b10;
        #2
        wr_e = 1'b0;
        wr_data = 2'b0;
        #10
        rd_e = 1'b1;
        #2
        rd_e = 1'b0;
    end

    fifo dut(
        .wr_e(wr_e),
        .wr_data(wr_data),
        .rd_e(rd_e),
        .rd_data(rd_data),
        .clk(clk),
        .rst(rst),
        .busy(busy)
    );

endmodule

