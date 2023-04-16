`include "calc_env/calc_env.sv"
class scoreboard;
  int total_scenarios;
  event all_scenarios_scored;
  mailbox #(calc_scenario) mas2scb;
  mailbox #(calc_out) mon2scb;

  function new(int _total_scenarios, mailbox #(calc_scenario) _mas2scb, mailbox #(calc_out) _mon2scb);
    this.total_scenarios = _total_scenarios;
    this.mas2scb = _mas2scb;
    this.mon2scb = _mon2scb;
  endfunction;

  function void score_scenario(calc_scenario sc, calc_out results[$]);
    bit[0:3] d1[4] = '{'0, '0, '0, '0};
    bit[0:3] d2[4] = '{'0, '0, '0, '0};
    bit[0:3] r1[4] = '{'0, '0, '0, '0};
    $display("[%0td] Scoring scenario: %s", $time, sc.label);
    foreach(sc.tr_array[i]) begin
      int _index[$] = results.find_last_index with (item.tag == sc.tr_array[i].tag);
      int index = _index[0];
      calc_out r = new(results[index].port_num, results[index].resp, results[index].tag, results[index].data);
      results.delete(index);
      sc.tr_array[i].display();
      r.display();
      case(sc.tr_array[i].cmd)
        4'b0001: begin // ADD
                end
        4'b0010: begin // SUB
                end
        4'b0101: begin // SHIFTL
                end
        4'b0110: begin // SHIFTR
                end
        4'b1001: begin // STORE
                end
        4'b1010: begin // FETCH
                end
        4'b1100: begin // BZERO
                end
        4'b1101: begin // BEQ
                end
      endcase
    end
  endfunction

  task main();
    calc_scenario sc;
    calc_out results[$];
    calc_out res;
    int i = 0;
    forever
    begin
      mas2scb.get(sc);
      for(i = 0; i < sc.tr_count; i++) begin
        mon2scb.get(res);
        results.push_front(res);
      end
      score_scenario(sc, results);
      if(--total_scenarios<1) begin
        ->all_scenarios_scored;
        break;
      end
    end
  endtask
endclass