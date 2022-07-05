; Returns a random 8-bit number in A (0-255), clobbers Y (unknown).
rand:
	LDA seed+1
	TAY ; store copy of high byte
	; compute seed+1 ($39>>1 = %11100)
	LSR ; shift to consume zeroes on left...
	LSR
	LSR
	STA seed+1 ; now recreate the remaining bits in reverse order... %111
	LSR
	EOR seed+1
	LSR
	EOR seed+1
	EOR seed+0 ; recombine with original low byte
	STA seed+1
	; compute seed+0 ($39 = %111001)
	TYA ; original high byte
	STA seed+0
	ASL
	EOR seed+0
	ASL
	EOR seed+0
	ASL
	ASL
	ASL
	EOR seed+0
	STA seed+0
	RTS
