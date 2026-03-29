module button_fsm (
    input  logic       clk,    
    input  logic       rst_n,  
    input  logic       btn[3:0],    
    output logic       led    
);

typedef enum logic [4:0] {
    S0 = 5'b00001,   
    S1 = 5'b00010,   
    S2 = 5'b00100,   
    S3 = 5'b01000,   
    S4 = 5'b10000    
} state_t;

state_t state, next_state;


logic [3:0] btn_active;  
logic [3:0] btn_prev;    
logic [3:0] btn_rise;    

assign btn_active = ~btn;
assign btn_rise   = btn_active & ~btn_prev;  


always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) btn_prev <= 4'b0;
    else        btn_prev <= btn_active;
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= S0;
    else        state <= next_state;
end


always_comb begin
    next_state = state;  

    unique case (state)
        S0: if (btn_rise == 4'b0001) next_state = S1; else if (btn_rise != 4'b0) next_state = S0;
        S1: if (btn_rise == 4'b0010) next_state = S2; else if (btn_rise != 4'b0) next_state = S0;
        S2: if (btn_rise == 4'b0100) next_state = S3; else if(btn_rise != 4'b0) next_state = S0;
        S3: if (btn_rise == 4'b1000) next_state = S4; else if(btn_rise != 4'b0) next_state = S0;
        S4: next_state = S4;
        default:          next_state = S0;
    endcase
end

assign led = state[4];  

endmodule
