***************************************
*
* Name: Vic Willis
* ID:   VAW42D
* Date: 20 October 2019
* Lab 4
*
* Program description:
*
* 2 Tables store unsigned integers that are sent to a function in pairs
* The function receives and sends them via call by value
* It performs the GCD on them, and sends the result back to main
* This is repeated for each pair among Tables 1 & 2
* The results are stored in their own array in main
*
* Pseudocode of Main Program:
*
*---------------------------------------
* unsigned int table1[], table2[], table3[]
* unsigned int *ptr1, *ptr2, *ptr3
*
* ptr1 = &table1[0]
* ptr2 = &table2[0]
* ptr3 = &table3[0]
*
* while (*ptr1 != FF)
* {
* 	push ptr1 to stack
* 	A = *ptr1
* 	B = *ptr2
* 	enter subroutine
* 	pull result from stack
* 	place current result in result table
* 	point ptr3 to next table index
* 	pull ptr1 from stack
* 	ptr1++
*	ptr2++
* }
*---------------------------------------
*
* Pseudocode of Subroutine:
*
*---------------------------------------
* unsigned int gcd, x, y, z
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
*---------------------------------------
*	
***************************************
* start of data section

	ORG $B000
TABLE1	FCB	222,  37, 16,  55,  55,  1,   3, 22, $FF
TABLE2	FCB	37,  222, 240,  5, 55, 15,  22,  3, $FF

	ORG $B020
RESULT	RMB	8

* define any other variables that you might need here using RMB (not FCB or FDB)
* remember that your subroutine must not access any of these variables, including
* N and PRIME

TADDR		RMB		2		* store address in table where current result is
	
		ORG		$C000
		LDS		#$01FF		* initialize stack pointer
	
* start of your program

		LDX		#RESULT		* load address of result
		STX		TADDR		* store address of current result in the table
		LDX		#TABLE1		* load address of table1
		LDY		#TABLE2		* load address of table2
WHILE		LDAA	0,X		* load num1
		CMPA	#$FF		* compare to table's sentinel value
		BEQ		ENDWHL		* continue while the values are not equal
		LDAB	0,Y			* load num2
		PSHX				* push address of table1 on the stack
		JSR		SUB			* enter sub routine
		PULA				* pull return address from stack to register

		LDX		TADDR		* load address of result in table
		STAA	0,X			* store result in table
		INX					* point to next index in result table
		STX		TADDR		* assign result address to next index
		PULX				* get address of table1
		INX					* increment table1 pointer to next index
		INY					* increment table2 pointer to next index
		BRA		WHILE		* end of loop
ENDWHL
DONE	BRA		DONE		* end of program
	

* define any other variables that you might need here using RMB (not FCB or FDB)
* remember that your main program must not access any of these variables, including

GCD	RMB	1
X	RMB	1
Y	RMB	1
Z	RMB	1

	ORG $D000
* start of your subroutine

*SUB		LDAA	NUM1	* NUM1 placed in register A
*		LDAB	NUM2	* NUM2 placed in register B
SUB		STAA	X		* X assigned to be NUM1
		STAB	Y		* Y assigned to be NUM2

WHILE1	LDAA	X		* while (X != Y)
		CMPA	Y
		BEQ		ENDWHL1

****************************************************	
* Inner While 1

WHILE2	LDAA	X		* while (X > Y)
		CMPA	Y
		BLS	ENDWHL2
		
* Z = X - Y
		LDAA	X		* load X into A
		SUBA	Y		* subtract Y from X
		STAA	Z		* store result into Z

* X = Z
		LDAA	Z		* load Z into A
		STAA	X		* assign X to be Z

		BRA		WHILE2	* end of loop
ENDWHL2

****************************************************

****************************************************	
* Inner While 2

WHILE3	LDAA	Y		* while (Y > X)
		CMPA	X
		BLS	ENDWHL3
		
* Z = Y - X
		LDAA	Y		* load Y into A
		SUBA	X		* subtract X from Y
		STAA	Z		* store result into Z
		
* Y = Z
		LDAA	Z		* load Z into A
		STAA	Y		* assign Y to be Z

		BRA		WHILE3	* end of loop
ENDWHL3

****************************************************

		BRA		WHILE1	
ENDWHL1	PULX			* pull return address from stack to register
		LDAA	X		* load X (the GCD) into A
		PSHA			* push X on the stack
		PSHX			* push return address on the stack
		RTS
				END