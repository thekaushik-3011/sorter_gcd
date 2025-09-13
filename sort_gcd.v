// Code your design here
module top_module ()
  
endmodule


module sorter (input [7:0] arr_i [9:0], 
               output reg [7:0] arr_o [9:0]) // Insertion sort
  
  reg [7:0] key;
  integer j;
  
  always @(*) begin
    for(int i=0; i<10; i++) begin
      arr_o[i] = arr_i[i];
    end
    
    for(int i=1; i<10; i++) begin
      key = arr_i[i];
      j = i-1;
      while(j>=0 && arr_i[j] < key) begin
        arr_o[j+1] = arr_i[j];
        j = j-1;
      end
      arr_o[j+1] = key;
    end
  end   
endmodule


module gcd_calc (input [7:0] a,
                 input [7:0] b,
                 output [7:0] out)
  always @(*) begin
    if(a == 0)
      out = b;
    else if(b == 0)
      out = a;
    else begin
      reg count_shift = 0;
      while((a != 0) && (b!= 0)) begin
        if(~a[0] & ~b[0]) begin // Both are even
          a = a >> 1;
          b = b >> 1;
          count_shift = count_shift+1;
        end else if (~a[0]) begin // a is even
          a = a >> 1;
        end else if (~b[0]) begin // b is even
          b = b >> 1;
        end else begin // Both are odd
          if(a > b) begin
            a = a - b;
          end else begin
            b = b - a;
          end
        end
        out = ((b == 0) ? a : b) << count_shift;
      end
    end
  end  
endmodule