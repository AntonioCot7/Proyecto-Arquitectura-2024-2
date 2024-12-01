module testbench;
  reg clk;
  reg reset;
  wire [31:0] WriteData;
  wire [31:0] DataAdr;
  wire MemWrite;

  top dut (
    .clk(clk),
    .reset(reset),
    .WriteData(WriteData),
    .DataAdr(DataAdr),
    .MemWrite(MemWrite)
  );

  initial begin
    reset <= 1;
    #22;
    reset <= 0;
    #500;  // Simular durante 500 unidades de tiempo
    $finish; // Finalizar la simulación
  end

  always begin
    clk <= 1;
    #5;
    clk <= 0;
    #5;
  end

initial begin
  $dumpfile("testbench.vcd");
  $dumpvars();

end
endmodule