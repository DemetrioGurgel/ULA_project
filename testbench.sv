module testbench;

    // Declaração das variáveis e módulos
    reg clk;
    reg rst;
    reg [2:0] crtl_ula;
    reg ctrl_des;
    wire flag_ula;
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] a_before_op;
    reg [7:0] b_before_op;
    wire [7:0] c;

    // Instancia o módulo ULA
    ula ULA_inst (
        .clk(clk),
        .rst(rst),
        .crtl_ula(crtl_ula),
        .ctrl_des(ctrl_des),
        .flag_ula(flag_ula),
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        // Configuração inicial
        clk = 0;
        rst = 1;
        crtl_ula = 3'b000;
        ctrl_des = 0;
        a = $random; // Gera valor aleatório para 'a'
        b = $random; // Gera valor aleatório para 'b'
        a_before_op = a;
        b_before_op = b;
        #1;

        // Desativa o reset
        rst = 0;
        #100;

        // Teste de Soma
        crtl_ula = 3'b000;
        a = $random; // Gera novo valor aleatório para 'a'
        b = $random; // Gera novo valor aleatório para 'b'
        a_before_op = a;
        b_before_op = b;
        #100;

        // Exibe valores e resultado da operação de soma
        $display("Operação: Soma");
        $display("a: %b, b: %b, Resultado: %b", a_before_op, b_before_op, c);

        // Teste de Subtração
        crtl_ula = 3'b001;
        a = $random; // Gera novo valor aleatório para 'a'
        b = $random; // Gera novo valor aleatório para 'b'
        a_before_op = a;
        b_before_op = b;
        #100;

        // Exibe valores e resultado da operação de subtração
        $display("Operação: Subtração");
        $display("a: %b, b: %b, Resultado: %b", a_before_op, b_before_op, c);

        // Teste de Multiplicação
        crtl_ula = 3'b010;
        a = $random; // Gera novo valor aleatório para 'a'
        b = $random; // Gera novo valor aleatório para 'b'
        a_before_op = a;
        b_before_op = b;
        #100;

        // Exibe valores e resultado da operação de multiplicação
        $display("Operação: Multiplicação");
        $display("a: %b, b: %b, Resultado: %b", a_before_op, b_before_op, c);

        // Teste de Divisão
        crtl_ula = 3'b011;
        a = $random; // Gera novo valor aleatório para 'a'
        b = $random; // Gera novo valor aleatório para 'b'
        a_before_op = a;
        b_before_op = b;
        #100;

        // Exibe valores e resultado da operação de divisão
        $display("Operação: Divisão");
        $display("a: %b, b: %b, Resultado: %b", a_before_op, b_before_op, c);

        // Teste de AND
        crtl_ula = 3'b100;
        a = $random; // Gera novo valor aleatório para 'a'
        b = $random; // Gera novo valor aleatório para 'b'
        a_before_op = a;
        b_before_op = b;
        #100;

        // Exibe valores e resultado da operação de AND
        $display("Operação: AND");
        $display("a: %b, b: %b, Resultado: %b", a_before_op, b_before_op, c);

        // Teste de OR
        crtl_ula = 3'b101;
        a = $random; // Gera novo valor aleatório para 'a'
        b = $random; // Gera novo valor aleatório para 'b'
        a_before_op = a;
        b_before_op = b;
        #100;

        // Exibe valores e resultado da operação de OR
        $display("Operação: OR");
        $display("a: %b, b: %b, Resultado: %b", a_before_op, b_before_op, c);

        // Teste de NOT
        crtl_ula = 3'b110;
        a = $random; // Gera novo valor aleatório para 'a'
        a_before_op = a;
        #100;

        // Exibe valores e resultado da operação de NOT
        $display("Operação: NOT");
        $display("a: %b, Resultado: %b", a_before_op, c);

        // Teste de BYPASS
        crtl_ula = 3'b111;
        b = $random; // Gera novo valor aleatório para 'b'
        b_before_op = b;
        #100;

        // Exibe valores e resultado da operação de BYPASS
        $display("Operação: BYPASS");
        $display("b: %b, Resultado: %b", b_before_op, c);

        #10;

        // Finaliza a simulação
        $finish;
    end

    // Gera um clock para simulação
    always begin
        #5 clk = ~clk;
    end

    // Inicialização da simulação
    initial begin
        $dumpfile("sim_dump.vcd");
        $dumpvars(0, testbench);
        $display("Iniciando simulação...");
    end

endmodule
