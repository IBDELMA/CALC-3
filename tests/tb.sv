module tb;
  parameter simulation_cycle = 100;
  
  bit clock;
  always #(simulation_cycle/2) 
    clock = ~clock;

  calc_interface io(clock);
  test t1(io);
  calc3_top top(
  .out1_data(io.out1_data), 
  .out1_resp(io.out1_resp), 
  .out1_tag(io.out1_tag), 
  .out2_data(io.out2_data), 
  .out2_resp(io.out2_resp), 
  .out2_tag(io.out2_tag), 
  .out3_data(io.out3_data), 
  .out3_resp(io.out3_resp), 
  .out3_tag(io.out3_tag), 
  .out4_data(io.out4_data), 
  .out4_resp(io.out4_resp), 
  .out4_tag(io.out4_tag), 
  .scan_out(io.scan_out), 
  .a_clk(io.clk), 
  .b_clk(io.clk), 
  .c_clk(io.clk), 
  .req1_cmd(io.req1_cmd), 
  .req1_d1(io.req1_d1), 
  .req1_d2(io.req1_d2), 
  .req1_data(io.req1_data), 
  .req1_r1(io.req1_r1), 
  .req1_tag(io.req1_tag), 
  .req2_cmd(io.req2_cmd), 
  .req2_d1(io.req2_d1), 
  .req2_d2(io.req2_d2), 
  .req2_data(io.req2_data), 
  .req2_r1(io.req2_r1), 
  .req2_tag(io.req2_tag), 
  .req3_cmd(io.req3_cmd), 
  .req3_d1(io.req3_d1), 
  .req3_d2(io.req3_d2), 
  .req3_data(io.req3_data), 
  .req3_r1(io.req3_r1), 
  .req3_tag(io.req3_tag), 
  .req4_cmd(io.req4_cmd), 
  .req4_d1(io.req4_d1), 
  .req4_d2(io.req4_d2), 
  .req4_data(io.req4_data), 
  .req4_r1(io.req4_r1), 
  .req4_tag(io.req4_tag), 
  .reset(io.reset), 
  .scan_in(io.scan_in));
endmodule