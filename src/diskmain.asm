;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; bloadのデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
include "src/disk.inc"

ORG DISK_MAIN_START
	jp SYSTEM_INIT
include "src/main.inc"

