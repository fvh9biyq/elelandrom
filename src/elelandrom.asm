FONT_ADD := 0x0004 ;フォントアドレス
VIDEO_WRITE_PORT := 0x0006 ;VRAMへのデータ書き込みポート

BIOS_FILVRM := 0x0056 ;VRAM の指定領域を同一のデータで埋める。HL に書き込みを開始する VRAM アドレス、BC に書き込む領域の長さ、A にデータ
BIOS_CHGCLR := 0x0062 ;画面の色を変える
 MSXWORK_FORCLR := 0xF3E9 ;色指定
BIOS_INIT32 := 0x006F ;SCREEN1にする
BIOS_SETGRP := 0x007E ;VDP のみを GRAPHIC2 モードにする
BIOS_DISSCR := 0x0041 ;画面表示の禁止
BIOS_CLRSPR := 0x00F5 ;プライトを初期化
 MSXWORK_SCRMOD := 0xFCAF; スクリーンモード
BIOS_WRTVDP := 0x0047 ; VDP のレジスタにデータを書き込む C にレジスタ番号、B にデータ
 MSXWORK_RG1SAV := 0xF3E0 ; VDP#1の保存
BIOS_ENASCR := 0x0044 ;画面の表示
BIOS_SETWRT := 0x0053 ;VDP に VRAM アドレスをセットして、書き込める状態にする。HL に VRAM アドレス
BIOS_LDIRVM := 0x005C ;メモリから VRAM へブロック転送 HL にソース・アドレス (メモリ)、DE にデスティネーション・アドレス (VRAM)、BC に長さ
BIOS_GTSTCK := 0x00D5 ;ジョイスティックの状態を返す A に調べるジョイスティックの番号
BIOS_GTTRIG := 0x00D8 ;トリガボタンの状態を返す Aに調べるトリガボタンの番号 A が 0 ならばトリガボタンは押されていない
BIOS_WRTPSG := 0x0093 ;PSGレジスタへのデータの書き込み A←PSGのレジスタ番号 E←書き込むデータ
BIOS_SNSMAT := 0x0141 ;キーボードマトリクスの読み出し
BIOS_KILBUF := 0x0156 ;キーボードバッファクリア
BIOS_CHSNS  := 0x009C ;キーボードバッファの残りのチェック キーボードバッファが空であればZフラグを立てる
BIOS_CHGET  := 0x009F ;キーボードバッファから1文字入力 (入力待ちあり)
BIOS_EXTROM := 0x015F ;SUB-ROM をインタースロット・コール
 SUBROM_SETPLT := 0x014D ;カラーコードをパレットにセット

WORK_HIMEM := 0xFC4A;
WORK_H_TIMI := 0xFD9F;
WORK_H_TIMI_SIZE := 0xFDA4-WORK_H_TIMI ;5バイト
WORK_CLIKSW := 0xF3DB ;キークリックスイッチ(0=OFF、0以外=ON)

FREE_AREA := 0xC000 ; 初期化時にフリーエリアとして使う
VIEW_CODE_AREA := 0xC000 ;キャラチップを入れておく　32*24の領域　初期化時にフリーエリアとして使う
 VIEW_CODE_AREA_WIDTH := 32;
 VIEW_CODE_AREA_HEIGHT := 24;

ENEMY_INDEX := VIEW_CODE_AREA+VIEW_CODE_AREA_WIDTH*VIEW_CODE_AREA_HEIGHT;敵移動用
ENEMY_COUNT := ENEMY_INDEX+1;敵は1度に移動せず、1体ずつ順に移動する

ENEMY_LIST := ENEMY_COUNT+1;
 ; +0 str
 ENEMY_EXP := +1
 ; +1 exp
 ENEMY_HP := +2
 ; +2 hp
 ENEMY_DAMAGE_COUNT := +3
 ; +3 無敵（ダメージ）カウント
 ENEMY_yPos := +4
 ; +4 Y座標
 ENEMY_xPos := +5
 ; +5 X座標
 ENEMY_SPRITE := +6
 ; +6 スプライトパターン番号
 ; +7 色コード
 ENEMY_yMove := +8
 ; +8 yMove
 ENEMY_xMove := +9
 ; +9 xMove bit0　0=右向き,1=左向き
 ENEMY_yMax := +10
 ; +10 yMax
 ; +11 xMax
 ENEMY_yMin := +12
 ; +12 yMin
 ; +13 xMin
 ENEMY_SIZE := 14
 ENEMY_MAX_COUNT := 4 ;敵は最大4

MAP_ID := ENEMY_LIST+ENEMY_SIZE*ENEMY_MAX_COUNT;
DISABLED_EVENT_ID := MAP_ID+1;マップ移動後のxy座標を取得し、使用不可にする
JUMP_COUNT := DISABLED_EVENT_ID+1 ; ジャンプ状態
  ;0の時着地　上ボタンを押していれば1へ　押していなければ下ブロックを調べ、地面でないなら落下
  ;1～16　上2
  ;17～32　上1
  ;32～40　0　天井 41までに上ボタンを離すと41になる
  ;41～56　-1　ここから上ボタンを離してもカウントアップ
    JUMP_COUNT_DOWN := 41
  ;57～　-2 落下　
    JUMP_COUNT_FALL := 57
  ;上ボタンを押している時 カウントアップ　JUMP_COUNT_FALL以上でJUMP_COUNT_FALLに
  ;上ボタンを離している時 0の時JUMP_COUNT_FALL　1以上　JUMP_COUNT_DOWN未満　の時JUMP_COUNT_DOWN　それ以外カウントアップ
ATTACK_COUNT := JUMP_COUNT+1 ; 攻撃の状態
  ATTACK_COUNT_END := 33
  ;0、33の時　攻撃なし　スペースキーを押していれば1～33までの値
  ;スペースキーを離すと0に戻る

WORK_H_TIMI_SAVE := ATTACK_COUNT+1; WORK_H_TIMIのコピー
GAME_CONTROLLER :=  WORK_H_TIMI_SAVE+WORK_H_TIMI_SIZE ;ゲーム処理
 ;bit0 1:MAPデータ書き込み
 ;bit1 1:イベントでマップ移動した場合、15/60秒待つ
 ;bit2 1:このマップで敵全滅した
WAIT_COUNT := GAME_CONTROLLER+1 ;移動後、この時間待つ
INTERVAL_TIMER := WAIT_COUNT+1 ;VSYNC毎にカウントアップされる
BGM_COUNT := INTERVAL_TIMER+1; BGMのカウント
BGM_CURRENT := BGM_COUNT+1 ; 現在処理中のBGMの位置
BGM_COUNT_DEFAULT := BGM_CURRENT+2 ;
BGM_VOLUME := BGM_COUNT_DEFAULT+1 ; BGMボリューム

PLAYER_Y := BGM_VOLUME+1 ; +0 Y座標
 NO_SPRITE_Y := 208 ;Y座標をこの値にするとその面以降のスプライトは表示されない
 END_SPRITE_Y := 192;スプライトを画面外においやる
PLAYER_X := PLAYER_Y+1 ; +1 X座標
PLAYER_SPRITE := PLAYER_X+1 ; +2 パターン番号
 ; +3 色コード

PLAYER_ITEMS := PLAYER_SPRITE+1 ;各アイテム 盾(bit7)、剣(bit6)、鍵(bit5)、ランプ(bit4)、ハンマー(bit3)、魔法のランプ(bit2)、妖精(bit1) があると1
 ITEM_SHIELD := 0x80 ;盾(bit7) 0番
 ITEM_SWORD := 0x40 ;剣(bit6) 1番
 ITEM_KEY := 0x20 ;鍵(bit5) 2番
 ITEM_LAMP := 0x10 ;ランプ(bit4) 3番　持っていると透明な壁が見える
 ITEM_HAMMER := 0x08 ;ハンマー(bit3) 4番
 ITEM_MAGICLAMP := 0x04 ;魔法のランプ(bit2) 5番　持っていると雲の上を歩ける
 ITEM_FAIRY := 0x02 ;妖精(bit1) 6番

PLAYER_EXP := PLAYER_ITEMS+1
PLAYER_NEXTEXP := PLAYER_EXP+1
PLAYER_LEVEL := PLAYER_NEXTEXP+1
PLAYER_HPMAX := PLAYER_LEVEL+1
PLAYER_HP := PLAYER_HPMAX+1

;デバッグ用のマクロ
include "src/debug.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MSX ROM ヘッダ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG 0x4000
	DEFS "AB" ; rom ID
	DEFW SYSTEM_INIT ; INIT(初期化ルーチンのアドレス)
	DEFW 0 ; STATEMENT(BASICステートメント拡張ルーチンのアドレス)
	DEFW 0 ; DEVICE(BASICデバイス拡張ルーチンのアドレス)
	DEFW 0 ; TEXT(オートスタートさせるBASICのコードのアドレス)
	DEFB 0,0,0,0,0,0 ; リザーブ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; マップテーブル
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
include "build/src/map.map.tbl"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; IS_BLOCKで使用するデータ
;;;;  スプライトは1ドットずれているため、それを加味したデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IS_BLOCK_CHECK_DATA::
	DEFW 0x0200,0x0800,0x0c00 ; 上
	DEFW 0x0d01,0x0d08,0x0d0f ; 右
	DEFW 0x0211,0x0811,0x0c11 ; 下
	DEFW 0x0101,0x0108,0x010f ; 左

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; プレイヤーレベル毎の攻撃力
;;;;   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PLAYER_ATTACK_POINT::
	DEFB   4;,3 ;レベル1
	DEFB  10;,10 ;レベル2
	DEFB  20;,20 ;レベル3
	DEFB  34;,33 ;レベル4
	DEFB  50;,50 ;レベル5
	DEFB  70;,70 ;レベル6
	DEFB  94;,93 ;レベル7
	DEFB 120;,120 ;レベル8
	DEFB 150;,150 ;レベル9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; メイン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE MAIN
MAIN::
	call TITLE ;タイトル表示
	call GAME_INIT ; 画面初期化
loop:
	call MOVE_PLAYER ;プレイヤー方向キーで移動
	call SET_ATTACK_COUNT ;プレイヤー攻撃
	call CHECK_ENEMY ;敵処理
	call CHECK_EVENT ;イベント確認
	call CHECK_MAPMOVE ;画面端でマップ移動していないかチェック

	call PUT_SPRITE

	ld  hl,GAME_CONTROLLER
	bit 0,[hl]
	jr z,skip_write_map
	res 0,[hl]
	call WRITE_VIEW_CODE_AREA
skip_write_map:

	ld  hl,GAME_CONTROLLER
	bit 1,[hl]
	jr z,skip_wait
	res 1,[hl]
	ld a,15 ;イベントでマップ移動した場合、15/60秒待つ
	call WAIT
skip_wait:

	jr loop
;	call ENDING
	jr MAIN
ENDSCOPE; MAIN


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; タイトル画面
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE TITLE
TITLE::
	xor a,a
	ld hl,MAP_ID
	ld [hl],a
	inc hl
	ld [hl],a ;DISABLED_EVENT_ID
	inc hl
	ld [hl],a ;JUMP_COUNT
	inc hl
	ld [hl],a ;ATTACK_COUNT

	ld hl,PLAYER_ITEMS
	ld [hl],a
	ld de,PLAYER_ITEMS+1
	ld bc,6
	ldir

	; SPRITE 初期化
	ld hl,PLAYER_Y
	ld [hl],112
	inc hl
	ld [hl],120
	inc hl
	xor a,a
	ld [hl],a
	call PUT_SPRITE

put_title:
	call CLEAR_VIEW_CODE_AREA
	ld hl,text_title
	ld b,3
put_text_loop:
	call TEXT_COPY
	djnz put_text_loop
	call WRITE_VIEW_CODE_AREA

	call BIOS_KILBUF
loop:
	call GTTRIG
	ret nz
	call BIOS_CHSNS
	jr z,loop
	call BIOS_CHGET
	cp a,0x0D ;リターンキーを押すとパスワード入力
	jr nz,loop

	ld hl,text_input_passward
	call TEXT_COPY

	ld b,PASSWARD_MAXSIZE
	ld hl,VIEW_CODE_AREA+10+22*VIEW_CODE_AREA_WIDTH
input_passward_loop:
	push hl
	push bc
	call WRITE_VIEW_CODE_AREA
no_input:
	ld a,12
	call WAIT ;一定時間待つ
	call BIOS_KILBUF ;WAIT処理中の入力をクリア
	call BIOS_CHGET ;キーボード入力があるまで待つ
	cp a,0x0D ;リターンキーを押すと入力終了
	jr z,input_end
	cp a,0x08 ;BSキーを押すと1つ戻る
	jr z,input_back
	cp a,0x1D ;左キーを押すと1つ戻る
	jr z,input_back
	cp a,0x7F ;DELキーを押すと1つ戻る
	jr nz,skip_back
input_back:
	pop bc
	push bc
	ld a,PASSWARD_MAXSIZE
	cp a,b
	jr z,no_input ;最大文字数なら何もしない
	pop bc
	pop hl
	dec hl
	inc b
	ld [hl],0
	jr input_passward_loop
skip_back:
	pop bc
	push bc
	dec b
	jr z,no_input ;最後の入力はリターンキーのみ受け付ける
	cp a,0x30 ;0より下のキャラクターは無視
    jr c,no_input
    cp a,0x3A ;0-9なら入力OK
    jr c,input_ok
	and a,0xDF;アルファベット大文字にする
    cp a,0x41 ;Aより下のキャラクターは無視
    jr c,no_input
	cp a,0x5B ;A-Zなら入力OK
    jr nc,no_input
input_ok:
	pop bc
	pop hl
	ld [hl],a
	inc hl
	djnz input_passward_loop
	jr check_password
input_end:
	pop bc
	pop hl
check_password:
	ld hl,VIEW_CODE_AREA+10+22*VIEW_CODE_AREA_WIDTH
	
	;パスワードの入力確認
	call PASSWORD_CHECK
	jp c,put_title ;パスワードの入力NGならタイトル再描画
	;パスワードの入力OKならゲームスタート
	ret
text_title:
	DEFW VIEW_CODE_AREA+12+10*VIEW_CODE_AREA_WIDTH
	DEFS "ELE LAND"
	DEFB 0
	DEFW VIEW_CODE_AREA+9+18*VIEW_CODE_AREA_WIDTH
	DEFS "PUSH SPACE KEY"
	DEFB 0
	DEFW VIEW_CODE_AREA+4+21*VIEW_CODE_AREA_WIDTH
	DEFS "PASSWORD: PUSH RETURN KEY"
	DEFB 0
text_input_passward:
	DEFW VIEW_CODE_AREA+4+21*VIEW_CODE_AREA_WIDTH
	DEFS "      INPUT PASSWORD     "
	DEFB 0
ENDSCOPE; TITLE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 画面初期化
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE GAME_INIT
GAME_INIT::
	ld hl,PLAYER_Y
	ld [hl],120

	ld bc,BGM_DATA_MAIN
	call SET_BGM_CURRENT

	call CLEAR_VIEW_CODE_AREA
	call SET_MAPDATA ; マップ表示
	call CALC_PLAYER_STATUS
	ld hl,PLAYER_HPMAX
	ld a,[hl]
	inc hl
	ld [hl],a
	call PUT_STATUS
	call WRITE_VIEW_CODE_AREA

	;GAME_CONTROLLER 初期化
	xor a,a
	ld [GAME_CONTROLLER],a

	ret
ENDSCOPE; GAME_INIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 方向キーで移動
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE MOVE_PLAYER
MOVE_PLAYER::
	call GTSTCK
	push af
	jr z,skip_move
	cp a,2
	jr c,skip_right
	cp a,5
	jr nc,skip_right
	ld a,1*6
	call IS_BLOCK
	jr c,skip_move
	ld a,[de]
	inc a
	ld b,0*4 ;右向きのスプライトパターン番号
move_1:
	ex de,hl
	ld [hl],a ;X座標増加
	inc l
	and a,8
	jr z,sprite_move_pattern
	set 3,b
sprite_move_pattern:
	ld [hl],b ;パターン番号
	jr skip_left
skip_right:
	cp a,6
	jr c,skip_left
	ld a,3*6
	call IS_BLOCK
	jr c,skip_left
	ld a,[de]
	dec a
	ld b,1*4 ;左向きのスプライトパターン番号
	jr move_1
skip_left:
skip_move:
	pop af
	jr z,not_press
	add a,256-8 ;8→0 7→255 ... 3→251 2→250 1→249
	cp a,251
not_press:
	ld hl,JUMP_COUNT
	ld a,[hl]
	jr c,jump_countup
	;上ボタンを離している時
	or a,a
	jr nz,not_fall
	; 0の時JUMP_COUNT_FALL
	ld a,JUMP_COUNT_FALL
	jr set_a
not_fall:
	cp a,JUMP_COUNT_DOWN
	jr nc,jump_countup
	ld a,JUMP_COUNT_DOWN
	jr set_a
jump_countup:
	inc a
set_a:
	ld [hl],a
	;JUMP_COUNTが
	cp a,41
	jr c,under_41
	ld bc,0x0100+2*6
	cp a,57
	jr c,loop ;JUMP_COUNTが41以上なら「下ブロックを調べ、地面でないなら落下、落下できないならJUMP_COUNTを0にする」を1回
	inc b     ;JUMP_COUNTが57以上なら「下ブロックを調べ、地面でないなら落下、落下できないならJUMP_COUNTを0にする」を2回
	ld [hl],JUMP_COUNT_FALL ;JUMP_COUNTの最大値を57にする
	jr loop
under_41:
	cp a,32
	jr nc,skip_jump ;JUMP_COUNTが32以上ならなにもしない
	ld bc,0x0200+0*6
	cp a,17
	jr c,loop ;JUMP_COUNTが17未満なら「上ブロックを調べ、地面でないなら上昇」を2回
	dec b ;JUMP_COUNTが17以上なら「上ブロックを調べ、地面でないなら上昇」を1回

loop:
	push bc
	ld a,c
	call IS_BLOCK
	pop bc
	jr c,skip_down
	dec e
	ex de,hl
	ld a,c ;cは0（上）または12（下） cが0ならY座標-1、cが12ならY座標+1
	rrca
	and a,2
	dec a
	add a,[hl]
	ld [hl],a
	djnz loop
	jr skip_jump
skip_down:
	ld hl,JUMP_COUNT
	ld a,[hl]
	cp a,JUMP_COUNT_DOWN
	jr c,skip_jump
	xor a,a
	ld [hl],a
skip_jump:
	ret
ENDSCOPE; MOVE_PLAYER

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 攻撃
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE SET_ATTACK_COUNT
SET_ATTACK_COUNT::
	call GTTRIG
	ld hl,ATTACK_COUNT
	ld a,[hl]
	jr nz,attack
	; スペースキーを押していなければ
	xor a,a
	jr set_a
attack:
	; スペースキーを押していれば
	inc a
	cp a,ATTACK_COUNT_END
	jr c,set_a
	ld a,ATTACK_COUNT_END
set_a:
	ld [hl],a
	ret
ENDSCOPE; SET_ATTACK_COUNT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 敵移動
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CHECK_ENEMY
CHECK_ENEMY::
	ld de,ENEMY_LIST+ENEMY_HP ;最初の敵のhp
	ld a,[ENEMY_COUNT]
	ld b,a
loop:
	ld a,[ENEMY_INDEX]
	inc a
	cp a,b
	jr nz,skip_move
	ld a,[de]
	or a,a
	jr z,skip_move

	push de
	pop ix
	call MOVE_ENEMY;Y座標について
	inc ix

	ld a,[ix+ENEMY_DAMAGE_COUNT -ENEMY_HP-1] ;ダメージカウント
	or a,a
	jr z,skip_down_damage_count
	;敵キャラにダメージがあれば横移動＆足踏みなし＆攻撃されない
	dec [ix+ENEMY_DAMAGE_COUNT -ENEMY_HP-1]
	jp skip_attack

skip_down_damage_count:
	call MOVE_ENEMY;X座標について

	ld a,[ix+ENEMY_SPRITE -ENEMY_HP-1] ; パターン番号 (ixはhp+1の位置にある)
	and a,255-4
	bit 0,[ix+ENEMY_xMove -ENEMY_HP-1] ; xMove (ixはhp+1の位置にある)
	jr z,right
	or a,4 ;スプライトパターン番号を左向きにする
right:
	ld [ix+ENEMY_SPRITE -ENEMY_HP-1],a

	;敵を足踏みさせる
	ld a,[ix+ENEMY_xPos -ENEMY_HP-1]
	and a,0x07
	cp a,04
	jr nz,skip_move
	ld a,[ix+ENEMY_SPRITE -ENEMY_HP-1] ; パターン番号
	xor a,2*4
	ld [ix+ENEMY_SPRITE -ENEMY_HP-1],a
skip_move:
	call IS_ATTACK
	jp nc,skip_attack
	; 剣の位置と敵の位置を比較し、ヒットしていればダメージを与える
	ld hl,PLAYER_Y
	ld a,[hl]
	add a,11 ;剣の下部分
	sub a,[ix+ENEMY_yPos -ENEMY_HP-1] ;敵yPosが剣の下部分より下ならヒットしない
	jr c,skip_attack
	cp a,5+16 ;剣の上部分 todoこの辺ちゃんと
	jr nc,skip_attack
	inc hl
	ld a,[hl]
	inc hl
	sub a,0
	bit 2,[hl]
	jr nz,left_attack
	;右向き
	add a,32+0
left_attack:
	sub a,[ix+ENEMY_xPos -ENEMY_HP-1] ;敵xPosが剣の右部分より右ならヒットしない
	jr c,skip_attack
	cp a,32
	jr nc,skip_attack
	;敵ダメージ処理
	ld a,[ix+ENEMY_xPos -ENEMY_HP-1] ;敵吹っ飛ぶ
	sub a,8
	bit 2,[hl]
	jr nz,left_knock_back
	add a,16
left_knock_back:
	ld [ix+ENEMY_xPos -ENEMY_HP-1],a ;敵吹っ飛ぶ

	ld a,3 ;敵無敵時間
	ld [ix+ENEMY_DAMAGE_COUNT -ENEMY_HP-1],a

	;敵HP減少
	push hl
	ld a,[PLAYER_LEVEL]
	ld hl,PLAYER_ATTACK_POINT-1
	add a,l
	ld l,a
	ld l,[hl]
	ld a,[ix+ENEMY_HP -ENEMY_HP-1] ;
	sub a,l
	jr nc,set_hp
	xor a,a
set_hp:
	ld [ix+ENEMY_HP -ENEMY_HP-1],a

	or a,a
	jr nz,skip_enemy_hp0
	;敵倒した
	ld a,[ix+ENEMY_EXP -ENEMY_HP-1]
	ld hl,PLAYER_EXP
	add a,[hl]
	jr nc,set_exp
	ld a,255
set_exp:
	ld [hl],a
	push de
	push bc
	call CALC_PLAYER_STATUS
	jr z,skip_levelup
	;レベルアップ
	ld hl,PLAYER_HPMAX
	ld a,[hl]
	inc hl
	ld [hl],a
	ld bc,BGM_DATA_LEVELUP
	call SET_BGM_CURRENT
skip_levelup:
	pop bc
	pop de
skip_enemy_hp0:
	pop hl

	;敵HP表示
	push de
	ld hl,VIEW_CODE_AREA+14+23*VIEW_CODE_AREA_WIDTH+1
	xor a,a
	ld [hl],a
	dec hl
	ld [hl],a
	push ix
	pop de
	dec de
	call BYTE_TO_TEXT
	call DAMAGE_EFFECT
	;敵に当たると剣を引っ込める
	ld a,ATTACK_COUNT_END
	ld [ATTACK_COUNT],a
	pop de
skip_attack:
	ld a,e
	add a,ENEMY_SIZE
	ld e,a
;	djnz loop
	dec b
	jp nz,loop

	;ENEMY_INDEX増加
	ld hl,ENEMY_COUNT
	ld b,[hl]
	dec l
	ld a,[hl]
	inc a
	cp a,b
	jr c,set_enemy_index
	xor a,a
set_enemy_index:
	ld [hl],a
	ret
ENDSCOPE; CHECK_ENEMY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; イベント確認
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CHECK_EVENT
CHECK_EVENT::
	call GET_EVENT_ID
	ld hl,DISABLED_EVENT_ID
	cp a,[hl]
	jr z,SKIP_EVENT ;一度実行したイベントは移動しないと再実行されない　パスワード表示位置でじっとしていても再実行されない
	ld [hl],a

	cp a,1
	jr c,SKIP_EVENT ;EVENT_ID=0 NoAction アクションなし
	jr z,event_getitem ;EVENT_ID=1 GetItem アイテム取得
	sub a,3
	jr c,event_getitem ;EVENT_ID=2 GetItem アイテム取得
	jp z,EVENT_PASSWORD ;EVENT_ID=3 Password パスワード表示
	;EVENT_ID=4以上 Warp ワープ
	ld hl,GAME_CONTROLLER
	set 1,[hl]
	ld hl,WARP_LIST-3
	ld c,a
	add a,a
	add a,c
	add a,l
	ld l,a
	ld a,[hl]
	ld [MAP_ID],a
	inc hl
	ld de,PLAYER_Y
	ldi ;y
	ldi ;x
	call GET_EVENT_ID
	ld [DISABLED_EVENT_ID],a ;ワープ先のワープイベントを実行しないようにする
	jp MAP_MOVE
event_getitem:
	ld hl,PLAYER_ITEMS
	ld a,[hl]
	or a,b
	ld [hl],a
	call PUT_STATUS
	ld bc,BGM_DATA_CHEST
	call SET_BGM_CURRENT
	call SET_MAPDATA_ONLY

SKIP_EVENT::

	;敵全滅時の処理
	ld hl,GAME_CONTROLLER
	bit 2,[hl]
	ret nz ;既に全滅している
	call ISNOENEMY
	ret nz ;全滅していない
	set 2,[hl]
	call SET_MAPDATA_ONLY

	ret
ENDSCOPE; CHECK_EVENT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 敵が全滅していれば
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE ISNOENEMY
ISNOENEMY::
	push hl
	push de
	push bc
	ld hl,ENEMY_LIST+ENEMY_HP
	ld b,4
	ld de,ENEMY_SIZE
loop:
	ld a,[hl]
	or a,a
	jr nz,skip
	add hl,de
	djnz loop
skip:
	pop bc
	pop de
	pop hl
	ret
ENDSCOPE; ISNOENEMY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 画面端でマップ移動していないかチェック
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CHECK_MAPMOVE
CHECK_MAPMOVE::
	ld hl,PLAYER_Y
	ld a,[hl]
	cp a,19*8+6 ;Y座標が画面下20*8から24*8の場合はマップ下へ
	jr c,not_down
	cp a,24*8
	jr nc,not_down

	ld bc,0x0400
	ld d,255
	ld hl,PLAYER_X
	ld e,[hl]
	jr move_2

not_down:
	inc hl
	ld a,[hl]
	cp a,4 ;画面左4ドットよりXが小さい場合はマップ左へ
	jr nc,not_left

	ld bc,0x00ff
	ld e,256-8-16
move_1:
	ld hl,PLAYER_Y
	ld d,[hl]
move_2:
	ld hl,MAP_ID
	ld a,[hl]
	and a,0x03
	add a,c
	and a,0x03
	ld c,a
	ld a,[hl]
	and a,0x0c
	add a,b
	cp a,12
	jr c,map_max
	add a,b
map_max:
	and a,0x0c
	or a,c
	ld [hl],a

	ld hl,PLAYER_Y
	ld [hl],d ;Y座標
	inc hl
	ld [hl],e ;X座標

MAP_MOVE::
	ld hl,GAME_CONTROLLER
	res 2,[hl] ;全滅フラグを消す
	call SET_MAPDATA
	jr not_right

not_left:
	cp a,256-4-16+1 ;画面右4ドットよりXが大きい場合はマップ右へ
	jr c,not_right

	ld bc,0x0001
	ld e,8
	jr move_1
not_right:
	ret

ENDSCOPE ;CHECK_MAPMOVE


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 画面領域クリア 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CLEAR_VIEW_CODE_AREA
CLEAR_VIEW_CODE_AREA::
	ld hl,VIEW_CODE_AREA
	ld bc,VIEW_CODE_AREA_WIDTH*VIEW_CODE_AREA_HEIGHT-1
	jp CLEAR_AREA
ENDSCOPE; CLEAR_VIEW_CODE_AREA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 領域クリア
;;;;   in bc:バイト数-1 hl:アドレス
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CLEAR_AREA
CLEAR_AREA::
	xor a,a
	ld [hl],a
	ld d,h
	ld e,l
	inc de
	ldir
	ret
ENDSCOPE; CLEAR_AREA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; マップIDから先頭アドレスを取得
;;;;   out hl:マップデータ先頭アドレス
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE GET_MAP_ADDR
GET_MAP_ADDR::
	ld hl,MAP_LIST
	ld a,[MAP_ID]
	add a,a
	;マップテーブルは256バイト境界を超えないのでhレジスタの演算は不要
	add a,l
	ld l,a
	ld e,[hl]
	inc hl
	ld d,[hl]
	ex de,hl
	ret
ENDSCOPE; GET_MAP_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; プレイヤーのx,y座標にあるイベントIDを取得
;;;;   out a:イベントデータ1バイト目の下位位6ビット
;;;;       b:イベントデータ2バイト目　アイテムデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE GET_EVENT_ID
GET_EVENT_ID::
	call GET_MAP_ADDR
	jr event_skip_mode

event_next:
	inc hl
	inc hl
event_skip_mode:
	inc hl ;skip mode
	ld a,[hl]
	inc hl
	or a,a
	ret z ;end of event
	and a,0x3f ;イベントデータ1バイト目の下位位6ビットが0ならNoAction
	jr z,event_next
	ld c,a
	cp a,2
	jr z,event_id_is_getitemnoenemy
	jr nc,event_id_is_not_getitem
event_id_is_getitem:
	;EVENT_ID=1 GetItemの場合、イベントデータ2バイト目はアイテムデータ　アイテムを持っていればNoAction
	ld b,[hl]
	ld a,[PLAYER_ITEMS]
	and a,b
	jr nz,event_next
	jr check_xy_pos
event_id_is_getitemnoenemy:
	call ISNOENEMY
	jr nz,event_next
	jr event_id_is_getitem
event_id_is_not_getitem:
	ld a,[PLAYER_ITEMS]
	ld b,a
	ld a,[hl]
	cpl
	or a,b
	inc a
	jr nz,event_next ;イベントデータ2バイト目はアイテムデータ　アイテムを持っていなければNoAction
	ld b,[hl] ;イベントデータ2バイト目　アイテムデータをbに保存
check_xy_pos:
	inc hl

	ld de,PLAYER_X
	ld a,[de]
	dec de
	add a,4
	sub a,[hl] ;イベントデータ3バイト目はスプライトx座標
	inc hl
	jr c,event_skip_mode
	cp a,8
	jr nc,event_skip_mode

	ld a,[de]
	sub a,[hl] ;イベントデータ4バイト目はスプライトy座標
	jr nz,event_skip_mode

	ld a,c
	ret
ENDSCOPE; GET_EVENT_ID


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; マップ表示 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE SET_MAPDATA
SET_MAPDATA::

	;敵データをクリア
	ld hl,ENEMY_INDEX
	ld [hl],0
	ld de,ENEMY_INDEX+1
	ld bc,ENEMY_SIZE*ENEMY_MAX_COUNT+2-1
	ldir

	;敵データをコピー
	call GET_MAP_ADDR
	dec hl
	ld c,[hl]
	dec c
	jr z,skip_copy_enemy
	ld a,l
	sub a,c
	ld l,a
	ld a,h
	sbc a,0
	ld h,a
	ld de,ENEMY_COUNT
	ldir
skip_copy_enemy:
SET_MAPDATA_ONLY::
	;マップデータ処理
	call GET_MAP_ADDR
	inc hl ;skip mode
next_event: ;skip イベントデータ
	ld a,[hl]
	inc hl
	or a,a
	jr z,map
	inc hl
	inc hl
	inc hl
	jr next_event
map:
	;マップデータ展開
	ld de,VIEW_CODE_AREA
loop:
	ld a,[hl]
	inc hl
	ld b,1
	cp a,91
	jr nc,loop1
	add a,2
	ld b,a
	ld a,[hl]
	inc hl
loop1:
	ld [de],a
	inc de
	djnz loop1

	push hl
	ld hl,65536-(VIEW_CODE_AREA+32*22)
	add hl,de
	ld a,h
	or a,l
	pop hl
	jr nz,loop

	;イベントデータ処理
	call GET_MAP_ADDR
	jr event_skip_mode

	;表示用データ
	DEFB 0x5b ;[ 1:宝箱
	DEFB 0xd8 ;リ 2:扉
	DEFB 0xd4 ;ヤ 3:妖精
event_next:
	inc hl
	inc hl
event_skip_mode:
	inc hl ;skip mode
	ld a,[hl]
	inc hl
	or a,a
	jr z,invisible_wall
	ld c,a
	and a,0x3f;イベントデータ1バイト目の下位2ビットがEVENT_ID=2 GetItemNoEnemy 敵全滅時アイテム取得
	cp a,2
	jr nz,event_id_is_not_getitemnoenemy
	call ISNOENEMY
	jr nz,event_next
event_id_is_not_getitemnoenemy:
	ld a,c
 	and a,0xc0 ;イベントデータ1バイト目の上位2ビットが0なら表示に変更なし
	jr z,event_next
	ld c,a
	ld a,[PLAYER_ITEMS]
	and a,[hl]
	jr nz,event_next ;イベントデータ2バイト目はアイテムデータ　アイテムを持っていれば表示に変更なし
	inc hl
	ld a,[hl] ;イベントデータ3バイト目はスプライトx座標
	rrca ;スプライトx座標を1/8にすることでRAMアドレスになる
	rrca
	rrca
	inc hl
	ld e,[hl] ;イベントデータ4バイト目はスプライトy座標
	inc e
	ld d,VIEW_CODE_AREA/256/4
	ex de,hl
	add hl,hl ;スプライトy座標を1/8*32、すなわち4倍にすることでRAMアドレスになる
	add hl,hl
	or a,l
	ld l,a

	ld a,c
	rlca
	rlca
	ld bc,event_next-4  ;1:宝箱 2:扉 3:妖精
	add a,c
	ld c,a
	ld a,b
	adc a,0
	ld b,a
	ld a,[bc] ;出力文字

	ld c,a
	ld [hl],a
	inc hl
	add a,2
	ld [hl],a
	ld a,31
	add a,l
	ld l,a
	ld a,h
	adc a,0
	ld h,a
	ld a,c
	inc a
	ld [hl],a
	inc hl
	add a,2
	ld [hl],a
	ex de,hl
	jr event_skip_mode

invisible_wall:
	;透明な壁の処理
	call GET_MAP_ADDR
	bit 0,[hl]
	jr z,skip_invisible_wall
	ld a,[PLAYER_ITEMS]
	and a,ITEM_LAMP
	jr nz,skip_invisible_wall ;ランプを持っていると透明な壁が見える
	;　壁を透明にする　マップ上の242を255に変更
	ld hl,VIEW_CODE_AREA
	ld bc,VIEW_CODE_AREA_WIDTH*22
	ld e,255
	ld a,242
loop_invisible_wall:
	cpir
	jr nz,not_invisible_wall
	dec hl
	ld [hl],e
	inc hl
not_invisible_wall:
	jp pe,loop_invisible_wall

skip_invisible_wall:

	ld hl,GAME_CONTROLLER
	set 0,[hl]

	ret
ENDSCOPE; SET_MAPDATA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; BGM 音階
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MUSICAL_SCALE::
	DEFB 0xD6 ; O5C 0x01
	DEFB 0xBE ; O5D 0x02
	DEFB 0xAA ; O5E 0x03
	DEFB 0x8F ; O5G 0x04
	DEFB 0x7F ; O5A 0x05
	DEFB 0x71 ; O5B 0x06
	DEFB 0x6B ; O6C 0x07
	DEFB 0x5F ; O6D 0x08
	DEFB 0x55 ; O6E 0x09
	DEFB 0x47 ; O6G 0x0a
	DEFB 0x40 ; O6A 0x0b
	DEFB 0x39 ; O6B 0x0c

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
	ld hl,WAIT_COUNT
	ld a,[hl]
	or a,a
	jr z,skip_wait_count
	dec [hl]
skip_wait_count:
	inc hl ; INTERVAL_TIMER
	inc [hl]

	inc hl ; BGM_COUNT
	ld a,[hl]
	or a,a
	jp z,skip_bgm_count
	dec a
	ld [hl],a
	jp nz,skip_bgm_count

	;BGM処理
	inc hl
	push bc
	push de
	ld c,[hl]
	inc hl
	ld b,[hl]
	dec hl
next_bgm_command:
	ld a,[bc]
	inc bc
	cp a,0xf0
	jr c,bgm_keyon ;00-ef
	jr z,bgm_set_tempo ;0xf0
	cp a,0xf2
	jr c,bgm_set_volume ;0xf1
	jr z,bgm_set_envelope ;0xf2
	cp a,0xf4
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
	and a,0x0f
	jr nz,bgm_keyon_1
	;休符
	ld e,0
	jr bgm_keyon_2
bgm_keyon_1:
	ld hl,MUSICAL_SCALE-1
	add a,l
	ld l,a
	ld e,[hl]
	xor a,a
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
	and a,0xf0
	jr z,set_bgm_count
bgm_tempo_double:
	sla e
	sub a,0x10
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

	pop hl
	pop af
	ei
	jp WORK_H_TIMI_SAVE
ENDSCOPE ;VSYNC

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
	or a,a
	jr nz,wait_loop
skip_wait:
	pop af
	pop hl
	ret
ENDSCOPE; WAIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ダメージ音声
;;;;   call DAMAGE_EFFECT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE DAMAGE_EFFECT
DAMAGE_EFFECT::
	push bc
	push de
	push hl

	call PUT_SPRITE
	call PUT_STATUS

	ld a,9
	ld e,15
	call BIOS_WRTPSG
	ld a,3
	ld e,0
	call BIOS_WRTPSG
	ld b,a
loop_1:
	ld d,0
loop_2:
	ld a,d
	add a,a ;*2
	ld e,a
	add a,a ;*4
	add a,a ;*8
	add a,a ;*16
	add a,a ;*32
	sub a,e ;*30
	ld e,a
	ld a,2
	call BIOS_WRTPSG
	ld a,1
	call WAIT
	inc d
	ld a,d
	cp a,6
	jr c,loop_2
	djnz loop_1
	ld a,9
	ld e,0
	call BIOS_WRTPSG
	pop hl
	pop de
	pop bc
	ret
ENDSCOPE; DAMAGE_EFFECT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SET_3LINE VRAMの上中下段それぞれにデータを書き込み
;;;;   call SET_3LINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE SET_3LINE
SET_3LINE::
	ld a,03
loop:
	push af
	push hl
	push bc
	push de
	call BIOS_LDIRVM
	pop de
	ld a,8
	add a,d
	ld d,a
	pop bc
	pop hl
	pop af
	dec a
	jr nz,loop
	ret
ENDSCOPE; SET_3LINE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; WRITE_VIEW_CODE_AREA
;;;;  VIEW_CODE_AREA の内容をVRAMに書き込む
;;;;   call WRITE_VIEW_CODE_AREA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE WRITE_VIEW_CODE_AREA
WRITE_VIEW_CODE_AREA::
	ld hl,VIEW_CODE_AREA
	ld de,0x1800
	ld bc,VIEW_CODE_AREA_WIDTH*VIEW_CODE_AREA_HEIGHT
	call BIOS_LDIRVM
	ret
ENDSCOPE; WRITE_VIEW_CODE_AREA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; PUT_SPRITE
;;;;  SPRITE内容をVRAMに書き込む
;;;;   call PUT_SPRITE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE PUT_SPRITE
PUT_SPRITE::
	ld hl,0x1b00
	call BIOS_SETWRT
	ld a,1
	call WAIT;ちらつき防止のため、vsync割り込みを待つ
	ld a,[VIDEO_WRITE_PORT]
	ld c,a
	;プレイヤーのスプライト1を出力
	ld hl,PLAYER_Y
	ld b,3
	otir
	ld a,7
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
	and a,4   ;[PLAYER_SPRITE]　and 4　が0なら右 1なら左
	ld de,0x0000
	jr z,right
	ld de,0x8004
right:
	ld a,24*4 ;剣のスプライト
	add a,e
	out [c],a
	ld a,15
	or a,d
	out [c],a ;画面端で剣を出した際に表示されるように左向きの場合、カラーコードのbit7をセットする

skip_sword:
	ld hl,ENEMY_LIST +ENEMY_HP ;敵データ最初のhp
	ld d,ENEMY_MAX_COUNT

put_enemy:
	ld e,ENEMY_SIZE-1-3-1 ;hpが0でない場合にhlに加算する値
	ld a,[hl]
	inc hl
	or a,a
	jr z,skip_enemy
	ld a,[hl]
	inc hl
	ld b,3
	otir
	ld b,[hl]
	or a,a
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
;;;; GTTRIG
;;;;  トリガボタンの状態を返す　押されていなければZフラグが立つ
;;;;   call GTTRIG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE GTTRIG
GTTRIG::
	ld a,1
	call BIOS_GTTRIG
	or a,a
	ret nz
	call BIOS_GTTRIG
	or a,a
	ret
ENDSCOPE; GTTRIG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GTSTCK
;;;;  ジョイスティックの状態を返す A に調べるジョイスティックの番号 押されていなければZフラグが立つ 押しても押されていなくてもキャリーフラグは偽
;;;;   call GTSTCK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE GTSTCK
GTSTCK::
	ld a,1
	call BIOS_GTSTCK
	or a,a
	ret nz
	call BIOS_GTSTCK
	or a,a
	ret
ENDSCOPE; GTSTCK


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 文字列コピー
;;;;   in hl コピー元データ　最初の2バイトは位置　次からは文字列　0で終わり
;;;;   use hl,de,af
;;;;   out hl,コピー元データの次
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE TEXT_COPY
TEXT_COPY::
	ld e,[hl]
	inc hl
	ld d,[hl]
	inc hl
loop:
	ld a,[hl]
	inc hl
	or a,a
	ret z
	ld [de],a
	inc de
	jr loop
ENDSCOPE; TEXT_COPY

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
	jr z,debug_code_end
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
debug_code_end:
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
	jr nc,debug_code_end
	ld [MAP_ID],a
	jr debug_code_end

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
	jr debug_code_end
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

debug_code:
	DEFB 3
	DEFS "MAP"
	DEFW debug_code_map
	DEFB 8
	DEFS "MSXCOLOR"
	DEFW debug_code_msxcolor
	DEFB 0 ; end of debug_code

ENDSCOPE; PASSWORD_CHECK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 1バイトのデータを10進テキストにして指定アドレスにコピー
;;;;   in de コピー元データ
;;;;      hl コピー先アドレス
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE BYTE_TO_TEXT
BYTE_TO_TEXT::
	ld a,[de]
	inc de
	push de
	ld d,0x30
	ld b,100
	call put_1_text
	ld b,10
	call put_1_text
	add a,0x30
	ld [hl],a
	pop de
	ret

put_1_text:
	ld c,0x30-1
loop:
	inc c
	sub a,b
	jr nc,loop
	add a,b
	ld b,a
	ld a,c
	cp a,d
	jr z,skip_put ;文字が'0'ならスキップ
	ld [hl],c
	ld d,0xff
skip_put:
	ld a,b
	inc hl
	ret
ENDSCOPE; BYTE_TO_TEXT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; CLEAR_STATUS_AREA
;;;;   ステータス表示区域のクリア 画面左端からE.HPまでクリア
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CLEAR_STATUS_AREA
CLEAR_STATUS_AREA::
	ld hl,VIEW_CODE_AREA+22*VIEW_CODE_AREA_WIDTH
	ld bc,17
	push bc
	call CLEAR_AREA
	ld hl,VIEW_CODE_AREA+23*VIEW_CODE_AREA_WIDTH
	pop bc
	jp CLEAR_AREA
ENDSCOPE; CLEAR_STATUS_AREA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; PUT_STATUS
;;;;   ステータス表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE PUT_STATUS
PUT_STATUS::
	ld hl,text_status
	ld b,3
put_text_loop:
	call TEXT_COPY
	djnz put_text_loop

	ld hl,VIEW_CODE_AREA+18+22*VIEW_CODE_AREA_WIDTH
	ld de,PLAYER_ITEMS
	ld a,[de]
	inc de
	ld c,a
	ld a,188 ;盾のキャラクター
item_loop:
	sla c
	jr c,put_item
	jr z,item_loop_end
	add a,4
	inc l
	inc l
	jr item_loop
put_item:
	ld [hl],a
	inc l
	add a,2
	ld [hl],a
	dec a
	dec l
	set 5,l
	ld [hl],a
	inc l
	add a,2
	ld [hl],a
	res 5,l
	inc l
	inc a
	jr item_loop
item_loop_end:

	ld hl,status_text_pos
	ld b,5
status_loop:
	ld a,[hl]
	inc hl
	push hl
	ld l,a
	ld h,VIEW_CODE_AREA/256+2
	push bc
	call BYTE_TO_TEXT
	pop bc
	pop hl
	djnz status_loop

	call WRITE_STATUS_AREA
	ret
text_status:
	DEFW VIEW_CODE_AREA+0+22*VIEW_CODE_AREA_WIDTH
	DEFS "HP    /    LV"
	DEFB 0
	DEFW VIEW_CODE_AREA+0+23*VIEW_CODE_AREA_WIDTH
	DEFS "EXP   /    "
	DEFB 0
	DEFW VIEW_CODE_AREA+14+22*VIEW_CODE_AREA_WIDTH
	DEFS "E.HP "
	DEFB 0
status_text_pos:
	DEFB 3+23*VIEW_CODE_AREA_WIDTH-16*VIEW_CODE_AREA_WIDTH;経験値
	DEFB 7+23*VIEW_CODE_AREA_WIDTH-16*VIEW_CODE_AREA_WIDTH;経験値MAX
	DEFB 11+23*VIEW_CODE_AREA_WIDTH-1-16*VIEW_CODE_AREA_WIDTH;レベル
	DEFB 7+22*VIEW_CODE_AREA_WIDTH-16*VIEW_CODE_AREA_WIDTH;HPMAX
	DEFB 3+22*VIEW_CODE_AREA_WIDTH-16*VIEW_CODE_AREA_WIDTH;HP

ENDSCOPE; PUT_STATUS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; WRITE_STATUS_AREA
;;;;   ステータス表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE WRITE_STATUS_AREA
WRITE_STATUS_AREA::
	ld hl,VIEW_CODE_AREA+22*VIEW_CODE_AREA_WIDTH
	ld de,0x1800+22*VIEW_CODE_AREA_WIDTH
	ld bc,VIEW_CODE_AREA_WIDTH*(VIEW_CODE_AREA_HEIGHT-22)
	call BIOS_LDIRVM
	ret
ENDSCOPE; WRITE_STATUS_AREA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; IS_BLOCK
;;;;  指定位置が移動できない壁である場合、キャリーフラグが立つ
;;;;   aレジスタに指定位置 上0 右1*6 下 2*6 左 3*6
;;;;   call IS_BLOCK2
;;;;   deレジスタにPLAYER_Y+1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE IS_BLOCK
IS_BLOCK::
	ld hl,IS_BLOCK_CHECK_DATA
	add a,l
	ld l,a
	push hl
	call is_block_one
	pop hl
	ret c
	inc l
	inc l
	push hl
	call is_block_one
	pop hl
	ret c
	inc l
	inc l
	call is_block_one
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; is_block_one
;;;;  指定位置が移動できない壁である場合、キャリーフラグが立つ
;;;;   [hl]に指定位置縦差分(ただしスプライトは-1して表示しているため+1したデータ)
;;;;   [hl+1]に指定位置横差分
;;;;   call IS_BLOCK
;;;;   deレジスタにPLAYER_Y+1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_block_one:
	ld de,PLAYER_Y
	ld a,[de]
	add a,[hl]
	inc l
	ld b,[hl]
	and a,0xf8
	ld l,a
	ld h,((VIEW_CODE_AREA)/256)/4
	add hl,hl
	add hl,hl

	inc de
	ld a,[de]
	add a,b
	and a,0xf8
	rrca
	rrca
	rrca
	add a,l
	ld l,a
	ld a,[PLAYER_ITEMS]
	and a,ITEM_MAGICLAMP
	neg
	add a,240-1 ;魔法のランプがない場合は240-1　ある場合は236-1
	cp a,[hl]
	ret
ENDSCOPE; IS_BLOCK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; CALC_PLAYER_STATUS
;;;;  経験値PLAYER_EXPから次の経験値やレベル、HPMAX等の値を計算、設定する
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CALC_PLAYER_STATUS
CALC_PLAYER_STATUS::
	ld de,PLAYER_EXP
	ld a,[de]
	ld hl,exp_tbl
	ld b,1
loop:
	inc b ;レベル
	cp a,[hl]
	inc hl
	jr z,break_loop
	jr nc,loop
	dec b
	dec hl
break_loop:
	inc a
	jr nz,skip_level_max
	ld b,99
	dec hl
skip_level_max:
	ld a,[hl]
	ex de,hl
	inc hl
	ld [hl],a ; 次の経験値 PLAYER_NEXTEXP
	inc hl
	ld c,[hl]
	ld [hl],b ; 現在のレベル PLAYER_LEVEL
	inc hl
	ld [hl],a ; HP max PLAYER_HPMAX
	ld a,c
	cp a,b
	ret
; 経験値テーブル
exp_tbl:
	DEFB 5,15,30,50,75,105,140,180,225,255
ENDSCOPE; CALC_PLAYER_STATUS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 敵　移動
;;;;   call MOVE_ENEMY
;;;;   ixはENEMY_HP（またはENEMY_HP+1）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE MOVE_ENEMY
MOVE_ENEMY::
	ld a,[ix+ENEMY_yMove-ENEMY_HP] ;yMove(xMove)
	or a,a
	ret z
	rra
	jr nc,right
	neg
	add a,[ix+ENEMY_yPos-ENEMY_HP] ;Y座標(X座標)
	cp a,[ix+ENEMY_yMin-ENEMY_HP] ;yMin(xMin)
	ccf
	jr set_pos
right:
	add a,[ix+ENEMY_yPos-ENEMY_HP] ;Y座標(X座標)
	cp a,[ix+ENEMY_yMax-ENEMY_HP] ;yMax(xMax)
set_pos:
	jr nc,turn
	ld [ix+ENEMY_yPos-ENEMY_HP],a ;Y座標(X座標)
	ret
turn:
	ld a,[ix+ENEMY_yMove-ENEMY_HP] ;yMove(xMove)
	xor a,1
	ld [ix+ENEMY_yMove-ENEMY_HP],a ;yMove(xMove)
	ret
ENDSCOPE; MOVE_ENEMY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 剣を出しているかどうか
;;;;   call IS_ATTACK
;;;;   use a
;;;;   剣を出している場合キャリーフラグが立つ、
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE IS_ATTACK
IS_ATTACK::
	ld a,[ATTACK_COUNT]
	dec a
	cp a,ATTACK_COUNT_END-1
	ret
ENDSCOPE; IS_ATTACK



SCOPE EVENT_PASSWORD
EVENT_PASSWORD::
	ld hl,text_password
	call TEXT_COPY
	ld hl,VIEW_CODE_AREA+0+23*VIEW_CODE_AREA_WIDTH
	ld de,PLAYER_LEVEL
	ld a,[de]
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

	call WRITE_STATUS_AREA
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
;;;; アスキーコード91~113のパターン
;;;;   1780行と1790行のデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHAR_91_PATTERN_START::
	DEFB 0xff,0xfc,0xe3,0x80,0xb8,0xc4,0xa2,0xa9 ;91
	DEFB 0xea,0xba,0xee,0xba,0xee,0xfa,0xfc,0xff ;92
	DEFB 0xff,0x03,0x31,0x88,0x44,0x23,0x1c,0xe3 ;93
	DEFB 0x1c,0xf7,0x1e,0xf4,0x17,0x1f,0x7f,0xff ;94
	DEFB 0x10,0x10,0x30,0xff,0x01,0x01,0x03,0xff ;95
	DEFB 0x3c,0x76,0x5f,0xef,0x7e,0x9f,0xd6,0x7f ;96
	DEFB 0xdf,0x7f,0x01,0x74,0xba,0x10,0x10,0x18 ;97
	DEFB 0x0f,0x3f,0x7f,0xcf,0x9f,0xbf,0xff,0xbf ;98
	DEFB 0xbf,0xff,0x26,0x7e,0x63,0xcf,0xe6,0x7f ;99
	DEFB 0xf0,0xfc,0xfe,0x5c,0x8e,0xd6,0xea,0xe8 ;100
	DEFB 0xd0,0xf5,0xed,0x99,0x31,0xc3,0x07,0xfe ;101
	DEFB 0x00,0x7c,0xfe,0x7c,0x00,0xe3,0xf7,0xe3 ;102
	DEFB 0x7e,0xff,0xfd,0x7f,0xfd,0xf9,0xf3,0x7e ;103
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ;104
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ;105
	DEFB 0x39,0xc6,0xc6,0x00,0x00,0x30,0x48,0x00 ;106
	DEFB 0x00,0x00,0x00,0x00,0x99,0xff,0xff,0x66 ;107
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ;108
	DEFB 0x0f,0x3f,0x7f,0xe6,0x59,0xff,0x7e,0xb8 ;109
	DEFB 0x7e,0x76,0x7f,0xed,0x3f,0x03,0x01,0x01 ;110
	DEFB 0xf0,0xfc,0xfe,0xdf,0x3e,0x67,0x8f,0xfe ;111
	DEFB 0x73,0xf4,0xbe,0xff,0xec,0xc0,0x80,0x80 ;112
	DEFB 0x0f,0x3f,0x7f,0xe6,0x59,0xff,0x7e,0xb8 ;113
CHAR_91_PATTERN_END::
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; アスキーコード91~113の色
;;;;   1800行と1810行のデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHAR_91_COLOR_START::
	DEFB 0x1f,0x1f,0x1a,0x1f,0x1a,0x1a,0x1a,0x1a ;91
	DEFB 0x18,0x1a,0x1a,0x18,0x1a,0x1a,0x1a,0x1f ;92
	DEFB 0x1f,0x1f,0x1a,0x1f,0x1f,0x1a,0x1a,0x1b ;93
	DEFB 0x1b,0x1b,0x1a,0x1a,0x18,0x1b,0x1a,0x1f ;94
	DEFB 0x19,0x1d,0x1d,0x1d,0x19,0x1d,0x1d,0x1d ;95
	DEFB 0x34,0x34,0xc4,0xc2,0xc2,0xc2,0xc2,0xc2 ;96
	DEFB 0xc2,0xc2,0x1c,0x1c,0x14,0x64,0x64,0x64 ;97
	DEFB 0x81,0x81,0x81,0x89,0x89,0x89,0x88,0x89 ;98
	DEFB 0x89,0x88,0x86,0x66,0x16,0x61,0x61,0x61 ;99
	DEFB 0x81,0x81,0x81,0x86,0x86,0x86,0x86,0x86 ;100
	DEFB 0x86,0x61,0x61,0x61,0x61,0x81,0x61,0x61 ;101
	DEFB 0x41,0x51,0x41,0x41,0x41,0x51,0x41,0x41 ;102
	DEFB 0xf1,0xe1,0xe1,0xe1,0xe1,0xe1,0xe1,0xe1 ;103
	DEFB 0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11 ;104
	DEFB 0x44,0x44,0x44,0x44,0x44,0x44,0x44,0x44 ;105
	DEFB 0xf7,0xf5,0x57,0xf7,0xf7,0xf7,0xf7,0xf7 ;106
	DEFB 0xf7,0xf7,0xf7,0xf7,0xf7,0xf7,0xf7,0xf7 ;107
	DEFB 0xf7,0xf7,0xf7,0xf7,0xf7,0xf7,0xf7,0xf7 ;108
	DEFB 0x34,0x34,0x34,0x32,0x32,0x32,0x3c,0x3c ;109
	DEFB 0x32,0x3c,0xc2,0x1c,0x14,0x64,0x64,0x64 ;110
	DEFB 0xc4,0xc4,0xc4,0xc2,0xc2,0xc2,0xc2,0xc1 ;111
	DEFB 0xc2,0xc1,0x12,0x1c,0x14,0x14,0x14,0x14 ;112
	DEFB 0x34,0x34,0x34,0x32,0x32,0x32,0x3c,0x3c ;113
CHAR_91_COLOR_END:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; アスキーコード88~245のパターン
;;;;   1820行から1860行までのデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHAR_188_PATTERN_START::
	DEFB 0x1f,0x20,0x5f,0x5d,0x5d,0x50,0x5d,0x5d ;188
	DEFB 0x2d,0x37,0x18,0x0f,0x00,0x00,0x00,0x00 ;189
	DEFB 0xc0,0x20,0xd0,0xd0,0xd0,0x50,0xd0,0xd0 ;190
	DEFB 0xa0,0x60,0xc0,0x80,0x00,0x00,0x00,0x00 ;191
	DEFB 0x00,0x60,0x70,0x38,0x1c,0x0e,0x07,0x03 ;192
	DEFB 0x01,0x02,0x00,0x00,0x00,0x00,0x00,0x00 ;193
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x80 ;194
	DEFB 0xc0,0xe0,0x70,0x30,0x00,0x00,0x00,0x00 ;195
	DEFB 0x08,0x5c,0x38,0x10,0x08,0x04,0x02,0x01 ;196
	DEFB 0x00,0x01,0x01,0x00,0x00,0x00,0x00,0x00 ;197
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x60 ;198
	DEFB 0x90,0x10,0x20,0xc0,0x00,0x00,0x00,0x00 ;199
	DEFB 0x07,0x08,0x1f,0x7f,0x17,0x2f,0x2f,0x2f ;200
	DEFB 0x2f,0x17,0x0f,0x1f,0x00,0x00,0x00,0x00 ;201
	DEFB 0x00,0x80,0xc0,0xf0,0x40,0xa0,0xa0,0xa0 ;202
	DEFB 0xa0,0x40,0x80,0xc0,0x00,0x00,0x00,0x00 ;203
	DEFB 0x00,0x01,0x03,0x01,0x09,0x1f,0x3e,0x5f ;204
	DEFB 0x2f,0x16,0x0c,0x00,0x00,0x00,0x00,0x00 ;205
	DEFB 0xc0,0xa0,0xd0,0xe8,0xf0,0x60,0x80,0x60 ;206
	DEFB 0x70,0x38,0x1c,0x08,0x00,0x00,0x00,0x00 ;207
	DEFB 0x00,0x00,0x00,0x00,0x04,0x9f,0x5f,0x5f ;208
	DEFB 0x3f,0x1f,0x0e,0x1f,0x00,0x00,0x00,0x00 ;209
	DEFB 0x00,0x00,0x00,0x00,0x70,0xd0,0x90,0xd0 ;210
	DEFB 0x60,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ;211
	DEFB 0x03,0x07,0x07,0x07,0x03,0x07,0x07,0x07 ;212
	DEFB 0x07,0x07,0x07,0x05,0x05,0x05,0x02,0x02 ;213
	DEFB 0x00,0x80,0x80,0x80,0x80,0x7e,0xfc,0xf8 ;214
	DEFB 0x60,0x70,0x38,0x1c,0x0c,0x00,0x80,0x80 ;215
	DEFB 0x3f,0x7f,0xe0,0xce,0x9e,0xbe,0xbe,0xbe ;216
	DEFB 0xbe,0xba,0xba,0xbe,0xbe,0xbe,0xbe,0xbe ;217
	DEFB 0xfc,0xfe,0x07,0xf3,0xf9,0xfd,0xfd,0xfd ;218
	DEFB 0xfd,0xdd,0xdd,0xfd,0xfd,0xfd,0xfd,0xfd ;219
	DEFB 0xff,0xfb,0xf3,0xe3,0xc3,0x83,0x83,0x81 ;220
	DEFB 0x07,0x0f,0x1f,0x1f,0x3f,0x3f,0x7f,0x7f ;221
	DEFB 0xcf,0x8f,0x1f,0x1e,0x08,0x00,0x00,0x80 ;222
	DEFB 0xc4,0x84,0x80,0x40,0x45,0x63,0x23,0x10 ;223
	DEFB 0xf3,0xf1,0xf8,0x78,0x10,0x00,0x00,0x01 ;224
	DEFB 0x23,0x21,0x01,0x02,0xa2,0xc6,0xc4,0x08 ;225
	DEFB 0xff,0xdf,0xcf,0xc7,0xc3,0xc1,0xc1,0x81 ;236
	DEFB 0xe0,0xf0,0xf8,0xf8,0xfc,0xfc,0xfe,0xfe ;227
	DEFB 0x81,0x01,0x02,0x02,0x02,0x81,0x81,0x55 ;228
	DEFB 0x2a,0x80,0x80,0xc0,0xc0,0x80,0x80,0xa4 ;239
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ;230
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x10,0x98 ;231
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ;232
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x19 ;233
	DEFB 0x81,0x80,0x40,0x40,0x40,0x81,0x81,0xaa ;234
	DEFB 0x54,0x01,0x01,0x03,0x03,0x01,0x01,0x25 ;235
	DEFB 0xf0,0xc0,0x7f,0x7f,0xff,0xff,0x87,0x62 ;236
	DEFB 0x00,0x09,0x9f,0xe7,0x80,0xc0,0xf0,0xff ;237
	DEFB 0xf0,0xfc,0xfe,0xfe,0xff,0xff,0xff,0x9c ;238
	DEFB 0x38,0x61,0xf0,0x80,0x01,0x03,0xf0,0x00 ;239
	DEFB 0x00,0xc6,0x00,0x00,0x00,0x00,0x00,0x00 ;240
	DEFB 0x00,0x00,0x20,0x00,0x00,0x04,0x00,0x00 ;241
	DEFB 0x7e,0x7f,0x3f,0x00,0xf3,0xf3,0xc3,0x00 ;242
	DEFB 0x57,0x57,0x57,0x57,0x57,0x57,0x57,0x57 ;243
	DEFB 0xea,0xea,0xea,0xea,0xea,0xea,0xea,0xea ;244
	DEFB 0xff,0xff,0x00,0x7e,0xff,0xff,0xff,0x00 ;245
CHAR_188_PATTERN_END::
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; アスキーコード88~245の色
;;;;   1870行から1910行までのデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHAR_188_COLOR_START:
	DEFB 0xf1,0x71,0x51,0x51,0x51,0x41,0x51,0x51 ;188
	DEFB 0x41,0x51,0x41,0x41,0xf1,0xf1,0xf1,0xf1 ;189
	DEFB 0xf1,0x51,0x51,0x51,0x41,0x41,0x51,0x41 ;190
	DEFB 0x41,0x51,0x41,0x41,0xf1,0xf1,0xf1,0xf1 ;191
	DEFB 0xf1,0xf1,0xf1,0xf1,0xf1,0xf1,0x41,0xe1 ;192
	DEFB 0xd1,0xd1,0xf1,0xf1,0xf1,0xf1,0xf1,0xf1 ;193
	DEFB 0xf1,0xf1,0xf1,0xf1,0xf1,0xf1,0xd1,0xd1 ;194
	DEFB 0x61,0x61,0x61,0x61,0x61,0xf1,0xf1,0xf1 ;195
	DEFB 0xf1,0xf1,0xb1,0xa1,0xa1,0xa1,0xa1,0xa1 ;196
	DEFB 0xa1,0xa1,0xa1,0xf1,0xf1,0xf1,0xf1,0xf1 ;197
	DEFB 0xf1,0xf1,0xf1,0xf1,0xf1,0xf1,0xa1,0xb1 ;198
	DEFB 0xf1,0xa1,0xa1,0x61,0xf1,0xf1,0xf1,0xf1 ;199
	DEFB 0xe1,0xe1,0x91,0xd1,0xf1,0xf1,0xf1,0xf1 ;200
	DEFB 0x91,0xa1,0x91,0xd1,0xf1,0xf1,0xf1,0xf1 ;201
	DEFB 0xe1,0xe1,0x91,0xd1,0xf1,0xf1,0xe1,0xe1 ;202
	DEFB 0x91,0xa1,0x91,0xd1,0xf1,0xf1,0xf1,0xf1 ;203
	DEFB 0xf1,0xf1,0xa1,0xa1,0xa1,0xa1,0xa1,0xa1 ;204
	DEFB 0xa1,0x91,0xd1,0xf1,0xf1,0xf1,0xf1,0xf1 ;205
	DEFB 0xf1,0xb1,0xa1,0xa1,0xa1,0x91,0xa1,0x61 ;206
	DEFB 0x61,0x61,0x61,0x61,0xf1,0xf1,0xf1,0xf1 ;207
	DEFB 0xf1,0xf1,0xf1,0xf1,0xd1,0xf1,0xa1,0xa1 ;208
	DEFB 0xa1,0xa1,0xa1,0xe1,0xf1,0xf1,0xf1,0xf1 ;209
	DEFB 0xf1,0xf1,0xf1,0xa1,0xa1,0xa1,0xa1,0xa1 ;210
	DEFB 0xa1,0xa1,0xa1,0xe1,0xf1,0xf1,0xf1,0xf1 ;211
	DEFB 0x81,0x81,0xb1,0xb1,0xb1,0x71,0x71,0x71 ;212
	DEFB 0xf1,0xf1,0xf1,0xb1,0xb1,0xb1,0xb1,0xb1 ;213
	DEFB 0xf1,0x81,0x81,0x81,0x81,0xf1,0xf1,0xf1 ;214
	DEFB 0xf1,0xf1,0xf1,0xf1,0xf1,0xf1,0xb1,0xb1 ;215
	DEFB 0x91,0x61,0x61,0x91,0x81,0x61,0x81,0x81 ;216
	DEFB 0x61,0x81,0x81,0x61,0x61,0x61,0x61,0x81 ;217
	DEFB 0x91,0x61,0x61,0x91,0x81,0x61,0x81,0x81 ;218
	DEFB 0x61,0x81,0x81,0x61,0x61,0x61,0x61,0x81 ;219
	DEFB 0x16,0x1d,0x1d,0x16,0x18,0x18,0x18,0x18 ;220
	DEFB 0xf8,0xf8,0xf8,0xf8,0xf8,0xf8,0xf6,0xf6 ;221
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;222
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;223
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;224
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;225
	DEFB 0x16,0x1d,0x1d,0x16,0x18,0x18,0x18,0x18 ;226
	DEFB 0xf8,0xf8,0xf8,0xf8,0xf8,0xf8,0xf6,0xf6 ;227
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;228
	DEFB 0xdf,0x6f,0x6f,0x6f,0x6f,0x6f,0x6f,0xdf ;229
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;230
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;231
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;232
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;233
	DEFB 0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f,0x1f ;234
	DEFB 0xdf,0x6f,0x6f,0x6f,0x6f,0x6f,0x6f,0xdf ;235
	DEFB 0x4f,0x4f,0xf5,0xfe,0xfe,0xfe,0xfe,0xfe ;236
	DEFB 0xfe,0xfe,0xfe,0xfe,0x5e,0x5e,0x4e,0x4e ;237
	DEFB 0xf4,0xf4,0xf5,0xfe,0xfe,0xfe,0xfe,0xfe ;238
	DEFB 0xfe,0xfe,0xfe,0xfe,0x5e,0x5e,0xe4,0xe4 ;239
	DEFB 0x23,0x23,0x22,0x22,0x22,0x22,0x22,0x22 ;240
	DEFB 0x22,0x22,0x32,0x22,0x22,0x32,0x22,0x22 ;241
	DEFB 0xfe,0xfe,0xfe,0x1e,0xfe,0xfe,0xfe,0xee ;242
	DEFB 0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe ;243
	DEFB 0xe1,0xe1,0xe1,0xe1,0xe1,0xe1,0xe1,0xe1 ;244
	DEFB 0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe ;245
CHAR_188_COLOR_END::

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; スプライトパターン
;;;;   元プログラム
;;;;     0:プレイヤー鎧1右,1:プレイヤー鎧1左
;;;;     2:プレイヤー鎧2右,3:プレイヤー鎧2左
;;;;     4:プレイヤー肌1右,5:プレイヤー肌1左
;;;;     6:プレイヤー肌2右,7:プレイヤー肌2左
;;;;     8:剣右,9:剣左
;;;;     10:オオカミ1右,11:オオカミ1左
;;;;     12:オオカミ2右,13:オオカミ2左
;;;;     14:ガイコツ1右,15:ガイコツ1左
;;;;     16:ガイコツ2右,17:ガイコツ2左
;;;;     18:スライム1,19:スライム2
;;;;     20:コウモリ1,21:コウモリ2
;;;;   このプログラム(bit0が0=右,1=左 bit1が0=歩行パターン1,1=歩行パターン2)
;;;;     0:プレイヤー鎧1右,1:プレイヤー鎧1左
;;;;     2:プレイヤー鎧2右,3:プレイヤー鎧2左
;;;;     4:プレイヤー肌1右,5:プレイヤー肌1左
;;;;     6:プレイヤー肌2右,7:プレイヤー肌2左
;;;;     8:オオカミ1右,9:オオカミ1左
;;;;     10:オオカミ2右,11:オオカミ2左
;;;;     12:ガイコツ1右,13:ガイコツ1左
;;;;     14:ガイコツ2右,15:ガイコツ2左
;;;;     16:スライム1右,17:スライム1左
;;;;     18:スライム2右,19:スライム2左
;;;;     20:コウモリ1右,21:コウモリ1左
;;;;     22:コウモリ2右,23:コウモリ2左
;;;;     24:剣右,25:剣左
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_START::
	DEFB 0x0f,0x0f,0x07,0x22,0x34,0x3c,0x18,0x06,0x16,0x17,0x0f,0x14,0x1c,0x07,0x0f,0x0f,0xc0,0xe0,0xf8,0x00,0x00,0x00,0x00,0x00,0xe0,0x70,0x70,0xa0,0xd0,0x80,0xe0,0xf0 ;プレイヤー鎧1
	DEFB 0x00,0x0f,0x0f,0x07,0x02,0x34,0x3c,0x18,0x06,0x0d,0x1d,0x0d,0x12,0x29,0x3e,0x1f,0x00,0xc0,0xe0,0xf8,0x00,0x00,0x00,0x00,0x00,0xe0,0xf0,0x30,0x26,0xde,0x3c,0x38 ;プレイヤー鎧2
	DEFB 0x60,0x70,0x38,0x1c,0x09,0x01,0x01,0x01,0x00,0x00,0x00,0x03,0x03,0x00,0x00,0x00,0x20,0x10,0x00,0x70,0xd0,0xd8,0xf0,0xe0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ;プレイヤー肌1
	DEFB 0x00,0x00,0xe0,0xf8,0x3c,0x09,0x01,0x01,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x20,0x10,0x00,0x70,0xd0,0xd8,0xf0,0xe0,0x00,0x00,0xc0,0xc0,0x00,0x00,0x00 ;プレイヤー肌2
	DEFB 0x00,0x1c,0x3f,0x7f,0x3f,0x7b,0x3b,0x7f,0x7f,0x3f,0xd0,0xbf,0x5b,0x23,0x1f,0x1d,0x00,0xc0,0xe0,0xf0,0xf0,0xb0,0xb0,0xf8,0xf8,0xf0,0x00,0xe0,0xe8,0xe8,0xe0,0xc0 ;オオカミ1
	DEFB 0x00,0x0e,0x1f,0x3f,0x1f,0x3d,0x1d,0x3f,0x3f,0x1f,0x88,0xdf,0xeb,0x57,0x0f,0x1c,0x00,0x60,0xf0,0xf8,0xf8,0xd8,0xd8,0xfc,0xfc,0xf8,0x00,0xf0,0xf4,0xf0,0xe0,0x38 ;オオカミ2
	DEFB 0x3f,0x7f,0x7f,0x7e,0x7e,0x7f,0x3f,0x02,0x78,0xcd,0xfd,0xfd,0xcd,0x78,0x02,0x02,0xe0,0xf0,0xf0,0xd0,0xd0,0xf4,0xf4,0xa8,0x08,0x90,0xb0,0xa0,0x80,0x80,0x40,0x40 ;ガイコツ1
	DEFB 0x00,0x1f,0x3f,0x3f,0x3f,0x3f,0x03,0x3d,0x67,0x7e,0x7e,0x66,0x3c,0x02,0x0c,0x18,0x00,0xf0,0xf8,0xf8,0x68,0x68,0xf9,0xf2,0x54,0x08,0xb0,0xc0,0x80,0xc0,0x30,0x18 ;ガイコツ2
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x0f,0x3f,0x7f,0xff,0xff,0xff,0xff,0xff,0xfe,0x7c,0x00,0x00,0x00,0x00,0x00,0x00,0xf0,0xfc,0xfe,0xff,0xff,0xff,0xff,0xff,0x7f,0x3e ;スライム1
	DEFB 0x00,0x00,0x00,0x00,0x00,0x38,0x7c,0xfc,0xfe,0xff,0xff,0xff,0xff,0x7f,0x3f,0x0f,0x00,0x00,0x00,0x00,0x00,0x1c,0x3e,0x3f,0x7f,0xff,0xff,0xff,0xff,0xfe,0xfc,0xf0 ;スライム2
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x06,0x1c,0x7c,0xfc,0xee,0xc7,0x87,0x83,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xc0,0x70,0x7c,0x7c,0xee,0xc6,0xc2,0x82,0x00 ;コウモリ1
	DEFB 0x00,0x04,0x06,0x2e,0x3f,0x3f,0x37,0x73,0x61,0x60,0x40,0x40,0x00,0x00,0x00,0x00,0x00,0x40,0xc0,0xe8,0xf8,0xf8,0xd8,0x9c,0x0c,0x0c,0x04,0x04,0x00,0x00,0x00,0x00 ;コウモリ2
	DEFB 0x00,0x00,0x00,0x00,0x00,0x00,0x4f,0x5f,0xb0,0x5f,0x4f,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xe0,0xfc,0x3f,0xfc,0xe0,0x00,0x00,0x00,0x00,0x00 ;剣
SPRITE_END::

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
	DEFB 0xf4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; マップデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; src/map.map を元に build/mapzip が build/src/map.map.data build/src/map.map.tbl にデータを出力
; build/mapzipは元データからマップデータに変換
; マップデータは以下
; mode　1バイト
; 　bit0 1の時、透明な壁があるマップ（ランプがあるかどうかで処理がかわる）
; 　bit1 1の時、ラスボスのマップ
; event　イベントデータ 4バイトの組
; 　+0 00:イベントデータ終了の場合は00
;      bit6-7:画面表示に変更がない場合は00、ある場合は01:宝箱、10:扉、11:妖精を指定位置に表示
;      bit0-5:実行するアクションを指定　0:アクションなし、1:アイテム取得、2:アイテム取得（敵全滅時）、3:パスワード出力、4以上:ワープ
;             ワープはそれぞれ別のイベントIDが振られており、WARP_LISTに移動先が記録されている
; 　+1 アイテム　PLAYER_ITEMSのbit　アイテムが無関係なら0
; 　+2 スプライトx座標 xy座標とプレイヤーのxy座標を比較し近い位置にあればイベント実行、画面表示に変更がある場合はxy座標を元にVIEW_CODE_AREAに文字出力
; 　+3 スプライトy座標 
; map マップデータ
; 　ランレングス圧縮でデータが収められている
; enemy 敵データ　最大4(ENEMY_MAX_COUNT)
; 　コピーするサイズ+1　各マップデータの1つ前
; 　ENEMY_COUNT　1バイト　敵は1体ずつ順に移動し、敵が減っても速度は変わらないため、敵の数を保存しておく必要がある
; 　各敵データ　ENEMY_SIZEバイト
; 　　+0 str
; 　　+1 exp
; 　　+2 hp　1バイトのHP
; 　　+3 無敵（ダメージ）カウント 敵がダメージを受けると少しの間、色が変わり無敵になる
; 　　+4 Y座標　スプライトY座標
; 　　+5 X座標　スプライトX座標
; 　　+6 スプライトパターン番号　bit0　方向 0:右、1:左、bit1:足踏み
; 　　+7 色コード
; 　　+8 yMove　高さの移動量　TODO
; 　　+9 xMove　横移動量　bit0　0=右向き,1=左向き　bit1-7:移動量
; 　　+10 yMax　y最大値
; 　　+11 xMax　x最大値
; 　　+12 yMin　y最小値
; 　　+13 xMin　x最小値


include "build/src/map.map.data"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; システム　初期化
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE SYSTEM_INIT
default_color:
	DEFB 15,1,1
SYSTEM_INIT::
	ld sp,[WORK_HIMEM]
	di
	; 画面の色を変える
	ld hl,default_color
	ld de,MSXWORK_FORCLR
	ld bc,3
	ldir
	ld a,01
	call BIOS_CHGCLR

	;画面をSCREEN1に　VDP のみを GRAPHIC2にする
	call BIOS_INIT32
	call BIOS_SETGRP

	; スクリーンモード2 プライトを初期化
	ld a,2
	ld [MSXWORK_SCRMOD],a
	call BIOS_CLRSPR

	;画面表示の禁止
	call BIOS_DISSCR

SCOPE FONT_ZERO_FULL
	;画面を0で埋める
	xor a,a
	ld [WORK_CLIKSW],a ;キークリックスイッチもOFFにしておく

	ld hl,0x1800
	ld bc,VIEW_CODE_AREA_WIDTH*VIEW_CODE_AREA_HEIGHT
	call BIOS_FILVRM
	; 空欄をVRAMに転送
	xor a,a
	ld bc,256*8*3
	ld hl,0
	call BIOS_FILVRM
	; デフォルフォントカラーを白黒にする
	ld a,0xf1
	ld bc,256*8*3
	ld hl,0x2000
	call BIOS_FILVRM
ENDSCOPE ; FONT_ZERO_FULL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; フォントを太字にする
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE BOLD_FONT
	ld hl,[FONT_ADD]
	inc h ; 32*8
	ld bc,59*8
	ld de,FREE_AREA
font_loop:
	ld a,[hl]
	rrca
	or a,[hl]
	ld [de],a
	inc hl
	inc de
	dec bc
	ld a,c
	or a,b
	jr nz,font_loop

	;VRAMに転送
	ld hl,FREE_AREA
	ld de,32*8
	ld bc,59*8
	call SET_3LINE
ENDSCOPE ; BOLD_FONT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; PCG アスキーコード91~113、114~117、188~245の形(絵)、色変更
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE SET_CHAR
	ld hl,CHAR_91_PATTERN_START
	ld de,91*8
	ld bc,CHAR_91_PATTERN_END-CHAR_91_PATTERN_START
	call SET_3LINE

	ld hl,CHAR_91_COLOR_START
	ld de,91*8+0x2000
	ld bc,CHAR_91_COLOR_END-CHAR_91_COLOR_START
	call SET_3LINE

	ld hl,CHAR_188_PATTERN_START
	ld de,188*8
	ld bc,CHAR_188_PATTERN_END-CHAR_188_PATTERN_START
	call SET_3LINE

	ld hl,CHAR_188_COLOR_START
	ld de,188*8+0x2000
	ld bc,CHAR_188_COLOR_END-CHAR_188_COLOR_START
	call SET_3LINE
ENDSCOPE ; SET_CHAR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; スプライトアトリビュート・テーブル初期化
;;;;  Y座標FREE_AREA　他0　のデータで埋める
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CLEAR_SPRITE
	ld hl,FREE_AREA+3
	xor a,a
	ld [hl],a ;+3
	dec hl
	ld [hl],a ;+2
	dec hl
	ld [hl],a ;+1
	dec hl
	ld [hl],NO_SPRITE_Y ;+0
	ld de,FREE_AREA+4
	ld bc,4*31
	ldir

	ld hl,FREE_AREA
	ld de,0x1b00
	ld bc,4*32
	call BIOS_LDIRVM

ENDSCOPE ; CLEAR_SPRITE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; スプライト設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE SET_SPRITE
	;SPRITE_STARTからSPRITE_ENDまでのデータを反転させる
	ld hl,FREE_AREA
	ld de,SPRITE_START
	ld bc,SPRITE_END-SPRITE_START
loop:
	ld a,[de]
	push bc
	ld b,8
reverse:
	rlca
	rr c
	djnz reverse
	ld [hl],c
	inc de
	inc hl
	pop bc
	dec bc
	ld a,b
	or a,c
	jr nz,loop

	ld b,(SPRITE_END-SPRITE_START)/32
	ld hl,FREE_AREA
	ld de,FREE_AREA+16
loop1:
	push bc
	ld b,16
loop2:
	ld a,[de]
	ld c,[hl]
	ex de,hl
	ld [de],a
	ld [hl],c
	ex de,hl
	inc hl
	inc de
	djnz loop2
	;de=de+a
	ld a,16
	add a,e
	ld e,a
	adc a,d
	sub a,e
	ld d,a

	;hl=hl+a
	ld a,16
	add a,l
	ld l,a
	adc a,h
	sub a,l
	ld h,a

	pop bc
	djnz loop1

	;VRAMにスプライトデータと反転データを書き込む
	ld hl,SPRITE_START
	ld de,0x3800
	ld c,2
loop_a0:
	ld b,(SPRITE_END-SPRITE_START)/32
loop_a1:
	push bc
	push hl
	push de
	ld bc,32
	call BIOS_LDIRVM
	pop de
	pop hl

	;de=de+a
	ld a,64
	add a,e
	ld e,a
	adc a,d
	sub a,e
	ld d,a

	;hl=hl+a
	ld a,32
	add a,l
	ld l,a
	adc a,h
	sub a,l
	ld h,a

	pop bc
	djnz loop_a1
	ld hl,FREE_AREA
	ld de,0x3800+32
	dec c
	jr nz,loop_a0

ENDSCOPE ; SET_SPRITE

	di
	ld hl,WORK_H_TIMI+WORK_H_TIMI_SIZE-1
	ld de,WORK_H_TIMI_SAVE+WORK_H_TIMI_SIZE-1
	ld bc,WORK_H_TIMI_SIZE
	lddr
	inc hl
	ld [hl],0xc3 ;z80 JP code
	inc hl
	ld [hl],VSYNC_START % 256
	inc hl
	ld [hl],VSYNC_START / 256

	;PSG初期化
	ld a,1
	ld e,0
	call BIOS_WRTPSG
	ld a,7
	ld e,0xbc ;Tone A&B Enable
	call BIOS_WRTPSG
	ld a,8
	ld e,0
	call BIOS_WRTPSG
	ld a,9
	call BIOS_WRTPSG
	;bgm初期化
	xor a,a
	ld [BGM_COUNT],a

	;画面の表示
	;スプライト
	ld a,[MSXWORK_RG1SAV]
	or a,0x62
	; 00000000
	; .x...... 0:画面表示OFF 1:画面表示ON
	; ..x..... 1=垂直割り込み有効, 0=無効
	; ......x. 0:スプライト8x8 1:スプライト16x16
	ld b,a
	ld c,0x01 ; vdp#1に 00100010を書き込む
	call BIOS_WRTVDP
	ei

	;タイトル画面へ
	jp MAIN
ENDSCOPE ; SYSTEM_INIT


_MAXSIZE:: ;最大サイズ

ALIGN 0x4000
