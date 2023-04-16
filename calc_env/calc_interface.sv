interface calc_interface(input clk);
  logic [0:3] req4_cmd, req1_cmd, req2_cmd, req3_cmd;
  logic [0:3] req4_d1, req1_d1, req2_d1, req3_d1;
  logic [0:3] req4_d2, req1_d2, req2_d2, req3_d2;
  logic [0:3] req4_r1, req1_r1, req2_r1, req3_r1;
  logic [0:1] req4_tag, req1_tag, req2_tag, req3_tag;
  logic [0:31] req4_data, req1_data, req2_data, req3_data;
  logic [0:1] out4_resp, out1_resp, out2_resp, out3_resp;
  logic [0:1] out4_tag, out1_tag, out2_tag, out3_tag;
  logic [0:31] out4_data, out1_data, out2_data, out3_data;
  logic scan_in;
  logic scan_out;
  logic reset;

  clocking master_cb @(posedge clk);
    default output #1;
    output req4_cmd, req1_cmd, req2_cmd, req3_cmd;
    output req4_d1, req1_d1, req2_d1, req3_d1;
    output req4_d2, req1_d2, req2_d2, req3_d2;
    output req4_r1, req1_r1, req2_r1, req3_r1;
    output req4_tag, req1_tag, req2_tag, req3_tag;
    output req4_data, req1_data, req2_data, req3_data;
    output reset;
  endclocking;

  clocking monitor_cb @(posedge clk);
      input out4_resp, out1_resp, out2_resp, out3_resp;
      input out4_tag, out1_tag, out2_tag, out3_tag;
      input out4_data, out1_data, out2_data, out3_data;
  endclocking;

  modport master(clocking master_cb);
  modport monitor(clocking monitor_cb);

  modport top(input req4_cmd, req1_cmd, req2_cmd, req3_cmd,
              input req4_d1, req1_d1, req2_d1, req3_d1,
              input req4_d2, req1_d2, req2_d2, req3_d2,
              input req4_r1, req1_r1, req2_r1, req3_r1,
              input req4_tag, req1_tag, req2_tag, req3_tag,
              input req4_data, req1_data, req2_data, req3_data,
              input reset, scan_in, clk,
              output out4_resp, out1_resp, out2_resp, out3_resp,
              output out4_tag, out1_tag, out2_tag, out3_tag,
              output out4_data, out1_data, out2_data, out3_data,
              output scan_out);
endinterface