module NV_HOST_INT_evq (
   input sysclk_slcg
  ,input reset_
  ,i_pd
  ,i_pvld
  ,o_prdy
  ,i_idle
  ,i_prdy
  ,o_pd
  ,o_pvld
  );

  input [1:0] i_pd;
  output reg [1:0] o_pd;

  input         sysclk_slcg;
  input         reset_;
  input         i_pvld;
  input         o_prdy;
  output        i_idle;
  output        i_prdy;
  output        o_pvld;

  reg           i_idle;
  reg           i_prdy;
  reg    [1:0] o_pd;
  reg           o_pvld;
  reg           p1_pipe_busy;
  reg    [1:0] p1_pipe_data;
  reg           p1_pipe_rand_busy;
  reg    [1:0] p1_pipe_rand_data;
  reg           p1_pipe_rand_ready;
  reg           p1_pipe_rand_valid;
  reg           p1_pipe_ready;
  reg           p1_pipe_ready_bc;
  reg    [1:0] p1_pipe_skid_data;
  reg           p1_pipe_skid_ready;
  reg           p1_pipe_skid_valid;
  reg           p1_pipe_valid;
  reg           p1_skid_catch;
  reg    [1:0] p1_skid_data;
  reg           p1_skid_ready;
  reg           p1_skid_ready_flop;
  reg           p1_skid_valid;

  always_comb begin
    p1_pipe_rand_valid = i_pvld;
    i_prdy = p1_pipe_rand_ready;
    p1_pipe_rand_data = i_pd;
  end

  always_comb begin
    p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
  end

  always_ff @(posedge sysclk_slcg) begin
    if (!reset_) begin
      p1_pipe_valid <= 1'b0;
    end else begin
    p1_pipe_valid <= (p1_pipe_ready_bc)? p1_pipe_rand_valid : 1'd1;
    end
  end

  always_ff @(posedge sysclk_slcg) begin
    p1_pipe_data <= (p1_pipe_ready_bc && p1_pipe_rand_valid)? p1_pipe_rand_data : p1_pipe_data;
  end
  always_comb begin
    p1_pipe_rand_ready = p1_pipe_ready_bc;
  end
  always_comb begin
    p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
    p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
  end
  always_ff @(posedge sysclk_slcg) begin
    if (!reset_) begin
      p1_skid_valid <= 1'b0;
      p1_skid_ready_flop <= 1'b1;
      p1_pipe_ready <= 1'b1;
    end else begin
    p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
    p1_skid_ready_flop <= p1_skid_ready;
    p1_pipe_ready <= p1_skid_ready;
    end
  end
  always_ff @(posedge sysclk_slcg) begin
    p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  end
  always_comb begin
    p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
    p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  end
  always_comb begin
    o_pvld = p1_pipe_skid_valid;
    p1_pipe_skid_ready = o_prdy;
    o_pd = p1_pipe_skid_data;
    p1_pipe_busy = p1_skid_valid || p1_pipe_valid;
  end
  always_comb begin
    i_idle = 
      (p1_pipe_busy)? 1'b0 : 1'b1;
  end
endmodule // NV_HOST_INT_evq
