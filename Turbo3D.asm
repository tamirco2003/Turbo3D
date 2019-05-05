; Turbo3D
; A raycasting based 3D maze game built in TASM.

; 	Using a top down 2d map and some math, it sends out rays from the player
; position to the direction he is looking. When the ray hits a wall, the game
; calculates the distance to the wall, and draws a column of pixels based on
; the distance to the wall, it's type, and the direction the ray hit it from.

; CHECK IF YOU NEED TO SET THE CURSOR POSITION FOR DRAWING THE MENUS, COULD BRING LINE COUNT DOWN.

IDEAL
MODEL small
STACK 100h
p186
jumps

DATASEG

; The main menu string.
mainMenu db '+-------------------------------------+', 13, 10
		 db '|                                     |', 13, 10
		 db '|               Turbo3D               |', 13, 10
		 db '|           The 3D Maze Game!         |', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '| There are 3 Mazes to complete, can  |', 13, 10
		 db '|         you finish them all?        |', 13, 10
		 db '|                                     |', 13, 10
		 db '|                                     |', 13, 10
		 db '|           To finish a maze,         |', 13, 10
		 db '|       walk into the pink wall!      |', 13, 10
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
		 db '|                                     |', 13, 10
		 db '+-------------------------------------+', 13, 10, '$'

; The next level menu string.
nextLevelMenu db '+-------------------------------------+', 13, 10
	 		  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|              Good Job!              |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|    Get ready for the next level!    |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|     Press any key to continue!      |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '|                                     |', 13, 10
		 	  db '+-------------------------------------+', 13, 10, '$'

; The win menu string.
winMenu db '+-------------------------------------+', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|             Holy S&%*!              |', 13, 10
		db '|                                     |', 13, 10
		db '|      You beat the entire game!      |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|    Press any key to exit the game!  |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '|                                     |', 13, 10
		db '+-------------------------------------+', 13, 10, '$'

screenWidth dw 320 ; Width of the screen (in pixels).
screenHeight dw 200 ; Height of the screen (in pixels).
midOfScreen dw 100 ; Middle of screen (height 200 divided by 2).

levelCount db 2 ; Number of levels (for checking if there are more levels).

; Level 1 map.
level1 db 1,1,1,1,1,1,1,1,1,1,1
	   db 1,0,0,0,0,0,0,0,0,0,1
	   db 1,0,2,2,2,0,3,3,3,0,1
	   db 1,0,2,0,0,0,3,0,3,0,1
	   db 1,2,2,0,4,0,3,0,3,0,1
	   db 1,0,0,0,4,0,3,0,3,0,1
	   db 1,0,4,0,4,0,3,0,3,3,1
	   db 1,0,4,0,4,0,0,0,3,5,1
	   db 1,0,4,4,4,0,3,3,3,0,1
	   db 1,0,4,0,0,0,0,0,0,0,1
	   db 1,1,1,1,1,1,1,1,1,1,1
level1X dd 1.5 ; X of starting player position in level 1.
level1Y dd 3.5 ; Y of starting player position in level 1.
level1DirX dd 0.0 ; X of starting player direction in level 1.
level1DirY dd -1.0 ; Y of starting player direction in level 1.
level1PlaneX dd -0.66 ; X of starting camera plane in level 1.
level1PlaneY dd 0.0 ; Y of starting camera plane in level 1.
level1Width dw 11 ; Level 1 width (for calculating X and Y in 1D array).

; Level 2 map.
level2 db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	   db 1,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
	   db 1,0,2,0,2,2,2,0,2,0,2,2,2,2,2,2,2,2,1
	   db 1,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,1
	   db 1,0,2,2,2,0,2,2,2,2,2,2,2,2,0,0,2,0,1
	   db 1,0,2,0,0,0,2,0,0,0,0,0,0,0,2,0,2,0,1
	   db 1,0,2,2,2,2,2,0,0,2,2,2,2,0,2,2,2,0,1
	   db 1,0,0,0,2,0,0,0,0,0,0,0,2,0,2,0,0,0,1
	   db 1,2,2,0,2,0,2,2,2,2,2,0,2,0,2,0,2,0,1
	   db 1,0,0,0,2,0,2,0,0,0,2,0,2,0,2,0,2,0,1
	   db 1,2,2,0,2,0,0,0,2,0,2,0,2,0,2,0,2,0,1
	   db 1,0,0,0,2,0,0,0,2,0,2,0,2,0,0,0,2,0,1
	   db 1,0,2,2,2,2,2,2,2,0,2,2,2,2,2,2,2,2,1
	   db 1,0,0,0,0,0,0,0,2,0,2,0,0,0,0,0,0,0,1
	   db 1,2,2,2,2,0,2,0,2,0,2,0,2,2,2,2,2,0,1
	   db 1,0,0,0,2,0,2,0,2,0,0,0,2,0,0,0,2,0,1
	   db 1,0,2,2,2,0,2,0,2,2,2,2,2,0,2,0,2,0,1
	   db 1,0,0,0,0,0,2,0,0,0,0,0,0,0,2,0,2,0,1
	   db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,1
level2X dd 1.5 ; X of starting player position in level 2.
level2Y dd 1.5 ; Y of starting player position in level 2.
level2DirX dd 0.0 ; X of starting player direction in level 2.
level2DirY dd 1.0 ; Y of starting player direction in level 2.
level2PlaneX dd 0.66 ; X of starting camera plane in level 2.
level2PlaneY dd 0.0 ; Y of starting camera plane in level 2.
level2Width dw 19 ; Level 2 width (for calculating X and Y in 1D array).

currentLevel db 1 ; Current level number.
currentWidth dw 0 ; The current level's width.
levelAddress dw 0 ; The current level's memory address.

floatHelper dw 0 ; A variable to insert integers into the FPU.
loopHelper dw 0 ; A variable to help with looping over the screen
rotHelper dd 0.0 ; A variable to help with rotating the player.
FPUHelper dw 0 ; A variable to help with changing the FPU control word.

playerX dd 22.0 ; X of player position.
playerY dd 12.0 ; Y of player position.

dirX dd -1.0 ; X of player direction.
dirY dd 0.0 ; Y of player direction.

planeX dd 0.0 ; X of camera plane.
planeY dd 0.66 ; Y of camera plane.

cameraX dd 0.0 ; X coordinate in camera plane (left = -1, middle = 0, right = 1).

rayDirX dd 0.0 ; X of ray's direction.
rayDirY dd 0.0 ; Y of ray's direction.

mapX dw 0 ; X of player's position in the grid (rounded player position).
mapY dw 0 ; Y of player's position in the grid (rounded player position).

sideDistX dd 0.0 ; Distance on ray from player position to first horizontal grid line.
sideDistY dd 0.0 ; Distance on ray from player position to first vertical grid line.

deltaDistX dd 0.0 ; Distance on ray from one horizontal grid line to the next.
deltaDistY dd 0.0 ; Distance on ray from one vertical grid line to the next.

perpWallDist dd 0.0 ; Distance from camera plane to wall.

stepX dw 0 ; X direction for ray to step in.
stepY dw 0 ; Y direction for ray to step in.

movSpeed dd 0.1 ; Movement speed.

movWallCheckX dw 0 ; X position of player, used for checking if there's a wall in the direction the player wants to move.
movWallCheckY dw 0 ; Y position of player, used for checking if there's a wall in the direction the player wants to move.

rotSpeedSin dd 0.052336 ; Sin of rotation speed.
rotSpeedCos dd 0.99863 ; Cos of rotation speed.
negRotSpeedSin dd -0.052336 ; Sin of negative rotation speed.
negRotSpeedCos dd 0.99863 ; Cos of negative rotation speed.

hit db 0 ; Was a wall hit?
side db 0 ; What side did it hit? (For color calculation).

; Helper variables for drawing the walls.
lineHeight dw 0 ; Height of line (calculated based on wall distance).
lineStart dw 0 ; Pixel to start drawing the line on (calculated based on line height and the middle of the screen).
lineEnd dw 0 ; Pixel to stop drawing the line on (calculated based on line height and the middle of the screen).
lineColor db 0 ; Color of the line (based on the wall number and the side the ray hit it from).
lineLooper dw 0 ; Variable used for looping one column of pixels.

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

; Waits for character and inserts it into char.
proc waitForChar
	pusha
	mov ah, 0h
    int 16h
	mov [char], al
	popa
	ret
endp waitForChar

; Initializes the floating point unit to round towards zero (1.9 = 1, -1.9 = -1).
proc initFPU
	pusha
	finit
	fstcw [FPUHelper]
	add [FPUHelper], 0000110000000000b
	fldcw [FPUHelper]
	popa
	ret
endp initFPU

; Calculates X coordinate in camera plane (2 * currentColumn / width - 1).
proc calculateCameraX
	pusha
	mov [floatHelper], 2
	fild [floatHelper]
	fild [loopHelper]
	fmul
	fild [screenWidth]
	fdiv
	fld1
	fsub
	fstp [cameraX]
	popa
	ret
endp calculateCameraX

; Calculates the ray's direction (playerDirection + cameraPlane * cameraX).
proc calculateRay
	pusha
	; Calculate rayDirX with the formula dirX + planeX * cameraX.
	fld [cameraX]
	fld [planeX]
	fmul
	fld [dirX]
	fadd
	fstp [rayDirX]

	; Calculate rayDirY with the formula dirY + planeY * cameraX.
	fld [cameraX]
	fld [planeY]
	fmul
	fld [dirY]
	fadd
	fstp [rayDirY]
	popa
	ret
endp calculateRay

; Stores rounded player position in mapX and mapY.
proc floorPlayerPos
	pusha
	; Round playerX and store in mapX.
	fld [playerX]
	fistp [mapX]
	
	; Round playerY and store in mapY.
	fld [playerY]
	fistp [mapY]
	popa
	ret
endp floorPlayerPos

; Calculates distance on ray from one horizontal grid line to the next, then from one vertical grid line to the next (abs(1 / rayDir)).
proc calculateGridDist
	pusha
	; Calculate deltaDistX with the formula abs(1 / rayDirX).
	fld1
	fld [rayDirX]
	fdiv
	fabs
	fstp [deltaDistX]
	
	; Calculate deltaDistY with the formula abs(1 / rayDirY).
	fld1
	fld [rayDirY]
	fdiv
	fabs
	fstp [deltaDistY]
	popa
	ret
endp calculateGridDist

; Calculates distance on ray from player to grid lines and the ray's step direction.
proc calculateStep
	pusha
	; Compare rayDirX to 0, if above or equal, jump to right.
	fld [rayDirX]
	ftst
	fstsw [floatHelper]
	mov ax, [floatHelper]
	sahf
	jae right
	
	; Because X direction is left, move -1 to stepX, and calculate sideDistX using the formula (playerX - mapX) * deltaDistX.
	mov [stepX], -1
	fld [playerX]
	fild [mapX]
	fsub
	fld [deltaDistX]
	fmul
	fstp [sideDistX]
	jmp y ; Jump to Y direction check when done.
	
	; Because X direction is right, move 1 to stepX, and calculate sideDistX using the formula (mapX + 1.0 - playerX) * deltaDistX.
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
		; Compare rayDirY to 0, if above or equal, jump to up.
		fld [rayDirY]
		ftst
		fstsw [floatHelper]
		mov ax, [floatHelper]
		sahf
		jae up
		
		; Because Y direction is down, move -1 to stepY, and calculate sideDistY using the formula (playerY - mapY) * deltaDistY.
		mov [stepY], -1
		fld [playerY]
		fild [mapY]
		fsub
		fld [deltaDistY]
		fmul
		fstp [sideDistY]
		jmp calculateStepEnd ; Jump to end of procedure when done.
		
		; Because Y direction is up, move 1 to stepY, and calculate sideDistY using the formula (mapY + 1.0 - playerY) * deltaDistY.
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

; Calculates distance from wall to camera plane (to avoid fisheye effect).
proc calculateWallDist
	pusha
	; Check what on what side the ray hit the wall and jump accordingly.
	cmp [side], 0
	jne yDist
	
	; Because wall was hit on the X axis, use formula (mapX - playerX + (1 - stepX) / 2) / rayDirX to calculate distance.
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

	jmp distEnd ; Jump to end of procedure when done.
	
	; Because wall was hit on the Y axis, use formula (mapY - playerY + (1 - stepY) / 2) / rayDirY to calculate distance.
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
	; Calculate height of line based on distance.
	fild [screenHeight]
	fld [perpWallDist]
	fdiv
	fistp [lineHeight]

	; Calculate highest and lowest points of the line using the middle of the screen and the height of the line.
	fldz
	fild [lineHeight]
	fsub
	mov [floatHelper], 2
	fild [floatHelper]
	fdiv
	fild [midOfScreen]
	fadd
	fistp [lineStart]
	
	; If lineStart is smaller than 0, clamp it to 0.
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
		
		; If lineStart is larger or equal to 0, clamp it to 199.
		cmp [lineEnd], 200
		jl drawLine
		mov [lineEnd], 200
		dec [lineEnd]
	
	; Start of line drawing section.
	drawLine:
		; Get wall color from current map.
		mov bx, [levelAddress]
		mov ax, [mapY]
		mul [currentWidth]
		add ax, [mapX]
		add bx, ax
		mov al, [bx]
		mov [lineColor], al
		
		; Loop over a single column of pixels, and draw according to lineStart and lineEnd.
		mov [lineLooper], 0
		drawLineLoop:
			; Draw a pixel at X loopHelper and Y lineLooper.
			mov cx, [loopHelper]
			mov dx, [lineLooper]
			mov al, 0
			; If lineLooper is between lineStart and lineEnd, use the wall color.
			cmp dx, [lineStart]
			jl drawLineInt
			cmp dx, [lineEnd]
			jg drawLineInt
			mov al, [lineColor]
			; If the wall was hit on the Y axis, make the color darker (for better 3D effect).
			cmp [side], 1
			jne drawLineInt
			add al, 8
		
		drawLineInt:
			; Draw the pixel.
			mov ah, 0ch
			int 10h
		inc [lineLooper]
		mov ax, [lineLooper]
		cmp ax, [screenHeight]
		jl drawLineLoop ; If lineLooper is smaller than screenHeight, loop.
	popa
	ret
endp drawWall

; Handles keyboard input, movement, and rotation.
proc handleInput
	pusha
	; Jump to label based on the character pressed.
	cmp [char], 'w'
	je forward
	cmp [char], 's'
	je back
	cmp [char], 'a'
	je turnLeft
	cmp [char], 'd'
	je turnRight

	jmp handleInputEnd ; If nothing was pressed, jump to end of procedure.

	; If there's no wall in front of the player, move forward.
	forward:
		; Calculate the next position of the player on the X axis, and store it in movWallCheckX.
		fld [playerX]
		fld [dirX]
		fld [movSpeed]
		fmul
		fadd
		fistp [movWallCheckX]

		fld [playerY]
		fistp [movWallCheckY]
		
		; Check what is in the movWallCheckX position.
		mov bx, [levelAddress]
		mov ax, [movWallCheckY]
		mul [currentWidth]
		add ax, [movWallCheckX]
		add bx, ax
		mov al, [bx]
		
		; If there's a pink wall in the movWallCheckX position, jump to nextLevel.
		cmp al, 5
		je nextLevel
		
		; If there's no wall in the movWallCheckX position, move to it.
		cmp al, 0
		jne forwardY

		fld [playerX]
		fld [dirX]
		fld [movSpeed]
		fmul
		fadd
		fstp [playerX]
		
		forwardY:
			; Calculate the next position of the player on the Y axis, and store it in movWallCheckY.
			fld [playerY]
			fld [dirY]
			fld [movSpeed]
			fmul
			fadd
			fistp [movWallCheckY]

			fld [playerX]
			fistp [movWallCheckX]
			
			; Check what is in the movWallCheckY position.
			mov bx, [levelAddress]
			mov ax, [movWallCheckY]
			mul [currentWidth]
			add ax, [movWallCheckX]
			add bx, ax
			mov al, [bx]
			
			; If there's a pink wall in the movWallCheckY position, jump to nextLevel.
			cmp al, 5
			je nextLevel
			
			; If there's no wall in the movWallCheckY position, move to it.
			cmp al, 0
			jne handleInputEnd

			fld [playerY]
			fld [dirY]
			fld [movSpeed]
			fmul
			fadd
			fstp [playerY]

		jmp handleInputEnd ; Jump to end of procedure when done.
	
	; If there's no wall behind the player, move backwards.
	back:
		; Calculate the next position of the player on the X axis, and store it in movWallCheckX.
		fld [playerX]
		fld [dirX]
		fld [movSpeed]
		fmul
		fsub
		fistp [movWallCheckX]

		fld [playerY]
		fistp [movWallCheckY]
		
		; Check what is in the movWallCheckX position.
		mov bx, [levelAddress]
		mov ax, [movWallCheckY]
		mul [currentWidth]
		add ax, [movWallCheckX]
		add bx, ax
		mov al, [bx]
		
		; If there's a pink wall in the movWallCheckX position, jump to nextLevel.
		cmp al, 5
		je nextLevel
		
		; If there's no wall in the movWallCheckX position, move to it.
		cmp al, 0
		jne backY

		fld [playerX]
		fld [dirX]
		fld [movSpeed]
		fmul
		fsub
		fstp [playerX]

		backY:
			; Calculate the next position of the player on the Y axis, and store it in movWallCheckY.
			fld [playerY]
			fld [dirY]
			fld [movSpeed]
			fmul
			fsub
			fistp [movWallCheckY]

			fld [playerX]
			fistp [movWallCheckX]
			
			; Check what is in the movWallCheckY position.
			mov bx, [levelAddress]
			mov ax, [movWallCheckY]
			mul [currentWidth]
			add ax, [movWallCheckX]
			add bx, ax
			mov al, [bx]
			
			; If there's a pink wall in the movWallCheckY position, jump to nextLevel.
			cmp al, 5
			je nextLevel
			
			; If there's no wall in the movWallCheckY position, move to it.
			cmp al, 0
			jne handleInputEnd

			fld [playerY]
			fld [dirY]
			fld [movSpeed]
			fmul
			fsub
			fstp [playerY]
		
		jmp handleInputEnd

	; Rotate direction and camera plane vectors 3 degrees.
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
	
	; Rotate direction and camera plane vectors -3 degrees.
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
	
	nextLevel:
		inc [currentLevel]
		call graphicMode
		mov dh, 0
		mov dl, 0
		mov bh, 0
		mov ah, 2
		int 10h
		
		mov bl, [levelCount]
		cmp [currentLevel], bl
		jg youWin

		mov dx, offset nextLevelMenu
		mov ah, 9h
		int 21h

		call waitForChar
		call initLevel
		jmp handleInputEnd
		
		youWin:
			mov dx, offset winMenu
			mov ah, 9h
			int 21h
			
			call waitForChar
			jmp endGame

	handleInputEnd:
		popa
		ret
endp handleInput

; Pushes only the current level's constants to the stack and pops everything to the right variables.
proc initLevel
	pusha
	cmp [currentLevel], 1
	je level1Init

	cmp [currentLevel], 2
	je level2Init

	jmp initLevelEnd

	level1Init:
		lea bx, [level1]
		mov [levelAddress], bx

		push [level1X]
		push [level1Y]
		push [level1DirX]
		push [level1DirY]
		push [level1PlaneX]
		push [level1PlaneY]
		push [level1Width]

		jmp initLevelPop
	
	level2Init:
		lea bx, [level2]
		mov [levelAddress], bx

		push [level2X]
		push [level2Y]
		push [level2DirX]
		push [level2DirY]
		push [level2PlaneX]
		push [level2PlaneY]
		push [level2Width]

		jmp initLevelPop
	
	initLevelPop:
		pop [currentWidth]
		pop [planeY] 
		pop [planeX]
		pop [dirY]
		pop [dirX]
		pop [playerY]
		pop [playerX]

	
	initLevelEnd:
		popa
		ret
endp initLevel

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

call initLevel
mainGameLoop:
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
				mov bx, [levelAddress]
				mov ax, [mapY]
				mul [currentWidth]
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
