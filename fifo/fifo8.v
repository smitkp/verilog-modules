module fifo8(
    input clk,
    input rst,
    input wr_e,
    input [1:0] wr_data,
    input rd_e,
    output reg [1:0] rd_data,
    output full,
    output empty
);

reg [2:0] rd_ptr, rd_ptr_nxt;
reg [2:0] wr_ptr, wr_ptr_nxt;

reg [1:0] data0, data1, data2, data3, data4, data5, data6, data7;
reg [1:0] data_nxt0, data_nxt1, data_nxt2, data_nxt3, data_nxt4, data_nxt5, data_nxt6, data_nxt7;

wire wr_e_qual;
wire rd_e_qual;

assign full = ((wr_ptr + 1) == rd_ptr);
assign empty = (rd_ptr == wr_ptr);
assign wr_e_qual = wr_e && !full;
assign rd_e_qual = rd_e && !empty;

always @(posedge clk) begin
    if (rst) begin
        rd_ptr <= 3'b0;
        wr_ptr <= 3'b0;
    end else begin
        rd_ptr <= rd_ptr_nxt;
        wr_ptr <= wr_ptr_nxt;
    end
end

always @(posedge clk) begin
    data0 <= rst ? 2'b0 : data_nxt0;
    data1 <= rst ? 2'b0 : data_nxt1;
    data2 <= rst ? 2'b0 : data_nxt2;
    data3 <= rst ? 2'b0 : data_nxt3;
    data4 <= rst ? 2'b0 : data_nxt4;
    data5 <= rst ? 2'b0 : data_nxt5;
    data6 <= rst ? 2'b0 : data_nxt6;
    data7 <= rst ? 2'b0 : data_nxt7;
end


always @(*) begin
    data_nxt0 = wr_e_qual && (wr_ptr == 3'h0) ? wr_data : data0;
    data_nxt1 = wr_e_qual && (wr_ptr == 3'h1) ? wr_data : data1;
    data_nxt2 = wr_e_qual && (wr_ptr == 3'h2) ? wr_data : data2;
    data_nxt3 = wr_e_qual && (wr_ptr == 3'h3) ? wr_data : data3;
    data_nxt4 = wr_e_qual && (wr_ptr == 3'h4) ? wr_data : data4;
    data_nxt5 = wr_e_qual && (wr_ptr == 3'h5) ? wr_data : data5;
    data_nxt6 = wr_e_qual && (wr_ptr == 3'h6) ? wr_data : data6;
    data_nxt7 = wr_e_qual && (wr_ptr == 3'h7) ? wr_data : data7;
    if (rd_e_qual) begin
        case(1)
            rd_ptr == 0 : rd_data <= data0;
            rd_ptr == 1 : rd_data <= data1;
            rd_ptr == 2 : rd_data <= data2;
            rd_ptr == 3 : rd_data <= data3;
            rd_ptr == 4 : rd_data <= data4;
            rd_ptr == 5 : rd_data <= data5;
            rd_ptr == 6 : rd_data <= data6;
            rd_ptr == 7 : rd_data <= data7;
        endcase
    end
    rd_ptr_nxt = rd_e_qual ? rd_ptr + 1 : rd_ptr;
    wr_ptr_nxt = wr_e_qual ? wr_ptr + 1 : wr_ptr;
end

endmodule
