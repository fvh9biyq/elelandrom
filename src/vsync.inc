;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; WAITサブルーチン WAIT_COUNTが0になるまで待つ
;;;;   call WAIT
;;;;   in a:Aレジスタの値だけ待つ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE WAIT
	;wait
WAIT::
	push hl
	push af
	ld hl,WAIT_COUNT
	ld [hl],a
	ei
wait_loop:
	ld a,[hl]
	or a
	jr nz,wait_loop
skip_wait:
	pop af
	pop hl
	ret
ENDSCOPE; WAIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; BGMデータセット
;;;;   bc:BGMデータ先頭
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE SET_BGM_CURRENT
SET_BGM_CURRENT::
	di
	push hl
	ld hl,BGM_COUNT
	ld [hl],1
	inc hl
	ld [hl],c
	inc hl
	ld [hl],b
	inc hl
	ld [hl],13
	inc hl
	ld [hl],15
	pop hl
	ei
ENDSCOPE; SET_BGM_CURRENT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; VSYNC割り込み処理
;;;;   WAIT_COUNTが0になるまでカウントダウン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE VSYNC
VSYNC_START::
	di
	push af
	push hl
	ld hl,CHGET_COUNT
	ld a,[hl]
	or a
	jr z,skip_chget_count
	dec [hl]
skip_chget_count:

	ld hl,WAIT_COUNT
	ld a,[hl]
	or a
	jr z,skip_wait_count
	dec [hl]
skip_wait_count:
	inc hl ; BGM_COUNT
	ld a,[hl]
	or a
	jp z,skip_bgm_count
	dec a
	ld [hl],a
	jp nz,skip_bgm_count

	;BGM処理
	inc hl ;BGM_CURRENT
	push bc
	push de
	ld c,[hl]
	inc hl
	ld b,[hl]
	dec hl
next_bgm_command:
	ld a,[bc]
	inc bc
	cp 0xf0
	jr c,bgm_keyon ;00-ef
	jr z,bgm_set_tempo ;0xf0
	cp 0xf2
	jr c,bgm_set_volume ;0xf1
	jr z,bgm_set_envelope ;0xf2
	cp 0xf4
	jr c,bgm_set_main ;0xf3
	;0xf4 bgm off
	ld e,0
	ld a,8
	call BIOS_WRTPSG
	jr end_bgm_count
bgm_set_main:
	ld bc,BGM_DATA_MAIN
	call SET_BGM_CURRENT
	jr end_bgm_count
bgm_set_volume:
	inc hl
bgm_set_tempo:
	inc hl
	inc hl
	ld a,[bc]
	inc bc
	ld [hl],a
	ld hl,BGM_CURRENT
	jr next_bgm_command
bgm_set_envelope:
	;次の2バイトをR11、R12の順に書き込む
	ld a,[bc]
	inc bc
	ld e,a
	ld a,11
	call BIOS_WRTPSG
	ld a,[bc]
	inc bc
	ld e,a
	ld a,12
	call BIOS_WRTPSG
	jr next_bgm_command

bgm_keyon:
	;00-ef
	ld d,a
	and 0x0f
	jr nz,bgm_keyon_1
	;休符
	ld e,0
	jr bgm_keyon_2
bgm_keyon_1:
	ld hl,MUSICAL_SCALE-1
	add a,l
	ld l,a
	ld e,[hl]
	xor a
	call BIOS_WRTPSG ;音階を指定
	ld a,13
	ld e,8
	call BIOS_WRTPSG ;エンベロープを指定する事でエンベロープをリセット
	ld hl,BGM_VOLUME
	ld e,[hl]
	ld hl,BGM_CURRENT
bgm_keyon_2:
	ld a,8
	call BIOS_WRTPSG ;音量を指定
	inc hl
	inc hl
	ld e,[hl]
	ld a,d
	and 0xf0
	jr z,set_bgm_count
bgm_tempo_double:
	sla e
	sub 0x10
	jr nz,bgm_tempo_double
set_bgm_count:
	dec hl
	ld [hl],b
	dec hl
	ld [hl],c
	dec hl
	ld [hl],e
end_bgm_count:
	pop de
	pop bc
skip_bgm_count:

	ld hl,GAME_CONTROLLER
	bit GAME_CONTROLLER_WRITE_BIT,[hl]
	jr z,skip_write_vram

	bit GAME_CONTROLLER_SPRITE_BIT,[hl]
	jr z,skip_write_sprite
	push hl
	call PUT_SPRITE
	pop hl
skip_write_sprite:

	bit GAME_CONTROLLER_MAP_BIT,[hl]
	jr z,skip_write_map
	push hl
	ld hl,VIEW_CODE_AREA
	ld de,0x1800
	ld bc,VIEW_CODE_AREA_WIDTH*(VIEW_CODE_AREA_HEIGHT-2)
	call BIOS_LDIRVM
	pop hl
skip_write_map:

	bit GAME_CONTROLLER_STATUS_BIT,[hl]
	jr z,skip_write_status
	push hl
	ld hl,VIEW_CODE_AREA+22*VIEW_CODE_AREA_WIDTH
	ld de,0x1800+22*VIEW_CODE_AREA_WIDTH
	ld bc,VIEW_CODE_AREA_WIDTH*(VIEW_CODE_AREA_HEIGHT-22)
	call BIOS_LDIRVM
	pop hl
skip_write_status:
	ld a,[hl]
	and 0x0f ;GAME_CONTROLLER_WRITE_BITからGAME_CONTROLLER_STATUS_BITをクリア
	ld [hl],a

skip_write_vram:
	pop hl
	pop af
	ei
	jp WORK_H_TIMI_SAVE
ENDSCOPE ;VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; PUT_SPRITE
;;;;  SPRITE内容をVRAMに書き込む
;;;;   call PUT_SPRITE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE PUT_SPRITE
PUT_SPRITE::
	ld hl,0x1b00
	call BIOS_SETWRT
	ld a,[VIDEO_WRITE_PORT]
	ld c,a
	;プレイヤーのスプライト1を出力
	ld hl,PLAYER_Y
	ld b,3
	otir
	ld a,[PLAYER_DAMAGE_COUNT]
	or a
	ld a,7
	jr z,skip_player_damage
	inc a
skip_player_damage:
	out [c],a

	;プレイヤーのスプライト2を出力
	ld hl,PLAYER_Y
	ld b,2
	otir
	ld a,[hl]
	add a,4*4
	out [c],a
	ld a,11
	out [c],a

	call IS_ATTACK
	jr nc,skip_sword
	;剣のスプライトを出力
	ld hl,PLAYER_Y
	outi
	ld a,[hl]
	inc hl
	add a,0x10 ;剣のX座標はプレイヤーが左右どちらに向いていてもプレイヤー+16
	out [c],a
	ld a,[hl]
	and 4   ;[PLAYER_SPRITE]　and 4　が0なら右 1なら左
	ld de,0x0000
	jr z,right
	ld de,0x8004
right:
	ld a,24*4 ;剣のスプライト
	add a,e
	out [c],a

	ld hl,PLAYER_EXP
	ld a,[hl]
	inc a
	ld a,8 ;経験値255なら剣の色S2=8
	jr z,put_sword_color
	dec hl ; PLAYER_ITEMS
	bit ITEM_SWORD_BIT,[hl]
	ld a,10
	jr nz,put_sword_color ;剣を持っていると剣の色S2=10
	ld a,15
put_sword_color:
	or d
	out [c],a ;画面端で剣を出した際に表示されるように左向きの場合、カラーコードのbit7をセットする

skip_sword:
	ld hl,ENEMY_LIST +ENEMY_HP ;敵データ最初のhp
	ld d,ENEMY_MAX_COUNT

put_enemy:
	ld e,ENEMY_SIZE-1-3-1 ;hpが0でない場合にhlに加算する値
	ld a,[hl]
	inc hl
	or a
	jr z,skip_enemy
	ld a,[hl]
	inc hl
	ld b,3
	otir
	ld b,[hl]
	or a
	jr z,skip_enemy_damage
	ld b,8
skip_enemy_damage:
	out [c],b
	jr next_enemy
skip_enemy:
	ld e,ENEMY_SIZE-1 ;hpが0の場合にhlに加算する値
next_enemy:
	;ENEMY_LISTは0xC300から始まるので下位バイトのみ加算
	ld a,e
	add a,l
	ld l,a
	dec d
	jr nz,put_enemy

	;これ以降のスプライトは表示しない
	ld a,NO_SPRITE_Y
	out [c],a

	ret
ENDSCOPE; PUT_SPRITE


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; BGMデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;メインBGM
BGM_DATA_MAIN::
	DEFB 0xf0,16 ;テンポ指定
	DEFB 0xf1,16 ;ボリューム指定
	DEFB 0xf2 ;エンベロープ指定
	DEFW 8000
	DEFB 0x01,0x00,0x03,0x04,0x02,0x01,0x01,0x00,0x03,0x01,0x03,0x00
	DEFB 0x07,0x00,0x09,0x0a,0x08,0x07,0x07,0x00,0x09,0x07,0x09,0x00
	DEFB 0xf3

;宝箱を取った時のBGM
BGM_DATA_CHEST::
	DEFB 0xf0,4 ;テンポ指定
	DEFB 0xf1,16 ;ボリューム指定
	DEFB 0xf2 ;エンベロープ指定
	DEFW 9000
	DEFB 0x0a,0x0b,0x3c,0x30
	DEFB 0xf3

;レベルアップBGM
BGM_DATA_LEVELUP::
	DEFB 0xf0,6 ;テンポ指定
	DEFB 0xf1,15 ;ボリューム指定
	DEFB 0x07,0x06,0x05,0x04,0x20,0x06,0x20,0x37,0x30
	DEFB 0xf3

;クリアBGM
BGM_DATA_CLEAR::
	DEFB 0xf0,6 ;テンポ指定
	DEFB 0xf1,15 ;ボリューム指定
	DEFB 0x07,0x06,0x05,0x04,0x20,0x06,0x05,0x04,0x20,0x06,0x05,0x04,0x06,0x20,0x37
	DEFB 0xf3

;音を消す
BGM_DATA_OFF::
	DEFB 0xf4

