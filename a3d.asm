IDEAL
MODEL small
STACK 100h
p186
jumps

DATASEG

mainMenu db '+-------------------------------------+', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '|   _____         _         _______   |', 13, 10
		 db '|  |_   _|  _ _ _| |__  ___|__ /   \  |', 13, 10
		 db '|    | || || |  _|  _ \/ _ \|_ \ |) | |', 13, 10
		 db '|    |_| \_,_|_| |_.__/\___/___/___/  |', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '|               Turbo3D               |', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '| Go forwards: W        Turn right: D |', 13, 10
		 db '|                                     |', 13, 10
		 db '| Go backwards: S       Turn left: A  |', 13, 10
		 db '|                                     |', 13, 10
		 db '|              Quit: q                |', 13, 10
		 db '|                                     |', 13, 10
		 db '|     Press any key to continue!      |', 13, 10
		 db '+-------------------------------------+', 13, 10, '$'

midOfScreen dw 100 ; Middle of screen (height 200).

; The map of the game.
gameMap db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1
		db 1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1
		db 1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
		db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

floatHelper dw 0 ; A variable to insert integers into the FPU.
loopHelper dw 0 ; A variable to help with looping over the screen
rotHelper dd 0.0 ; A variable to help with rotating the player.
FPUHelper dw 0 ; A variable to help with changing the FPU control word.
		
; Player position.
playerX dd 22.0
playerY dd 12.0

; Player direction.
dirX dd -1.0
dirY dd 0.0

; Camera plane (perpendicular to direction).
planeX dd 0.0
planeY dd 0.66

; X coordinate in camera plane (left = -1, middle = 0, right = 1).
cameraX dd 0.0

; Direction of the ray used for drawing the environment.
rayDirX dd 0.0
rayDirY dd 0.0

; Player position in grid.
mapX dw 0
mapY dw 0

; Distance from player position to next grid line on ray.
sideDistX dd 0.0
sideDistY dd 0.0

; Distance from grid line to next grid line on ray.
deltaDistX dd 0.0
deltaDistY dd 0.0

; Distance from camera plane to wall.
perpWallDist dd 0.0

; What direction to move on each axis.
stepX dw 0
stepY dw 0

movSpeed dd 0.1 ; Movement speed.
; For checking if there is a wall in front of the player.
movWallCheckX dw 0
movWallCheckY dw 0

; Sin and cos of rotation speed.
rotSpeedSin dd 0.017452
rotSpeedCos dd 0.999847
negRotSpeedSin dd -0.017452
negRotSpeedCos dd 0.999847

hit db 0 ; Was a wall hit?
side db 0 ; What side did it hit? (For color calculation).

; Helper variables for drawing the walls.
lineHeight dw 0
lineStart dw 0
lineEnd dw 0
lineColor db 0

char db 0 ; What character was hit?

CODESEG
; Enters graphic mode.
proc graphicMode
	pusha
	mov ax, 13h
	int 10h
	popa
	ret
endp graphicMode

; Enters text mode.
proc textMode
	pusha
	mov ax, 2h
	int 10h
	popa
	ret
endp textMode

proc waitForChar
	pusha
	mov ah, 0h
    int 16h
	mov [char], al
	popa
	ret
endp waitForChar

; Initializes the floating point unit.
proc initFPU
	pusha
	finit
	fstcw [FPUHelper]
	add [FPUHelper], 0000110000000000b
	fldcw [FPUHelper]
	popa
	ret
endp initFPU

; Calculates X coordinate in camera plane.
proc calculateCameraX
	pusha
	mov [floatHelper], 2
	fild [floatHelper]
	fild [loopHelper]
	fmul
	mov [floatHelper], 320
	fild [floatHelper]
	fdiv
	fld1
	fsub
	fstp [cameraX]
	popa
	ret
endp calculateCameraX

; Calculates the ray's direction.
proc calculateRay
	pusha
	fld [cameraX]
	fld [planeX]
	fmul
	fld [dirX]
	fadd
	fstp [rayDirX]
	
	fld [cameraX]
	fld [planeY]
	fmul
	fld [dirY]
	fadd
	fstp [rayDirY]
	popa
	ret
endp calculateRay

; Stores floored (rounded-down) player position in mapX and mapY.
proc floorPlayerPos
	pusha
	fld [playerX]
	fistp [mapX]
	
	fld [playerY]
	fistp [mapY]
	popa
	ret
endp floorPlayerPos

; Calculates length of ray from one X to the next X.
proc calculateGridDist
	pusha
	fld1
	fld [rayDirX]
	fdiv
	fabs
	fstp [deltaDistX]
	
	fld1
	fld [rayDirY]
	fdiv
	fabs
	fstp [deltaDistY]
	popa
	ret
endp calculateGridDist

; Calculates direction and distance to step.
proc calculateStep
	pusha
	fld [rayDirX]
	ftst
	fstsw [floatHelper]
	mov ax, [floatHelper]
	sahf
	jae right
	
	mov [stepX], -1
	fld [playerX]
	fild [mapX]
	fsub
	fld [deltaDistX]
	fmul
	fstp [sideDistX]
	jmp y
	
	right:
		mov [stepX], 1
		fild [mapX]
		fld1
		fadd
		fld [playerX]
		fsub
		fld [deltaDistX]
		fmul
		fstp [sideDistX]
	
	y:
		fld [rayDirY]
		ftst
		fstsw [floatHelper]
		mov ax, [floatHelper]
		sahf
		jae up
		
		mov [stepY], -1
		fld [playerY]
		fild [mapY]
		fsub
		fld [deltaDistY]
		fmul
		fstp [sideDistY]
		jmp calculateStepEnd
		
		up:
			mov [stepY], 1
			fild [mapY]
			fld1
			fadd
			fld [playerY]
			fsub
			fld [deltaDistY]
			fmul
			fstp [sideDistY]
	
	calculateStepEnd:
		popa
		ret
endp calculateStep

; Calculates distance from wall to camera plane.
proc calculateWallDist
	pusha
	cmp [side], 0
	jne yDist

	fld1
	fild [stepX]
	fsub
	mov [floatHelper], 2
	fild [floatHelper]
	fdiv
	fild [mapX]
	fadd
	fld [playerX]
	fsub
	fld [rayDirX]
	fdiv
	fstp [perpWallDist]

	jmp distEnd

	yDist:
		fld1
		fild [stepY]
		fsub
		mov [floatHelper], 2
		fild [floatHelper]
		fdiv
		fild [mapY]
		fadd
		fld [playerY]
		fsub
		fld [rayDirY]
		fdiv
		fstp [perpWallDist]

	
	distEnd:
		popa
		ret
endp calculateWallDist

; Draws line on screen based on distance from wall.
proc drawWall
	pusha
	; Calculate height of line.
	mov [floatHelper], 200
	fild [floatHelper]
	fld [perpWallDist]
	fdiv
	fistp [lineHeight]

	; Calculate highest and lowest points of the line.
	fldz
	fild [lineHeight]
	fsub
	mov [floatHelper], 2
	fild [floatHelper]
	fdiv
	fild [midOfScreen]
	fadd
	fistp [lineStart]

	cmp [lineStart], 0
	jge endCalc
	mov [lineStart], 0

	endCalc:
		fild [lineHeight]
		mov [floatHelper], 2
		fild [floatHelper]
		fdiv
		fild [midOfScreen]
		fadd
		fistp [lineEnd]

		cmp [lineEnd], 200
		jl drawLine

		mov [lineEnd], 200
		dec [lineEnd]
	
	drawLine:
		; Get wall color.
		lea bx, [gameMap]
		mov ax, [mapY]
		mov [floatHelper], 24
		mul [floatHelper]
		add ax, [mapX]
		add bx, ax
		mov al, [bx]
		mov [lineColor], al
		
		drawLineLoop:
			xor bh, bh
			mov cx, [loopHelper]
			mov dx, [lineStart]
			mov al, [lineColor]
			cmp [side], 1
			jne drawLineInt
			add al, 8
		drawLineInt:
			mov ah, 0ch
			int 10h
		inc [lineStart]
		mov ax, [lineStart]
		cmp ax, [lineEnd]
		jle drawLineLoop

	popa
	ret
endp drawWall

; Handles keyboard input, movement, and rotation.
proc handleInput
	pusha
	cmp [char], 'w'
	je forward
	cmp [char], 's'
	je back
	cmp [char], 'a'
	je turnLeft
	cmp [char], 'd'
	je turnRight

	jmp handleInputEnd

	; If there's no wall in front of the player, move forward.
	forward:
		fld [playerX]
		fld [dirX]
		fld [movSpeed]
		fmul
		fadd
		fistp [movWallCheckX]

		fld [playerY]
		fistp [movWallCheckY]
		
		lea bx, [gameMap]
		mov ax, [movWallCheckY]
		mov [floatHelper], 24
		mul [floatHelper]
		add ax, [movWallCheckX]
		add bx, ax
		mov al, [bx]

		cmp al, 0
		jne forwardY

		fld [playerX]
		fld [dirX]
		fld [movSpeed]
		fmul
		fadd
		fstp [playerX]

		forwardY:
			fld [playerY]
			fld [dirY]
			fld [movSpeed]
			fmul
			fadd
			fistp [movWallCheckY]

			fld [playerX]
			fistp [movWallCheckX]
			
			lea bx, [gameMap]
			mov ax, [movWallCheckY]
			mov [floatHelper], 24
			mul [floatHelper]
			add ax, [movWallCheckX]
			add bx, ax
			mov al, [bx]

			cmp al, 0
			jne handleInputEnd

			fld [playerY]
			fld [dirY]
			fld [movSpeed]
			fmul
			fadd
			fstp [playerY]

		jmp handleInputEnd
	
	; If there's no wall in front of the player, move forward.
	back:
		fld [playerX]
		fld [dirX]
		fld [movSpeed]
		fmul
		fsub
		fistp [movWallCheckX]

		fld [playerY]
		fistp [movWallCheckY]
		
		lea bx, [gameMap]
		mov ax, [movWallCheckY]
		mov [floatHelper], 24
		mul [floatHelper]
		add ax, [movWallCheckX]
		add bx, ax
		mov al, [bx]

		cmp al, 0
		jne forwardY

		fld [playerX]
		fld [dirX]
		fld [movSpeed]
		fmul
		fsub
		fstp [playerX]

		backY:
			fld [playerY]
			fld [dirY]
			fld [movSpeed]
			fmul
			fsub
			fistp [movWallCheckY]

			fld [playerX]
			fistp [movWallCheckX]
			
			lea bx, [gameMap]
			mov ax, [movWallCheckY]
			mov [floatHelper], 24
			mul [floatHelper]
			add ax, [movWallCheckX]
			add bx, ax
			mov al, [bx]

			cmp al, 0
			jne handleInputEnd

			fld [playerY]
			fld [dirY]
			fld [movSpeed]
			fmul
			fsub
			fstp [playerY]
		
		jmp handleInputEnd

	; Rotate direction and camera plane vectors 1 degree.
	turnLeft:
		fld [dirX]
		fst [rotHelper]
		fld [rotSpeedCos]
		fmul
		fld [dirY]
		fld [rotSpeedSin]
		fmul
		fsub
		fstp [dirX]
		
		fld [rotHelper]
		fld [rotSpeedSin]
		fmul
		fld [dirY]
		fld [rotSpeedCos]
		fmul
		fadd
		fstp [dirY]

		fld [planeX]
		fst [rotHelper]
		fld [rotSpeedCos]
		fmul
		fld [planeY]
		fld [rotSpeedSin]
		fmul
		fsub
		fstp [planeX]

		fld [rotHelper]
		fld [rotSpeedSin]
		fmul
		fld [planeY]
		fld [rotSpeedCos]
		fmul
		fadd
		fstp [planeY]

		jmp handleInputEnd
	
	; Rotate direction and camera plane vectors -1 degrees.
	turnRight:
		fld [dirX]
		fst [rotHelper]
		fld [negRotSpeedCos]
		fmul
		fld [dirY]
		fld [negRotSpeedSin]
		fmul
		fsub
		fstp [dirX]
		
		fld [rotHelper]
		fld [negRotSpeedSin]
		fmul
		fld [dirY]
		fld [negRotSpeedCos]
		fmul
		fadd
		fstp [dirY]

		fld [planeX]
		fst [rotHelper]
		fld [negRotSpeedCos]
		fmul
		fld [planeY]
		fld [negRotSpeedSin]
		fmul
		fsub
		fstp [planeX]

		fld [rotHelper]
		fld [negRotSpeedSin]
		fmul
		fld [planeY]
		fld [negRotSpeedCos]
		fmul
		fadd
		fstp [planeY]

		jmp handleInputEnd

	handleInputEnd:
		popa
		ret
endp handleInput

start:
	mov ax, @data
	mov ds, ax

call initFPU
call graphicMode

mov dh, 0
mov dl, 0
mov bh, 0
mov ah, 2
int 10h

mov dx, offset mainMenu
mov ah, 9h
int 21h

call waitForChar


mainGameLoop:
	call graphicMode
	mov [loopHelper], 0
	rayLoop:
		call calculateCameraX
		call calculateRay
		call floorPlayerPos
		call calculateGridDist
		call calculateStep
		; Perform the DDA algorithm.
		mov [hit], 0
		ddaLoop:
			; Step in the correct direction.
			fld [sideDistX]
			fcom [sideDistY]
			fstsw [floatHelper]
			mov ax, [floatHelper]
			sahf
			jae yDir
			
			fld [sideDistX]
			fld [deltaDistX]
			fadd
			fstp [sideDistX]
			
			mov ax, [mapX]
			add ax, [stepX]
			mov [mapX], ax
			
			mov [side], 0
			jmp checkHit
			
			yDir:
				fld [sideDistY]
				fld [deltaDistY]
				fadd
				fstp [sideDistY]

				mov ax, [mapY]
				add ax, [stepY]
				mov [mapY], ax

				mov [side], 1

			; Check if ray has hit a wall.
			checkHit:
				lea bx, [gameMap]
				mov ax, [mapY]
				mov [floatHelper], 24
				mul [floatHelper]
				add ax, [mapX]
				add bx, ax
				mov al, [bx]

				cmp al, 0
				jle ddaLoopEnd

				mov [hit], 1

			ddaLoopEnd:
				cmp [hit], 0
				je ddaLoop
		
		call calculateWallDist
		call drawWall

		inc [loopHelper]
		cmp [loopHelper], 320
		jl rayLoop
	
call waitForChar
cmp [char], 'q'
je endGame

call handleInput
jmp mainGameLoop

endGame:
	call textMode
exit:
	mov ax, 4c00h
	int 21h
END start
