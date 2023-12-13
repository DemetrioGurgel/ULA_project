module ula (
    input wire clk, // Entrada de clock
    input wire rst, // Entrada de reset
  	input wire [2:0] crtl_ula, // Entrada de controle da unidade lógica e aritmética ULA
    input wire ctrl_des, // Entrada de controle para deslocamento
    output wire flag_ula, // Saída da flag da ULA
  	input wire signed [7:0] a, // Entrada 'a' de 8 bits
  	input wire signed [7:0] b, // Entrada 'b' de 8 bits
  	output wire signed [7:0] c // Entrada 'c' de 8 bits
);

        typedef enum logic [2:0] {
        Estado_SOMA = 3'b000,
        Estado_SUBTRACAO = 3'b001,
        Estado_MULTIPLICACAO = 3'b010,
        Estado_DIVISAO = 3'b011,
        Estado_AND = 3'b100,
        Estado_OR = 3'b101,
        Estado_NOT = 3'b110,
        Estado_BYPASS = 3'b111  
    } ULAState;

    ULAState current_state, next_state;
    reg [7:0] result;
    reg flag_ula_reg;

    // Bloco sempre ativo na borda de subida do clock ou na borda de subida do reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Estado inicial ao detectar borda de subida no reset
            current_state <= Estado_SOMA;
            result <= 8'b0;
            flag_ula_reg <= 1'b0;
        end else begin
            // Atualiza o estado atual com o próximo estado calculado
            current_state <= next_state;

            // Lógica para cada estado
            case (current_state)
                Estado_SOMA: begin
                    // Realiza a operação de soma
                    result <= a + b;
                    flag_ula_reg <= 1'b1; // Ativa a flag de resultado válido
                end

                Estado_SUBTRACAO: begin
                    // Realiza a operação de subtração
                    result <= a - b;
                    flag_ula_reg <= 1'b1;
                end

                Estado_MULTIPLICACAO: begin
                    // Realiza a operação de multiplicação
                    result <= a * b;
                    flag_ula_reg <= 1'b1;
                end

                Estado_DIVISAO: begin
                    // Verifica se o divisor é zero antes de realizar a operação de divisão
                    if (b != 0) begin
                        result <= a / b;
                        flag_ula_reg <= 1'b1;
                    end else begin
                        result <= 8'b0;
                        flag_ula_reg <= 1'b0;
                    end
                end

                Estado_AND: begin
                    // Realiza a operação lógica AND bit-a-bit
                    result <= a & b;
                    flag_ula_reg <= 1'b1;
                end

                Estado_OR: begin
                    // Realiza a operação lógica OR bit-a-bit
                    result <= a | b;
                    flag_ula_reg <= 1'b1;
                end

                Estado_NOT: begin
                    // Realiza a operação lógica NOT bit-a-bit em A
                    result <= ~a;
                    flag_ula_reg <= 1'b1;
                end

                Estado_BYPASS: begin
                    // Realiza a operação de bypass, resultando em B
                    result <= b;
                    flag_ula_reg <= 1'b1;
                end

                default: begin
                    // Estado padrão
                    result <= 8'b0;
                    flag_ula_reg <= 1'b0;
                end
            endcase
        end
    end

    // Bloco sempre ativo quando qualquer uma das entradas muda
    always_ff @(*) begin
        // Lógica de transição de estados baseada no sinal de controle crtl_ula
        case (crtl_ula)
            3'b000: next_state = Estado_SOMA;
            3'b001: next_state = Estado_SUBTRACAO;
            3'b010: next_state = Estado_MULTIPLICACAO;
            3'b011: next_state = Estado_DIVISAO;
            3'b100: next_state = Estado_AND;
            3'b101: next_state = Estado_OR;
            3'b110: next_state = Estado_NOT;
            3'b111: next_state = Estado_BYPASS;
            default: next_state = Estado_SOMA;
        endcase
    end

    // Atribui a saída de flag da ULA
    assign flag_ula = flag_ula_reg;

    // Atribui a saída da ULA, com deslocamento à esquerda se ctrl_des for 1
    assign c = (ctrl_des) ? {result[6:0], 1'b0} : result;

endmodule