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
  reg [LEN_DATA:0] data_in;
  wire [LEN_CNT-1:0] cnt0;
  wire [LEN_CNT-1:0] cnt1;
  wire [LEN_CNT-1:0] cnt2;
  wire [LEN_CNT-1:0] cnt3;
  reg [LEN_DATA:0] cnt_0;
  reg [LEN_DATA:0] cnt_int;
  reg [LEN_CNT-1:0] block_cnt0;
  reg [LEN_CNT-1:0] block_cnt1;
  reg [LEN_CNT-1:0] block_cnt2;
  reg [LEN_CNT-1:0] block_cnt3;
  wire [LEN_CNT-1:0] block_cnt01;
  wire [LEN_CNT-1:0] block_cnt23;
  reg [LEN_CNT-1:0] block_cnt_01;
  reg [LEN_CNT-1:0] block_cnt_23;
  wire [LEN_CNT-1:0] block_cnt_0;
  reg valid_0;
  reg valid_1;
  reg valid_2;
  
    //data in flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      data_in <= #FF_DLY 33'h0;
    end 
    else begin 
      data_in <= #FF_DLY data;
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
  
  always @ (data_in) begin
    cnt_int = 0;
  end
  
  genvar i;
  generate
    for (i=0;i<8;i=i+1) begin : counter0
      always @ (data_in or i) begin
        cnt_0[i] = ((data_in[i] == 0) && (i > 1)) ? (data_in[i-1]*data_in[i-2]) : cnt_int[i];
      end
    end
  endgenerate
  assign cnt0 = cnt_0[0] + cnt_0[1] + cnt_0[2] + cnt_0[3] + cnt_0[4] + cnt_0[5] + cnt_0[6] + cnt_0[7];

  genvar j;
  generate
    for (j=8;j<16;j=j+1) begin : counter1
      always @ (data_in or j) begin
        cnt_0[j] = ((data_in[j] == 0)) ? (data_in[j-1]*data_in[j-2]) : cnt_int[j];
      end
    end
  endgenerate
  assign cnt1 = cnt_0[8] + cnt_0[9] + cnt_0[10] + cnt_0[11] + cnt_0[12] + cnt_0[13] + cnt_0[14] + cnt_0[15];
  
  genvar g;
  generate
    for (g=16;g<24;g=g+1) begin : counter2
      always @ (data_in or g) begin
        cnt_0[g] = ((data_in[g] == 0)) ? (data_in[g-1]*data_in[g-2]) : cnt_int[g];
      end
    end
  endgenerate
  assign cnt2 = cnt_0[16] + cnt_0[17] + cnt_0[18] + cnt_0[19] + cnt_0[20] + cnt_0[21] + cnt_0[22] + cnt_0[23];
  
  genvar h;
  generate
    for (h=24;h<33;h=h+1) begin : counter3
      always @ (data_in or h) begin
        cnt_0[h] = ((data_in[h] == 0)) ? (data_in[h-1]*data_in[h-2]) : cnt_int[h];
      end
    end
  endgenerate
  assign cnt3 = cnt_0[24] + cnt_0[25] + cnt_0[26] + cnt_0[27] + cnt_0[28] + cnt_0[29] + cnt_0[30] + cnt_0[31] + cnt_0[32];
  
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt0 <= #FF_DLY 4'd0;
	end
	else begin
	    block_cnt0 <= #FF_DLY cnt0;
	end
  end
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt1 <= #FF_DLY 4'd0;
	end
	else begin
	  block_cnt1 <= #FF_DLY cnt1;
	end
  end
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt2 <= #FF_DLY 4'd0;
	end
	else begin
	  block_cnt2 <= #FF_DLY cnt2;
	end
  end
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt3 <= #FF_DLY 4'd0;
	end
	else begin
	  block_cnt3 <= #FF_DLY cnt3;
	end
  end
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid_1 <= #FF_DLY 1'b0;
    end
    else begin 
      valid_1 <= #FF_DLY valid_0;
    end
  end
  assign block_cnt01 = block_cnt0 + block_cnt1;
  assign block_cnt23 = block_cnt2 + block_cnt3;
  //enable in flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid_2 <= #FF_DLY 1'b0;
    end
    else begin 
      valid_2 <= #FF_DLY valid_1;
    end
  end
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt_01 <= #FF_DLY 4'd0;
	end
	else begin
	  block_cnt_01 <= #FF_DLY block_cnt01;
	end
  end
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt_23 <= #FF_DLY 4'd0;
	end
	else begin
	  block_cnt_23 <= #FF_DLY block_cnt23;
	end
  end
  
  assign block_cnt_0 = block_cnt_01 + block_cnt_23;
  
  
  
  
  
  
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid <= #FF_DLY 1'b0;
    end
    else begin 
      valid <= #FF_DLY valid_2;
    end
  end
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt <= #FF_DLY 4'd0;
	end
	else begin
      if (valid_2 == 1) begin 
	      block_cnt <= #FF_DLY block_cnt_0;
      end
	end
  end
endmodule
