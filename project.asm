	.ORIG x3000
	jsr wipe
	

	;R0 is the prompt
	;R1 is String Array
	;R2 is 10 multiply array
	;R7 is the sum

	;Initializes arrays and prompts for the String
	;================================================================
getNum	lea R1,array 		;loads array to store input
	and r3,r3,#0
	and r5,r5,#0
	lea R2,tenarray  	;loads array with powers of 10(1,10,100,1000,10000)
	lea R0,Prompt 		;loads first prompt
	puts
 
loop1 	getc 			;loop for getting input
	add R5,R0,#-10		;checks if ENTER is pressed
	brz nextL
	out			;echos the characters
	
	str R0,R1,#0		;stores the character in the array
	
	add R3,R3,#1		;increases the length by 1
	add R1,R1,#1		;increases the array pointer by 1
	brp loop1

	;R1 will hold the character array pointer
	;R7 will be the sum

nextL	add R3,R3,#-1		;subtract 1 from the length
	st r3, LEN		;store the length
	and r0, r0, #0		;clear R0
	str r0, r1, #0		;declares the array full
	and r7,r7,#0
	lea R1, array		;gets the begining of the array
	
loop2 	
	ldr R6,R1,#0		;get the ascii digit

	;Convert ASCII character to digit by subtracting 30
	;====================================================================
	ld r0, MINUS30
	add R6,R6,r0		;r6 contains the digit
		
	;Multiply the digit by the number
	;=====================================================================
	and R0,R0,#0
	add R4,R2,R3
	ldr R4,R4,#0		;loads the ten power to R4
	
loop3
	add R0,R0, R6
	add R4,R4,#-1
	brp loop3

; R0 contains the (digit * power of ten)	


	;Take the new number and add it to the sum
	;====================================================================
	add r7,r7,r0		;partial sum


	;Increment the pointer
	;====================================================================
	add R1,R1,#1		;increment array pointer for String array
	add R3,R3,#-1		;subtracts 1 from the length of R3
	
	brzp loop2
	
	and r0,r0,#0
	ld r0,totalNum		;loads the count for numbers entered
	brp numJump		;if we have two numbers skip
	st r7,value1 		;stores the first number
	add r0,r0,#1		;increments a counter
	st r0,totalNum		;store the count for the amount of numbers we have
	brp getNum		;loops back to get second number
	numJump
	st r7,value2		;stores the second number

	
	and r1,r1,#0
	and r2,r2,#0
	ld r1,value1		;loads first digit to r1
	ld r2,value2		;loads second digit to r2

	lea r0,operand		;loads operation prompt
	puts
	getc			;gets the character for the operation
	out			;reprints to console

	ld r3,multiplicationCheck	;loads ASCII value of 'x'
	add r5,r0,r3
	brp opSkip1			;checks if user selected mulitiplication
	jsr multiplication		;subroutine for multiplication
	brnzp skipAll			
opSkip1
	ld r3,additionCheck		;loads ASCII value of '+'
	add r5,r0,r3
	brp opSkip2			;checks if user selected addition
	jsr addition			;subroutine for addition
	brnzp skipAll
opSkip2
	ld r3,subtractionCheck		;loads ASCII value of '-'
	add r5,r0,r3
	brp opSkip3			;checks if user selected subtraction
	jsr subtraction			;subroutine for subtraction
	brnzp skipAll
opSkip3
	;ld r3,divisionCheck		;loads ASCII value of '/'
	;add r5,r0,r3
	jsr division		;subroutine of division
	ld r0,quotient

	and r4,r4,#0
	add r4,r4,#1
	

skipAll
	jsr length		;subroutine for getting length of result
	and r1,r1,#0
	add r1,r1,r0
	and R3,R3,#0
	add r4,r4,#0		
	brp promptSkip2		;checks if user performed division
	
	
;PRINT LOOP
;====================================
	
        

	ld r6,sign	;loads the sign status
	brz promptSkip1	;checks if number is positive or negative
	lea r0,endline2	;loads prompt for negative numbers
	puts		;displays it
	add r6,r6,#0	
	brp skipEndline
promptSkip1
	lea r0,endline1	;loads prompt for postive numbers
	puts		;displays it
	add r6,r6,#0
	brz skipEndline
promptSkip2
	lea r0,endline3	;loads prompt for division
	puts		;displays it
skipEndline

	ld R5,ASCII	;loads value for ASCII
	add R4,R4,#1
	ld R3,LEN	;loads the length of the array to R3
	lea r4, tenreverse	;loads the tenreverse array. Same constants, but in a differnt order. (easier to parse)
	add r4,r4,#5		;loads the end of the array
	
	not r3,r3
	add r3,r3,#2		;converts R3 to 2s complement
	add r4,r4,r3		;add to R4, which contains the memory location of the constants. Sets R4 to address of largest constant
	add r4,r4,#-1		
	and R6,R6,#0
	ldr R2,R4,#0		;loads the value at R2 to R4
printloop
	
	and R0,R0,#0		;sets R0 to zero
	not R2,R2
	add R2,R2,#1		;converts R2 to 2s complement

divloop				;divloop gets the quotient of the stored number and puts it in R0
	add R0,R0,#1		
	add R1,R1,R2		
	brp divloop
add R1,R1,#0			
	BRzp even
	add R0,R0,#-1
	Not R2,R2
	Add R2,R2,#1
	Add R1,R1,R2
even
	Add R0,R0,R5
	out
back 	ld R3,LEN		;loads the length
	add R3,R3,#-1		;subtracts 1 from the length
	st r3,LEN
	add R4,R4,#1		;moves the address of R4 up one
	ldr R2,R4,#0		;Stores the value of R4 in R2
	add R1,R1,#0		
	add r3,r3,#0
	BRp printloop 

	
	ld r6,quotient		;checks if dicsion was performed
	brz skipRemainder	;if not, end
	jsr getRemainder	;subroutine for displaying remainder
skipRemainder
	halt





	;ARRAYS,VARIABLES, AND PROMPTS USED IN THE PROGRAM
	;===================================================	
Prompt  	.STRINGZ "\n Enter a Integer <5 char: "
operand		.STRINGZ "\n Choose a operation: + - * / " 
multiplicationCheck	.FILL #-42
additionCheck	.fill #-43
subtractionCheck	.fill #-45
divisionCheck	.fill #-47
ASCII 		.fill  x30  
MINUS30		.FILL  x-30
LEN		.FILL  #0
array 		.BLKW 6 #0	      		; array holds the string of variables
tenarray 	.FILL       #1
         	.FILL       #10
         	.FILL       #100
         	.FILL       #1000
         	.FILL       #10000

tenreverse 	.FILL       #10000
         	.FILL       #1000
         	.FILL       #100
         	.FILL       #10
         	.FILL       #1
EOL 		.FILL #-14
number 		.FILL #0
endline1	.Stringz "\n The Number is: "
endline2 	.Stringz "\n The Number is: -"
endline3	.Stringz "\n The Quotient is: "
endline4	.Stringz " The Remainder is: "
zero		.Stringz "0"
value1		.FILL #0
value2		.FILL #0
totalNum	.FILL #0
sign		.FILL #0
count		.FILL #2
remainder	.FILL #0
quotient	.FILL #0
remainderReturn .FILL #0

	;*******************************
	;Subroutines
	;*******************************
wipe
	AND R6,R6,#0	;Clear R6
	AND R5,R5,#0	;Clear R5
	AND R4,R4,#0	;Clear R4
	AND R3,R3,#0	;Clear R3
	AND R2,R2,#0	;Clear R2
	AND R1,R1,#0	;Clear R1
	AND R0,R0,#0	;Clear R0
	st r0,totalNum	;clears number count
	st r6,quotient	;clears quotient
	st r6,sign	;clears the sign
ret

length
	and r3,r3,#0
	add r3,r0,#0
	and r1,r1,#0	;clears r1
	add r1,r1,#4	;max length of characters
loop4	lea r2,tenarray	;loads multiplier to r2
	add r2,r2,r1	;moves index
	ldr r2,r2,#0	;loads value at index
	not r2,r2	;2's complement
	add r2,r2,#1
	add r3,r3,r2	;subtract value in multiplier array from number
	brzp END
	not r2,r2	;re-add mulitplier	
	add r2,r2,#1	
	add r3,r3,r2
	add r1,r1,#-1	;decrement array
	brp loop4
	END
	add r1,r1,#1	;add 1 for offset
	st r1, LEN	;stores length
ret

addition
	add r0,r1,r2	;add the values
ret

subtraction
	not r2,r2	;2's complement of r2
	add r2,r2,#1
	add r0,r1,r2	;add values
	brzp skip	;if positive or zero skip
	ld r6,sign	;loads sign
	add r6,r6,#1	;increments if result is negative
	st r6,sign	;stores 1 to sign value
	not r0,r0	;2's complement of the negative number
	add r0,r0,#1
skip
ret

multiplication
	AND r0,r0,#0
	ADD R1,R1,#0

	BRN RZERO		;handle the case that r1 is 0

	MULTLOOP ADD R0, R0, R2	;start multplication

	ADD R1, R1, #-1
	
BRp MULTLOOP
RET
RZERO 	AND R0, R0, #0		;return 0 if R1 is 0
ret

division
	and r3,r3,#0	;clears r3
	not r2,r2	;2's complement
	add r2,r2,#1
divloop2		;loop for dividing
 	add r3,r3,#1	;increases quotient
	add r1,r1,r2	;subtracts from value1
	brp divloop2	;loops value1 is still positive
	brz divdone	;if value1 is zero, skip
	add r3,r3,#-1	;else subtract one from quotient
	not r2,r2	;2's complement
	add r2,r2,#1
	add r1,r1,r2	;add to value1
divdone
	st r1,remainder	;store r1 as remainder
	st r3,quotient	;store r3 as quotient
ret

getRemainder
	st r7,remainderReturn
	ld r0,remainder
	jsr length		;subroutine for getting length of result
	and r1,r1,#0
	add r1,r1,r0
	add r4,r4,#0

	lea r0,endline4
	puts

ld R5,ASCII	;loads value for ASCII
	add R4,R4,#1
	ld R3,LEN	;loads the length of the array to R3
	lea r4, tenreverse	;loads the tenreverse array. Same constants, but in a differnt order. (easier to parse)
	add r4,r4,#5		;loads the end of the array
	
	not r3,r3
	add r3,r3,#2		;converts R3 to 2s complement
	add r4,r4,r3		;add to R4, which contains the memory location of the constants. Sets R4 to address of largest constant
	add r4,r4,#-1		
	and R6,R6,#0
	ldr R2,R4,#0		;loads the value at R2 to R4
printloop2
	
	and R0,R0,#0		;sets R0 to zero
	not R2,R2
	add R2,R2,#1		;converts R2 to 2s complement

divloop3				;divloop gets the quotient of the stored number and puts it in R0
	add R0,R0,#1		
	add R1,R1,R2		
	brp divloop3
add R1,R1,#0			
	BRzp even2
	add R0,R0,#-1
	Not R2,R2
	Add R2,R2,#1
	Add R1,R1,R2
even2
	Add R0,R0,R5
	out
back2 	ld R3,LEN		;loads the length
	add R3,R3,#-1		;subtracts 1 from the length
	st r3,LEN
	add R4,R4,#1		;moves the address of R4 up one
	ldr R2,R4,#0		;Stores the value of R4 in R2
	add R1,R1,#0		
	add r3,r3,#0
	BRp printloop2
	ld r7,remainderReturn 
	
ret

.end
