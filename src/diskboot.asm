;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; diskのブートセクタ ブート時にC000Hから256バイト読み込まれる
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BIOS_INIT32 := 0x006F ;SCREEN1にする
BIOS_CHGCLR := 0x0062 ;画面の色を変える
 MSXWORK_FORCLR := 0xF3E9 ;色指定
BIOS_LDIRVM := 0x005C ;メモリから VRAM へブロック転送 HL にソース・アドレス (メモリ)、DE にデスティネーション・アドレス (VRAM)、BC に長さ

include "src/disk.inc"

SCOPE DISKBOOT
	ORG 0xC000

	DEFB 0xeb,0xfe,0x90 ;jmpコード
title:
	DEFS "ELE LAND"
	ORG 0xC00B
	DEFW 512 ;1セクタのサイズ(バイト単位)
	DEFB 2 ;1クラスタのサイズ(セクタ単位)
	DEFW 1 ;MSX-DOSが使用しないセクタ数

	ORG 0xC010
	DEFB 2 ;FATの個数
	DEFW 112 ;作成可能なファイルの数
	DEFW 1440 ;ディスクに含まれるセクタの総数
	DEFB 0xf9 ;メディアID 2DD,9セクタ
	DEFW 3 ;FATのサイズ(セクタ単位)
	DEFW 9 ;1トラックに含まれるセクタ数 9セクタ
	DEFW 2 ;面の数 2DD
	DEFW 0 ;隠されたセクタ数

	ORG 0xC01E ;ここから開始
	ret c ;MSX-DOS環境で開始する場合はret nc、DISK環境で開始する場合はret c

	call BIOS_INIT32

; FORCLR (F3E9H) に前景色
; BAKCLR (F3EAH) に背景色
; BDRCLR (F3EBH) に周辺色
	ld hl,MSXWORK_FORCLR
	ld [hl],0x0f
	inc hl
	ld [hl],01
	inc hl
	ld [hl],00
	call BIOS_CHGCLR

	ld hl,title
	ld de,0x1800
	ld bc,8
	call BIOS_LDIRVM

	; DMA アドレス
	ld c,0x1a
	ld de,DISK_MAIN_START
	call DISK_SYSTEM_CALL

	; 1セクタ(0200h)目から 18*0200hバイト
	LD DE, 0x0001
	LD HL, 0x1800
	LD C, 0x2f
	CALL DISK_SYSTEM_CALL

	jp DISK_MAIN_START

	ALIGN 0x100
	ALIGN 0x200
ENDSCOPE; DISKBOOT


