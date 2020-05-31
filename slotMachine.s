.data

/* Strings */
intro:		.asciz "Welcome to the slot machine simulator!\n"

betMessage:	.asciz "\nYou have %d coins. How much would you like to bet?\n"

betError:	.asciz "Your bet is invalid. Please try again.\n"

rolling1:	.asciz "Rolling!\n"

rolling2:	.asciz "You rolled: %d %d %d\n"

msg_noMatch:	.asciz "None of your numbers matched. You win nothing. New balance: %d coins\n"

msg_twoMatch:	.asciz "Two of your numbers matched! You win %d coins! New balance: %d coins\n"

msg_matchAll:	.asciz "All three of your numbers matched! You win %d coins!! New balance: %d coins\n"

msg_playAgain:	.asciz "Would you like to play again? (1-Yes/0-No)\n"

scanType:	.string "%d"

endgame:	.asciz "Thank you for playing! You stopped with %d coins.\n"


/* Variables */
current:	.word 1000	@ Current amount is set to 1000 at the start of program

yn_input:	.word 0

bet:		.word 0

num1:		.word 0

num2:		.word 0

num3:		.word 2		@ Num3 default set to 2

winnings:	.word 0

lr_bu:		.word 0


.text
.global _start
.global printf
.global scanf
.func rollFunc

_start:
	LDR R0, addr_intro		@ Print intro message
	bl printf

main:
	@ First roll		
	bl rollFunc			@ Branch to rollFunc function
	LDR R3, addr_num1		
	STR R2, [R3]			@ Stores given number from rollFunc into num1 variable


	MOV R6, #0			@ Declare R6 with value 0
	LDR R1, addr_current		@ Loads current amount address
	LDR R1, [R1]			@ Loads value in current amount address
	CMP R6, R1			@ Compares current amount with 0
	BEQ end				@ Branches to end if amount is 0

	LDR R0, addr_betMessage		@ Print bet message
	LDR R1, addr_current		@ Load "current" variable	
	LDR R1, [R1]
	bl printf

	LDR R0, addr_scanType		@ Loads Scan type address into R0
	LDR R1, addr_bet		@ Loads Bet address into R1
	bl scanf
	
	LDR R1, addr_bet		
	LDR R1, [R1]			@ Loads contents of addr_bet variable into R1
	
	@ store input bet in bet variable
	LDR R9, addr_bet
	STR R1, [R9]
	
	LDR R2, addr_current		@ Loads variable "current"
	LDR R2, [R2]			@ Loads contents of "current"
	b _subloop
	


_betErrorMessage:
	LDR R0, addr_betError		@ Print error message "bet too high"
	bl printf
	b main				@ Branch to main
	

_subloop:
	CMP R2, R1
	BLT _betErrorMessage		@ Branch to error if bet is invalid

	CMP R1, R6			@ Compares bet amount with 0
	BLT _betErrorMessage		@ Branches to error if bet is less than 0
	BEQ _betErrorMessage		@ Branches if bet is equal to 0

	@ Second Roll
	bl rollFunc
	LDR R3, addr_num2
	STR R2, [R3]			@ Stores given number from rollFunc into num2 variable

_roll:
	LDR R0, addr_rolling1	
	bl printf

	LDR R0, addr_rolling2
	LDR R1, addr_num1
	LDR R1, [R1]			@ Stores roll 1 into R1
	
	LDR R2, addr_num2
	LDR R2, [R2]			@ Stores roll 2 into R2

	LDR R3, addr_num3
	LDR R3, [R3]			@ Stores roll 3 into R3

	bl printf

	@ Loads num1, num2, and num3 variables into registers
	LDR R1, addr_num1
	LDR R1, [R1]
	
	LDR R2, addr_num2
	LDR R2, [R2]

	LDR R3, addr_num3
	LDR R3, [R3]

	CMP R1, R2			@ Compares R1 and R2
	BNE _firstCheck			@ Branches if not equal
	
					@ if equal, that means R1 = R3
	CMP R2, R3			@ Assumes R1 = R2, goes to _lastCheck if R2 != R3
	BNE _firstCheck			

	b _allMatch
			

_firstCheck:
	CMP R2, R3			@ Compares R2 and R3
	BNE _lastCheck			@ Branches if not equal

/* R2 = R3, since R1 doesnt equal R2, R3 cannot be the same as R1 */

	b _twoMatch			@ Branches to _twoMatch if R2 = R3


_lastCheck:
	CMP R1, R3			@ Compares R1 and R3
	BEQ _twoMatch			@ Branches to _twoMatch if equal
	
	CMP R1, R2			@ Compares R1 and R2
	BEQ _twoMatch			@ Branches to _twoMatch if equal
	

_noMatchAll:
	@ Load current amount, sub it from bet, store it back in
	LDR R1, addr_bet
	LDR R1, [R1]

	LDR R2, addr_current
	LDR R2, [R2]
	
	SUB R2, R2, R1			@ Subtracts bet from current
	
	LDR R3, addr_current
	STR R2, [R3]			@ Stores new current value

	LDR R0, addr_msg_noMatch
	
	LDR R1, addr_current
	LDR R1, [R1]
	bl printf

	b _playAgain


_twoMatch:
	LDR R1, addr_bet
	LDR R1, [R1]
	
	LDR R2, addr_current
	LDR R2, [R2]

	LDR R3, addr_winnings

	SUB R2, R2, R1			@ Subtracts bet from current
		
	MOV R8, R1			@ Moves R1 bet value into R8
	MOV R9, #2			@ Moves value 2 into R9

	SDIV R8, R8, R9			@ Divides R8 by 2
	ADD R1, R1, R8			@ Adds bet with R8 (winnings)
	STR R1, [R3]			@ Stores bet value into winnings variable

	ADD R2, R2, R1			@ Adds current variable with new bet value

	LDR R3, addr_current
	STR R2, [R3]			@ Stores new value of current into variable


	LDR R0, addr_msg_twoMatch
	
	LDR R1, addr_winnings
	LDR R1, [R1]

	LDR R2, addr_current
	LDR R2, [R2]	

	bl printf

	b _playAgain


_allMatch:
	LDR R1, addr_bet
	LDR R1, [R1]

	LDR R2, addr_current
	LDR R2, [R2]

	LDR R3, addr_winnings

	SUB R2, R2, R1			@ Subtracts bet from current				
	MOV R9, #2			@ Moves value 2 into R9

	MUL R1, R9, R1			@ Multiplies bet by 2		
	STR R1, [R3]			@ Stores R1 new value in winnings

	ADD R2, R2, R1			@ Adds current with winnings
	
	LDR R3, addr_current		@ Loads current variable
	STR R2, [R3]			@ Stores new current value
	

	LDR R0, addr_msg_matchAll
	
	LDR R1, addr_winnings
	LDR R1, [R1]

	LDR R2, addr_current
	LDR R2, [R2]
	
	bl printf
	

_playAgain:
/* Check to see if current variable equals 0. If so, branch to end */
	LDR R1, addr_current
	LDR R1, [R1]
	MOV R6, #0
	CMP R6, R1
	BEQ end

	@ Third Roll
	bl rollFunc
	LDR R3, addr_num3
	STR R2, [R3]

	LDR R0, addr_msg_playAgain
	bl printf

	LDR R0, addr_scanType
	LDR R1, addr_yn_input
	bl scanf


	LDR R1, addr_yn_input
	MOV R6, #1			@ Stores value 1 into R6
	LDR R1, [R1]
	CMP R6, R1
	BEQ main			@ If input = 1, branch back to main
	
	b end				@ If input is not equal to 1, branch to end


rollFunc:
	LDR R6, addr_lr_bu	
	STR lr, [R6]		@ Stores current Link Register in R6

	MOV R0, #0
	bl time				@ Call GCC time function
	bl srand			@ Call GCC srand function
	bl rand				@ Call GCC rand function

/* Remainder Theorem */
	MOV R2, #3			@ Moves value 3 into R2
	SDIV R3, R0, R2		@ Divides randomly generated number by 3
	MUL R2, R3, R2		@ Multiplies value by 2
	SUB R0, R0, R2		@ Subtracts randomly generated number by value
	ADD R2, R0, #1		@ Adds 1 to value to make randomly generated number 1-3

	LDR lr, addr_lr_bu	@ Loads stored Link Register address
	LDR lr, [lr]		@ Loads Link Register with stored Link Register address
	bx lr				@ Branches to Link Register and exits function

			
end:
		
	LDR R0, addr_endgame		@ Loads ending message
	LDR R1, addr_current		@ Loads current amount
	LDR R1, [R1]
	bl printf

/* Exit call */
	MOV R0, #0					
	MOV R7, #1
	SWI 0


/* Address Declarations */
addr_intro:		.word intro
addr_betMessage: 	.word betMessage
addr_current:		.word current
addr_scanType:		.word scanType
addr_bet:		.word bet
addr_betError:		.word betError
addr_rolling1:		.word rolling1
addr_rolling2:		.word rolling2
addr_num1:		.word num1
addr_num2:		.word num2
addr_num3:		.word num3
addr_winnings:		.word winnings
addr_lr_bu:		.word lr_bu
addr_yn_input:		.word yn_input
addr_msg_noMatch:	.word msg_noMatch
addr_msg_twoMatch:	.word msg_twoMatch
addr_msg_matchAll:	.word msg_matchAll
addr_msg_playAgain:	.word msg_playAgain
addr_endgame:		.word endgame
