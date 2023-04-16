class calc_out;
  int port_num;
  bit [0:1] resp;
  bit [0:1] tag;
  bit [0:31] data;

  function new(int _port_num, bit [0:1] _resp, bit [0:1] _tag, bit [0:31] _data);
    this.port_num = _port_num;
    this.resp = _resp;
    this.tag = _tag;
    this.data = _data;
  endfunction

  function string stringify_resp(bit [0:1] _resp);
    if(_resp == 2'b01)
      return "SUCCESS";
    if(_resp == 2'b10)
      return "OU";
    if(_resp == 2'b11)
      return "SKIP";
  endfunction

  function void display();
    $display("[%0t] Port: %0d, Resp: %s, DATA = 0x%0x",
              $time, port_num, stringify_resp(resp), data);
  endfunction;
endclass