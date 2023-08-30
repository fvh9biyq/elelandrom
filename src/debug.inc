;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; フォントを0-255で埋める
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DEBUG_FONT_FULL MACRO
SCOPE DEBUG_FONT_FULL
	ld hl,FREE_AREA
	ld b,3
	xor a,a
loop:
	ld [hl],a
	inc hl
	inc a
	jr nz,loop
	djnz loop

	;VRAMに転送
	ld hl,FREE_AREA
	ld de,0x1800
	ld bc,VIEW_CODE_AREA_WIDTH*VIEW_CODE_AREA_HEIGHT
	call BIOS_LDIRVM
ENDSCOPE ; DEBUG_FONT_FULL
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 画面を0で埋める
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DEBUG_FONT_ZERO_FULL MACRO
SCOPE DEBUG_FONT_ZERO_FULL
	xor a,a
	ld hl,0x1800
	ld bc,VIEW_CODE_AREA_WIDTH*VIEW_CODE_AREA_HEIGHT
	call BIOS_FILVRM
ENDSCOPE ; DEBUG_FONT_ZERO_FULL
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; スプライト表示テスト
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DEBUG_SPRITE MACRO
SCOPE DEBUG_SPRITE
	ld hl,FREE_AREA
	ld bc,22*256
loop:
	ld a,c
	and a,0xfc
	add a,a
	add a,a
	dec a
	ld [hl],a
	inc hl
	ld a,c
	and a,0x03
	rlca
	rlca
	rlca
	rlca
	ld [hl],a
	inc hl
	ld a,c
	add a,a
	add a,a
	ld [hl],a
	inc hl
	ld [hl],0x7
	inc hl
	inc c
	djnz loop

	ld hl,FREE_AREA
	ld de,0x1b00
	ld bc,22*4
	call BIOS_LDIRVM
ENDSCOPE ; DEBUG_SPRITE
ENDM


