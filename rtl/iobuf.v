module iobuf(PAD, OEN, I, C);
output  C;     
input   OEN,I; 
inout   PAD;  

TBUFX20 u0(.A(I), .Y(PAD), .OE(OEN));
BUFX20 u1(.A(PAD), .Y(C));

endmodule
