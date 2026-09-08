// palinfinder.s, provided with Lab1 in TDT4258 autumn 2026
.global _start


// Please keep the _start method and the input strings name ("input") as
// specified below
// For the rest, you are free to add and remove functions as you like,
// just make sure your code is clear, concise and well documented.

_start:
	// Here your execution starts
	
	// starting at the check_input section
	b check_input
	

	
check_input:
	// You could use this symbol to check for your input length
	// you can assume that your input string is at least 2 characters 
	// long and ends with a null byte
	
	// Initializing values to check the length
	ldr r0, =input // put input into r0
	mov r1, #0 //set string length to 0
	
	
check_length:

	
	ldrb r2, [r0, r1] // loading character given by input[r1]
	cmp  r2, #0 // Checking for null-terminator since were using asciz
	beq length_done // If null terminator, length has been found
	
	// Looping through and increasing r1 count until we reach null
	add r1, r1, #1  // Increase string length by 1
	b check_length // repeat
	
length_done:
	cmp r1, #4 // Compare length to minimum valid length
	blt is_no_palindrom // Strings shorter than 4 characters are not valid
	b check_palindrom // otherwise continue
	
	
check_palindrom:
	// Here you could check whether input is a palindrom or not
	
	// initializing the left and right pointer
	mov r2, #0
    sub r3, r1, #1
	
palindrom_loop:

	// If left and right meet or cross, very checked character has matched
    cmp r2, r3
    bge is_palindrom

	// Loading each character on the edges given by input[r2] and input[r3]
    ldrb r4, [r0, r2]
    ldrb r5, [r0, r3]
	
	// Skipping spaces with the left pointer
	cmp r4, #' '
	beq skip_spaces_left
	
	// Skipping spaces with the right pointer
	cmp r5, #' '
	beq skip_spaces_right
	
	// Check wildcards
    cmp r4, #'?'
    beq match

    cmp r5, #'?'
    beq match

    cmp r4, #'%'
    beq match

    cmp r5, #'%'
    beq match
	
	// Check left for casing
	b check_left
	
skip_spaces_left:
	add r2, r2, #1
    b palindrom_loop


skip_spaces_right:
    sub r3, r3, #1
    b palindrom_loop


check_left:
	// Convert left character to lowercase if it is A-Z
	cmp r4, #'A' // Compare left character to 'A'
	blt check_right // If below 'A', it is not uppercase
	
	cmp r4, #'Z' // Compare left character to 'Z'
	bgt check_right // If above 'Z', it is not uppercase
	
	add r4, r4, #32 // Convert uppercase ASCII to lowercase


check_right:
	// Convert right character to lowercase if it is A-Z
	cmp r5, #'A' // Compare right character to 'A'
	blt compare_chars // If below 'A', it is not uppercase
	
	cmp r5, #'Z' // Compare right character to 'Z'
	bgt compare_chars // If above 'Z', it is not uppercase
	
	add r5, r5, #32 // Convert uppercase ASCII to lowercase

compare_chars:
	// Characters must match after case conversion and wildcard-checking
    cmp r4, r5
    bne is_no_palindrom

    b match

match:
	// Move both pointers toward the center and continue the loop
    add r2, r2, #1
    sub r3, r3, #1
    b palindrom_loop
	
	
is_palindrom:
	// Switch on only the 5 rightmost LEDs
	// Write 'Palindrom detected' to UART
   	ldr r6, =0xFF200000     
    mov r7, #0x1F
    str r7, [r6]
	
	ldr r0, =pal_msg
    b print_string
	
 
	
	
is_no_palindrom:
	// Switch on only the 5 leftmost LEDs
	// Write 'Not a palindrom' to UART
	ldr r6, =0xFF200000    
    ldr r7, =0x3E0          
    str r7, [r6]
	
    ldr r0, =not_pal_msg
    b print_string
	

print_string:
    ldr r1, =0xFF201000// JTAG UART address

print_loop:
    ldrb r2, [r0] // load current character
    cmp r2, #0            
    beq _exit

    str r2, [r1] // write character to UART

    add r0, r0, #1 // move to next character
    b print_loop	
	
_exit:
// Branch here for exit
	b .
	
.data
pal_msg:
    .asciz "Palindrome detected\n"

not_pal_msg:
    .asciz "Not a palindrome\n"
.align
	// This is the input you are supposed to check for a palindrom
	// You can modify the string during development, however you
	// are not allowed to change the name 'input'!
	input: .asciz "Grav ned den varg"
.end
