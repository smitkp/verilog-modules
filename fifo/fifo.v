module fifo #(parameter
    WIDTH = 2
    )
(
    input clk,
    input rst,
    input wr_e,
    input [WIDTH-1:0] wr_data,
    input rd_e,
    output reg [WIDTH-1:0] rd_data,
    output reg busy
);

    reg [WIDTH-1:0] p1_data, p1_data_nxt;
    reg busy_nxt;

    always @(posedge clk) begin
        if (rst) begin
            busy <= 1'b0;
        end else begin
            p1_data <= wr_e ? wr_data : p1_data;
            busy <= busy_nxt;
        end
    end

    always @(*) begin
        if (busy)
            busy_nxt = (rd_e && wr_e) ? 1'b1 : rd_e ? 1'b0 : busy;
        else
            busy_nxt = (rd_e && wr_e) ? 1'b0 : wr_e ? 1'b1 : busy;
        rd_data = rd_e ? p1_data : rd_data;
    end

endmodule

