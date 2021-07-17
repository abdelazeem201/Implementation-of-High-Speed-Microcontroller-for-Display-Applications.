module osc_circ(XIN, XOUT, XC);

output  XC;   
input   XIN;  
output	XOUT; 

INVX20 u0(.A(XIN), .Y(XOUT));
INVX20 u1(.A(XOUT), .Y(XC));

endmodule
