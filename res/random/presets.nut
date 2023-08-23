/*
BONUS BLOCK IDS:
1  - coin
2  - fire flower
3  - star
4  - tux doll
5  - ice flower
6  - light (hidden)
7  - stationary trampoline
8  - portable trampoline
9  - rock
10 - coin rain
11 - coin explosion
12 - potion
13 - air flower
14 - earth flower
15 - light (turned on)

AUTOTILE TABLE:
{tiles = [0] top_tile = 0}
*/

local default_powerups = [0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 4 7 7 7 8 8 8 8 11 11 11]
local snow_flowers = [2 2 2 2 13]
local forest_flowers = [5 5 5 5 14]

sector.presets <- {
	antarctic = {
		musics = [
			"music/antarctic/airship_remix"
			"music/antarctic/airship_remix-2"
			"music/antarctic/chipdisko"
			"music/antarctic/voc-daytime"
			"music/antarctic/voc-daytime2"
		]
		bgs = ["images/background/antarctic/snow_panorama.png"]

		allowed_flowers = snow_flowers
		allowed_powerups = default_powerups

		autotile = [
			{tiles = [203] top_tile = 202} {tiles = [13] top_tile = 7} {tiles = [14] top_tile = 8} {tiles = [15] top_tile = 9} 20 {tiles = [14] top_tile = 8} {tiles = [14] top_tile = 8} 23 {tiles = [13] top_tile = 7} 214 {tiles = [14 14 14 14 14 3988 3989 3990] top_tile = 8} {tiles = [15] top_tile = 9}
			206 3056 214 3048 10 23 20 12 10 23 0 20
			206 3056 214 3048 10 11 11 12 23 {tiles = [11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 11 2134 2135 19 26]} 20 12
			{tiles = [203] top_tile = 202} {tiles = [13] top_tile = 7} {tiles = [14] top_tile = 8} {tiles = [15] top_tile = 9} 214 23 20 214 10 11 11 12
		]
	}

	forest = {
		musics = [
			"music/forest/forest"
			"music/forest/forest2"
			"music/forest/forest3"
			"music/forest/forest-sprint"
			"music/forest/forest_theme"
			"music/forest/shallow-green"
		]
		bgs = ["images/background/forest/forest_panorama.png"]

		allowed_flowers = forest_flowers
		allowed_powerups = default_powerups

		autotile = [
			{tiles = [1044] top_tile = 1038} {tiles = [4293] top_tile = 1000} {tiles = [4304] top_tile = 1001} {tiles = [4296] top_tile = 1003} 4309 {tiles = [4295] top_tile = 1001} {tiles = [4294] top_tile = 1001} 4310 {tiles = [1004] top_tile = 1000} 1039 {tiles = [1005 1006] top_tile = 1001} {tiles = [1007] top_tile = 1003}
			1738 4298 4311 4299 4297 1040 1041 4300 1008 1042 0    4319
			3472 4305 4301 4308 4302 4318 4317 4303 4320 {tiles = [1009 1013 1014 1009 1013 1014 1010]} 1043 1015
			{tiles = [4327] top_tile = 1038} {tiles = [3621] top_tile = 1000} {tiles = [3623] top_tile = 1001} {tiles = [3624] top_tile = 1003} 4313 4307 4306 4314 1016 1018 4312 1019
		]
	}

	antarctic_cave = {
		cave = true
		musics = [
			"music/antarctic/arctic_cave"
			"music/antarctic/cave"
			"music/antarctic/voc-dark"
			
		]
		bgs = ["images/background/ice_cave/ice_cave_backwall.png"]

		lights = [0.5 0.5 0.6]

		allowed_flowers = snow_flowers
		allowed_powerups = default_powerups

		autotile = [
			{tiles = [2950] top_tile = 2949} {tiles = [4045] top_tile = 2384} {tiles = [4046] top_tile = 2385} {tiles = [4047] top_tile = 2386} 4071 {tiles = [2388] top_tile = 2385} {tiles = [2388] top_tile = 2385} 4072 {tiles = [2387] top_tile = 2384} 4052 {tiles = [2388] top_tile = 2385} {tiles = [2389] top_tile = 2386}
			2951 4057 4056 4058 4061 2960 2959 4062 2390 4064 0    4069
			2952 4053 4054 4055 4073 2962 2957 4074 4070 {tiles = [2391 2396 2397 2398 2399]} 4063 2392
			{tiles = [2956] top_tile = 2384} {tiles = [2953] top_tile = 2384} {tiles = [2954] top_tile = 2385} {tiles = [2955] top_tile = 2386} 4065 4075 4076 4066 2393 2394 4077 2395
		]
	}

	retro_castle = {
		castle = true
		musics = [
			"music/retro/fortress_old"
		]
		bgs = ["images/background/misc/transparent_up.png"]

		gradient = [
			1 0 0
			0 0 0
		]

		allowed_flowers = [2]
		allowed_powerups = default_powerups

		autotile = [
			3516 489 65 490 3519 4898 4897 3520 489 64 65 490
			3517 68 64 69 68 64 64 69 68 3519 0 64
			3518 67 66 321 68 3519 3520 69 64 64 3520 69
			2472 3280 3281 3282 3519 3520 3519 3520 67 66 66 321
		]
	}
}