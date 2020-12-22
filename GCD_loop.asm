
**************************************
*
* Name: Vic Willis
* ID: VAW42D
* Date: 3 October 2019
* Lab3
*
* Program description: iteratively subtract NUM2 from NUM1 to compute their GCD using nested while loop structures
*
* Pseudocode:
*
*	num1 = 64;
*	num2 = 36;
*
*	x = num1;
*	y = num2;
*
*	while (x != y) 
*	{
*		while (x > y) 
*		{
*			z = x - y;
*			x = z;
*		}
*		
*		while (y > x) 
*		{
*			z = y - x;
*			y = z;
*		}
*	}
*
*	return x;
*
**************************************

* start of data section

	ORG $B000
NUM1	FCB	 64
NUM2	FCB	 36

	ORG $B010
GCD	RMB	1
X	RMB	1
Y	RMB	1
Z	RMB	1


* define any other variables that you might need here using RMB (not FCB or FDB)


	ORG $C000
	
	
	
* start of your program

		LDAA	NUM1	* NUM1 placed in register A
		LDAB	NUM2	* NUM2 placed in register B
		STAA	X		* X assigned to be NUM1
		STAB	Y		* Y assigned to be NUM2

WHILE1	LDAA	X
		CMPA	Y
		BEQ		ENDWHIL1

****************************************************	
* Inner While 1

WHILE2	LDAA	X
		CMPA	Y
		BLS	ENDWHIL2
		
* Z = X - Y
		LDAA	X
		SUBA	Y
		STAA	Z

* X = Z
		LDAA	Z
		STAA	X

		BRA		WHILE2
ENDWHIL2

****************************************************

****************************************************	
* Inner While 2

WHILE3	LDAA	Y
		CMPA	X
		BLS	ENDWHIL3
		
* Z = Y - X
		LDAA	Y
		SUBA	X
		STAA	Z
		
* Y = Z
		LDAA	Z
		STAA	Y

		BRA		WHILE3
ENDWHIL3

****************************************************

		BRA		WHILE1	
ENDWHIL1
		LDAA	X
		STAA	GCD
DONE		BRA		DONE			* Inf loop to end Wookie
