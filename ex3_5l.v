module bit_block_counter (data, data_enb, clk, rst_n, block_cnt, valid);
  //parameter
  parameter FF_DLY = 1;
  parameter LEN_DATA = 32;
  parameter LEN_CNT = 4;
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
  reg [24:0] data_in_1;
  reg [16:0] data_in_2;
  reg [8:0]  data_in_3;
  
  reg [LEN_DATA+1:0] flag;
  
  reg [LEN_CNT-1:0] cnt_0;
  reg [LEN_CNT-1:0] cnt_1;
  reg [LEN_CNT-1:0] cnt_2;
  reg [LEN_CNT-1:0] cnt_3;
  
  reg [LEN_CNT-1:0] block_cnt_0;
  reg [LEN_CNT-1:0] block_cnt_1;
  reg [LEN_CNT-1:0] block_cnt_2;
  
  reg valid_0;
  reg valid_1;
  reg valid_2;
  reg valid_3;
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
      valid_0 <= #FF_DLY 1'b0;
    end
    else begin 
      valid_0 <= #FF_DLY data_enb;
    end
  end
      //////////////////////////counter_0/////////////////////////
  genvar i;
  generate
    for (i=0;i<8;i=i+1) begin : counter_0
      always @ (data_in_0 or flag[i] or i) begin
        if (i == 0) begin
          cnt_0 = 0;
          flag = 0;
          flag[i+1] = (flag[i] == 1) ? (flag[i]*data_in_0[i]) : (flag[i]+data_in_0[i]);
        end
        else begin
          flag[i+1] = (flag[i] == 1) ? (flag[i]*data_in_0[i]) : (flag[i]+data_in_0[i]);
          cnt_0 = ((flag[i+1] == 0)) ? (cnt_0 + flag[i]*flag[i-1]) : cnt_0;
        end
      end
    end
  endgenerate
  //data in of counter_1
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_1 <= #FF_DLY 25'h0;
    end
    else begin 
      data_in_1 <= #FF_DLY data_in_0[32:8];
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
      valid_1 <= #FF_DLY 1'b0;  
    end
    else begin
      valid_1 <= #FF_DLY valid_0;
    end
  end
 //////////////////////////////counter_1////////////////////////////
  genvar j;
  generate
    for (j=0;j<8;j=j+1) begin : counter_1
      always @ (data_in_1 or flag[j+8] or j) begin
        if (k == 0) begin
          cnt_1 = block_cnt_0;
          flag[j+9] = (flag[j+8] == 1) ? (flag[j+8]*data_in_1[j]) : (flag[j+8]+data_in_1[j]);
		  cnt_1 = ((flag[j+9] == 0)) ? (cnt_1 + flag[j+8]*flag[j+7]) : cnt_1;
        end
        else begin
          flag[j+9] = (flag[j+8] == 1) ? (flag[j+8]*data_in_1[j]) : (flag[j+8]+data_in_1[j]);
          cnt_1 = ((flag[j+9] == 0)) ? (cnt_1 + flag[j+8]*flag[j+7]) : cnt_1;
        end
      end
    end
  endgenerate
   //data in of counter_2
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_2 <= #FF_DLY 17'h0;
    end
    else begin 
      data_in_2 <= #FF_DLY data_in_1[24:8];
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
      valid_2 <= #FF_DLY 1'b0;  
    end
    else begin
      valid_2 <= #FF_DLY valid_1;
    end
  end
  //////////////////////////////counter_2////////////////////////////
  genvar k;
  generate
    for (k=0;k<8;k=k+1) begin : counter_2
      always @ (data_in_2 or flag[k+16] or k) begin
        if (k == 0) begin
          cnt_2 = block_cnt_1;
          flag[k+17] = (flag[k+16] == 1) ? (flag[k+16]*data_in_2[k]) : (flag[k+16]+data_in_2[k]);
		  cnt_2 = ((flag[k+17] == 0)) ? (cnt_2 + flag[k+16]*flag[k+15]) : cnt_2;
        end
        else begin
          flag[k+17] = (flag[k+16] == 1) ? (flag[k+16]*data_in_2[k]) : (flag[k+16]+data_in_2[k]);
          cnt_2 = ((flag[k+17] == 0)) ? (cnt_2 + flag[k+16]*flag[k+15]) : cnt_2;
        end
      end
    end
  endgenerate
   //data in of counter_3
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_3 <= #FF_DLY 9'h0;
    end
    else begin 
      data_in_3 <= #FF_DLY data_in_2[16:8];
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
  // valid of counter_1
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid_3 <= #FF_DLY 1'b0;  
    end
    else begin
      valid_3 <= #FF_DLY valid_2;
    end
  end
    //////////////////////////////counter_3////////////////////////////
  genvar l;
  generate
    for (l=0;l<9;l=l+1) begin : counter_3
      always @ (data_in_3 or flag[l+24] or l) begin
        if (l == 0) begin
          cnt_3 = block_cnt_2;
          flag[l+25] = (flag[l+24] == 1) ? (flag[l+24]*data_in_3[l]) : (flag[l+24]+data_in_3[l]);
		  cnt_3 = ((flag[l+25] == 0)) ? (cnt_3 + flag[l+24]*flag[l+23]) : cnt_3;
        end
        else begin
          flag[l+25] = (flag[l+24] == 1) ? (flag[l+24]*data_in_3[l]) : (flag[l+24]+data_in_3[l]);
          cnt_3 = ((flag[l+25] == 0)) ? (cnt_3 + flag[l+24]*flag[l+23]) : cnt_3;
        end
      end
    end
  endgenerate
  // number block bit 1 of counter_3
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt <= #FF_DLY cnt_3;
    end
  end
  // valid of counter_3
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid <= #FF_DLY 1'b0;  
    end
    else begin
      valid <= #FF_DLY valid_3;
    end
  end
  