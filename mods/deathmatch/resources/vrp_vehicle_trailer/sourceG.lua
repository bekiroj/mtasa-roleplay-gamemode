GROUP_ID = 33
TRUCK_MODEL = 443

SLIDE_ANIMATION_TIME = 2564
ROTATE_ANIMATION_TIME = 1200
CAR_ANIMATION_TIME = 4150

FLATBED_OFFSETS = {
	-- startX, startY, stopX, stopY
	{-1.35, 1, -1.35, -5.85}, -- bal oldal, hátulról nézve
	{1.35, 1, 1.35, -5.85}, -- jobb oldal, hátulról nézve
	{-1.35, -5.85, 1.35, -5.85}, -- hátul
	{-1.35, 1, 1.35, 1} -- elöl
}



ZONE_MIN_X, ZONE_MIN_Y = 2056.30078, 1454.94531
ZONE_MAX_X, ZONE_MAX_Y = ZONE_MIN_X + 12, ZONE_MIN_Y + 4
ZONE_Z = 10.67188 - 0.99
