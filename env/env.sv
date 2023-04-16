`include "env/scoreboard.sv"
class test_cfg;
  rand int total_scenarios;
  constraint basic {
    total_scenarios > 0;
    total_scenarios < 1000;
  }
endclass;
class env;
  test_cfg cfg;
  calc_generator gen;
  calc_master mas;
  calc_monitor mon;
  scoreboard scb;
  
  mailbox #(calc_scenario) gen2mas;  
  mailbox #(calc_scenario) mas2scb;
  mailbox #(calc_out) mon2scb;
  mailbox #(calc_out) mon2mas;

  virtual calc_interface io;

  function new(virtual calc_interface io);
    this.io = io;
    gen2mas = new();
    mas2scb = new();
    mon2scb = new();
    mon2mas = new();
    cfg = new();
    if (!cfg.randomize()) begin
      $display("test_cfg::randomize failed");
      $finish;
    end

    cfg.total_scenarios = 50;
    gen = new(gen2mas, cfg.total_scenarios);
    mas = new(io, gen2mas, mas2scb, mon2mas);
    mon = new(io, mon2scb, mon2mas);
    scb = new(cfg.total_scenarios, mas2scb, mon2scb);
  endfunction;

  virtual task pre_test();
    fork
      scb.main();
      mas.main();
      mon.main();
    join_none
  endtask;

  virtual task test();
    fork
      gen.main();
    join_none
  endtask

  virtual task post_test();
    fork
      wait(gen.all_scenarios_sent.triggered);
      wait(scb.all_scenarios_scored.triggered);
    join
  endtask

  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass