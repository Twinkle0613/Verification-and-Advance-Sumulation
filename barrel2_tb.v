`timescale 1ns/1ns
/*
Check list
1. Global stimulus
2. Individual testCase?
3. Main Loop(initial block)
   -to control sequence of task
4.Error counting task/function 
5.Autocheck function using task/always block
6.use for loop / randomize data
7.$display/$monitor final sucess failure 
8.Force Error into design.
9.All test sets covered 
*/
module barrel2_tb;

//SetUp I/O
reg clk,Load,reset;
reg [7:0]Data_in;
reg [2:0]Select;
wire [7:0]Data_out;
integer i,j;
reg Error = 0;
barrel2 #(data_size(8))
B2(.clk(clk),.Load(abc),.reset(reset),.Select(sel),.Data_in(data_in),.Data_out(Data_out));
//SetUp reset
initial 
 begin 
 reset <= 1;
 @(posedge clk);
 @(negedge clk) reset = 0;
 end 

//----------------Main loop------------------//
initial 
 begin 
 reset = 1;
@(negedge clk);
 CHECK();
 reset = 0; Load = 1;
@(negedge clk);
 CHECK();
 reset = 0; Load = 0;
@(negedge clk);
 CHECK();
 $finish;
 end 
//-------------------------------------------// 
 
/*
task COMPA()
for(i = 0; i < 3 ; i = i + 1)
 begin 
  data_in = {$random}%3;
     for(j = 0; j < 8 ; j = j + 1)
	  #1 sel = j; 	 
 end 
endtask
*/
task CHECK();
if(reset)
 begin 
	if(Data_out == 0)
		Error = Error;
	else 
	 begin 
		Error = Error + 1;
		$display("When reset is active, data_out should be Zero ,at time = %d\n", $time);
		$display("Data_out = %h, Expected = %h, errors = %d\n",Data_out,0,errors);
     end
 end 
else 
 begin
   CHECK_LOAD();
   CHECK_REG();
 end 
 
endtask


task CHECK_LOAD();
  if(Load)
    begin 
     if(barrel2.brl_in == Data_in)
       Error = Error;
     else 
      begin 
	   Error = Error + 1;
	   $display("When Load is high, brl_in should be equal data_in ,at time = %d\n", $time);
	   $display("data_out = %h, brl_in = %h, errors = %d\n",data_in,barrel2.brl_in,errors);
      end 
    end 
 else 
    begin 
     if(barrel2.brl_in == Data_out)
       Error = Error;
     else
      begin  
       Error = Error + 1;
       $display("When Load is low, brl_in should be equal data_out ,at time = %d\n", $time);
	   $display("Data_out = %h, brl_in = %h, errors = %d\n",Data_out,barrel2.brl_in,errors);
      end 
    end 
endtask

task CHECK_REG();
 if(barrel2.brl_out == Data_out)
    Error = Error;
 else 
  begin
    Error = Error + 1;
    $display("When reset is low, brl_out should be equal data_out ,at time = %d\n", $time);
    $display("data_out = %h, brl_out = %h, errors = %d\n",Data_out,barrel2.brl_out,errors);
  end 
endtask


//Monitor the simulation 
initial 
 begin 
 $display("");
 $monitor("");
 end 


//SetUp Clock
initial 
 begin 
	clk <= 0 ;
	forever #5 clk = ~clk;
 end 
 
/*
task verify_output;
 input[23:0] simulated_value;
 input[23:0] expected_value;
begin 
 if(simulated_value[23:0] != expected_value[23:0])
   begin
   errors = errors + 1;
   $display("Simulated Value = %h, Expected Value = %h, errors = %d ,at time = %d\n",simulated_value, expected_value, errors, $time);
   end 
end 
endtask
*/
endmodule 