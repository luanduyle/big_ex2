module bit_block_counter (data, data_enb, clk, rst_n, block_cnt, valid);
  //parameter
  parameter FF_DLY = 1;
  parameter LEN_DATA = 32;
  parameter LEN_CNT = 4;
  parameter INTL = 0;
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
  reg [LEN_DATA:0] cnt_0;
  
  wire [11:0] cnt;
   
  reg [11:0] block_cnt0;
  wire [6:0] block_cnt1;
  reg [6:0] block_cnt2;
  
  wire [LEN_CNT-1:0] block_cnt_0;
  
  reg valid_0;
  reg valid_1;
  reg valid_2;
  
      //data in flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      data_in <= #FF_DLY INTL;
    end 
    else begin 
      data_in <= #FF_DLY data;
    end
  end
  //enable in flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid_0 <= #FF_DLY INTL;
    end
    else begin 
      valid_0 <= #FF_DLY data_enb;
    end
  end
  
  genvar i;
  generate
    for (i=0;i<33;i=i+1) begin : counter0
      always @ (data_in or i) begin
        cnt_0[i] = ((data_in[i] == 0) && (i > 1)) ? (data_in[i-1]*data_in[i-2]) : INTL;
      end
    end
  endgenerate
  assign cnt[1:0] = cnt_0[0] + cnt_0[1] + cnt_0[2] + cnt_0[3] + cnt_0[4] + cnt_0[5];
  assign cnt[3:2] = cnt_0[6] + cnt_0[7] + cnt_0[8] + cnt_0[9] + cnt_0[10] + cnt_0[11];
  assign cnt[5:4] = cnt_0[12] + cnt_0[13] + cnt_0[14] + cnt_0[15] + cnt_0[16] + cnt_0[17];
  assign cnt[7:6] = cnt_0[18] + cnt_0[19] + cnt_0[20] + cnt_0[21] + cnt_0[22] + cnt_0[23];
  assign cnt[9:8] = cnt_0[24] + cnt_0[25] + cnt_0[26] + cnt_0[27] + cnt_0[28] + cnt_0[29];
  assign cnt[11:10] = cnt_0[30] + cnt_0[31] + cnt_0[32];
  //Latency 2
  genvar j;
  generate 
	for (j=0;j<6;j=j+1) begin : latency2
	  always @ (posedge clk or negedge rst_n) begin 
        if (rst_n == 0) begin 
		  block_cnt0[(2*j+1):2*j] <= #FF_DLY INTL;
		end
		else begin
		  block_cnt0[(2*j+1):2*j] <= #FF_DLY cnt[(2*j+1):2*j];
		end
      end
	end
  endgenerate
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid_1 <= #FF_DLY INTL;
    end
    else begin 
      valid_1 <= #FF_DLY valid_0;
    end
  end
  assign block_cnt1[2:0] = block_cnt0[1:0] + block_cnt0[3:2] + block_cnt0[5:4];
  assign block_cnt1[5:3] = block_cnt0[7:6] + block_cnt0[9:8] + block_cnt0[11:10];
  //Latency 3
  genvar z;
  generate
	for (z=0;z<2;z=z+1) begin : latency3
	  always @ (posedge clk or negedge rst_n) begin 
		if (rst_n == 0) begin 
		  block_cnt2[(3*z+2):3*z] <= #FF_DLY INTL;
		end
		else begin
		  block_cnt2[(3*z+2):3*z] <= #FF_DLY block_cnt1[(3*z+2):3*z];
		end
	  end
	end
  endgenerate
  
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt_345 <= #FF_DLY INTL;
	end
	else begin
	  block_cnt_345 <= #FF_DLY block_cnt345;
	end
  end
  
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid_2 <= #FF_DLY INTL;
    end
    else begin 
      valid_2 <= #FF_DLY valid_1;
    end
  end
  assign block_cnt_0 = block_cnt2[2:0] + block_cnt2[5:3];
  //Latency 4
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt <= #FF_DLY INTL;
	end
	else begin
	  if (valid_2 == 1) begin
	    block_cnt <= #FF_DLY block_cnt_0;
	  end
	end
  end
  
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid <= #FF_DLY INTL;
    end
    else begin 
      valid <= #FF_DLY valid_2;
    end
  end
endmodule