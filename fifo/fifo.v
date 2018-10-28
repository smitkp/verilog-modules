module fifo (
    input clk,
    input rst,

    input in_pvld,
    input in_pd,
    output in_prdy,

    output o_pvld,
    output o_pd,
    input o_prdy
);

    assign o_pvld = in_pvld;
    assign o_pd = in_pd;
    assign in_prdy = o_prdy;

endmodule


module test_fifo();
    reg clk;
    initial begin
//        $dumpfile("test.vcd");
//        $dumpvars(0,test_fifo);
        clk = 1'b0;
        #1
        clk = !clk;
        #1
        clk = !clk;
        #1
        clk = !clk;
        #1
        clk = !clk;
        #1
        clk = !clk;
    end

    fifo fifo_ins(
        .clk(clk),
        .rst(1'b0),
        .in_pvld(1'b1),
        .in_pd(1'b1),
        .in_prdy(),
        .o_pvld(),
        .o_pd(),
        .o_prdy(1'b0)
    );
endmodule


