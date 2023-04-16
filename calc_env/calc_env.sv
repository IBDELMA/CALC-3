`include "calc_env/calc_interface.sv"
`include "calc_env/calc_scenario.sv"
`include "calc_env/calc_out.sv"

class calc_monitor;
  virtual calc_interface.monitor io;
  mailbox #(calc_out) mon2scb, mon2mas;

  function new(virtual calc_interface.monitor _io, mailbox #(calc_out) _mon2scb, _mon2mas);
    this.io = _io;
    this.mon2scb = _mon2scb;
    this.mon2mas = _mon2mas;
  endfunction

  task main();
    forever begin
      @(io.monitor_cb);
      if(io.monitor_cb.out1_resp != '0) begin
        calc_out res = new(1, io.monitor_cb.out1_resp, io.monitor_cb.out1_tag, io.monitor_cb.out1_data);
        mon2scb.put(res);
        mon2mas.put(res);      
      end
      if(io.monitor_cb.out2_resp != '0) begin
        calc_out res = new(2, io.monitor_cb.out2_resp, io.monitor_cb.out2_tag, io.monitor_cb.out2_data);
        mon2scb.put(res);
        mon2mas.put(res);
      end
      if(io.monitor_cb.out3_resp != '0) begin
        calc_out res = new(3, io.monitor_cb.out3_resp, io.monitor_cb.out3_tag, io.monitor_cb.out3_data);
        mon2scb.put(res);
        mon2mas.put(res);
      end
      if(io.monitor_cb.out4_resp != '0) begin
        calc_out res = new(4, io.monitor_cb.out4_resp, io.monitor_cb.out4_tag, io.monitor_cb.out4_data);
        mon2scb.put(res);
        mon2mas.put(res);
      end
    end
  endtask
endclass

class calc_generator;
  int total_scenarios;
  event all_scenarios_sent;
  int scenario_count = 0;

  mailbox #(calc_scenario) gen2mas;
  function new(mailbox #(calc_scenario) _gen2mas, int _total_scenarios);
    this.gen2mas = _gen2mas;
    this.total_scenarios = _total_scenarios;
  endfunction

  task main();
    $display("[%0t] Starting calc_generator for %0d scenarios", $time, total_scenarios);
    while(scenario_count < total_scenarios) begin
      calc_scenario sc = get_scenario();
      gen2mas.put(sc);
      ++scenario_count;
    end
    $display("[%0t] Ending calc_generator", $time);
    ->all_scenarios_sent;
  endtask

  virtual function calc_scenario get_scenario();
    calc_scenario sc = new();
    if(!sc.randomize()) begin
      $display("calc_generator::get_scenario<base>: randomize() failed");
      $finish;
    end
    get_scenario = sc;
  endfunction
endclass;

class calc_master;
  virtual calc_interface.master io;
  mailbox #(calc_scenario) gen2mas, mas2scb;
  mailbox #(calc_out) mon2mas;
  bit port0_tags[int];
  bit port1_tags[int];
  bit port2_tags[int];
  bit port3_tags[int];

  function new(virtual calc_interface.master _io, 
              mailbox #(calc_scenario) _gen2mas, _mas2scb,
              mailbox #(calc_out) _mon2mas);
    this.io = _io;
    this.gen2mas = _gen2mas;
    this.mas2scb = _mas2scb;
    this.mon2mas = _mon2mas;
  endfunction

  function int get_tag_state(int port_num, int tag);
    case(port_num)
      0:
        return port0_tags[tag];
      1:
        return port1_tags[tag];
      2:
        return port2_tags[tag];
      //3:
      default:
        return port3_tags[tag];
    endcase
  endfunction

  function void set_tag_state(int port_num, int tag, int state);
    case(port_num)
      0: port0_tags[tag] = state;
      1: port1_tags[tag] = state;
      2: port2_tags[tag] = state;
      //3:
      default: port3_tags[tag] = state;
    endcase
  endfunction

  task drive_transaction(calc_transaction tr);
    case(tr.port_num)
      0: begin
        io.master_cb.req4_cmd <= tr.cmd; 
        io.master_cb.req4_d1 <= tr.d1;
        io.master_cb.req4_d2 <= tr.d2;
        io.master_cb.req4_r1 <= tr.r1;
        io.master_cb.req4_tag <= tr.tag;
        io.master_cb.req4_data <= tr.data;
        repeat(2) @(io.master_cb);
      end
      1: begin
        io.master_cb.req1_cmd <= tr.cmd; 
        io.master_cb.req1_d1 <= tr.d1;
        io.master_cb.req1_d2 <= tr.d2;
        io.master_cb.req1_r1 <= tr.r1;
        io.master_cb.req1_tag <= tr.tag;
        io.master_cb.req1_data <= tr.data;
        repeat(2) @(io.master_cb);
      end
      2: begin
        io.master_cb.req2_cmd <= tr.cmd; 
        io.master_cb.req2_d1 <= tr.d1;
        io.master_cb.req2_d2 <= tr.d2;
        io.master_cb.req2_r1 <= tr.r1;
        io.master_cb.req2_tag <= tr.tag;
        io.master_cb.req2_data <= tr.data;
        repeat(2) @(io.master_cb);
      end
      //3:
      default: begin
        io.master_cb.req3_cmd <= tr.cmd; 
        io.master_cb.req3_d1 <= tr.d1;
        io.master_cb.req3_d2 <= tr.d2;
        io.master_cb.req3_r1 <= tr.r1;
        io.master_cb.req3_tag <= tr.tag;
        io.master_cb.req3_data <= tr.data;
        repeat(2) @(io.master_cb);
      end
    endcase
  endtask

  task reset;
    io.master_cb.reset <= 0;
    io.master_cb.req4_cmd <= '0; 
    io.master_cb.req1_cmd <= '0; 
    io.master_cb.req2_cmd <= '0; 
    io.master_cb.req3_cmd <= '0;
    io.master_cb.req4_d1 <= '0; 
    io.master_cb.req1_d1 <= '0; 
    io.master_cb.req2_d1 <= '0; 
    io.master_cb.req3_d1 <= '0;
    io.master_cb.req4_d2 <= '0; 
    io.master_cb.req1_d2 <= '0; 
    io.master_cb.req2_d2 <= '0; 
    io.master_cb.req3_d2 <= '0;
    io.master_cb.req4_r1 <= '0; 
    io.master_cb.req1_r1 <= '0; 
    io.master_cb.req2_r1 <= '0; 
    io.master_cb.req3_r1 <= '0;
    io.master_cb.req4_tag <= '0; 
    io.master_cb.req1_tag <= '0; 
    io.master_cb.req2_tag <= '0; 
    io.master_cb.req3_tag <= '0;
    io.master_cb.req4_data <= '0; 
    io.master_cb.req1_data <= '0; 
    io.master_cb.req2_data <= '0; 
    io.master_cb.req3_data <= '0;
    repeat(2) @(io.master_cb);
    io.master_cb.reset <= 1;
    repeat(8) @(io.master_cb);
    io.master_cb.reset <= 0;
    repeat(2) @(io.master_cb);
  endtask;

  task main();
    forever begin
      calc_scenario sc;
      calc_out res;
      reset;
      gen2mas.get(sc);
      port0_tags[0] = 0;
      port0_tags[1] = 0;
      port0_tags[2] = 0;
      port0_tags[3] = 0;
      port1_tags[0] = 0;
      port1_tags[1] = 0;
      port1_tags[2] = 0;
      port1_tags[3] = 0;
      port2_tags[0] = 0;
      port2_tags[1] = 0;
      port2_tags[2] = 0;
      port2_tags[3] = 0;
      port3_tags[0] = 0;
      port3_tags[1] = 0;
      port3_tags[2] = 0;
      port3_tags[3] = 0;
      $display("[%0t] Running scenario: %s (with %0d transactions)", $time, sc.label, sc.tr_count);
      foreach(sc.tr_array[i]) begin
        calc_transaction tr = sc.tr_array[i].copy();
        int unused_tag = -1;
        int j = 0;
        while(1) begin
          for(j = 0; j < 4; j++) begin
            if(get_tag_state(tr.port_num, j) == 0) begin
              unused_tag = j;
              set_tag_state(tr.port_num, j, 1);
              break;
            end
          end
          if(unused_tag != -1) break;
          mon2mas.get(res);
          set_tag_state(res.port_num, res.tag, 0);
        end
        tr.tag = unused_tag;
        sc.tr_array[i].tag = unused_tag;
        $display("[%0t] Driving transaction %0d on port %0d (tag: 0x%0x)", $time, i, tr.port_num, tr.tag);
        drive_transaction(tr);
      end
      mas2scb.put(sc);
    end
  endtask
endclass