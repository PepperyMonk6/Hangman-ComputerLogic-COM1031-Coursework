	.eabi_attribute 25, 1
	.eabi_attribute 20, 1
	.eabi_attribute 18, 4
	.eabi_attribute 28, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 30, 6
	.eabi_attribute 24, 1
	.eabi_attribute 26, 2
	.eabi_attribute 34, 1
	.section	.rodata
gMes0:
	.ascii	"Do you want to start a new game, yes(y) or no(n)? \000"
gMes1:
	.ascii	"clear\000"
gMes2:
	.ascii	"The game has finished\000"
	.text
	.global	main
main:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
printWelMes:							@function links to printWelcomeMes function
	bl	printWelcomeMes
inputCheck1:							@function checks for the welcome message input
	ldr	r0, gMessages
	bl	printf
	bl	getLetter
	mov	r3, r0
	strb	r3, [fp, #-5]
	ldrb	r3, [fp, #-5]	
	cmp	r3, #121
	beq	inputCheck2
	ldrb	r3, [fp, #-5]	
	cmp	r3, #110
	bne	inputCheck1
inputCheck2:										@function checks characters
	ldr	r0, gMessages+4
	bl	system
	ldrb	r3, [fp, #-5]	
	cmp	r3, #110
	bne	inputCheck3
	ldr	r0, gMessages+8
	bl	puts
	b	finish1
inputCheck3:										@function checks input and decides what to do next
	ldrb	r3, [fp, #-5]
	cmp	r3, #121
	bne	printWelMes
	bl	playHangman
	b	printWelMes
finish1:
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	pop	{fp, pc}
gMessages:
	.word	gMes0
	.word	gMes1
	.word	gMes2
	.section	.rodata
drawHangman0:
	.ascii	"  ____ |\012 |   | |\012 |   O |\012 |  /|\\|\012_|"
	.ascii	"_ / \\|  \000"
drawHangman1:
	.ascii	"  ____ |\012 |   | |\012 |   O |\012 |  /|\\|\012_|"
	.ascii	"_ /  |  \000"
drawHangman2:
	.ascii	"  ____ |\012 |   | |\012 |   O |\012 |  /|\\|\012_|"
	.ascii	"_    |  \000"
drawHangman3:
	.ascii	"  ____ |\012 |   | |\012 |   O |\012 |  /| |\012_|_"
	.ascii	"    |  \000"
drawHangman4:
	.ascii	"  ____ |\012 |   | |\012 |   O |\012 |   | |\012_|_"
	.ascii	"    |  \000"
drawHangman5:
	.ascii	"  ____ |\012 |   | |\012 |   O |\012 |     |\012_|_"
	.ascii	"    |  \000"
drawHangman6:
	.ascii	"  ____ |\012 |     |\012 |     |\012 |     |\012_|_"
	.ascii	"    |  \000"
	.text
hangman:											@function checks a hangman and finishes drawing if necessary
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #6
	ldrls	pc, [pc, r3, asl #2]
	b	finish2
displayHangman:
	.word	printHangman6
	.word	printHangman5
	.word	printHangman4
	.word	printHangman3
	.word	printHangman2
	.word	printHangman1
	.word	printHangman0
printHangman0:										@function prints a hangman comparing to drawing
	ldr	r0, drawHangman
	bl	printf
	b	empty
printHangman1:										@function prints a hangman comparing to drawing functions
	ldr	r0, drawHangman+4
	bl	printf
	b	empty
printHangman2:										@function prints a hangman comparing to drawing functions
	ldr	r0, drawHangman+8
	bl	printf
	b	empty
printHangman3:										@function prints a hangman comparing to drawing functions
	ldr	r0, drawHangman+12
	bl	printf
	b	empty
printHangman4:										@function prints a hangman comparing to drawing functions
	ldr	r0, drawHangman+16
	bl	printf
	b	empty
printHangman5:										@function prints a hangman comparing to drawing functions
	ldr	r0, drawHangman+20
	bl	printf
	b	empty
printHangman6:										@function draws a hangman comparing to drawing functions
	ldr	r0, drawHangman+24
	bl	printf
empty:
finish2:
	sub	sp, fp, #4
	pop	{fp, pc}
drawHangman:
	.word	drawHangman0
	.word	drawHangman1
	.word	drawHangman2
	.word	drawHangman3
	.word	drawHangman4
	.word	drawHangman5
	.word	drawHangman6
	.section	.rodata
wMessage0:
	.ascii	"****************************\000"
wMessage1:
	.ascii	"*                          *\000"
wMessage2:
	.ascii	"*  Welcome to the Hangman  *\000"
wMessage3:
	.ascii	"*      By Illya Globa      *\000"
wMessage4:
	.ascii	"****************************\012\012\000"
	.text
printWelcomeMes:							@fuction prints welcome message(more precisely writes a string but not including null character)
	push	{fp, lr}
	add	fp, sp, #4
	ldr	r0, messages
	bl	puts
	ldr	r0, messages+4
	bl	puts
	ldr	r0, messages+8
	bl	puts
	ldr	r0, messages+12
	bl	puts
	ldr	r0, messages+4
	bl	puts
	ldr	r0, messages+16
	bl	puts
	pop	{fp, pc}
messages:
	.word	wMessage0
	.word	wMessage1
	.word	wMessage2
	.word	wMessage3
	.word	wMessage4
characterMes:
	.ascii	"%c\000"
wrongCharacterMes:
	.ascii	"Not a letter, try again: \000"
	.align	2
getLetter:										@the whole function checks for the validity of the player's input
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
letterCheck0:									@function scans given string(player's input)
	sub	r3, fp, #6
	mov	r1, r3
	ldr	r0, validSymMes
	bl	__isoc99_scanf
letterCheck1:									@function checks an input wether it is a character, 0 or any other symbol
	bl	getchar
	mov	r3, r0
	strb	r3, [fp, #-5]
	ldrb	r3, [fp, #-5]
	cmp	r3, #10
	bne	letterCheck1
	bl	__ctype_b_loc
	mov	r3, r0
	ldr	r2, [r3]
	ldrb	r3, [fp, #-6]
	lsl	r3, r3, #1
	add	r3, r2, r3
	ldrh	r3, [r3]
	and	r3, r3, #1024
	cmp	r3, #0
	beq	letterCheck2
	ldrb	r3, [fp, #-6]
	b	finish3
letterCheck2:									@function finishes the program if the input is 0
	ldrb	r3, [fp, #-6]
	cmp	r3, #48
	bne	letterCheck3
	ldrb	r3, [fp, #-6]
	b	finish3
letterCheck3:									@function prints not a letter message
	ldr	r0, validSymMes+4
	bl	printf
	b	letterCheck0
finish3:
	mov	r0, r3
	sub	sp, fp, #4
	pop	{fp, pc}
validSymMes:
	.word	characterMes
	.word	wrongCharacterMes
gMes3:
	.ascii	"r\000"
gMes4:
	.ascii	"words.txt\000"
gMes5:
	.ascii	"Error! Can't open file\000"
gMes6:
	.ascii	"Chosen letters - %s\012\000"
gMes7:
	.ascii	"Lives left: %d\012\000"
gMes8:
	.ascii	"Enter letter: \000"
gMes9:
	.ascii	"The game was finished\000"
gMes10:
	.ascii	"The word was - '%s'\012\000"
gMes11:
	.ascii	"You have already chosen '%c'\012\000"
gMes12:
	.ascii	"Wrong letter\000"
gMes13:
	.ascii	"You lost\000"
gMes14:
	.ascii	"You won\000"
gMes15:
	.ascii	"\000\000"
playHangman:								@starting the hangman game this function loads the ingamemessages and opens a words text file if exists 
	push	{fp, lr}						@and at the end shows an appropriate message
	add	fp, sp, #4
	sub	sp, sp, #304
	ldr	r3, inGameMessages
	ldrh	r3, [r3]
	strh	r3, [fp, #-84]
	sub	r3, fp, #82
	mov	r2, #0
	str	r2, [r3]
	str	r2, [r3, #4]
	str	r2, [r3, #8]
	str	r2, [r3, #12]
	str	r2, [r3, #16]
	str	r2, [r3, #20]
	strb	r2, [r3, #24]
	mov	r3, #0
	str	r3, [fp, #-8]
	ldr	r1, inGameMessages+4
	ldr	r0, inGameMessages+8
	bl	fopen
	str	r0, [fp, #-28]
	ldr	r3, [fp, #-28]
	cmp	r3, #0
	bne	file
	ldr	r0, inGameMessages+12
	bl	puts
	mov	r0, #1
	bl	exit
file:
	mov	r3, #0
	str	r3, [fp, #-12]
	b	fileCheck
fileFgets:
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
fileCheck:									@functions checks provided text file and closes it if necessary
	sub	r1, fp, #284
	ldr	r2, [fp, #-12]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	ldr	r2, [fp, #-28]
	mov	r1, #20
	mov	r0, r3
	bl	fgets
	mov	r3, r0
	cmp	r3, #0
	bne	fileFgets
	ldr	r0, [fp, #-28]
	bl	fclose
	mov	r3, r0
	cmp	r3, #0
	beq	randomWord
	mov	r0, #1
	bl	exit
randomWord:								@function takes a random word from provided and prints series of dashes respectively
	mov	r0, #0
	bl	time
	mov	r3, r0
	mov	r0, r3
	bl	srand
	bl	rand
	mov	r3, r0
	ldr	r1, [fp, #-12]
	mov	r0, r3
	bl	__aeabi_idivmod
	mov	r3, r1
	str	r3, [fp, #-32]
	sub	r1, fp, #284
	ldr	r2, [fp, #-32]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	str	r3, [fp, #-36]
	ldr	r0, [fp, #-36]
	bl	strlen
	mov	r3, r0
	sub	r3, r3, #1
	str	r3, [fp, #-40]
	ldr	r3, [fp, #-40]
	ldr	r2, [fp, #-36]
	add	r3, r2, r3
	mov	r2, #0
	strb	r2, [r3]
	ldr	r0, [fp, #-36]
	bl	strlen
	mov	r3, r0
	str	r3, [fp, #-44]
	mov	r3, #0
	str	r3, [fp, #-16]
	b	dashCheck
dashLength:
	sub	r2, fp, #304
	ldr	r3, [fp, #-16]
	add	r3, r2, r3
	mov	r2, #45
	strb	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
dashCheck:
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-44]
	cmp	r2, r3
	blt	dashLength
	sub	r2, fp, #304
	ldr	r3, [fp, #-44]
	add	r3, r2, r3
	mov	r2, #0
	strb	r2, [r3]
	mov	r3, #0
	str	r3, [fp, #-20]
	b	stringCheck
inGameAction0:							@functions print provided messages and checks player's input and make necessary actions for instance if 
	ldr	r0, [fp, #-20]					@the input is 0 then it finishes the game with appropriate messages
	bl	hangman
	sub	r3, fp, #304
	mov	r0, r3
	bl	puts
	sub	r3, fp, #84
	mov	r1, r3
	ldr	r0, inGameMessages+16
	bl	printf
	ldr	r3, [fp, #-20]
	rsb	r3, r3, #6
	mov	r1, r3
	ldr	r0, inGameMessages+20
	bl	printf
	ldr	r0, inGameMessages+24
	bl	printf
	bl	getLetter
	mov	r3, r0
	strb	r3, [fp, #-45]
	ldr	r0, inGameMessages+28
	bl	system
	ldrb	r3, [fp, #-45]
	cmp	r3, #48
	bne	inGameAction1
	ldr	r0, inGameMessages+32
	bl	puts
	ldr	r1, [fp, #-36]
	ldr	r0, inGameMessages+36
	bl	printf
	b	finish4
inGameAction1:									@function converts letters to uppercase and prints the message if you already guessed this letter
	ldrb	r3, [fp, #-45]	
	mov	r0, r3
	bl	toupper
	mov	r3, r0
	strb	r3, [fp, #-45]
	ldrb	r2, [fp, #-45]
	sub	r3, fp, #84
	mov	r1, r2
	mov	r0, r3
	bl	strchr
	mov	r3, r0
	cmp	r3, #0
	beq	charCheck0
	ldrb	r3, [fp, #-45]
	mov	r1, r3
	ldr	r0, inGameMessages+40
	bl	printf
	b	stringCheck
charCheck0:										@in relation to the previous function this function looks and checks the first occurence of a character
	sub	r2, fp, #84								@in a string and cheks it
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r2, [fp, #-45]
	strb	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	sub	r2, fp, #4
	add	r3, r2, r3
	mov	r2, #0
	strb	r2, [r3, #-80]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-36]
	str	r3, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-52]
	b	charCheck1
inGameAction2:									@the whole function checks wether secret word contains a letter and print the message respectively
	ldrb	r3, [fp, #-45]
	mov	r1, r3
	ldr	r0, [fp, #-24]
	bl	strchr
	str	r0, [fp, #-56]
	ldr	r3, [fp, #-56]
	cmp	r3, #0
	bne	char
	ldr	r2, [fp, #-24]
	ldr	r3, [fp, #-36]
	cmp	r2, r3
	bne	stringCheck
	ldr	r0, inGameMessages+44
	bl	puts
	ldr	r3, [fp, #-20]
	add	r3, r3, #1
	str	r3, [fp, #-20]
	b	stringCheck
char:
	ldr	r2, [fp, #-56]
	ldr	r3, [fp, #-36]
	sub	r3, r2, r3
	sub	r2, fp, #4
	add	r3, r2, r3
	ldrb	r2, [fp, #-45]
	strb	r2, [r3, #-300]
	ldr	r3, [fp, #-56]
	add	r3, r3, #1
	str	r3, [fp, #-24]
charCheck1:												@function finishes checking and links to the previous game function
	ldr	r3, [fp, #-24]
	cmp	r3, #0
	bne	inGameAction2
stringCheck:											@funtion compares two strings if they are similar then returns 0
	sub	r3, fp, #304									@afterwards all necessary actions like linking to the messages and beginning of the game done
	mov	r1, r3
	ldr	r0, [fp, #-36]
	bl	strcmp
	mov	r3, r0
	cmp	r3, #0
	beq	inGameAction3
	ldr	r3, [fp, #-20]
	cmp	r3, #6
	bne	inGameAction0
inGameAction3:											@function clears the console and prints defeat message
	ldr	r0, inGameMessages+28
	bl	system
	ldr	r3, [fp, #-20]
	cmp	r3, #6
	bne	inGameAction4
	ldr	r0, inGameMessages+48
	bl	puts
	b	inGameAction5
inGameAction4:											@function prints victory message
	ldr	r0, inGameMessages+52
	bl	puts
inGameAction5:											@function prints the secret word
	ldr	r1, [fp, #-36]
	ldr	r0, inGameMessages+36
	bl	printf
finish4:
	sub	sp, fp, #4
	pop	{fp, pc}
inGameMessages:
	.word	gMes15
	.word	gMes3
	.word	gMes4
	.word	gMes5
	.word	gMes6
	.word	gMes7
	.word	gMes8
	.word	gMes1
	.word	gMes9
	.word	gMes10
	.word	gMes11
	.word	gMes12
	.word	gMes13
	.word	gMes14
