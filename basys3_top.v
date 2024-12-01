module basys3_top (
    input clk,          // Reloj de la Basys3 (50 MHz)
    input reset,        // Botón de reset (BTNC)
    output [6:0] out0,   // Salidas para el display de 7 segmentos
    output [3:0] enable  // Habilitación del display de 7 segmentos
);

    wire clk_div;

    // Divisor de frecuencia para obtener un clk de 1 Hz (aprox.)
    clock_divider clk_div_inst (
        .clk_in(clk),
        .clk_out(clk_div)
    );

    wire [31:0] WriteData;
    wire [31:0] DataAdr;
    wire MemWrite;

    top top_inst (
        .clk(clk_div),  // Conectar al reloj dividido
        .reset(reset),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
    );

    basysdecoder display_ctrl (
        .internal_clk(clk_div), // Reloj interno del decodificador
        .ResultW(DataAdr),     // Resultado del procesador (DataAdr)
        .out0(out0),
        .enable(enable)
    );

endmodule

// Divisor de frecuencia
module clock_divider (
    input clk_in,
    output reg clk_out
);
    reg [25:0] counter = 0;

    always @(posedge clk_in) begin
        counter <= counter + 1;
        if (counter == 25_000_000) begin
            clk_out <= ~clk_out;
            counter <= 0;
        end
    end
endmodule