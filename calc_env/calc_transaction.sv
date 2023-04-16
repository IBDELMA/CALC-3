`ifndef CALC_TRANSACTION
`define CALC_TRANSACTION
class calc_transaction;
  rand int port_num;
  constraint c_port_num {
    port_num >= 0;
    port_num < 4;
  }
  rand bit [0:3] cmd;
  constraint c_cmd {
    cmd inside {
      4'b0001, // ADD
      4'b0010, // SUB
      4'b0101, // SHIFTL
      4'b0110, // SHIFTR
      4'b1001, // STORE
      4'b1010, // FETCH
      4'b1100, // BZERO
      4'b1101 // BEQ
    };
  }
  rand bit [0:3] d1;
  rand bit [0:3] d2;
  rand bit [0:3] r1;
  bit [0:1] tag;
  rand bit [0:31] data;

  function string stringify_cmd(bit [0:3] _cmd);
    if(_cmd == 4'b0000)
      return "NO_OP";
    if(_cmd == 4'b0001)
      return "ADD";
    if(_cmd == 4'b0010)
      return "SUB";
    if(_cmd == 4'b0101)
      return "SHIFTL";
    if(_cmd == 4'b0110)
      return "SHIFTR";
    if(_cmd == 4'b1001)
      return "STORE";
    if(_cmd == 4'b1010)
      return "FETCH";
    if(_cmd == 4'b1100)
      return "BZERO";
    if(_cmd == 4'b1101)
      return "BEQ";
  endfunction

  function void display();
    $display("[%0t] Port: %0d, Tag: 0x%0x: %s (D1: 0x%0x, D2: 0x%0x, R1: 0x%0x) DATA = 0x%0x", 
      $time, port_num, tag, stringify_cmd(cmd), d1, d2, r1, data);
  endfunction: display;

  function calc_transaction copy();
    calc_transaction to = new();
    to.port_num = this.port_num;
    to.cmd = this.cmd;
    to.d1 = this.d1;
    to.d2 = this.d2;
    to.r1 = this.r1;
    to.tag = this.tag;
    to.data = this.data;
    copy = to;
  endfunction: copy

  static function calc_transaction new_add(input int _port_num, input bit [0:3] _d1, _d2);
    calc_transaction tr = new();
    tr.port_num = _port_num;
    tr.d1 = _d1;
    tr.d2 = _d2;
    new_add = tr;
  endfunction
endclass
`endif