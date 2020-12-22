***************************************
*
* Name: Vic Willis
* ID:   VAW42D
* Date: 6 November 2019
* Lab 4
*
* Program description:
*
* 2 Tables store unsigned integers that are loaded into registers
* The function loads the values from the registers onto the stack
* It performs the GCD on them, and sends the result back to main
* The values are local and dymanic, and destroyed upon exiting the subroutine
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
*
*---------------------------------------
*
* Pseudocode of Subroutine:
*
*---------------------------------------
* store number1, number2 onto stack
* declare space on stack for variables x, y, z
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
*	close local dynamic variable holes
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
WHILE	LDAA		0,X		* load num1
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

	ORG $D000
* start of your subroutine

SUB	
		PULX			* pull return address
		DES				* open hole for return address
		PSHX			* push return address
		DES				* open 3 holes for my local variables
		DES
		DES
		TSX
		
		STAA	0,X		* X assigned to be 1st number
		STAB	1,X		* Y assigned to be 2nd number

WHILE1	LDAA	0,X		* while (X != Y)
		CMPA	1,X
		BEQ		ENDWHL1

****************************************************	
* Inner While 1

WHILE2	LDAA	0,X		* while (X > Y)
		CMPA	1,X
		BLS	ENDWHL2
		
* Z = X - Y
		LDAA	0,X		* load X into A
		SUBA	1,X		* subtract Y from X
		STAA	2,X		* store result into Z

* X = Z
		LDAA	2,X		* load Z into A
		STAA	0,X		* assign X to be Z

		BRA		WHILE2	* end of loop
ENDWHL2

****************************************************

****************************************************	
* Inner While 2

WHILE3	LDAA	1,X		* while (Y > X)
		CMPA	0,X
		BLS	ENDWHL3
		
* Z = Y - X
		LDAA	1,X		* load Y into A
		SUBA	0,X		* subtract X from Y
		STAA	2,X		* store result into Z
		
* Y = Z
		LDAA	2,X		* load Z into A
		STAA	1,X		* assign Y to be Z

		BRA		WHILE3	* end of loop
ENDWHL3

****************************************************

		BRA		WHILE1	
ENDWHL1	
		LDAA	0,X		* load the GCD into A
		STAA	5,X
		INS				* close 3 variable holes
		INS
		INS
		RTS
				END