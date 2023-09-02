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

ENEMY_INDEX := VIEW_CODE_AREA+VIEW_CODE_AREA_WIDTH*VIEW_CODE_AREA_HEIGHT;敵移動用 敵は1度に移動せず、1体ずつ順に移動する
ENEMY_COUNT := ENEMY_INDEX+1;画面上の敵最大数

ENEMY_LIST := ENEMY_COUNT+1;
 ENEMY_STR := +0
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
 ENEMY_Status := +8
 ; +8 ENEMY_Status　bit0:0=右向き,1=左向き　bit1:1=横移動する　bit2:1=ジャンプする　bit3:1=ガイコツ　bit4:1=オオカミ
  ENEMY_Status_ISRIGHT_BIT := 0
  ENEMY_Status_JUMP_BIT := 2
  ENEMY_Status_Skeleton_BIT := 3
  ENEMY_Status_Wolf_BIT := 4
  ENEMY_Status_BatWithBoss_BIT :=5 ;ボス面のコウモリ

  ENEMY_Status_ISRIGHT := 1
  ENEMY_Status_MOVE := 2
  ENEMY_Status_JUMP := 4
  ENEMY_Status_BatWithBoss := 32
 ENEMY_JumpCount := +9
 ; +9 JumpCount
 ;    0の時着地
 ;    1～16　上2
 ;    17～32　上1
 ;    33～40　移動しない
 ;    40～56　下1
 ;    57～72　下2
 ENEMY_xMax := +10
 ; +10 xMax
 ENEMY_xMin := +11
 ; +11 xMin
 ENEMY_SIZE := 12
 ENEMY_MAX_COUNT := 4 ;敵は最大4

BOSS_COUNT := ENEMY_LIST+ENEMY_SIZE*ENEMY_MAX_COUNT;
BOSS_Status := BOSS_COUNT+1 ;ボスの状態
 ; 0の時ボスは存在しないマップ
 ; 1～3の時ボスが存在するマップ　ボスの位置のインデックス
 ; 4の時ボスは死亡
   BOSS_Status_Dead := 4
BOSS_HP := BOSS_Status+1; ボスのHP 2バイト
BOSS_DAMAGE_COUNT := BOSS_HP+2;

MAP_ID := BOSS_DAMAGE_COUNT+1;
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
GAME_SPEED := ATTACK_COUNT+1 ;ゲームの速さ

WORK_H_TIMI_SAVE := GAME_SPEED+1; WORK_H_TIMIのコピー
GAME_CONTROLLER :=  WORK_H_TIMI_SAVE+WORK_H_TIMI_SIZE ;ゲーム処理
 ;bit0 1:このマップで敵全滅した
  GAME_CONTROLLER_NOENEMY_BIT := 0
 ;bit1 1:マップ移動した場合、10/60秒待つ
  GAME_CONTROLLER_WAIT_BIT := 1
 ;bit2 1:ダメージエフェクト
  GAME_CONTROLLER_DAMAGE_EFFECT_BIT := 2

 ;bit7 1:VRAM書き込み司令
  GAME_CONTROLLER_WRITE_BIT := 7
 ;bit6 1:スプライト書き込み
  GAME_CONTROLLER_SPRITE_BIT := 6
 ;bit5 1:MAP欄
  GAME_CONTROLLER_MAP_BIT := 5
 ;bit4 1:ステータス欄
  GAME_CONTROLLER_STATUS_BIT := 4

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

 ITEM_SHIELD_BIT := 7
 ITEM_HAMMER_BIT := 3
 ITEM_FAIRY_BIT := 1

PLAYER_EXP := PLAYER_ITEMS+1
PLAYER_NEXTEXP := PLAYER_EXP+1
PLAYER_LEVEL := PLAYER_NEXTEXP+1
PLAYER_HPMAX := PLAYER_LEVEL+1
PLAYER_HP := PLAYER_HPMAX+1
PLAYER_DAMAGE_COUNT := PLAYER_HP+1 ;無敵カウント
PLAYER_NODAMAGE := PLAYER_DAMAGE_COUNT+1 ;1の時ダメージを受けない
PLAYER_HEAL_COUNT := PLAYER_NODAMAGE+1 ;この値が桁あふれした時点でHP回復

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
	DEFB   4,3 ;レベル1
	DEFB  10,10 ;レベル2
	DEFB  20,20 ;レベル3
	DEFB  34,33 ;レベル4
	DEFB  50,50 ;レベル5
	DEFB  70,70 ;レベル6
	DEFB  94,93 ;レベル7
	DEFB 120,120 ;レベル8
	DEFB 150,150 ;レベル9
	DEFB 170,170 ;レベル10

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
;;;; BOSSの位置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BOSS_POSITION::
	DEFB  6*8-1 ;yPos1
	DEFB 14*8   ;xPos1
	DEFB 10*8-1 ;yPos2
	DEFB 21*8   ;xPos2
	DEFB 10*8-1 ;yPos3
	DEFB  7*8   ;xPos3


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; _MAXHEADDATAが04100h以下であるなら　↑のテーブルを見る際、下位1バイトだけ見ればいい
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_MAXHEADDATA::

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; メイン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE MAIN
MAIN::
	call TITLE ;タイトル表示
	call GAME_INIT ; 画面初期化
loop:
	call MOVE_PLAYER ;プレイヤー方向キーで移動
	call MOVE_ENEMY ;敵移動処理
	call JUMP_ENEMY ;敵JUMP処理
	call CHECK_PLAYER_ATTACK ;プレイヤー攻撃判定
	call CHECK_PLAYER_DAMAGE ;プレイヤーダメージ判定
	call CHECK_BOSS ;ボス処理
	call DOWN_DAMAGE_COUNT ;ダメージカウントをダウン
	call CHECK_EVENT ;イベント確認
	call CHECK_MAPMOVE ;画面端でマップ移動していないかチェック

	ld  hl,GAME_CONTROLLER
	set GAME_CONTROLLER_SPRITE_BIT,[hl]
	set GAME_CONTROLLER_WRITE_BIT,[hl] ;VRAM書き込み司令

	bit GAME_CONTROLLER_DAMAGE_EFFECT_BIT,[hl]
	jr z,skip_damage_effect
	res GAME_CONTROLLER_DAMAGE_EFFECT_BIT,[hl]
	call DAMAGE_EFFECT
skip_damage_effect:

	ld a,[GAME_SPEED] ;
	or a,a
	jr z,do_wait
	bit 1,[hl]
	jr z,do_wait
	res 1,[hl]
	ld a,10 ;イベントでマップ移動した場合、10/60秒待つ
do_wait:
	call WAIT

	;ボス倒されたら
	ld a,[BOSS_Status]
	cp a,BOSS_Status_Dead
	jp z,GAMECLEAR

	ld a,[PLAYER_HP]
	or a,a
	jp z,GAMEOVER

	jr loop
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
	inc a
	inc hl
	ld [hl],a ;GAME_SPEED

	ld hl,PLAYER_ITEMS
	ld bc,PLAYER_HEAL_COUNT-PLAYER_ITEMS
	call CLEAR_AREA

	; SPRITE 初期化
	ld hl,PLAYER_Y
	ld [hl],112
	inc hl
	ld [hl],120
	inc hl
	xor a,a
	ld [hl],a

	;敵データをクリア
	ld hl,ENEMY_LIST
	ld bc,ENEMY_SIZE*ENEMY_MAX_COUNT-1
	call CLEAR_AREA

put_title:
	call CLEAR_VIEW_CODE_AREA
	ld hl,text_title
	ld b,3
put_text_loop:
	call TEXT_COPY
	djnz put_text_loop

	;BGM OFF
	ld bc,BGM_DATA_OFF
	call SET_BGM_CURRENT

	;VRAMに書き込み
	ld a,0xf0 ;GAME_CONTROLLER_WRITE_BITからGAME_CONTROLLER_STATUS_BIT
	ld [GAME_CONTROLLER],a

	;GAMEOVER時にスペースを押してタイトルに戻った際、スペースキーが離されるまで待たないと再スタートしてしまう
wait_release:
	call GTTRIG
	jr nz,wait_release

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

	;VRAMに書き込み
	ld a,0xf0 ;GAME_CONTROLLER_WRITE_BITからGAME_CONTROLLER_STATUS_BIT
	ld [GAME_CONTROLLER],a
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
	ld a,[MAP_ID]
	or a,a
	ld a,120
	jr z,set_player_y
	ld a,-1
set_player_y:
	ld hl,PLAYER_Y
	ld [hl],a

	ld bc,BGM_DATA_CHEST
	call SET_BGM_CURRENT

	call CLEAR_VIEW_CODE_AREA
	call SET_MAPDATA ; マップ表示
	call CALC_PLAYER_STATUS
	ld hl,PLAYER_HPMAX
	ld a,[hl]
	inc hl
	ld [hl],a
	call PUT_STATUS

	;VRAMに書き込み
	ld a,0xf0 ;GAME_CONTROLLER_WRITE_BITからGAME_CONTROLLER_STATUS_BIT
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
	call z,PLAYER_HEAL ;何も押されていなければプレイヤー回復
	pop af
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
;;;; 敵移動処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE MOVE_ENEMY
MOVE_ENEMY::
	ld hl,ENEMY_INDEX
	ld b,[hl]
	inc b
	ld hl,ENEMY_LIST+ENEMY_HP-ENEMY_SIZE
	ld de,ENEMY_SIZE
current_enemy:
	add hl,de
	djnz current_enemy

	ld a,[hl]
	or a,a
	jp z,next_enemy ;HP=0の敵は移動しない

	push hl
	pop ix

	ld a,[ix+ENEMY_DAMAGE_COUNT-ENEMY_HP] ;ENEMY_DAMAGE_COUNT
	or a,a
	jr nz,next_enemy ;ダメージを受けている敵は移動＆足踏みしない

	ld a,[ix+ENEMY_Status-ENEMY_HP] ;ENEMY_Status
	and a,ENEMY_Status_MOVE+ENEMY_Status_JUMP+ENEMY_Status_ISRIGHT+ENEMY_Status_BatWithBoss
	jr z,next_enemy ;横移動もジャンプもしない場合は次の敵
	bit ENEMY_Status_JUMP_BIT,a
	jr z,not_jump

	;ジャンプする
	ld a,[ix+ENEMY_JumpCount-ENEMY_HP] ;ENEMY_JumpCount
	or a,a
	jr nz,next_enemy ;ジャンプ中
	inc [ix+ENEMY_JumpCount-ENEMY_HP] ; ジャンプ開始
	jr next_enemy
not_jump:
	ld c,a
	bit ENEMY_Status_BatWithBoss_BIT,a
	jr z,not_batwithboss
	inc [ix+ENEMY_yPos-ENEMY_HP] ;Y座標+1 ボス面のコウモリは斜めに移動する事にする
not_batwithboss:

	ld b,[ix+ENEMY_xMin-ENEMY_HP] ;xMin
	and a,ENEMY_Status_ISRIGHT+ENEMY_Status_MOVE
	rra
	jr nc,right ;右向き
	neg
	add a,[ix+ENEMY_xPos-ENEMY_HP] ;X座標
	cp a,[ix+ENEMY_xMin-ENEMY_HP] ;xMin
	ccf
	ld b,[ix+ENEMY_xMax-ENEMY_HP] ;xMax
	jr set_pos
right:
	add a,[ix+ENEMY_xPos-ENEMY_HP] ;X座標
	cp a,[ix+ENEMY_xMax-ENEMY_HP] ;xMax
set_pos:
	jr nc,turn
	ld [ix+ENEMY_xPos-ENEMY_HP],a ;X座標
	jr step_enemy
warp_bat:
	sub a,b
	bit 7,a
	jr nz,set_y
	neg
set_y:
	add a,[ix+ENEMY_yPos-ENEMY_HP]
	ld [ix+ENEMY_yPos-ENEMY_HP],a
	ld [ix+ENEMY_xPos-ENEMY_HP],b
	jr step_enemy
turn:
	bit ENEMY_Status_BatWithBoss_BIT,c
	jr nz,warp_bat
	ld a,[ix+ENEMY_Status-ENEMY_HP] ;ENEMY_Status
	xor a,ENEMY_Status_ISRIGHT
	ld [ix+ENEMY_Status-ENEMY_HP],a ;ENEMY_Status

step_enemy:
	;敵を足踏みさせる
	ld a,[ix+ENEMY_xPos -ENEMY_HP]
	and a,0x07
	cp a,04
	jr nz,next_enemy
	ld a,[ix+ENEMY_SPRITE -ENEMY_HP] ; パターン番号
	xor a,2*4 ;足踏み
	and a,255-4
	bit ENEMY_Status_ISRIGHT_BIT,[ix+ENEMY_Status -ENEMY_HP] ; Statusのbit0が1の場合右向き
	jr z,set_enemy_sprite
	or a,4 ;スプライトパターン番号を左向きにする
set_enemy_sprite:
	ld [ix+ENEMY_SPRITE -ENEMY_HP],a

next_enemy:
	ld hl,ENEMY_COUNT
	ld b,[hl]
	dec hl ;ENEMY_INDEX
	ld a,[hl]
	inc a
	cp a,b
	jr c,set_enemy_index
	xor a,a
set_enemy_index:
	ld [hl],a
	ret
ENDSCOPE; MOVE_ENEMY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 敵JUMP処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE JUMP_ENEMY
JUMP_ENEMY::
	ld ix,ENEMY_LIST
	ld b,ENEMY_MAX_COUNT ;敵は最大4
loop:
	ld a,[ix+ENEMY_HP]
	or a,a
	jp z,next_enemy ;HP=0の敵は判定しない
	ld a,[ix+ENEMY_DAMAGE_COUNT] ;ダメージカウント
	or a,a
	jr nz,next_enemy ;ダメージを受けている敵はJUMPしない
	ld a,[ix+ENEMY_JumpCount] ;JumpCount
	or a,a
	jr z,next_enemy ;JumpCountが0の敵はJUMPしない
	ld c,a
	dec a
	and a,0xf8
	rrca
	rrca
	rrca
	ld hl,enemy_jump_data
	add a,l
	ld l,a
	ld a,h
	adc a,0
	ld h,a
	ld a,[hl]
	add a,[ix+ENEMY_yPos]
	ld [ix+ENEMY_yPos],a

	ld a,c
	inc a
	cp a,73
	jr c,set_jumpcount
	xor a,a
set_jumpcount:
	ld [ix+ENEMY_JumpCount],a
next_enemy:
	ld de,ENEMY_SIZE
	add ix,de
	djnz loop
	ret
enemy_jump_data:
	DEFB -2,-2,-1,-1,0,+1,+1,+2,+2

ENDSCOPE; JUMP_ENEMY


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; プレイヤー攻撃判定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CHECK_PLAYER_ATTACK
CHECK_PLAYER_ATTACK::
	call GTTRIG
	ld hl,ATTACK_COUNT
	ld a,[hl]
	jr nz,attack
	; スペースキーを押していなければ
	xor a,a
	jr set_attack_count

next_enemy:
	ld de,ENEMY_SIZE
	add ix,de
	pop bc
	djnz loop
	ret

attack:
	; スペースキーを押していれば
	inc a
	cp a,ATTACK_COUNT_END
	jr c,set_attack_count
	ld a,ATTACK_COUNT_END
set_attack_count:
	ld [hl],a

	call IS_ATTACK
	ret nc ;剣を出していない

	;敵全員と攻撃判定
	ld ix,ENEMY_LIST
	ld b,ENEMY_MAX_COUNT ;敵は最大4
loop:
	push bc
	ld a,[ix+ENEMY_HP]
	or a,a
	jr z,next_enemy ;HP=0の敵は判定しない
	ld a,[ix+ENEMY_DAMAGE_COUNT] ;ダメージカウント
	or a,a
	jr nz,next_enemy ;ダメージを受けている敵は攻撃判定なし

	;ガイコツはハンマー無しだとダメージを与えられない
	bit ENEMY_Status_Skeleton_BIT,[ix+ENEMY_Status]
	jr z,not_skeleton
	ld hl,PLAYER_ITEMS
	bit ITEM_HAMMER_BIT,[hl]
	jr z,next_enemy

not_skeleton:
	; 剣の位置と敵の位置を比較し、ヒットしていればダメージを与える
	ld hl,PLAYER_Y
	ld a,[hl]
	add a,11 ;剣の下部分
	sub a,[ix+ENEMY_yPos] ;敵yPosが剣の下部分より下ならヒットしない
	jr c,next_enemy
	cp a,5+16 ;剣の上部分 todoこの辺ちゃんと
	jr nc,next_enemy
	inc hl ;PLAYER_X
	ld a,[hl]
	inc hl ;PLAYER_SPRITE
;	sub a,0
	bit 2,[hl]
	jr nz,left_attack
	;右向き
	add a,32+0
left_attack:
	sub a,[ix+ENEMY_xPos] ;敵xPosが剣の右部分より右ならヒットしない
	jr c,next_enemy
	cp a,32
	jr nc,next_enemy

	;オオカミは吹っ飛ばない(であってる？)
	bit ENEMY_Status_Wolf_BIT,[ix+ENEMY_Status]
	jr nz,skip_knock_back

	;敵吹っ飛ぶ
	ld a,[ix+ENEMY_xPos]
	sub a,8
	bit 2,[hl]
	jr nz,left_knock_back
	add a,16
left_knock_back:
	ld [ix+ENEMY_xPos],a

skip_knock_back:
	ld a,3 ;敵無敵時間
	ld [ix+ENEMY_DAMAGE_COUNT],a

	;ダメージエフェクト
	ld  hl,GAME_CONTROLLER
	set GAME_CONTROLLER_DAMAGE_EFFECT_BIT,[hl] ;DAMAGE_EFFECT

	;敵HP減少
	ld a,[PLAYER_LEVEL]
	cp a,11 ;level max
	jr c,not_max_level
	;ボス以外の敵は最大255ダメージ
max_damage:
	ld c,255
	jr enemy_damage
not_max_level:
	ld hl,PLAYER_ATTACK_POINT-2
	add a,a
	add a,l
	ld l,a
	ld c,[hl]
	ld a,[PLAYER_ITEMS]
	and a,ITEM_SWORD
	jr z,enemy_damage ;剣を持っているとダメージ2倍
	inc l
	ld a,[hl]
	add a,c
	jr c,max_damage
	ld c,a
enemy_damage:
	ld a,[ix+ENEMY_HP]
	sub a,c
	jr nc,set_hp
	xor a,a
set_hp:
	ld [ix+ENEMY_HP],a

	or a,a
	jr nz,skip_enemy_hp0
	;敵倒した
	ld a,[ix+ENEMY_EXP]
	ld hl,PLAYER_EXP
	add a,[hl]
	jr nc,set_exp
	ld a,255 ;経験値は最大255
set_exp:
	ld [hl],a
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
skip_enemy_hp0:

	;敵HP表示
	ld hl,VIEW_CODE_AREA+14+23*VIEW_CODE_AREA_WIDTH+1
	xor a,a
	ld [hl],a
	dec hl
	ld [hl],a ;予め0クリアしておく
	push ix
	pop de
	inc de
	inc de ;ENEMY_HP
	call BYTE_TO_TEXT

	jp next_enemy

ENDSCOPE; CHECK_PLAYER_ATTACK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 剣を出しているかどうか
;;;;   call IS_ATTACK
;;;;   use a
;;;;   剣を出している場合キャリーフラグが立つ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE IS_ATTACK
IS_ATTACK::
	ld a,[ATTACK_COUNT]
	dec a
	cp a,ATTACK_COUNT_END-1
	ret
ENDSCOPE; IS_ATTACK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; プレイヤー回復
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE PLAYER_HEAL
PLAYER_HEAL::
	;ジャンプ中は回復しない
	ld a,[JUMP_COUNT]
	or a,a
	ret nz

	;ENEMY_INDEXが0でない場合は回復しない
	ld a,[ENEMY_INDEX]
	or a,a
	ret nz

	;ダメージを食らっている最中は回復しない
	ld hl,PLAYER_DAMAGE_COUNT
	or a,a
	ret nz

	ld a,0x08 ;回復速度
	ld hl,PLAYER_ITEMS
	bit ITEM_FAIRY_BIT,[hl] ;ITEM_FAIRY
	jr z,normal_heal
	ld a,0x20 ;妖精がいる場合の回復速度
normal_heal:
	ld hl,PLAYER_HEAL_COUNT
	add a,[hl]
	ld [hl],a
	ret nc

	ld hl,PLAYER_HPMAX
	ld b,[hl]
	inc hl ;PLAYER_HP
	ld a,[hl]
	cp a,b
	ret nc
	inc a
	ld [hl],a

	call PUT_STATUS

	ret
ENDSCOPE; PLAYER_HEAL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; プレイヤーダメージ判定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CHECK_PLAYER_DAMAGE
CHECK_PLAYER_DAMAGE::

	;PLAYER_NODAMAGEが1の時ダメージを受けない
	ld hl,PLAYER_NODAMAGE
	ld a,[hl]
	or a,a
	ret nz

	;ダメージ受けている中はダメージ判定しない
	dec hl ;PLAYER_DAMAGE_COUNT
	ld a,[hl]
	or a,a
	ret nz

	;敵全員と判定
	ld ix,ENEMY_LIST
	ld b,ENEMY_MAX_COUNT ;敵は最大4
loop:
	push bc
	ld a,[ix+ENEMY_HP]
	or a,a
	jp z,next_enemy ;HP=0の敵は判定しない
	ld a,[ix+ENEMY_DAMAGE_COUNT] ;ダメージカウント
	or a,a
	jr nz,next_enemy ;ダメージを受けている敵は判定なし
	; プレイヤーの位置と敵の位置を比較し、ヒットしていればダメージを受ける
	ld hl,PLAYER_Y
	ld a,[hl]
	sub a,[ix+ENEMY_yPos]
	add a,16
	cp a,32
	jr nc,next_enemy
	inc hl ;PLAYER_X
	ld a,[hl]
	sub a,[ix+ENEMY_xPos]
	add a,13
	cp a,26
	jr nc,next_enemy

	;ダメージエフェクト
	ld  hl,GAME_CONTROLLER
	set GAME_CONTROLLER_DAMAGE_EFFECT_BIT,[hl] ;DAMAGE_EFFECT

	;ダメージ
	ld b,[ix+ENEMY_STR]
	ld a,[PLAYER_EXP]
	inc a
	jr nz,check_item_shield
	;経験値MAXの場合ダメージ1/3
	ld a,b
	call DIV3
	ld b,a
	jr skip_item_shield
check_item_shield:
	ld hl,PLAYER_ITEMS
	bit ITEM_SHIELD_BIT,[hl] ;ITEM_SHIELD
	jr z,skip_item_shield
	;盾を持っているとダメージ半減
	srl b
skip_item_shield:

	ld hl,PLAYER_HEAL_COUNT
	ld [hl],0
	dec hl
	dec hl ;PLAYER_DAMAGE_COUNT
	ld [hl],32
	dec hl ;PLAYER_HP
	ld a,[hl]
	sub a,b
	jr nc,set_hp
	xor a,a
set_hp:
	ld [hl],a
	call PUT_STATUS

next_enemy:
	ld de,ENEMY_SIZE
	add ix,de
	pop bc
	djnz loop

	ret
ENDSCOPE; CHECK_PLAYER_DAMAGE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 3で割る
;;;; in a:割られる数 out a:割った結果
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE DIV3
DIV3::
	push de
	push hl
	ld hl,0xc040
	ld d,a
	ld e,0
loop:
	ld a,d
	sub a,h
	jr c,next
	ld d,a
	ld a,e
	add a,l
	ld e,a
next:
	srl h
	srl l
	jr nc,loop
	ld a,e

	pop hl
	pop de
	ret
ENDSCOPE; DIV3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; in:[hl] y [hl+1] x
;;;; out hl:VIEW_CODE_AREAのXY位置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE POSXY_VIEW_CODE_AREA
POSXY_VIEW_CODE_AREA::
	ld e,[hl] ;スプライトy座標
	inc hl
	ld a,[hl] ;スプライトx座標
	rrca ;スプライトx座標を1/8にすることでRAMアドレスになる
	rrca
	rrca
	inc e
	ld d,VIEW_CODE_AREA/256/4
	ex de,hl
	add hl,hl ;スプライトy座標を1/8*32、すなわち4倍にすることでRAMアドレスになる
	add hl,hl
	or a,l
	ld l,a
	ret
ENDSCOPE; POSXY_VIEW_CODE_AREA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ボス処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CHECK_BOSS
CHECK_BOSS::
	ld hl,BOSS_Status
	ld a,[hl]
	or a,a
	ret z ;0の時ボスは存在しないマップ

	dec hl ;BOSS_COUNT
	ld a,[hl]
	or a,a
	call z,warp_boss ;ボス移動

	;プレイヤー攻撃判定
	call IS_ATTACK
	call c,check_boss_damage
	;プレイヤーダメージ判定
	call check_boss_attack

	ld hl,BOSS_COUNT
	inc [hl]

	ret

;プレイヤー攻撃判定
check_boss_damage:
	; 剣の位置と敵の位置を比較し、ヒットしていればダメージを与える
	call get_boss_yx

	ld de,PLAYER_Y
	ld a,[de]
	add a,11 ;剣の下部分
	sub a,[hl] ;敵yPosが剣の下部分より下ならヒットしない
	ret c
	cp a,5+32 ;剣の上部分 todoこの辺ちゃんと
	ret nc
	inc de ;PLAYER_X
	ld a,[de]
	inc de ;PLAYER_SPRITE
;	sub a,0
	ld c,a
	ld a,[de]
	and a,4
	ld a,c
	jr nz,left_attack
	;右向き
	add a,32+0
left_attack:
	inc hl
	sub a,[hl] ;敵xPosが剣の右部分より右ならヒットしない
	ret c
	cp a,64
	ret nc

	;BOSSダメージエフェクト
	ld a,[BOSS_Status]
	call get_boss_view_code_area
	ld a,230 ;「に」背景
	call put_boss_line2

	;BOSS HP減少
	ld a,[PLAYER_LEVEL]
	cp a,11 ;level max
	jr c,not_max_level
	;ボスには最大255*2ダメージ
	ld hl,255*2
	jr enemy_damage
not_max_level:
	ld de,PLAYER_ATTACK_POINT-2
	add a,a
	add a,e
	ld e,a
	ld a,[de]
	ld h,0
	ld l,a
	ld a,[PLAYER_ITEMS]
	and a,ITEM_SWORD
	jr z,enemy_damage ;剣を持っているとダメージ2倍
	inc e
	ld a,[de]
	ld e,a
	ld d,0
	add hl,de
enemy_damage:
	ld c,l
	ld b,h
	ld hl,BOSS_HP
	ld e,[hl]
	inc hl
	ld d,[hl]
	ex de,hl
	or a,a
	sbc hl,bc
	jr nc,set_hp
	ld hl,0
set_hp:
	ex de,hl
	ld [hl],d
	dec hl
	ld [hl],e

	;BOSS 倒したか
	ld a,d
	or a,e
	jr nz,skip_boss_dead
	ld hl,BOSS_Status
	ld [hl],BOSS_Status_Dead
skip_boss_dead:

	;BOSS HP表示
	ld hl,BOSS_HP
	ld e,[hl]
	inc hl
	ld d,[hl]
	ex de,hl
	ld de,VIEW_CODE_AREA+14+23*VIEW_CODE_AREA_WIDTH
	call WORD_TO_TEXT

	ld hl,GAME_CONTROLLER
	set GAME_CONTROLLER_DAMAGE_EFFECT_BIT,[hl] ;DAMAGE_EFFECT
	set GAME_CONTROLLER_MAP_BIT,[hl]
	set GAME_CONTROLLER_STATUS_BIT,[hl]

	ret

;プレイヤーダメージ判定
check_boss_attack:
	ret

warp_boss:
	;移動前のボスの位置を消す
	ld a,[BOSS_Status]
	call get_boss_view_code_area
	ld a,0x5f ;_
	call put_boss_line2

	;ボス移動
	ld hl,BOSS_Status
	ld a,[hl]
not_zero:
	inc a
	and a,0x03
	jr z,not_zero
	ld [hl],a

	;ボス表示
	call get_boss_view_code_area
	ld a,220 ;ワ
	call put_boss_line1
	ld a,221 ;ン
	call put_boss_line1
	ld a,228 ;と
	call put_boss_line1
	ld a,229 ;な
	call put_boss_line1

	;敵データコピー
	call GET_MAP_ADDR
	call COPY_ENEMY_DATA
	call get_boss_yx
	ex de,hl
	ld hl,ENEMY_LIST+ENEMY_yPos

	ld a,[ENEMY_COUNT]
	or a,a
	jr z,skip_enemy_copy
	ld b,a
loop_enemy_copy:
	push bc
	ld a,[de] ;boss_y
	add a,[hl]
	ld [hl],a ;ENEMY_yPos
	inc hl ;ENEMY_xPos
	inc de ;boss_x
	ld a,[de]
	add a,[hl]
	ld [hl],a ;ENEMY_yPos
	ld bc,ENEMY_xMax-ENEMY_xPos
	add hl,bc ;ENEMY_xMax
	ld a,[de]
	add a,[hl]
	ld [hl],a ;ENEMY_xMax
	inc hl
	ld a,[de]
	add a,[hl]
	jr nz,set_enemy_xmin
	inc a ;ENEMY_xMinが0の時は1にする
set_enemy_xmin:
	ld [hl],a ;ENEMY_xMin
	dec de ;boss_y
	ld bc,ENEMY_SIZE-ENEMY_xMin+ENEMY_yPos
	add hl,bc

	pop bc
	djnz loop_enemy_copy

skip_enemy_copy:
	ld hl,BOSS_COUNT
	ld [hl],0

	ld hl,GAME_CONTROLLER
	set GAME_CONTROLLER_MAP_BIT,[hl]

	ret

get_boss_yx:
	;ボスの位置HLに
	ld a,[BOSS_Status]
	ld hl,BOSS_POSITION-2
	add a,a
	add a,l
	ld l,a
	ret

get_boss_view_code_area:
	call get_boss_yx
	call POSXY_VIEW_CODE_AREA
	ret

put_boss_line1:
	ld b,4
loop1:
	ld [hl],a
	add a,2
	inc hl
	djnz loop1
	ld a,VIEW_CODE_AREA_WIDTH-4
	add a,l
	ld l,a
	ld a,h
	adc a,0
	ld h,a
	ret

put_boss_line2:
	ld c,4
loop3:
	ld b,4
loop2:
	ld [hl],a
	inc hl
	djnz loop2
	push af
	ld a,VIEW_CODE_AREA_WIDTH-4
	add a,l
	ld l,a
	ld a,h
	adc a,0
	ld h,a
	pop af
	dec c
	jr nz,loop3
	ret

ENDSCOPE; CHECK_BOSS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 2バイトのデータを10進テキストにして指定アドレスにコピー
;;;;   in hl 2バイトのデータ
;;;;      hl コピー先アドレス
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE WORD_TO_TEXT
WORD_TO_TEXT::
	push hl
	exx
	pop hl
	ld c,0x30
	ld de,1000
	call put_text
	ld de,100
	call put_text
	ld de,10
	call put_text
	ld a,l
	add a,0x30
	exx
	ld [de],a
	ret

put_text:
	ld a,0x30-1
loop:
	inc a
	or a,a
	sbc hl,de
	jr nc,loop
	add hl,de
	cp a,c
	jr z,put_space
	ld c,0xff
	jr put_1char
put_space:
	xor a,a
put_1char:
	exx
	ld [de],a
	inc de
	exx
skip_put:
	ret
ENDSCOPE; WORD_TO_TEXT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ダメージカウントをダウン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE DOWN_DAMAGE_COUNT
DOWN_DAMAGE_COUNT::
	;敵　無敵（ダメージ）カウントダウン
	ld hl,ENEMY_LIST+ENEMY_DAMAGE_COUNT
	ld b,4
	ld de,ENEMY_SIZE
loop:
	ld a,[hl]
	or a,a
	jr z,next_enemy
	dec a
	ld [hl],a
next_enemy:
	add hl,de
	djnz loop

	ld hl,PLAYER_DAMAGE_COUNT
	ld a,[hl]
	or a,a
	jr z,skip_player
	dec a
	ld [hl],a
skip_player:

	ret
ENDSCOPE; DOWN_DAMAGE_COUNT

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
	set GAME_CONTROLLER_WAIT_BIT,[hl]
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
	bit GAME_CONTROLLER_NOENEMY_BIT,[hl]
	ret nz ;既に全滅している
	call ISNOENEMY
	ret nz ;全滅していない
	set 0,[hl]
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
	res GAME_CONTROLLER_NOENEMY_BIT,[hl] ;敵全滅フラグを消す
	set GAME_CONTROLLER_WAIT_BIT,[hl] ;マップ移動した場合、15/60秒待つ
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

	ld de,PLAYER_Y
	ld a,[de]
	sub a,[hl] ;イベントデータ3バイト目はスプライトy座標
	inc hl
	jr nz,event_skip_mode

	inc de ;PLAYER_X
	ld a,[de]
	add a,4
	sub a,[hl] ;イベントデータ4バイト目はスプライトx座標
	jr c,event_skip_mode
	cp a,8
	jr nc,event_skip_mode

	ld a,c
	ret
ENDSCOPE; GET_EVENT_ID


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; マップ表示 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE SET_MAPDATA
boss_data:
	DEFB 3 ;BOSS_Status
	DEFW 4096 ;BOSS_HP

;  hl:GET_MAP_ADDR
COPY_ENEMY_DATA::
	dec hl
	ld c,[hl]
	dec c
	ret z
	ld a,l
	sub a,c
	ld l,a
	ld a,h
	sbc a,0
	ld h,a
	ld de,ENEMY_COUNT
	ldir
	ret

SET_MAPDATA::

	;敵、ボスデータをクリア
	ld hl,ENEMY_INDEX
	ld bc,BOSS_DAMAGE_COUNT-ENEMY_INDEX
	call CLEAR_AREA

	;敵データをコピー
	call GET_MAP_ADDR
	bit 1,[hl] ;ラスボスのマップ
	jr z,skip_boss
	push hl
	ld hl,boss_data
	ld de,BOSS_Status
	ld bc,3
	ldir
	pop hl
skip_boss:
	call COPY_ENEMY_DATA
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

	call POSXY_VIEW_CODE_AREA ;イベントデータ3,4バイト目からRAMアドレスを取得

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

	;map書き込み
	ld hl,GAME_CONTROLLER
	set GAME_CONTROLLER_MAP_BIT,[hl]

	ret
ENDSCOPE; SET_MAPDATA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ダメージ音声
;;;;   call DAMAGE_EFFECT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE DAMAGE_EFFECT
DAMAGE_EFFECT::
	push hl

	call PUT_STATUS
	ld  hl,GAME_CONTROLLER
	set GAME_CONTROLLER_SPRITE_BIT,[hl]
	set GAME_CONTROLLER_STATUS_BIT,[hl]
	set GAME_CONTROLLER_WRITE_BIT,[hl]
	ld a,1
	call WAIT

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

	;敵に当たると剣を引っ込める
	ld a,ATTACK_COUNT_END
	ld [ATTACK_COUNT],a

	pop hl
	ret
ENDSCOPE; DAMAGE_EFFECT

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
;;;;   ステータス表示区域のクリア
;;;;   in bc:クリア文字数-1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE CLEAR_STATUS_AREA
CLEAR_STATUS_AREA::
	ld hl,VIEW_CODE_AREA+22*VIEW_CODE_AREA_WIDTH
	push bc
	call CLEAR_AREA
	ld hl,VIEW_CODE_AREA+23*VIEW_CODE_AREA_WIDTH
	pop bc
	jp CLEAR_AREA
ENDSCOPE; CLEAR_STATUS_AREA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; PUT_STATUS
;;;;   ステータスをVRAMのエリアに展開
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE PUT_STATUS
PUT_STATUS::
	ld bc,13
	call CLEAR_STATUS_AREA

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

	ld  hl,GAME_CONTROLLER
	set GAME_CONTROLLER_STATUS_BIT,[hl]

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
;;;; GAMECLEAR
;;;;  GAMECLEAR処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE GAMECLEAR
GAMECLEAR::
	ld bc,BGM_DATA_CLEAR
	call SET_BGM_CURRENT

	di
	ld bc,0x0807
	call BIOS_WRTVDP
	ei

	ld hl,GAME_CONTROLLER
	ld [hl],0xf0 ;VRAM書き込み
	ld a,60
	call WAIT

	di
	ld bc,0x0007
	call BIOS_WRTVDP
	ei

	;スプライト消去
	ld hl,PLAYER_Y
	ld [hl],NO_SPRITE_Y

	call CLEAR_VIEW_CODE_AREA
	ld hl,text_message
	ld b,2
put_text_loop:
	call TEXT_COPY
	djnz put_text_loop

	ld hl,text_push_space_key
	jp WAIT_SPACE
text_message:
	DEFW VIEW_CODE_AREA+8+11*VIEW_CODE_AREA_WIDTH
	DEFS "CONGRATULATIONS!"
	DEFB 0
	DEFW VIEW_CODE_AREA+3+14*VIEW_CODE_AREA_WIDTH
	DEFS "LET'S CREATE A NEW WORLD!"
	DEFB 0
text_push_space_key:
	DEFW VIEW_CODE_AREA+9+(13+4)*VIEW_CODE_AREA_WIDTH
	DEFS "PUSH SPACE KEY"
	DEFB 0
ENDSCOPE; GAMECLEAR


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; WAIT_SPACE
;;;;  GAMEOVER/GAMECLEAR処理共通
;;;;  in hl:"PUSH SPACE KEY"のアドレス
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE WAIT_SPACE
WAIT_SPACE::
	push hl
	ld hl,GAME_CONTROLLER
	ld [hl],0xf0 ;VRAM書き込み
	ld a,60
	call WAIT

	pop hl
	call TEXT_COPY
	ld hl,GAME_CONTROLLER
	ld [hl],0xf0 ;VRAM書き込み
	ld a,60
	call WAIT

	;スペースキーが押されるまで待つ
loop:
	call GTTRIG
	jr z,loop
	jp MAIN
ENDSCOPE; WAIT_SPACE


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; GAMEOVER
;;;;  GAMEOVER処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCOPE GAMEOVER
GAMEOVER::
	ld hl,text_gameover
	call TEXT_COPY

	;スプライト消去
	ld hl,PLAYER_Y
	ld [hl],NO_SPRITE_Y

	ld hl,text_push_space_key
	jp WAIT_SPACE
text_gameover:
	DEFW VIEW_CODE_AREA+11+11*VIEW_CODE_AREA_WIDTH
	DEFS "GAME OVER"
	DEFB 0
text_push_space_key:
	DEFW VIEW_CODE_AREA+9+13*VIEW_CODE_AREA_WIDTH
	DEFS "PUSH SPACE KEY"
	DEFB 0
ENDSCOPE; GAMEOVER


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
; 　+2 スプライトy座標 xy座標とプレイヤーのxy座標を比較し近い位置にあればイベント実行、画面表示に変更がある場合はxy座標を元にVIEW_CODE_AREAに文字出力
; 　+3 スプライトx座標
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
; 　　+8 ENEMY_Status　bit0:0=右向き,1=左向き　bit1:1=横移動する　bit2:1=ジャンプする　bit3:1=ガイコツ　bit4:1=オオカミ
; 　　+9 JumpCount
; 　　+10 xMax　x最大値
; 　　+12 xMin　x最小値
include "build/src/map.map.data"

include "src/vsync.inc"

include "src/password.inc"

include "src/system_init.inc"


_MAXSIZE:: ;最大サイズ

ALIGN 0x4000
