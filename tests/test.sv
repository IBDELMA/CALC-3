`include "env/env.sv"
program test(calc_interface io);
env test_env;
initial begin
  test_env = new(io);
  test_env.run();
  $finish;
end 
endprogram
