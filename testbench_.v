
module testbench;
// Declare 
  reg clk;
  reg rst_n;
  reg new_buf_req;
  reg [1:0] ref_buf_numbr;
  wire [1:0] buf_num_replc;
//*****  Parameter declaration  *****  
  parameter HALF_CYCLE = 5;
  parameter CYCLE = HALF_CYCLE *2;
  
lfu_finder lfu_finder_01(
      .clk(clk), 
      .rst_n(rst_n), 
      .new_buf_req(new_buf_req), 
      .ref_buf_numbr(ref_buf_numbr),
      .buf_num_replc (buf_num_replc)
);

always begin
   clk = 1'b0;
    # HALF_CYCLE clk = 1'b1 ;
    # HALF_CYCLE ;   
end

always @ ( posedge clk ) begin
#1 $strobe ("t= %d, rst_n=%b, clk=%b, new_buf_req=%d, ref_buf_numbr=%d, buf_num_replc=%d, access_time[7:6]=%d, access_time[5:4]=%d, access_time[3:2]=%d, access_time[1:0]=%d, flag=%d, n_buf_num_replc=%d, buf_num_replc=%d",
$stime, rst_n, clk, new_buf_req, ref_buf_numbr, buf_num_replc, lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0],&(lfu_finder_01.flag),lfu_finder_01.n_buf_num_replc,lfu_finder_01.buf_num_replc);
end

initial begin
    rst_n = 0 ;
    #(CYCLE * 3 ) rst_n = 1'b1 ;
    $display(" ");
    $display("*******************************************************************************************************");
    $display("** Case 1: Reset test *********************************************************************************");
    $display("** Expectation: access time will be reset to 8'b01_01_01_01 *******************************************");
    $display("*******************************************************************************************************");
    $display(" ");
    #(CYCLE*5);
    rst_n = 1'b0; 
    #(CYCLE);
    rst_n = 1'b1;
	     $display(" ");
    if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b01_01_01_01) 
	     $display("================================================ PASS =================================================");
    else $display("================================================ FAIL =================================================");
         //$display(" ");   
end

initial begin
   new_buf_req = 0;
   ref_buf_numbr = 0;
   $display(" ");
   $display("********************************************************************************************************");
   $display("********************************************Start the testbench*****************************************");
   $display("********************************************************************************************************");
   $display(" ");
   #(CYCLE * 4);
   #(CYCLE) ref_buf_numbr = 2'b11; 
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE) ref_buf_numbr = 2'b11;
   $display(" ");
   $display("********************************************************************************************************");
   $display("** Case 2: new_buf_req = 0, increase access time until it reach maximum ********************************");
   $display("** Expectation: access time will increase from 8'b01_01_01_01 -> 8'b11_11_11_11 ************************");
   $display("********************************************************************************************************");
   $display(" ");
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE) ref_buf_numbr = 2'b11;
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE)                      ; 
//        $display(" ");
//   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b11_11_11_11) 
//        $display("=============================================== PASS ================================================");
//   else $display("=============================================== FAIL ================================================");
//        $display(" ");
//   $display("*****************************************************************************************************");
//   $display("** Case 3: When access time reach its maximum -> new_buf_req = 0, ref_buf_numbr = 2'b00 *************");
//   $display("** Expectation: the access time should be 8'b01_01_01_10 ********************************************");
//   $display("*****************************************************************************************************");
   #(CYCLE) ref_buf_numbr = 2'b00;
   $display(" ");   
   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b01_01_01_10) 
   $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
   $display(" ");
   $display("********************************************************************************************************");
   $display("** Case 4: new_buf_req = 0, increase access time until it reach maximum ********************************");
   $display("** Expectation: access time will increase from 8'b01_01_01_10 -> 8'b11_11_11_11 ************************");
   $display("********************************************************************************************************");
   $display(" ");
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b11;
   #(CYCLE) ref_buf_numbr = 2'b11;
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE)                      ; 
        $display(" ");
   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b11_11_11_11) 
        $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
        $display(" ");
   $display("*****************************************************************************************************");
   $display("** Case 5: When access time reach its maximum -> new_buf_req = 0, ref_buf_numbr = 2'b01 *************");
   $display("** Expectation: the access time should be 8'b01_01_10_01 ********************************************");
   $display("*****************************************************************************************************");
   #(CYCLE) ref_buf_numbr = 2'b11;
   $display(" ");   
   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b01_01_10_01) 
   $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
   $display(" ");
   $display("********************************************************************************************************");
   $display("** Case 6: new_buf_req = 0, increase access time until it reach maximum ********************************");
   $display("** Expectation: access time will increase from 8'b01_01_10_01 -> 8'b11_11_11_11 ************************");
   $display("********************************************************************************************************");
   $display(" ");
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE) ref_buf_numbr = 2'b11;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE)                      ; 
        $display(" ");
   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b11_11_11_11) 
        $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
        $display(" ");
   $display("*****************************************************************************************************");
   $display("** Case 7: When access time reach its maximum -> new_buf_req = 0, ref_buf_numbr = 2'b10 *************");
   $display("** Expectation: the access time should be 8'b01_10_01_01 ********************************************");
   $display("*****************************************************************************************************");
   #(CYCLE) ref_buf_numbr = 2'b11;
   $display(" ");   
   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b01_10_01_01) 
   $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
   $display(" ");
   $display("********************************************************************************************************");
   $display("** Case 8: new_buf_req = 0, increase access time until it reach maximum ********************************");
   $display("** Expectation: access time will increase from 8'b01_10_01_01 -> 8'b11_11_11_11 ************************");
   $display("********************************************************************************************************");
   $display(" ");
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b11;
   #(CYCLE)                      ; 
        $display(" ");
   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b11_11_11_11) 
        $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
        $display(" ");
   $display("*****************************************************************************************************");
   $display("** Case 9: When access time reach its maximum -> new_buf_req = 0, ref_buf_numbr = 2'b11 *************");
   $display("** Expectation: the access time should be 8'b10_01_01_01 ********************************************");
   $display("*****************************************************************************************************");
   #(CYCLE) ref_buf_numbr = 2'b11;
   $display(" ");   
   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b10_01_01_01) 
   $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
   $display(" ");
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE)                      ;
   #(CYCLE) ref_buf_numbr = 2'b11;
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE) ref_buf_numbr = 2'b11;
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b00; new_buf_req = 1;
   
   $display(" ");
   $display("*****************************************************************************************************");
   $display("** Case 10: new_buf_req = 1 *************************************************************************");
   $display("** In this case buf_num_replc = 00 -> result: 8'b11_11_11_01 ****************************************");
   $display("*****************************************************************************************************");
   $display(" ");  
   
   #(CYCLE) ref_buf_numbr = 2'b11;
   $display(" ");   
   if({lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b11_11_11_01) 
   $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");   
   $display(" ");
   $display("** Case 11: ref_buf_req = 1 *************************************************************************");
   $display("** Expectation: the access time of replaced buffer should be 01, and buf_num_replc output new value *");
   $display("*****************************************************************************************************");
   $display(" ");
   #(CYCLE) new_buf_req = 0;
   #(CYCLE) ref_buf_numbr = 2'b11;
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) ref_buf_numbr = 2'b00;
   #(CYCLE*4) new_buf_req = 1;
   $display(" ");
   $display("*****************************************************************************************************");
   $display("** buf_num_replc == 2'b01 and access_time = 8'b01_01_01_11*******************************************");
   $display("*****************************************************************************************************");
   $display(" ");
   #(CYCLE) new_buf_req = 0;
   $display(" ");
   if(lfu_finder_01.buf_num_replc == 2'b01 && {lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b01_01_01_11) 
   $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
   $display(" ");
   $display("*****************************************************************************************************");
   $display("** buf_num_replc == 2'b10 and access_time = 8'b01_01_10_11*******************************************");
   $display("*****************************************************************************************************");
   $display(" ");
   #(CYCLE) ref_buf_numbr = 2'b01;
   #(CYCLE) new_buf_req = 1;
   #(CYCLE);
   $display(" "); 
   if(lfu_finder_01.buf_num_replc == 2'b10 && {lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b01_01_10_11) 
   $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
   $display(" ");
   $display("*****************************************************************************************************");
   $display("** buf_num_replc == 2'b11 and access_time = 8'b01_10_11_11*******************************************");
   $display("*****************************************************************************************************");
   $display(" ");
   #(CYCLE) new_buf_req = 0;
   #(CYCLE) ref_buf_numbr = 2'b10;
   #(CYCLE) new_buf_req = 1; ref_buf_numbr = 2'b01;
   #(CYCLE);
   $display(" ");   
   if(lfu_finder_01.buf_num_replc == 2'b11 && {lfu_finder_01.access_time[7:6],lfu_finder_01.access_time[5:4],lfu_finder_01.access_time[3:2],lfu_finder_01.access_time[1:0]} == 8'b01_10_11_11) 
   $display("=============================================== PASS ================================================");
   else $display("=============================================== FAIL ================================================");
   $display(" ");
   $display("*****************************************************************************************************");
   $display("*******************************************  End the testbench  *************************************"); 
   $display("*****************************************************************************************************");
   $display(" ");
   $finish;
end

endmodule
`include "dut.v"
