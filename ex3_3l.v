module bit_block_counter (data, data_enb, clk, rst_n, block_cnt, valid);
  //parameter
  parameter FF_DLY = 1;
  //port
  input [31:0] data;
  input data_enb;
  input clk;
  input rst_n;
  output [3:0] block_cnt;
  output valid;
  //port data type
  wire [31:0] data;
  wire data_enb;
  wire clk;
  wire rst_n;
  reg [3:0] block_cnt;
  reg valid;
  //internal variable
  reg [32:0] data_in;
  reg [33:0] flag;
  reg [3:0] cnt_0;
  reg data_enb_in;
  reg [3:0] cnt_1;
  reg [16:0] data_in_0;
  reg [3:0] block_cnt_0;
  reg valid_0;
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
      data_enb_in <= #FF_DLY 1'b0;
    end
    else begin 
      data_enb_in <= #FF_DLY data_enb;
    end
  end
    /////////counter_0
  genvar i;
  generate
    for (i=0;i<16;i=i+1) begin : counter_0
      always @ (data_in or flag[i] or i) begin
        if (i == 0) begin
          cnt_0 = 0;
          flag = 0;
          flag[i+1] = (flag[i] == 1) ? (flag[i]*data_in[i]) : (flag[i]+data_in[i]);
        end
        else begin
          flag[i+1] = (flag[i] == 1) ? (flag[i]*data_in[i]) : (flag[i]+data_in[i]);
          cnt_0 = ((flag[i+1] == 0)) ? (cnt_0 + flag[i]*flag[i-1]) : cnt_0;
        end
      end
    end
  endgenerate
  //////////////
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      block_cnt_0 <= #FF_DLY 4'd0; 
    end
    else begin 
      block_cnt_0 <= #FF_DLY cnt_0;
    end
  end
///////////////////////////////
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      valid_0 <= #FF_DLY 1'b0;  
    end
    else begin
      valid_0 <= #FF_DLY data_enb_in;
    end
  end
/////////////////////////////////////
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      data_in_0 <= #FF_DLY 17'h0;
    end
    else begin 
      data_in_0 <= #FF_DLY data_in[32:16];
    end
  end
////////counter_1
  genvar k;
  generate
    for (k=0;k<17;k=k+1) begin : counter_1
      always @ (data_in or flag[k+16] or k) begin
        if (k == 0) begin
          cnt_1 = block_cnt_0;
          flag[k+17] = (flag[k+16] == 1) ? (flag[k+16]*data_in_0[k]) : (flag[k+16]+data_in_0[k]);
        end
        else begin
          flag[k+17] = (flag[k+16] == 1) ? (flag[k+16]*data_in_0[k]) : (flag[k+16]+data_in_0[k]);
          cnt_1 = ((flag[k+17] == 0)) ? (cnt_1 + flag[k+16]*flag[k+15]) : cnt_1;
        end
      end
    end
  endgenerate

  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	    valid <= #FF_DLY 1'b0;
	  end
	  else begin 
	    valid <= #FF_DLY valid_0;
	  end
  end
  //block_cnt flipflop////////////////////////////
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	    block_cnt <= #FF_DLY 4'd0;
	  end
	  else begin 
	    block_cnt <= #FF_DLY cnt_1;
	  end
  end
endmodule

