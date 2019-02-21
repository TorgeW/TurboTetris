				.model small
;-------------------------------------------------------------------------------------------------------------				
; Konstanten
;-------------------------------------------------------------------------------------------------------------
videoseg 				= 0A000h									; Video-Segmentadresse, Offset geht in Bildschirm
romseg 					= 0F000h									; ROM-Segment
chargen 				= 0FA6Eh									; Char-Generator-Segment (Tabelle)
esc_code 				= 11Bh										; Character-Code von Esc
left_code 				= 4B00h										; Character-Code von Pfeil Links
right_code 				= 4D00h										; Character-Code von Pfeil Rechts
down_code 				= 5000h										; Character-Code von Pfeil Unten
a_code 					= 1E61h										; Character-Code von A-Taste
d_code 					= 2064h										; Character-Code von D-Taste
m_code 					= 326Dh										; Character-Code von M-Taste
screenHeight 			= 200										; Höhe des VGA Monitors
screenWidth 			= 320										; Breite des VGA Monitors
playScreenOffset 		= 28 * screenWidth + 120					; Startposition des Spielfeldes auf dem Monitors
nextStoneWindowOffset 	= 91 * screenWidth + 213					; Startposition des Fensters für den nächsten Block auf dem Monitors
scoreOffset 			= 62 * screenWidth + 213					; Startposition der Score Anzeige auf dem Monitors
scoreTextOffset 		= 54 * screenWidth + 213					; Startposition des Scooretextes auf dem Monitors
LevelOffset 			= 37 * screenWidth + 213					; Startposition der Level Anzeige auf dem Monitors
LevelTextOffset 		= 29 * screenWidth + 213					; Startposition des Leveltextes auf dem Monitors	
endScoreTextOffset		= 70 * screenWidth + 143					; Startposition des Endscoretextes auf dem Monitors	
endScoreOffset			= 80 * screenWidth + 135					; Startposition der Endscore Anzeige auf dem Monitors
gameOverTextOffset		= 30 * screenWidth + 127					; Startposition des Gameovertextes auf dem Monitors	
fieldHeight 			= 19										; Spielfeldhöhe in Blöcken
fieldWidth 				= 12										; Spielfeldbreite in Blöcken
fieldSize 				= 228										; Spielfeld größe in Blöcken
spawnAreaSize 			= 24										; Größe der Einwurfstelle für Blöcke
solidBlock 				= 10b										; Code für ein festen Block
movingBlock 			= 01b										; Code für ein beweglichen Block
rotMatrixWidth 			= 4											; Breite der Rotationsmatrix für Steine
rotMatrixHeight 		= 4											; Höhe der Rotationsmatrix für Steine
blockGraficWidth 		= 8											; Breite der Grafik für Blöcke
blockGraficHeight 		= 8											; Höhe der Grafik für Blöcke
stoneMaxWidth 			= 4											; Maximale breite eines Steins
charWidth 				= 8											; Breite eines Zeichens
charHeight 				= 8											; Höhe eines Zeichens
backgroundColor 		= 103										; Hintergrundfarbe für die Felder
rotationMatrixStart 	= 259										; Startposition der Rotationsmatrix

menuStartX 				= 90
menuStartY 				= 100
menuEndX 				= 230
menuEndY 				= 180
menuOffset				= 110 * screenWidth + 145
; MenuItem1
StartMenuItem1 			= 125
EndMenuItem1 			= 135
menuItem1Offset 		= 130 * screenWidth + 130
; MenuItem2
StartMenuItem2 			= 140
EndMenuItem2 			= 150
menuItem2Offset 		= 145 * screenWidth + 140
; MenuItem3
StartMenuItem3 			= 155
EndMenuItem3 			= 165
menuItem3Offset 		= 160 * screenWidth + 130	

offsetSub 				= 95
offsetTop 				= 90
manualOffset			= 30 * screenWidth + 135
manualItem1Offset 		= 50 * screenWidth + offsetTop
manualItem2Offset 		= 60 * screenWidth + offsetSub
manualItem3Offset 		= 70 * screenWidth + offsetSub
manualItem4Offset 		= 80 * screenWidth + offsetSub		
manualItem5Offset 		= 100 * screenWidth + offsetTop
manualItem6Offset 		= 110 * screenWidth + offsetSub
manualItem7Offset 		= 120 * screenWidth + offsetSub
manualItem8Offset 		= 140 * screenWidth + offsetTop
manualItem9Offset 		= 150 * screenWidth + offsetSub
manualItem10Offset 		= 160 * screenWidth + offsetSub

tetrisMusicSize			= 2826
				
;-------------------------------------------------------------------------------------------------------------				
; Variablen
;-------------------------------------------------------------------------------------------------------------
				.data
gameBGFile		DB	"GameBG.bmp",0									; Dateiname des Hintergrunds des Sppielfeldes
scoreText		DB	"SCORE"											; Score Text
gameOverText	DB	"GAME OVER"											; Game Over Text
levelText		DB	"LEVEL"											; Level Text
activeFalling	DB	0												; Solange ein Block fällt 1, sonst 0
leftPressed		DB	0												; 1 wenn Benutzer die Linke Pfeiltaste drückt
rightPressed	DB	0												; 1 wenn Benutzer die Rechte Pfeiltaste drückt
downPressed		DB	0												; 1 wenn Benutzer die Unten Pfeiltaste drückt
aPressed		DB	0												; 1 wenn Benutzer die A-Taste drückt
dPressed		DB	0												; 1 wenn Benutzer die D-Taste drückt
mPressed		DB	0												; 1 wenn Benutzer die M-Taste drückt
updateCounter	DB  0												; Wert der Festlegt wie oft das Spiel geupdatet wird (wie schnell es läuft)
gameUpdateDone	DB 	0												; 1 Wenn Game geupdatet wurde, 0 wenn kein update in dieser runde
nextStone		DB  0												; Wert zwischen 0 und 100 der den Offset zum nächsten Stein speichert
nextBlockColor	DB 	0												; Farbcode für den nächsten Stein
rotMatrixPos	DW	0												; Position der Rotations Matrix
level			DB	0												; Das Level in dem sich der Spieler befindet (bestimmt die fallgeschwindigkeit)
scoreh			DW	0												; Obere hälfte des Scoors der dem Spieler angezeigt wird
scorel			DW	0												; Untere hälfte des Scoors der dem Spieler angezeigt wird
dropedLines		DB	0												; Die anzahl der Zeilen die ein Spieler den Stein nach unten beschleunigt hat
lineCounter		DB	0												; Zählt wieviele Zeilen gelöscht wurden, bei 10 wird er auf 0 zurück gesetzt und das Level erhöht

																	; 21 Zeilen mit jeweils 12 Blöcken. 18 mal 10 Sichtbar, ...0 Luft, ..01 Beweglich, ..10 Fest
field			DB solidBlock, solidBlock, solidBlock, solidBlock, solidBlock, solidBlock, solidBlock, solidBlock, solidBlock, solidBlock, solidBlock, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock	
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock
				DB solidBlock, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, solidBlock

																	; Rotationsmatrix (Verschiebungsmatrix) für die rechtsrotation eines Steines
rightRotMatrix  DB 3					,  2 +   rotMatrixWidth ,  1 + 2*rotMatrixWidth	,      3*rotMatrixWidth
				DB 2 -   rotMatrixWidth	,  1					, 	     rotMatrixWidth	, -1 + 2*rotMatrixWidth
				DB 1 - 2*rotMatrixWidth ,    -   rotMatrixWidth	, -1					, -2 + rotMatrixWidth
				DB   - 3*rotMatrixWidth	, -1 - 2*rotMatrixWidth	, -2 -   rotMatrixWidth	, -3
				
																	; Rotationsmatrix (Verschiebungsmatrix) für die linksrotation eines Steines
leftRotMatrix 	DB     3*rotMatrixWidth	, -1 + 2*rotMatrixWidth	, -2 +   rotMatrixWidth	, -3
				DB 1 + 2*rotMatrixWidth	, 	     rotMatrixWidth	, -1					, -2 -   rotMatrixWidth	
				DB 2 +   rotMatrixWidth	,  1					,    -   rotMatrixWidth	, -1 - 2*rotMatrixWidth
				DB 3 					,  2 -   rotMatrixWidth	,  1 - 2*rotMatrixWidth , 	 - 3*rotMatrixWidth	

rotationSave	DB 16 DUP(0)										; Speicherbereich für den aktuell rotierten Stein

stoneI			DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0						; Spielstein I
				DB 0, 0, 0, 1, 1, 1, 1, 0, 0, 0
				
stoneJ			DB 0, 0, 0, 1, 1, 1, 0, 0, 0, 0						; Spielstein J
				DB 0, 0, 0, 0, 0, 1, 0, 0, 0, 0
				
stoneL			DB 0, 0, 0, 0, 1, 1, 1, 0, 0, 0						; Spielstein L
				DB 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
				
stoneO			DB 0, 0, 0, 0, 1, 1, 0, 0, 0, 0						; Spielstein O
				DB 0, 0, 0, 0, 1, 1, 0, 0, 0, 0	
				
stoneS			DB 0, 0, 0, 0, 1, 1, 0, 0, 0, 0						; Spielstein S
				DB 0, 0, 0, 1, 1, 0, 0, 0, 0, 0	
				
stoneT			DB 0, 0, 0, 1, 1, 1, 0, 0, 0, 0						; Spielstein T
				DB 0, 0, 0, 0, 1, 0, 0, 0, 0, 0	
				
stoneZ			DB 0, 0, 0, 1, 1, 0, 0, 0, 0, 0						; Spielstein Z
				DB 0, 0, 0, 0, 1, 1, 0, 0, 0, 0	
								
blockGrafic		DB 0, 0, 0, 0, 0, 0, 0, 0							; Grafik für einen Block
				DB 0, 1, 1, 1, 1, 1, 1, 0
				DB 0, 1,15,15,15,15, 1, 0
				DB 0, 1,15, 2, 2, 0, 1, 0
				DB 0, 1,15, 2, 2, 0, 1, 0
				DB 0, 1, 0, 0, 0, 0, 1, 0
				DB 0, 1, 1, 1, 1, 1, 1, 0
				DB 0, 0, 0, 0, 0, 0, 0, 0
				
fallSpeeds		DB 48, 43, 38, 33, 28, 23, 18, 13, 8, 6				; Fallgeschwindigkeit abhängig vom Level (Zb. alle 48 Frames einen Block fallen)
				DB 	5, 	5, 	5, 	4, 	4, 	4, 	3, 	3, 3, 2
				DB 	2, 	2, 	2, 	2, 	2, 	2, 	2, 	2, 2, 1 
				
scorTable		DW 0, 40, 100, 300, 1200							; Tabelle wie viele Punkte es für das löschen von 1, ..., 4 Zeilen gleichzeitig gibt


menu			DB	"MENU"
menuItem1		DB	"New Game"
menuItem2		DB	"Manual"
menuItem3		DB	"Exit(Esc)"
backgroundFile	DB	"Menu.bmp",0
x				DW	?												; x-Koordinate der Maus
y				DW	?												; y-Koordinate der Maus
playClicked		DB	0
manualClicked	DB	0
exitClicked		DB	0


manual			DB	"MANUAL"
manualItem1		DB	"Move Block"
manualItem2		DB	"Left : Arrow Left"
manualItem3		DB	"Right: Arrow Right"
manualItem4		DB	"Down : Arrow Down"
manualItem5		DB	"Rotate Block"
manualItem6		DB	"Left : A"
manualItem7		DB	"Right: D"
manualItem8		DB	"Others"
manualItem9		DB	"Mute : M"
manualItem10	DB	"Exit : Esc"
manualBGFile	DB	"Manual.bmp",0


musicFile 			DB "music.txt",0	
musicUpdateCount DB 0		
midiNoteToFreqTable DB 014h, 03ah, 015h, 01ah, 0e2h, 0fbh, 060h, 0dfh, 079h, 0c4h, 013h, 0abh, 01bh, 093h, 07bh, 07ch
					DB 020h, 067h, 0f8h, 052h, 0f2h, 03fh, 0fdh, 02dh, 00ah, 01dh, 00ah, 00dh, 0f1h, 0fdh, 0b0h, 0efh
					DB 03ch, 0e2h, 089h, 0d5h, 08dh, 0c9h, 03dh, 0beh, 090h, 0b3h, 07ch, 0a9h, 0f9h, 09fh, 0feh, 096h
					DB 085h, 08eh, 085h, 086h, 0f8h, 07eh, 0d8h, 077h, 01eh, 071h, 0c4h, 06ah, 0c6h, 064h, 01eh, 05fh
					DB 0c8h, 059h, 0beh, 054h, 0fch, 04fh, 07fh, 04bh, 042h, 047h, 042h, 043h, 07ch, 03fh, 0ech, 03bh
					DB 08fh, 038h, 062h, 035h, 063h, 032h, 08fh, 02fh, 0e4h, 02ch, 05fh, 02ah, 0feh, 027h, 0bfh, 025h
					DB 0a1h, 023h, 0a1h, 021h, 0beh, 01fh, 0f6h, 01dh, 047h, 01ch, 0b1h, 01ah, 031h, 019h, 0c7h, 017h
					DB 072h, 016h, 02fh, 015h, 0ffh, 013h, 0dfh, 012h, 0d0h, 011h, 0d0h, 010h, 0dfh, 00fh, 0fbh, 00eh
					DB 023h, 00eh, 058h, 00dh, 098h, 00ch, 0e3h, 00bh, 039h, 00bh, 097h, 00ah, 0ffh, 009h, 06fh, 009h
					DB 0e8h, 008h, 068h, 008h, 0efh, 007h, 07dh, 007h, 011h, 007h, 0ach, 006h, 04ch, 006h, 0f1h, 005h
					DB 09ch, 005h, 04bh, 005h, 0ffh, 004h, 0b7h, 004h, 074h, 004h, 034h, 004h, 0f7h, 003h, 0beh, 003h
					DB 088h, 003h, 056h, 003h, 026h, 003h, 0f8h, 002h, 0ceh, 002h, 0a5h, 002h, 07fh, 002h, 05bh, 002h
					DB 03ah, 002h, 01ah, 002h, 0fbh, 001h, 0dfh, 001h, 0c4h, 001h, 0abh, 001h, 093h, 001h, 07ch, 001h
					DB 067h, 001h, 052h, 001h, 03fh, 001h, 02dh, 001h, 01dh, 001h, 00dh, 001h, 0fdh, 000h, 0efh, 000h
					DB 0e2h, 000h, 0d5h, 000h, 0c9h, 000h, 0beh, 000h, 0b3h, 000h, 0a9h, 000h, 09fh, 000h, 096h, 000h
					DB 08eh, 000h, 086h, 000h, 07eh, 000h, 077h, 000h, 071h, 000h, 06ah, 000h, 064h, 000h, 05fh, 000h
tetrisMusicPos	DW	0
tetrisMusic 	DB	tetrisMusicSize DUP(0)

				.code
				.486	

;-------------------------------------------------------------------------------------------------------------				
; Kopiert die Daten einer BMP Datei in den Video Speicher
; @param dx offset zum Dateinamen 
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------
CopyDataFromFileToVideo PROC		
				mov ah, 3Dh											; Datei mit übergebendem Dateinamen öffnen
				mov al, 0						
				int 21h
				
				mov bx, ax											; Dateihandle nach bx
				
				mov ax, videoseg									; ds mit Videosegment belegen
				mov ds, ax	
				
				mov ah, 3Fh											; Offset zu den Daten aus dem Header lesen
				mov cx, 12						
				mov dx, 0
				int 21h

				mov ah, 42h											; Pointer zum Start der Daten verschieben
				mov al, 0
				mov cx, 0
				mov dx, word ptr ds:[10]
				int 21h
				
				mov di, 320 * 200 - 320								; Datei, Zeile für Zeile, in Bildschirmspeicher Kopieren (dadurch drehen)
				
				
continueCopyToV:mov ah, 3Fh
				mov cx, 320						
				mov dx, di
				int 21h
				
				cmp di, 0
				je endCopyToVideo
				sub di, 320
				jmp continueCopyToV
					
endCopyToVideo:	mov ah, 3Eh											; Schließen der Datei			
				int 21h
				
				mov ax, @DATA										; ds mit Datensegment belegen
				mov ds, ax
				ret
CopyDataFromFileToVideo ENDP	
;-------------------------------------------------------------------------------------------------------------
; Write String to Position
; @param si pixelnummer der position wo der String stehen soll
; @param di Pointer zum String der Geschrieben werden soll
; @param dh Anzahl der Zeichen
; @param al Farbe der Zeichenkette
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------	
WriteStringToPosition PROC	
nextCharacter:	mov bl,	[di]										; Character aus string laden und für jeden die Zeichenrotine aufrufen
				xor bh, bh
				
				push di
				call WriteCharacterToPosition
				pop di
				
				sub si, screenWidth * charHeight - charWidth
				inc di
				dec dh
				jnz nextCharacter		
				ret				
WriteStringToPosition ENDP	
;-------------------------------------------------------------------------------------------------------------
; Write Number to Position
; @param si pixelnummer der position wo die Zahl stehen soll
; @param ax niderwertiger part der Zahl die Geschrieben werden soll
; @param dx höherwertiger part der Zahl die Geschrieben werden soll
; @param bh Anzahl der Ziffern
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------	
WriteNumberToPosition PROC	
				mov cl, bh											; si auf das ende der zu bezeichnenden Fläche verschieben (Damit Zahl richtig rum geschrieben wird)
				xor ch, ch
				dec cx
				sal cx, 3
				add si, cx
								
nextNum:		push bx												; Für jede Ziffer den Rest also die nächste Ziffer berechnen und Zeichnen lassen
				mov cx, 10				
				div cx					
				mov bx, dx
				xor dx, dx
				add bx, 30h											; Rest + 30h ist der Ascii Code für die Ziffer
				
				push ax
				mov al, 0
				call WriteCharacterToPosition
				pop ax
				
				pop bx
				sub si, screenWidth * charHeight + charWidth
				dec bh
				jnz nextNum		
				ret				
WriteNumberToPosition ENDP		

;-------------------------------------------------------------------------------------------------------------
; Write Character to Position
; @param al Farbe des Zeichens
; @param si pixelnummer der position wo das Zeichen stehen soll
; @param bx ASCII Code des Zeichens
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------
WriteCharacterToPosition PROC			
				sal bx, 3											; input * 8 zeigt auf den entsprechenden Eintrag in der Zeichentabelle
				
				mov ch, charHeight				
nextCharRow:	mov cl, charWidth				
				mov di, romseg					
				mov es, di	
				mov dl, byte ptr es: [bx + chargen]
				
				mov di, videoseg									; es mit Bildschirmsegment inizialisieren
				mov es, di	
				
nextCharPixel:	sal dl, 1											; Höchstwertiges Bit der Zeile bestimmmt ob Zeichen oder Hintergrund gemalt wird
				jc drawCharacter
				mov byte ptr es:[si], backgroundColor		
				jmp continueDrawChs
drawCharacter:	mov byte ptr es:[si], al	
continueDrawChs:inc si							
				dec cl	
				jnz nextCharPixel
				add si, screenWidth - charWidth
				inc bx
				dec ch
				jnz nextCharRow
				ret
WriteCharacterToPosition ENDP		

;-------------------------------------------------------------------------------------------------------------
; Random next Block Rotine
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------	
RandomStone PROC			
				mov ah, 2ch  										; Zeit von Dos abfragen und Millisekunde gekürzt als Zufallszahl für Startblock
				int 21h      					
				and dx, 00000111b 
				cmp dx, 7
				jne continueNextBlo
				dec dx
continueNextBlo:mov al, 20
				mul dl
				mov nextStone, al
				ret				
RandomStone ENDP	
;-------------------------------------------------------------------------------------------------------------
; Random Bits
; @return Zufällige 6 bit in al
; @save für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------	
RandomBits PROC
				push cx
				push dx
				push ax
				mov ah, 2ch  										; Zeit von Dos abfragen und Millisekunde als 6 Zufallsbits
				int 21h      					
				pop ax
				mov al, dl
				pop dx
				pop cx
				ret				
RandomBits ENDP				
;-------------------------------------------------------------------------------------------------------------
; Rotate to Memory
; @param di Adresse der Rotationsmatrix
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------
RotateToMemory PROC	
				mov bx, rotMatrixPos								; Kopiere das Bewegliche Objekt in der rotMatrix, rotiert in den Rotationsspeicher
				mov si, bx
				mov cx, rotMatrixHeight
				mov dx, rotMatrixWidth
				mov bx, 0
				
copyNextLine:	mov al, [field + si]			
				test al, movingBlock
				jnz copyMoving
				mov al, 0
copyMoving:		push bx
				add bl, [di + bx]
				mov [rotationSave + bx], al 
				pop bx
				inc bx
				dec si
				dec dx
				jnz copyNextLine
				sub si, fieldWidth - rotMatrixWidth
				cmp si, fieldSize + spawnAreaSize
				jae endRotateToMemo
				mov dx, rotMatrixWidth
				dec cx
				jnz copyNextLine		
endRotateToMemo:ret				
RotateToMemory ENDP	
;-------------------------------------------------------------------------------------------------------------
; Test if rotation is blocked
; @return al = 0 blocked, al = 1 not blocked
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------
TestRotationBlocked PROC	
testBorders:	mov bx, rotMatrixPos								; Teste ob das Rotieren von festen Blöcken blockiert wird, wenn ja al = 0, sonst al = 1
				mov cx, rotMatrixHeight
				mov dx, rotMatrixWidth
				mov si, 0

testRotAllowed: test [rotationSave + si], movingBlock
				jz continueTestRot
				test [field + bx ], solidBlock
				jz continueTestRot
				mov al, 0
				ret
continueTestRot:inc si
				dec bx
				dec dx
				jnz testRotAllowed
				sub bx, fieldWidth - rotMatrixWidth
				mov dx, rotMatrixWidth
				dec cx
				jnz testRotAllowed
				mov al, 1
				ret
TestRotationBlocked ENDP	
;-------------------------------------------------------------------------------------------------------------
; Write back rotated object from memory
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------
WriteRotatedBack PROC	
rotadeRight:	mov bx, rotMatrixPos								; Schreibe das rotierte Objekt zurück auf das Spielfeld 
				mov cx, rotMatrixHeight
				mov dx, rotMatrixWidth
				mov si, 0

writeBackNextLi:mov al, [rotationSave + si]	
				test [field + bx ], solidBlock
				jnz continueWithOut
				mov [field + bx ], al
continueWithOut:inc si
				dec bx
				dec dx
				jnz writeBackNextLi
				sub bx, fieldWidth - rotMatrixWidth
				cmp bx, fieldSize + spawnAreaSize
				jae endWriteRotated
				mov dx, rotMatrixWidth
				dec cx
				jnz writeBackNextLi	
endWriteRotated:ret
WriteRotatedBack ENDP	
;-------------------------------------------------------------------------------------------------------------
; Write 8 Pixel of Background Color
; @param si pixelnummer der position wo Hintergrund gemahlt werden soll
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------
WriteBackgroundLine PROC	
				mov di, blockGraficWidth 							; Male 8 pixel in der Hintergrundfarbe
continueDrawSpa:mov byte ptr es:[si], backgroundColor			
				inc si
				dec di
				jnz continueDrawSpa
				ret
WriteBackgroundLine ENDP	
;-------------------------------------------------------------------------------------------------------------
; Write 8 Pixel of the Block Grafic
; @param si pixelnummer der position wo der Block gemahlt werden soll
; @param dl Zeile des Blocks die gezeichnet werden soll
; @param dh Farbcode des Blocks
; @unsave für Register
; @unsave für Flags
;-------------------------------------------------------------------------------------------------------------
WriteBlockLine PROC	
				mov di, 0											; Male eine Zeile der Block Grafik
continueDrawTil:xor ax, ax
				mov al, blockGraficWidth
				mul dl
				add di, ax
				mov ah, [blockGrafic + di]
				
				cmp ah, 1
				jne checkColorTwo
				mov ah, dh
				sal ah, 3
				shr ah, 5
				sal ah, 1
				add ah, 64
				jmp drawBlockPixel
checkColorTwo:	cmp ah, 2
				jne	drawBlockPixel
				mov ah, dh
				shr ah, 5
				sal ah, 1
				add ah, 64
				
drawBlockPixel:	mov byte ptr es:[si], ah
				xor ah, ah
				sub di, ax
				inc si
				inc di
				cmp di, blockGraficWidth 
				jne continueDrawTil
				ret
WriteBlockLine ENDP	

;-------------------------------------------------------------------------------------------------------------				
; Erkennt und verarbeitet Mausklicks auf Menuitems und visualisiert Hoverevent über Menuitems
;-------------------------------------------------------------------------------------------------------------
mouseEvents proc far
				mov ax, 2				;int 33h / AX = 2 - hide mouse pointer
				int 33h
				
				cmp bx,0				;bx (Mausstatus) = 0 (links nicht gedrückt)?
				jne press				;bx = 1 -> linke Maustaste gedrückt
				call calcCords
			
;Testet ob Maus im Menüpanel
				cmp x, menuStartX
				jb noHover
				
				cmp x, menuEndX
				ja noHover
				
				cmp y, StartMenuItem1
				jb noHover
				cmp y,EndMenuItem1
				ja testHover1
				

				mov si, menuItem1Offset
				mov di, offset menuItem1
				mov dh, 8
				mov al, 15
				call WriteStringToPosition
				
				mov si, menuItem2Offset
				mov di, offset menuItem2
				mov dh, 6
				mov al, 0
				call WriteStringToPosition
				
				mov si, menuItem3Offset
				mov di, offset menuItem3
				mov dh, 9
				mov al, 0
				call WriteStringToPosition
				jmp off
				
testHover1:	
				cmp y, StartMenuItem2
				jb off
				cmp y,EndMenuItem2
				ja testHover2
				
				mov si, menuItem2Offset
				mov di, offset menuItem2
				mov dh, 6
				mov al, 15
				call WriteStringToPosition
				
				mov si, menuItem1Offset
				mov di, offset menuItem1
				mov dh, 8
				mov al, 0
				call WriteStringToPosition
				
				mov si, menuItem3Offset
				mov di, offset menuItem3
				mov dh, 9
				mov al, 0
				call WriteStringToPosition
				jmp off
		
testHover2:	
				cmp y, StartMenuItem3
				jb off
				cmp y,EndMenuItem3
				ja noHover
				
				mov si, menuItem3Offset
				mov di, offset menuItem3
				mov dh, 9
				mov al, 15
				call WriteStringToPosition
				
				mov si, menuItem1Offset
				mov di, offset menuItem1
				mov dh, 8
				mov al, 0
				call WriteStringToPosition
				
				mov si, menuItem2Offset
				mov di, offset menuItem2
				mov dh, 6
				mov al, 0
				call WriteStringToPosition
				jmp off

noHover:

				mov si, menuItem3Offset
				mov di, offset menuItem3
				mov dh, 9
				mov al, 0
				call WriteStringToPosition
				
				mov si, menuItem1Offset
				mov di, offset menuItem1
				mov dh, 8
				mov al, 0
				call WriteStringToPosition
				
				mov si, menuItem2Offset
				mov di, offset menuItem2
				mov dh, 6
				mov al, 0
				call WriteStringToPosition
				jmp off
				
press:		
				call calcCords			

;Testet ob Maus im Menüpanel geklickt wird
				cmp x, menuStartX
				jb off
				
				cmp x, menuEndX
				ja off
				
				cmp y, StartMenuItem1
				jb off
				cmp y,EndMenuItem1
				ja testPress2
				mov playClicked, 1
				jmp off
				
testPress2:	
				cmp y, StartMenuItem2
				jb off
				cmp y,EndMenuItem2
				ja testPress3
				mov manualClicked, 1
				jmp off
		
testPress3:	
				cmp y, StartMenuItem3
				jb off
				cmp y,EndMenuItem3
				ja off
				mov exitClicked, 1
				jmp off	
			
off:	
				
				mov ax, 1				;int 33h / AX = 1 - show mouse pointer
				int 33h
				ret

mouseEvents endp 

;-------------------------------------------------------------------------------------------------------------				
; Berechnet Koordinaten  
;-------------------------------------------------------------------------------------------------------------
calcCords proc
				xor si, si 
				mov y, dx				;dx (y-Koordinate)
				
				mov ax, cx				;x-Koordinate in Akkumulator
				mov cx, 320				
				mul cx					;x-Koordinate in Character-Mode: x * 320 / 640 (hier: dx:ax = ax * cx)
				mov cx, 640
				div cx					;ax = dx:ax / cx
				mov x, ax				;x-Koordinate in Character-Mode nach x geschoben	
				
				mov ax, y				;y-Koordinate in Akkumulator
				mov cx, 200				;Videomodus 3 hat 200 Zeilen
				mul cx					;y-Koordinate in Character-Mode: y * 200 / 200 (hier: dx:ax = ax * cx)
				mov cx, 200
				div cx					;ax = dx:ax / cx
				mov y, ax				;y-Koordinate
				ret
calcCords endp

;-------------------------------------------------------------------------------------------------------------				
; Load Music File
;-------------------------------------------------------------------------------------------------------------	
start:			mov  ax, @data
				mov  ds, ax	
				
				mov ah, 3Dh						
				mov dx, offset musicFile				
				mov al, 0						
				int 21h
				
				mov bx, ax						
				
				mov ah, 3Fh
				mov cx, tetrisMusicSize
				mov dx, offset tetrisMusic
				int 21h
				
				mov ah, 3Eh
				int 21h

;-------------------------------------------------------------------------------------------------------------				
; Menü
;-------------------------------------------------------------------------------------------------------------		
startMenue:
				mov  ax, @data
				mov  ds, ax		
				
				mov  ax, 13h
				int 10h
				
				mov ax, videoseg									; es mit Bildschirmsegment inizialisieren
				mov es, ax	
				
				in al, 61h											; Ton aus
				and al, 0fch
				out 61h, al	
				
				mov playClicked, 0
				mov manualClicked, 0
				mov exitClicked, 0
				
				mov dx, offset backgroundFile
				call CopyDataFromFileToVideo
				
				mov si, menuItem1Offset
				mov di, offset menuItem1
				mov dh, 8
				mov al, 0
				call WriteStringToPosition
				
				mov si, menuItem2Offset
				mov di, offset menuItem2
				mov dh, 6
				mov al, 0
				call WriteStringToPosition
				
				mov si, menuItem3Offset
				mov di, offset menuItem3
				mov dh, 9
				mov al, 0
				call WriteStringToPosition
				
				mov si, menuOffset
				mov di, offset menu
				mov dh, 4
				mov al, 0
				call WriteStringToPosition
				
				push cs
				pop es
			
				mov ax, 0				;int 33h / AX = 0 - mouse initialization	
				int 33h
				
				mov ax, 1				;int 33h / AX = 1 - show mouse pointer
				int 33h
				
				mov dx, offset mouseEvents		;Adresse von UProg. mouseEvents nach dx
				mov cx, 0111b				;Auslöser = wenn linke Maustaste gedrückt wird in cx
				mov ax, 0Ch				;Aktivierungsmaske, ruft Unterprogramm auf
				int 33h

checkIfClicked:	mov ah, 1											; Standard-Tastaturabfrage (nicht stoneIerend)
				int 16h
				jz contCheckIfClic									; Ist eine Taste gedrückt? wenn ja dann führe blockierende Abfrage durch
				mov ah, 0											; Standard-Tastaturabfrage (stoneIerend)
				int 16h
				cmp ax, esc_code									; Springe zum Epilog wenn esc eingegeben, sonst zum programm
				je epilog 	
contCheckIfClic:cmp exitClicked, 1
				je epilog
				cmp playClicked, 1
				je startGame
				cmp manualClicked, 1
				je startManuel
				jmp checkIfClicked
				
;-------------------------------------------------------------------------------------------------------------				
; Manuel
;-------------------------------------------------------------------------------------------------------------	
startManuel:	mov ax, 0											; Mouse reset
				int 33h	
				
				mov ax, videoseg									; es mit Bildschirmsegment inizialisieren
				mov es, ax	
				
				mov dx, offset manualBGFile
				call CopyDataFromFileToVideo
				
				mov si, manualItem1Offset
				mov di, offset manualItem1
				mov dh, 10
				mov al, 0
				call WriteStringToPosition
				
				mov si, manualItem2Offset
				mov di, offset manualItem2
				mov dh, 17
				mov al, 0
				call WriteStringToPosition
				
				mov si, manualItem3Offset
				mov di, offset manualItem3
				mov dh, 18
				mov al, 0
				call WriteStringToPosition
				
				mov si, manualItem4Offset
				mov di, offset manualItem4
				mov dh, 17
				mov al, 0
				call WriteStringToPosition

				mov si, manualItem5Offset
				mov di, offset manualItem5
				mov dh, 12
				mov al, 0
				call WriteStringToPosition
								
				mov si, manualItem6Offset
				mov di, offset manualItem6
				mov dh, 8
				call WriteStringToPosition
				
				mov si, manualItem7Offset
				mov di, offset manualItem7
				mov dh, 8
				mov al, 0
				call WriteStringToPosition

				mov si, manualItem8Offset
				mov di, offset manualItem8
				mov dh, 6
				mov al, 0
				call WriteStringToPosition

				mov si, manualItem9Offset
				mov di, offset manualItem9
				mov dh, 8
				mov al, 0
				call WriteStringToPosition
				
				mov si, manualItem10Offset
				mov di, offset manualItem10
				mov dh, 10
				mov al, 0
				call WriteStringToPosition
		
				mov si, manualOffset
				mov di, offset manual
				mov dh, 6
				mov al, 0
				call WriteStringToPosition
				
testExit:		mov ah, 1											; Standard-Tastaturabfrage (nicht blockieren)
				int 16h
				jz testExit											; Ist eine Taste gedrückt? wenn ja dann führe blockierende Abfrage durch
				mov ah, 0											; Standard-Tastaturabfrage (blockieren)
				int 16h
				cmp ax, esc_code									; Springe zum Epilog wenn esc eingegeben, sonst zum programm
				je startMenue 	
				jmp testExit
				
;-------------------------------------------------------------------------------------------------------------				
; GameOver
;-------------------------------------------------------------------------------------------------------------
startGameOver:	mov ax, 0											; Mouse reset
				int 33h	
				
				mov ax, videoseg									; es mit Bildschirmsegment inizialisieren
				mov es, ax	
				
				in al, 61h											; Ton aus
				and al, 0fch
				out 61h, al	
				
				mov dx, offset manualBGFile
				call CopyDataFromFileToVideo
				
				mov si, endScoreTextOffset
				mov di, offset scoreText
				mov dh, 5
				mov al, 0
				call WriteStringToPosition
				
				mov si, endScoreOffset
				mov ax, scorel
				mov dx, scoreh
				mov bh, 7
				call WriteNumberToPosition
				
				mov si, manualItem10Offset
				mov di, offset manualItem10
				mov dh, 10
				mov al, 0
				call WriteStringToPosition
		
				mov si, gameOverTextOffset
				mov di, offset gameOverText
				mov dh, 9
				mov al, 0
				call WriteStringToPosition
				
testExitMenue:	mov ah, 1											; Standard-Tastaturabfrage (nicht blockieren)
				int 16h
				jz testExitMenue									; Ist eine Taste gedrückt? wenn ja dann führe blockierende Abfrage durch
				mov ah, 0											; Standard-Tastaturabfrage (blockieren)
				int 16h
				cmp ax, esc_code									; Springe zum Epilog wenn esc eingegeben, sonst zum programm
				je startMenue 	
				jmp testExitMenue
;-------------------------------------------------------------------------------------------------------------				
; Inizialisierungen Spiel
;-------------------------------------------------------------------------------------------------------------				
startGame: 		mov ax, 0											; Mouse reset
				int 33h
				
				mov ax, videoseg									; es mit Bildschirmsegment inizialisieren
				mov es, ax	
				
				mov dx, offset gameBGFile							; Lade das Hintergrundbild
				call CopyDataFromFileToVideo
				
				call RandomStone									; Wähle den ersten Stein

				mov si, scoreTextOffset								; Schreibe den Scoretext an die richtige stelle
				mov di, offset scoreText
				mov dh, 5
				mov al, 0
				call WriteStringToPosition
				
				mov si, levelTextOffset								; Schreibe den Leveltext an die richtige stelle
				mov di, offset levelText
				mov dh, 5
				mov al, 0
				call WriteStringToPosition
				
				mov si, scoreOffset									; Schreibe den Score an die richtige stelle
				mov ax, scorel
				mov dx, scoreh
				mov bh, 7
				call WriteNumberToPosition
				
				mov si, levelOffset									; Schreibe das Level an die richtige stelle
				mov al, level
				xor ah, ah
				xor dx, dx
				mov bh, 2
				call WriteNumberToPosition
				
;-------------------------------------------------------------------------------------------------------------				
; Reinizialisierung der Variablen
;-------------------------------------------------------------------------------------------------------------
				mov activeFalling	,0
				mov leftPressed		,0
				mov rightPressed	,0
				mov downPressed		,0
				mov aPressed		,0
				mov dPressed		,0
				mov updateCounter	,0
				mov gameUpdateDone	,0
				mov nextStone		,0
				mov nextBlockColor	,0
				mov rotMatrixPos	,0
				mov level			,0
				mov scoreh			,0
				mov scorel			,0
				mov dropedLines		,0
				mov lineCounter		,0
				mov musicUpdateCount,0
				mov tetrisMusicPos	,0
				
				mov bx, fieldWidth + 1
				mov cx, fieldWidth - 2
				mov dx, fieldHeight + 1
				
wipeOutNext:	mov [field + bx], 0									; Leeren des Spielfeldes
				inc bx
				dec cx
				jnz wipeOutNext
				mov cx, fieldWidth - 2
				add bx, 2
				dec dx
				jnz wipeOutNext
		
				jmp mainloop
				
;-------------------------------------------------------------------------------------------------------------
; Keyboord abfrage				
;-------------------------------------------------------------------------------------------------------------
mainloop:		
				mov leftPressed, 0									; Reset der letzten Tastatureingabe
				mov rightPressed, 0
				mov downPressed, 0
				mov aPressed, 0
				mov dPressed, 0

				mov ah, 1											; Standard-Tastaturabfrage (nicht blockieren)
				int 16h
				jz doneCheckPress									; Ist eine Taste gedrückt? wenn ja dann führe blockierende Abfrage durch
				mov ah, 0											; Standard-Tastaturabfrage (blockieren)
				int 16h
				cmp ax, esc_code									; Springe zum Epilog wenn esc eingegeben, sonst zum programm
				je startMenue 	
				
				cmp ax, left_code
				je leftIsPressed
				cmp ax, right_code
				je rightIsPressed
				cmp ax, down_code
				je downIsPressed
				cmp ax, a_code
				je aIsPressed
				cmp ax, d_code
				je dIsPressed
				cmp ax, m_code
				je mIsPressed
				jmp doneCheckPress	
				
leftIsPressed:	mov leftPressed, 1
				jmp doneCheckPress
rightIsPressed: mov rightPressed, 1
				jmp doneCheckPress
downIsPressed: 	mov downPressed, 1
				jmp doneCheckPress
aIsPressed: 	mov aPressed, 1
				jmp doneCheckPress
dIsPressed: 	mov dPressed, 1
				jmp doneCheckPress
mIsPressed:		xor mPressed, 1
doneCheckPress:

;-------------------------------------------------------------------------------------------------------------
;Testen ob Bewegung nach Links ok und dann nach links bewegen
;-------------------------------------------------------------------------------------------------------------
				test leftPressed, 1									; Ist die Links-Taste gedrückt
				jz endMoveLeft

				mov bx, 0											; Wenn ein fester Block links von einem Beweglichen, erlaube das bewegen nicht
testLeft:		test [field + bx], movingBlock
				jz continueTestLef
				test [field + bx + 1], solidBlock 
				jz continueTestLef
				jmp endMoveLeft
continueTestLef:inc bx
				cmp bx, fieldSize + spawnAreaSize - 1
				jne testLeft

				mov bx, fieldSize + spawnAreaSize					; Bewegung des Fallenden Blockes nach Links 
moveNextLeft:	test [field + bx - 1], movingBlock
				jz continueLeft
				mov al, [field + bx - 1]
				mov [field + bx - 1], 0
				mov [field + bx], al
continueLeft:	dec bx
				jnz moveNextLeft
				inc rotMatrixPos									; Rotationsmatrix nach links verschieben.
endMoveLeft:			

;-------------------------------------------------------------------------------------------------------------
;Testen ob Bewegung nach rechts ok und dann nach rechts bewegen
;-------------------------------------------------------------------------------------------------------------
				test rightPressed, 1								; Ist die Rechts-Taste gedrückt
				jz endMoveRight

				mov bx, 1											; Wenn ein fester Block rechts von einem Beweglichen, erlaube das bewegen nicht
testRight:		test [field + bx], movingBlock
				jz continueTestRigh
				test [field + bx - 1], solidBlock 
				jz continueTestRigh
				jmp endMoveRight
continueTestRigh:inc bx
				cmp bx, fieldSize + spawnAreaSize
				jne testRight
				
				mov bx, 0											; Bewegung des Fallenden Blockes nach Rechts 
moveNextRight:	test [field + bx], movingBlock
				jz continueRight
				mov al, [field + bx]
				mov [field + bx], 0
				mov [field + bx - 1], al
continueRight:	inc bx
				cmp bx, fieldSize + spawnAreaSize
				jne moveNextRight
				dec rotMatrixPos									; Rotationsmatrix nach rechts verschieben.
endMoveRight:

;-------------------------------------------------------------------------------------------------------------
;Testen ob Bewegung nach unten ok und dann nach unten bewegen
;-------------------------------------------------------------------------------------------------------------
				test downPressed, 1									; Ist die Unten-Taste gedrückt
				jz endMoveDown

				mov bx, fieldWidth									; Wenn ein fester Block unter einem Beweglichen, erlaube das bewegen nicht
testDown:		test [field + bx], movingBlock
				jz continueTestDow
				test [field + bx - fieldWidth], solidBlock 
				jz continueTestDow
				jmp endMoveDown
continueTestDow:inc bx
				cmp bx, fieldSize + spawnAreaSize
				jne testDown
				
				mov bx, 0											; Bewegung des Blocks nach Unten
moveNextDown:	test [field + bx], movingBlock
				jz continueDown
				mov al, [field + bx]
				mov [field + bx], 0
				mov [field + bx - fieldWidth], al
continueDown:	inc bx
				cmp bx, fieldSize + spawnAreaSize
				jne moveNextDown
				sub rotMatrixPos, fieldWidth						; Rotationsmatrix nach unten verschieben.
				inc dropedLines										; Erhöhe die Anzahl der schnell gefallenden Zeilen
endMoveDown:

;-------------------------------------------------------------------------------------------------------------
;Rotiere Block nach Links
;-------------------------------------------------------------------------------------------------------------
				test aPressed, 1									; Ist die Links Rotations-Taste gedrückt
				jz endRotateLeft
				
				mov di, offset leftRotMatrix
				call RotateToMemory
				
				call TestRotationBlocked
				test al, 1
				jz endRotateRight
				
				call WriteRotatedBack	
				
endRotateLeft:
;-------------------------------------------------------------------------------------------------------------
;Rotiere Block nach Rechts
;-------------------------------------------------------------------------------------------------------------
				test dPressed, 1									; Ist die Rechts Rotations-Taste gedrückt
				jz endRotateRight
				
				mov di, offset rightRotMatrix
				call RotateToMemory
				
				call TestRotationBlocked
				test al, 1
				jz endRotateRight
				
				call WriteRotatedBack			
				
endRotateRight:
;-------------------------------------------------------------------------------------------------------------
; Main Loop Update unterschiedung (70 Loops pro sekunde (70Hz VGA Update))
;-------------------------------------------------------------------------------------------------------------
				mov dx, 3dah										; Lese das Input Status #1 Register von VGA (NNNN(VRetrace)NN(DD))
waitForScreenDr:in al, dx
				test al, 8											; Wiederhole solange bis bit 4 (Wenn es 1 ist, dann ist der Bildschirm im vertical retrace Zyklus) 0 ist 
				jnz waitForScreenDr	
waitForVR:		in al, dx											; Lese das Input Status #1 Register von VGA (NNNN(VRetrace)NN(DD))
				test al, 8											; Wiederhole solange bis bit 4 (Wenn es 1 ist, dann ist der Bildschirm im vertical retrace Zyklus) 1 ist 
				jz waitForVR
				
				mov gameUpdateDone, 0
				
				inc updateCounter									; Reset des Update Counter wenn dieser "Überläuft"
				mov bl, level										; Updategeschwindigkeit abhängig vom Aktuellen level laden
				xor bh, bh
				mov al, [fallSpeeds + bx]
				cmp updateCounter, al
				jne continueMainLoo
				mov updateCounter, 0
				
continueMainLoo:cmp updateCounter, 0								; Führe Updates durch wenn der Counter auf 0 ist, sonst nur Das malen den Bildschirms
				jne draw
				cmp gameUpdateDone, 0
				jne draw
				mov gameUpdateDone, 1	
				jmp update
;-------------------------------------------------------------------------------------------------------------
;Setzen eines neuen Stein in die Spawnarea
;-------------------------------------------------------------------------------------------------------------
update:			test activeFalling, 1								; Den vorher festgelegten nächsten Stein in die Spawn Area setzen wenn kein fallender Stein mehr auf dem Feld ist.
				jnz dontSpawnNew
				mov rotMatrixPos, rotationMatrixStart 		    	; Startwert für die Rotationsmatrix setzen
				mov bx, spawnAreaSize - 4
				mov di, 1
				mov al, nextStone
				xor ah, ah
				mov si, ax
copyPartOfBlock:mov ah, [stoneI + si + bx - 1]
				or ah, nextBlockColor
				mov[field + fieldSize + di], ah
				inc di
				cmp di, 11
				jne continueCopyBlo
				add di, 2
continueCopyBlo:dec bx
				jnz copyPartOfBlock
				mov dropedLines, 0
				mov activeFalling, 1

;-------------------------------------------------------------------------------------------------------------
;Wähle den nächsten Stein zufällig und Male ihn in das nächster Stein Fenster
;-------------------------------------------------------------------------------------------------------------							
				call RandomStone									; Wähle den nächsten Stein und die Farbe des nächsten Steins

				call RandomBits
				sal al, 2 
				mov nextBlockColor, al
				
				mov si, nextStoneWindowOffset						; Male den nächsten Stein in den dafür vorgesehenen Bereich
				mov bl, nextStone
				add bl, 3
				xor bh, bh
				mov dl, 0
				
drawNextLineOfN:mov cx, stoneMaxWidth		
drawNextTileOfN:mov al, [stoneI + bx ]								
				test al, movingBlock
				jnz drawTileOfNext
				
				call WriteBackgroundLine
				jmp nextTileOfNext
				
drawTileOfNext: mov dh, nextBlockColor
				call WriteBlockLine

nextTileOfNext:	inc bl
				dec cx
				jnz	drawNextTileOfN
				add si, screenWidth - (stoneMaxWidth * blockGraficWidth)
				add bl, 6
				inc dl
				cmp dl, blockGraficHeight
				jne redoLineOfNext
				mov dl, nextStone
				add dl, 23
				cmp bl, dl 
				je endDrawOfNext
				mov dl, 0
				jmp drawNextLineOfN
redoLineOfNext:	sub bx, 10
				jmp drawNextLineOfN
endDrawOfNext:					
dontSpawnNew:

;-------------------------------------------------------------------------------------------------------------
;Testen ob Stein in festen verwandelt werden muss und wenn test erfolgreich, Stein in festen verwandeln
;-------------------------------------------------------------------------------------------------------------
				mov bx, 0											; Wenn ein beweglicher Block in der untersten Line ist, mache alle beweglichen Steine fest
nextFromFirstLi:test [field + bx], movingBlock					
				jz continueFirstLi	
				jmp makeAllSolid
continueFirstLi:inc bx							
				cmp bx, fieldWidth
				jne nextFromFirstLi	
					
				mov bx, fieldWidth									; Wenn ein fester Block unter dem Beweglichen ist, spring zu makeAllSolid
testUnderFallin:test [field + bx], movingBlock
				jz continueTesting
				test [field + bx - fieldWidth], solidBlock 
				jz continueTesting
				jmp makeAllSolid
continueTesting:inc bx
				cmp bx, fieldSize + spawnAreaSize
				jne testUnderFallin
				jmp finishTestingBlocks
				
makeAllSolid:	mov al, dropedLines									; Erhöhe den Score um die schnell gefallenden Zeilen und resete den Wert der Schnell gefallenden Zeilen
				xor ah, ah
				add ax, scorel
				adc scoreh, 0
				mov scorel, ax
				mov si, scoreOffset
				mov ax, scorel
				mov dx, scoreh
				mov bh, 7
				call WriteNumberToPosition
				mov dropedLines, 0
				mov bx, 0											; Mache alle Beweglichen Blöcke zu festen und setze activeFalling auf false
makeSolid:		test [field + bx], movingBlock
				jz continueSolid
				and [field + bx], 11111100b
				or  [field + bx], solidBlock
				cmp bx, fieldSize									; Wenn ein fester Block in der Spawn Area, ist das Spiel verloren
				ja startGameOver
continueSolid:	inc bx
				cmp bx, fieldSize + spawnAreaSize
				jne makeSolid 
				mov activeFalling, 0
finishTestingBlocks:
	
;-------------------------------------------------------------------------------------------------------------
; Beweglichen Block eine Ebene fallen lassen
;-------------------------------------------------------------------------------------------------------------
				mov bx, fieldWidth									; Setze jeden fallenden Block eine Zeile nach unten von unten nach oben. 
moveNextFalling:test [field + bx], movingBlock
				jz continueFalling
				mov al, [field + bx]
				mov [field + bx], 0
				mov [field + bx - fieldWidth], al
continueFalling:inc bx
				cmp bx, fieldSize + spawnAreaSize
				jne moveNextFalling
				sub rotMatrixPos, fieldWidth						; Rotationsmatrix nach unten verschieben.

;-------------------------------------------------------------------------------------------------------------
; Testen ob Zeile voll, wenn ja dann volle Zeile löschen
;-------------------------------------------------------------------------------------------------------------
				mov di, 0
				mov bx, fieldWidth
checkLine:		mov si, 0 											; Testen ob Zeile an blöcken voll ist. (Von unten nach oben)
				mov cl, solidBlock
continueLine:	and cl, [field+bx+si]
				inc si
				cmp si, fieldWidth
				jne continueLine
				cmp cl, solidBlock
				jne checkNextLine
				inc di
				inc lineCounter										; Erhöhe das Level wenn 10 Zeilen gelöscht wurden
				cmp lineCounter, 10
				jne dontIncLevel
				mov lineCounter, 0
				inc level
dontIncLevel:	mov cx, bx											; Alle Zeilen die über der vollen liegen, eins nach unten schieben, die volle zeile wird gelöscht
moveNextBlock:	mov al, [field+bx+fieldWidth]
				mov [field+bx], al
				inc bx
				cmp bx, fieldSize - fieldWidth
				jne moveNextBlock
				mov bx, cx
				sub bx, fieldWidth
checkNextLine:	add bx, fieldWidth
				cmp bx, fieldSize - fieldWidth
				jne	checkLine
				
				sal di, 1											; Erhöhe den Score um den korrekten wert für die anzahl an gleichzeitig gelöschten Zeilen
				mov ax, [scorTable + di]
				add scorel, ax
				adc scoreh, 0
				
				mov si, scoreOffset									; Schreibe Score und Level auf den Bildschirm
				mov ax, scorel
				mov dx, scoreh
				mov bh, 7
				call WriteNumberToPosition
				
				mov si, levelOffset
				mov al, level
				xor ah, ah
				mov bh, 2
				call WriteNumberToPosition
				
				jmp draw
				
;-------------------------------------------------------------------------------------------------------------
; Malen des Spiels																							 
;-------------------------------------------------------------------------------------------------------------			
draw:			
				mov si, playScreenOffset							; Malt die Datenstruktur von oben nach unten
				mov bx, fieldSize - 1
				mov dl, 0
				
drawNextLine:	mov cx, fieldWidth - 2		
drawNextTile:	mov al, [field+bx-1]								
				test al, solidBlock
				jnz drawTile
				test al, movingBlock
				jnz drawTile
				
				call WriteBackgroundLine
				jmp nextTile
				
drawTile:		cmp bx, fieldWidth - 1
				je endDraw
				mov dh, [field+bx-1]
				call WriteBlockLine

nextTile:		dec bx
				cmp bx, fieldWidth - 2
				je endDraw
				dec cx
				jnz	drawNextTile
				sub bx, 2
				add si, screenWidth - ((fieldWidth - 2) * blockGraficWidth)
				inc dl
				cmp dl, blockGraficHeight
				jne redoLine
				mov dl, 0
				jmp drawNextLine
redoLine:		add bx, fieldWidth
				jmp drawNextLine
endDraw:		

;-------------------------------------------------------------------------------------------------------------
; Abspielen der Musik
;-------------------------------------------------------------------------------------------------------------
				test mPressed, 1
				jnz noteOff
				inc musicUpdateCount
				cmp musicUpdateCount, 3
				jne mainloop
				mov musicUpdateCount, 0
				
				mov si, tetrisMusicPos
				mov bh, 0
				mov bl, [tetrisMusic + si]

				cmp bl, 255 										; Beibehalten des aktuellen Tons
				jz endPlayMusic
				cmp bl, 254 										; Ton ausstellen
				jz noteOff
				
				shl bx, 1											; Umwandeln des Tons zu einer Frequenz
				mov ax, Offset [midiNoteToFreqTable + bx];
				
				mov dx, ax											; Ändern der Frequenz
				mov al, 0b6h
				out 43h, al
				mov ax, dx
				out 42h, al
				mov al, ah
				out 42h, al

				in al, 61h											; Ton abspielen
				or al, 3h
				out 61h, al
				jmp endPlayMusic
				
noteOff:		in al, 61h											; Ton aus
				and al, 0fch
				out 61h, al			

endPlayMusic:	inc tetrisMusicPos
				cmp tetrisMusicPos, tetrisMusicSize
				jne mainloop
				mov tetrisMusicPos, 0
				jmp mainloop
				
;-------------------------------------------------------------------------------------------------------------
; Epilog 
;-------------------------------------------------------------------------------------------------------------
epilog:			in al, 61h											; Ton aus
				and al, 0fch
				out 61h, al	

				mov ax, 3											; Rückstellen des VideoModus
				int 10h
				
				mov ah, 4Ch											; Rücksprung ins DOS
				int 21h
				
				.stack 100h
				
				end start