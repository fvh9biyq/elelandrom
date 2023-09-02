;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; パスワード出力イベント
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE EVENT_PASSWORD
EVENT_PASSWORD::
	;ステータス表示区域のクリア 画面左端からE.HPまでクリア
	ld bc,17
	call CLEAR_STATUS_AREA

	ld hl,text_password
	call TEXT_COPY
	ld hl,VIEW_CODE_AREA+0+23*VIEW_CODE_AREA_WIDTH
	ld de,PLAYER_LEVEL
	ld a,[de]
	cp a,99
	jr nz,not_max_level
	ld a,10
not_max_level:
	call PUT_HEX4
	inc de
	inc de
	ld a,[de]  ;PLAYER_HP
	call PUT_HEX8
	ld de,PLAYER_EXP
	ld a,[de]
	call PUT_HEX8
	dec de ;PLAYER_ITEMS
	ld a,[de]
	ld c,a
	ld b,7
loop:
	ld a,'0'
	sla c
	adc a,0
	ld [hl],a
	inc hl
	djnz loop

	;VRAMに書き込み
	ld a,0xf0
	ld [GAME_CONTROLLER],a

	jp SKIP_EVENT
text_password:
	DEFW VIEW_CODE_AREA+0+22*VIEW_CODE_AREA_WIDTH
	DEFS "PASS WORD"
	DEFB 0

ENDSCOPE ;EVENT_PASSWORD


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; PUT_HEX4
;;;; aレジスタ下位4ビットを16進にしてhlアドレスに書き込む
;;;; in a:出力データ hl:出力メモリアドレス
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE PUT_HEX4
PUT_HEX4::
	and a,0x0f
	cp a,10
	sbc a,0x69
	daa
	ld [hl],a
	inc hl
	ret
ENDSCOPE ;PUT_HEX4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; PUT_HEX8
;;;; aレジスタを16進にしてhlアドレスに書き込む
;;;; in a:出力データ hl:出力メモリアドレス
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE PUT_HEX8
PUT_HEX8::
	push af
	rrca
	rrca
	rrca
	rrca
	call PUT_HEX4
	pop af
	call PUT_HEX4
	ret
ENDSCOPE ;PUT_HEX8


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; パスワードのチェック
;;;;   in hl パスワード入力アドレス
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PASSWARD_MAXSIZE = 13 ;パスワードの入力は最後のリターンキー含めて最大13文字
SCOPE PASSWORD_CHECK
PASSWORD_CHECK::
	ex de,hl
	ld hl,debug_code
debug_code_next:
	push de
	ld a,[hl]
	inc hl
	or a,a
	jr z,debug_code_skip
	ld c,a
	ld b,a
debug_code_loop:
	ld a,[de]
	inc de
	cp a,[hl]
	inc hl
	jr nz,debug_code_mismatch
	dec c
debug_code_mismatch:
	djnz debug_code_loop
	ld a,c
	or a,a
	jr z,debug_code_match
	inc hl
	inc hl
	pop de
	jr debug_code_next
debug_code_match:
	ld c,[hl]
	inc hl
	ld b,[hl]
	push bc
	ret ;jump_debug_code_xxx
debug_code_success:
debug_code_fail:
	pop de
	ex de,hl
	scf
	ret

debug_code_skip:
	pop de
	ex de,hl
	call HEXTOBIN ;最初の1文字はレベル(値チェックのみして実際には反映しない)
	ret c
	call HEXTOBIN2 ;次の2文字はHP
	ret c
	ld d,a
	call HEXTOBIN2 ;次の2文字はEX
	ret c
	ld e,a
	ld bc,0x700
loop:
	ld a,[hl]
	inc hl
	cp a,0x32 ;キャラクターコードが'1'より上ならNG
	ccf
	ret c
	cp a,0x30 ;キャラクターコードが'0'より下ならNG
	ret c
	jr z,not_set_item ;キャラクターコードが'1'ならアイテムフラグON
	inc c
not_set_item:
	sla c
	djnz loop
	ld hl,PLAYER_ITEMS
	ld [hl],c
	inc hl
	ld [hl],e
	ld hl,PLAYER_HP
	ld [hl],d
	ret

debug_code_map:
	ld a,[de]
	sub a,'A'
	cp a,12
	jr nc,debug_code_fail
	ld [MAP_ID],a
	jr debug_code_success

debug_wait:
	ld a,[de]
	sub a,'0'
	cp a,10
	jr nc,debug_code_fail
	ld [GAME_SPEED],a
	jr debug_code_success

debug_code_nodamage:
	ld a,1
	ld [PLAYER_NODAMAGE],a
	jr debug_code_success

debug_code_msxcolor:
	ld b,15
	ld hl,debug_code_msxcolor_data
debug_code_msxcolor_loop:
	ld d,b
	ld a,[hl]
	inc hl
	ld e,[hl]
	inc hl
	push hl
	push bc
	ld ix,SUBROM_SETPLT
	call BIOS_EXTROM
	pop bc
	pop hl
	djnz debug_code_msxcolor_loop
	jr debug_code_success
debug_code_msxcolor_data:
	DEFB 0x77, 0x007; 0xffffff
	DEFB 0x66, 0x006; 0xcccccc
	DEFB 0x55, 0x003; 0xb766b5
	DEFB 0x12, 0x005; 0x3aa241
	DEFB 0x64, 0x006; 0xded087
	DEFB 0x62, 0x006; 0xccc35e
	DEFB 0x73, 0x004; 0xff897d
	DEFB 0x62, 0x003; 0xdb6559
	DEFB 0x37, 0x006; 0x65dbef
	DEFB 0x52, 0x002; 0xb95e51
	DEFB 0x47, 0x003; 0x8076f1
	DEFB 0x27, 0x002; 0x5955e0
	DEFB 0x33, 0x006; 0x74d07d
	DEFB 0x12, 0x005; 0x3eb849
	DEFB 0x00, 0x000; 0x000000

debug_code_gameclear:
	pop de ;debug_code_successの後のpop de
	pop de ;call PASSWORD_CHECKに対応するret
	pop de ;call TITLEに対応するret
	jp GAMECLEAR

debug_code:
	DEFB 3
	DEFS "MAP"
	DEFW debug_code_map
	DEFB 4
	DEFS "WAIT"
	DEFW debug_wait
	DEFB 8
	DEFS "NODAMAGE"
	DEFW debug_code_nodamage
	DEFB 8
	DEFS "MSXCOLOR"
	DEFW debug_code_msxcolor
	DEFB 9
	DEFS "GAMECLEAR"
	DEFW debug_code_gameclear
	DEFB 0 ; end of debug_code

ENDSCOPE; PASSWORD_CHECK


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 16進数の1文字を0から15の数値にする
;;;;   in hl 入力アドレス
;;;;   out キャリーフラグが立っているとデータNG
;;;;       キャリーフラグが立っていないならデータOK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE HEXTOBIN
HEXTOBIN::
	ld a,[hl]
	inc hl
	sub a,0x30 ;キャラクターコードが'0'より下ならNG
	ret c
	cp a,10
	ccf
	ret nc     ;キャラクターコードが'0'から'9'ならその値を返す
	add a,0x100-0x47+0x30  ;キャラクターコードが'G'以上ならNG
	ret c
	sub a,-6
	ret c
	add a,10
	ret
ENDSCOPE; HEXTOBIN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 16進数の1文字を0から15の数値にする
;;;;   in hl 入力アドレス
;;;;   in de 出力アドレス
;;;;   out キャリーフラグが立っているとデータNG
;;;;       キャリーフラグが立っていないならデータOK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE HEXTOBIN2
HEXTOBIN2::
	call HEXTOBIN
	ret c
	add a,a
	add a,a
	add a,a
	add a,a
	ld b,a
	call HEXTOBIN
	ret c
	or a,b
	ret
ENDSCOPE; HEXTOBIN2


