module bit_block_counter (data, data_enb, clk, rst_n, block_cnt, valid);
  //parameter
  parameter FF_DLY = 1;
  parameter LEN_DATA = 32;
  parameter LEN_CNT = 4;
  parameter INT_CNT = 4'b0;
  parameter INT_ENB = 1'b0;
  //port
  input [LEN_DATA-1:0] data;
  input data_enb;
  input clk;
  input rst_n;
  output [LEN_CNT-1:0] block_cnt;
  output valid;
  //port data type
  wire [LEN_DATA-1:0] data;
  wire data_enb;
  wire clk;
  wire rst_n;
  reg [LEN_CNT-1:0] block_cnt;
  reg valid;
    //internal variable
  reg [LEN_DATA:0] data_in_0;
  reg [27:0]       data_in_1;
  reg [22:0]       data_in_2;
  reg [17:0]       data_in_3;
  reg [12:0]       data_in_4;
  reg [7:0]        data_in_5;
  reg [2:0]        data_in_6;
  
  reg [LEN_DATA+1:0] flag;
  
  reg [LEN_CNT-1:0] cnt_0;
  reg [LEN_CNT-1:0] cnt_1;
  reg [LEN_CNT-1:0] cnt_2;
  reg [LEN_CNT-1:0] cnt_3;
  reg [LEN_CNT-1:0] cnt_4;
  reg [LEN_CNT-1:0] cnt_5;
  reg [LEN_CNT-1:0] cnt_6;
  
  reg [LEN_CNT-1:0] block_cnt_0;
  reg [LEN_CNT-1:0] block_cnt_1;
  reg [LEN_CNT-1:0] block_cnt_2;
  reg [LEN_CNT-1:0] block_cnt_3;
  reg [LEN_CNT-1:0] block_cnt_4;
  reg [LEN_CNT-1:0] block_cnt_5;
  
  reg valid_0;
  reg valid_1;
  reg valid_2;
  reg valid_3;
  reg valid_4;
  reg valid_5;
  reg valid_6;
    //data in flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      data_in_0 <= #FF_DLY 33'h0;
    end 
    else begin 
      data_in_0 <= #FF_DLY data;
    end
  end
    //enable in flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid_0 <= #FF_DLY INT_ENB;
    end
    else begin 
      valid_0 <= #FF_DLY data_enb;
    end
  end
  //////////////////////////counter_0/////////////////////////
  genvar a;
  generate
    for (a=0;a<5;a=a+1) begin : counter_0
      always @ (data_in_0 or flag[a] or a) begin
        if (a == 0) begin
          cnt_0 = 0;
          flag = 0;
          flag[a+1] = (flag[a] == 1) ? (flag[a]*data_in_0[a]) : (flag[a]+data_in_0[a]);
        end
        else begin
          flag[a+1] = (flag[a] == 1) ? (flag[a]*data_in_0[a]) : (flag[a]+data_in_0[a]);
          cnt_0 = ((flag[a+1] == 0)) ? (cnt_0 + flag[a]*flag[a-1]) : cnt_0;
        end
      end
    end
  endgenerate
   //data in of counter_1
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_1 <= #FF_DLY 28'h0;
    end
    else begin 
      data_in_1 <= #FF_DLY data_in_0[32:5];
    end
  end
  // number block bit 1 of counter_0
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt_0 <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt_0 <= #FF_DLY cnt_0;
    end
  end
  // valid of counter_0
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid_1 <= #FF_DLY INT_ENB;  
    end
    else begin
      valid_1 <= #FF_DLY valid_0;
    end
  end
  //////////////////////////////counter_1////////////////////////////
  genvar b;
  generate
    for (b=0;b<5;b=b+1) begin : counter_1
      always @ (data_in_1 or flag[b+5] or b) begin
        if (b == 0) begin
          cnt_1 = block_cnt_0;
          flag[b+6] = (flag[b+5] == 1) ? (flag[b+5]*data_in_1[b]) : (flag[b+5]+data_in_1[b]);
		  cnt_1 = ((flag[b+6] == 0)) ? (cnt_1 + flag[b+5]*flag[b+4]) : cnt_1;
        end
        else begin
          flag[b+6] = (flag[b+5] == 1) ? (flag[b+5]*data_in_1[b]) : (flag[b+5]+data_in_1[b]);
          cnt_1 = ((flag[b+6] == 0)) ? (cnt_1 + flag[b+5]*flag[b+4]) : cnt_1;
        end
      end
    end
  endgenerate
   //data in of counter_2
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_2 <= #FF_DLY 23'h0;
    end
    else begin 
      data_in_2 <= #FF_DLY data_in_1[27:5];
    end
  end
  // number block bit 1 of counter_1
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt_1 <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt_1 <= #FF_DLY cnt_1;
    end
  end
  // valid of counter_1
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid_2 <= #FF_DLY INT_ENB;  
    end
    else begin
      valid_2 <= #FF_DLY valid_1;
    end
  end
    //////////////////////////////counter_2////////////////////////////
  genvar c;
  generate
    for (c=0;c<5;c=c+1) begin : counter_1
      always @ (data_in_2 or flag[c+10] or c) begin
        if (c == 0) begin
          cnt_2 = block_cnt_1;
          flag[c+11] = (flag[c+10] == 1) ? (flag[c+10]*data_in_2[c]) : (flag[c+10]+data_in_2[c]);
		  cnt_2 = ((flag[c+11] == 0)) ? (cnt_2 + flag[c+10]*flag[c+9]) : cnt_2;
        end
        else begin
          flag[c+11] = (flag[c+10] == 1) ? (flag[c+10]*data_in_2[c]) : (flag[c+10]+data_in_2[c]);
          cnt_2 = ((flag[c+11] == 0)) ? (cnt_2 + flag[c+10]*flag[c+9]) : cnt_2;
        end
      end
    end
  endgenerate
   //data in of counter_3
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_3 <= #FF_DLY 18'h0;
    end
    else begin 
      data_in_3 <= #FF_DLY data_in_2[22:5];
    end
  end
  // number block bit 1 of counter_2
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt_2 <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt_2 <= #FF_DLY cnt_2;
    end
  end
  // valid of counter_2
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid_3 <= #FF_DLY INT_ENB;  
    end
    else begin
      valid_3 <= #FF_DLY valid_2;
    end
  end
    //////////////////////////////counter_3////////////////////////////
  genvar d;
  generate
    for (d=0;d<5;d=d+1) begin : counter_3
      always @ (data_in_3 or flag[d+15] or d) begin
        if (d == 0) begin
          cnt_3 = block_cnt_2;
          flag[d+16] = (flag[d+15] == 1) ? (flag[d+15]*data_in_3[d]) : (flag[d+15]+data_in_3[d]);
		  cnt_3 = ((flag[d+16] == 0)) ? (cnt_3 + flag[d+15]*flag[d+14]) : cnt_3;
        end
        else begin
          flag[d+16] = (flag[d+15] == 1) ? (flag[d+15]*data_in_3[d]) : (flag[d+15]+data_in_3[d]);
          cnt_3 = ((flag[d+16] == 0)) ? (cnt_3 + flag[d+15]*flag[d+14]) : cnt_3;
        end
      end
    end
  endgenerate
   //data in of counter_4
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_4 <= #FF_DLY 13'h0;
    end
    else begin 
      data_in_4 <= #FF_DLY data_in_3[17:5];
    end
  end
  // number block bit 1 of counter_3
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt_3 <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt_3 <= #FF_DLY cnt_3;
    end
  end
  // valid of counter_3
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid_4 <= #FF_DLY INT_ENB;  
    end
    else begin
      valid_4 <= #FF_DLY valid_3;
    end
  end
   //////////////////////////////counter_4////////////////////////////
  genvar e;
  generate
    for (e=0;e<5;e=e+1) begin : counter_4
      always @ (data_in_4 or flag[e+20] or e) begin
        if (e == 0) begin
          cnt_4 = block_cnt_3;
          flag[e+21] = (flag[e+20] == 1) ? (flag[e+20]*data_in_4[e]) : (flag[e+20]+data_in_4[e]);
		  cnt_4 = ((flag[e+21] == 0)) ? (cnt_4 + flag[e+20]*flag[e+19]) : cnt_4;
        end
        else begin
          flag[e+21] = (flag[e+20] == 1) ? (flag[e+20]*data_in_4[e]) : (flag[e+20]+data_in_4[e]);
          cnt_4 = ((flag[e+21] == 0)) ? (cnt_4 + flag[e+20]*flag[e+19]) : cnt_4;
        end
      end
    end
  endgenerate
   //data in of counter_5
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_5 <= #FF_DLY 8'h0;
    end
    else begin 
      data_in_5 <= #FF_DLY data_in_4[12:5];
    end
  end
  // number block bit 1 of counter_4
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt_4 <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt_4 <= #FF_DLY cnt_4;
    end
  end
  // valid of counter_4
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid_5 <= #FF_DLY INT_ENB;  
    end
    else begin
      valid_5 <= #FF_DLY valid_4;
    end
  end
   //////////////////////////////counter_5////////////////////////////
  genvar f;
  generate
    for (f=0;f<5;f=f+1) begin : counter_5
      always @ (data_in_5 or flag[f+25] or f) begin
        if (f == 0) begin
          cnt_5 = block_cnt_4;
          flag[f+26] = (flag[f+25] == 1) ? (flag[f+25]*data_in_5[f]) : (flag[f+25]+data_in_5[f]);
		  cnt_5 = ((flag[f+26] == 0)) ? (cnt_5 + flag[f+25]*flag[f+24]) : cnt_5;
        end
        else begin
          flag[f+26] = (flag[f+25] == 1) ? (flag[f+25]*data_in_5[f]) : (flag[f+25]+data_in_5[f]);
          cnt_5 = ((flag[f+26] == 0)) ? (cnt_5 + flag[f+25]*flag[f+24]) : cnt_5;
        end
      end
    end
  endgenerate
   //data in of counter_6
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_6 <= #FF_DLY 3'h0;
    end
    else begin 
      data_in_6 <= #FF_DLY data_in_5[8:5];
    end
  end
  // number block bit 1 of counter_5
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt_5 <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt_5 <= #FF_DLY cnt_5;
    end
  end
  // valid of counter_5
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid_6 <= #FF_DLY INT_ENB;  
    end
    else begin
      valid_6 <= #FF_DLY valid_5;
    end
  end
     //////////////////////////////counter_6////////////////////////////
  genvar g;
  generate
    for (g=0;g<3;g=g+1) begin : counter_6
      always @ (data_in_6 or flag[g+30] or g) begin
        if (g == 0) begin
          cnt_6 = block_cnt_5;
          flag[g+31] = (flag[g+30] == 1) ? (flag[g+30]*data_in_6[g]) : (flag[g+30]+data_in_6[g]);
		  cnt_6 = ((flag[g+31] == 0)) ? (cnt_6 + flag[g+30]*flag[g+29]) : cnt_6;
        end
        else begin
          flag[g+31] = (flag[g+30] == 1) ? (flag[g+30]*data_in_6[g]) : (flag[g+30]+data_in_6[g]);
          cnt_6 = ((flag[g+31] == 0)) ? (cnt_6 + flag[g+30]*flag[g+29]) : cnt_6;
        end
      end
    end
  endgenerate
  // number block bit 1 of counter_6
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt <= #FF_DLY cnt_6;
    end
  end
  // valid of counter_6
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid <= #FF_DLY INT_ENB;  
    end
    else begin
      valid <= #FF_DLY valid_6;
    end
  end
endmodule
