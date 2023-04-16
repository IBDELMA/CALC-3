`include "calc_env/calc_transaction.sv"
`include "calc_env/calc_transaction.sv"
class calc_scenario;
  static int count = 0;
  string label = "";
  rand int tr_count;
  calc_transaction tr_array[];
  constraint c_trans_count {
    tr_count > 0 && tr_count <= 16;
  }
  function void post_randomize();
    tr_array = new[tr_count];
    foreach(tr_array[i]) begin
      tr_array[i] = new();
      if(!tr_array[i].randomize()) begin
        $display("calc_scenario::post_randomize: randomize() failed");
        $finish;
      end
    end
    count = count + 1;
    $sformat(label, "Random test #%0d", count);
  endfunction
  // function new(string _label, calc_transaction _tr_array[]);
  //   this.label = _label;
  //   this.tr_array = _tr_array;
  //   this.tr_count = _tr_array.size();
  // endfunction
endclass;