	db DEX_KYONPAN ; 230

	db  60,  50,  55,  55,  70,  50
	;   hp  atk  def  spd  sat  sdf

	db TYPE_GHOST, TYPE_GHOST ; type
	db 255 ; catch rate
	db 100 ; base exp
	db ITEM_APPLE, ITEM_SPIKE ; items
	db GENDER_50_50 ; gender ratio
	db 100, 4, 70 ; unknown
	dn 7, 7 ; sprite dimensions
	dw KyonpanPicFront, KyonpanPicBack ; sprites
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm 1, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18, 19, 20, 22, 24, 25, 29, 30, 31, 32, 33, 34, 35, 36, 38, 40, 44, 45, 46, 49, 50, 54, 55
	; end

