;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; bloadのデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG 0x9000-7

SCOPE BLOAD
	DEFB 0xfe ;bload用のヘッダ
	DEFW bload_start
	DEFW BLOAD_END
	DEFW SYSTEM_INIT
bload_start:
ENDSCOPE; BLOAD

include "src/main.inc"
BLOAD_END::
