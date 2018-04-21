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
  reg [3:0] cnt;
  reg data_enb_in;

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
  //valid flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	    valid <= #FF_DLY 1'b0;
	  end
	  else begin 
	    valid <= #FF_DLY data_enb_in;
	  end
  end
  //block_cnt flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
	  block_cnt <= #FF_DLY 4'd0;
	end
	else begin 
	  block_cnt <= #FF_DLY cnt;
	end
  end
  
  genvar i;
  generate
    for (i=0;i<33;i=i+1) begin : counter
      always @ (data_in or flag[i] or i) begin
        if (i == 0) begin
          cnt = 0;
          flag = 0;
          flag[i+1] = (flag[i] == 1) ? (flag[i]*data_in[i]) : (flag[i]+data_in[i]);
        end
        else begin
          flag[i+1] = (flag[i] == 1) ? (flag[i]*data_in[i]) : (flag[i]+data_in[i]);
          cnt = ((flag[i+1] == 0)) ? (cnt + flag[i]*flag[i-1]) : cnt;
        end
        //cnt = (i == 0) ? 0 : cnt;
        //flag = (i == 0) ? 0 : flag;
        //if (flag[i] == 1) begin 
        //  flag[i+1] = flag[i]*data[i];
        //  flag[i+2] = flag[i]*flag[i+1];
        //  cnt = ((flag[i+1] == 0) && (i>0)) ? (cnt + flag[i]*flag[i-1]) : cnt; 
        //end
		    //else begin 
		    //  flag[i+1] = flag[i] + data[i];
		    //end
      end
    end
    //flag[33] = (flag[32])*(flag[31]);
  endgenerate
  
endmodule


/* module counter (data, data_enb, flag_in, temp_block_cnt, clk, rst_n, flag_out, block_cnt, valid)
  //parameter
  parameter FF_DLY = 1;
  parameter BLOCK = 0;
  //port
  input [7:0] data;
  input data_enb;
  input flag_in;
  input [3:0] temp_block_cnt;
  input clk;
  input rst_n;
  output flag_out;
  output block_cnt;
  output valid;
  //port data type
  wire [7:0] data;
  wire data_enb;
  wire flag;
  wire [qw3:0] temp_block_cnt;
  wire clk;
  wire rst_n;
  reg [4:0] block_cnt;
  reg valid;
  //internal variable
  reg [7:0] data_in;
  reg data_enb_in;
  reg [7:0]flag;
  //counter flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin 
      block_cnt <= #FF_DLY 4'h0;
    end 
    else begin 
      block_cnt <= #FF_DLY nx_block_cnt;
    end
  end
  //enable flipflop
  always @ (posedge clk or negedge rst_n) begin 
    if (rst_n == 0) begin
      valid <= #FF_DLY 1'b0;
    end
    else begin 
      valid <= #FF_DLY data_enb;
    end
  end
  //count blocks bit 1
  genvar i;
  generate 
    for (i=0;i<8;i=i+1) begin : counter
      always @ (data or flag or block_cnt) begin 
        if (flag[i] == 1) begin 
          flag[i+1] = flag*data[i+8*BLOCK];
          block_cnt = (flag[i+1] == 1) ? 
        end
      end
    end
  endgenerate

endmodule */
