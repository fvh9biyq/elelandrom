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

include "src/main.inc"

ALIGN 0x4000
