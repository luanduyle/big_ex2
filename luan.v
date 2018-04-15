module lfu_finder (clk, rst_n, new_buf_req, ref_buf_numbr, buf_num_replc);
/////////// parameter ////////
parameter BUF_0 = 2'd0;
parameter BUF_1 = 2'd1;
parameter BUF_2 = 2'd2;
parameter BUF_3 = 2'd3;
parameter FF_DLY = 1;
parameter LEN = 2;
parameter LEN_F = 8;
////////// port declaration ////////
input clk;
input rst_n;
input new_buf_req;
input [LEN-1:0] ref_buf_numbr;
output [LEN-1:0] buf_num_replc;

wire clk, rst_n;
wire new_buf_req;
wire [LEN-1:0] ref_buf_numbr;
wire [LEN-1:0] buf_num_replc;
///////// internal variable /////////
reg [LEN_F-1:0] access_time;
reg [LEN_F-1:0] n_access_time;
reg [LEN-1:0] min;
reg [LEN-1:0] n_buf_num_replc;
reg [LEN-1:0] temp_buf_num_replc;
/////////////////////////////
assign buf_num_replc = temp_buf_num_replc;
////////// Replacement Flip flop//////////
always @ (posedge clk or negedge rst_n) begin 
  if (rst_n == 1'b0) begin
      temp_buf_num_replc <= #FF_DLY BUF_0;
  end
  else begin
      if (new_buf_req) begin
          temp_buf_num_replc <= #FF_DLY n_buf_num_replc;
      end
  end
end
///////////// Replacement control logic ///////////
always @ (access_time) begin
  min[0] = (access_time[1:0] > access_time[3:2]) ? 1'b1 : 1'b0;
  min[1] = (access_time[5:4] > access_time[7:6]) ? 1'b1 : 1'b0;
  case (min) 
      2'b00: begin 
        n_buf_num_replc = (access_time[1:0] > access_time[5:4]) ? BUF_2 : BUF_0;
      end
      2'b01: begin 
        n_buf_num_replc = (access_time[3:2] > access_time[5:4]) ? BUF_2 : BUF_1;
      end
      2'b10: begin 
        n_buf_num_replc = (access_time[1:0] > access_time[7:6]) ? BUF_3 : BUF_0;
      end
      2'b11: begin 
        n_buf_num_replc = (access_time[3:2] > access_time[7:6]) ? BUF_3 : BUF_1;
      end
  endcase
end
///////counter//////
genvar k;

generate 
  for (k=0;k<=3;k=k+1) begin :
  
  always @ (new_buf_req or ref_buf_numbr or access_time or temp_buf_num_replc) begin
    if (new_buf_req) begin 
      n_access_time[(2*k+1):2*k] = (temp_buf_num_replc == k) ? 2'b01 : access_time[(2*k+1):2*k]; 
    end
    else begin 
      case (access_time[(2*k+1):2*k])
          2'b01 : begin 
            n_access_time[(2*k+1):2*k] = (ref_buf_numbr == k) ? 2'b10 : access_time[(2*k+1):2*k];
          end
          2'b10 : begin 
            n_access_time[(2*k+1):2*k] = (ref_buf_numbr == k) ? 2'b11 : access_time[(2*k+1):2*k];
          end
          2'b11 : begin 
            if (access_time == 8'hFF) begin 
              n_access_time[(2*k+1):2*k] = (ref_buf_numbr == k) ? 2'b10 : 2'b01;
            end
            else begin 
              n_access_time[(2*k+1):2*k] = access_time[(2*k+1):2*k];
            end
          end
          default : begin
            n_access_time[(2*k+1):2*k] = 2'b00;
          end
      endcase
    end
  end
  
    always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
	  access_time[(2*k+1):2*k] <= #FF_DLY 2'b01;
    end
    else begin
      access_time[(2*k+1):2*k] <= #FF_DLY n_access_time[(2*k+1):2*k];
    end
  end
  end
 endgenerate

 
 endmodule