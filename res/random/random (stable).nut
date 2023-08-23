import("res/random/words.nut")
import("res/random/presets.nut")

local rseed = 0
local deftext = ""
local inc = 0
local loading = true

local seed_key = "menu-select"

local themes = sector.presets

function start() {
	//display()
	//return 0

	if("seed" in Level) {
		srand(Level.seed)
	} else {
		srand(rand())
	}

	deftext = "Current seed is " + rseed.tostring() + ". Set the seed to: "
	
	sector.random_ui_thread <- newthread(seed_ui)
	sector.random_ui_thread.call()

	local x = 10
	local y = 252

	//Gradient.fade_color1(random_between(1, 3) - 1, random_between(1, 3) - 1, random_between(1, 3) - 1, 3)

	//make_square(0, 252, 10, 250, 1, interactive)

	local deco_table = random_in_list(themes)
	local musoc = random_in_list(deco_table.musics) + ".music"
	background1.set_image(random_in_list(deco_table.bgs))

	while(true) {
		loading_text("Generating terrain/blocks. (" + x.tostring() + " / 500)")
		local w = random_between(1, 15)
		local h = random_between(1, 20)
		if(random() % 2 == 0) {
			make_square(x, y, w, h, 1, interactive)
		} else {
			make_square(x, y, w, 250, 1, interactive)
		}

		local bonus_block_y = y - random_between(3, 7)
		if(random() % 5 == 0) {
			local bonusmin = (random() % 5) - 3
			local bonusmax = random_between(1, 3)
			for(local bonus_block_x = x - bonusmin; bonus_block_x < x + bonusmax; bonus_block_x++) {
				make_bonus_block(bonus_block_x, bonus_block_y, interactive)
				wait(0.01)
			}
		}
		
		play_music(musoc)
	   
		x = x + w + (random() % 6) - 3
		y = y + (random() % 8) - 4

		if(x > 500) break
		wait(0.01)
	}
	local space = (random() % 3)
	local g1 = get_floor(482, interactive)
	local g2 = get_floor(483 + space, interactive)
	local goaly = 0

	if(g1 < g2) {
		goaly = g1 - (random() % 15) + 2
	} else {
		goaly = g2 - (random() % 15) + 2
	}
	
	loading_text("Generating goalposts. (1 / 2)")
	generate_goal(482, goaly, background, interactive)
	loading_text("Generating goalposts. (2 / 2)")
	generate_goal(483 + space, goaly, foreground, interactive)

	for(local x = 0; x < 499; x++) {

		local y1 = get_floor(x, interactive)
		local y2 = get_floor(x + 1, interactive)

		if(y1 - y2 > 5 ) {//&& y1 < 500 && y2 < 500 ) {
			spawn_object("trampoline", x - 0.5, y1 - 1, "(portable #f)")
		} //else {
		//	local y3 = get_floor(x - 1, interactive)
		//	if(y3 - y2 > 5 )//&& y3 < 500 && y2 < 500 )
		//		spawn_object("trampoline", x, y3 - 1, "(portable #f)")
		//}
		//if(y2 - y1 > 5 && y1 < 500 && y2 < 500 ) {
		//	spawn_object("trampoline", x, y, "(portable #f)")
		//}
		if(x % 5 == 0) {
			loading_text("Generating trampolines. (" + x.tostring() + " / 500)")
			wait(0.01)
		}
	}
	loading_text()
}

function seed_ui() {
	try{
		local newseed = rseed
		local oldseed = newseed
		while(true) {
			if(sector.Tux.get_input_held(seed_key)) {
				if(sector.Tux.get_input_pressed("up")) {
					newseed++
				} else if(sector.Tux.get_input_pressed("down")) {
					newseed--
				} else if(sector.Tux.get_input_held("peek-up")) {
					newseed += 10
				} else if(sector.Tux.get_input_held("peek-down")) {
					newseed -= 10
				} else if(sector.Tux.get_input_pressed("left")) {
					newseed = rand()
				} else if(sector.Tux.get_input_pressed("right")) {
					newseed = 0
				}
				
				Text.set_text(deftext + newseed.tostring() + ".")
				Text.set_visible(true)

				sector.Tux.deactivate()
			}
			if(sector.Tux.get_input_released(seed_key)) {
				sector.Tux.activate()
				Text.set_visible(false)
				if(newseed != oldseed) {
					Level.seed <- newseed
					restart()
				}
			} 
			wait(0.01)
		}
	} catch(e) if(e != "'set_text' called without instance") throw(e)
}

function loading_text(taxt = "") {
	if(taxt == "") {
		loading = false
	} else {
		loading = true
		if(!sector.Tux.get_input_held(seed_key)) Text.set_text(taxt)
	}
	Text.set_visible(loading)
}

//////////////////-UTILITY-//////////////////

function make_square(x_, y_, w, h, id, tilemap) {
	for(local x = x_; x < x_ + w; x++) {
		for(local y = y_; y < y_ + h; y++)
			if(x_ > 1 && y > 1 && x < tilemap_get_width(tilemap) && y < tilemap_get_height(tilemap))
				tilemap.change(x, y, id)
		wait(0.01)
	}
}

function generate_goal(x, y_, tilemap, datamap = null) {
	if(datamap == null) datamap = tilemap
	local y = y_
	for(local i = 0; i < 500; i++) {
		//display(y)
		if(datamap.get_tile_id(x, y) == 0) {
			tilemap.change(x, y, 129)
			y++
		} else {
			tilemap.change(x, y - 1, 127)
			break
		}
		wait(0.01)
	}
	tilemap.change(x, y_, 130)
}

function get_floor(x, tilemap) {
	for(local y = 0; y < 500; y++) {
		if(tilemap.get_tile_id(x, y) != 0) return y - 1
		y++
		if(y % 10 == 0) wait(0.01)
	}
	return 500
}

function srand(seed) rseed = seed

function random() return rseed = (rseed * 1103515245 + 12345) & RAND_MAX

function random_between(min, max, blacklist = null) {
	if(blacklist == null) {
		return (random() % max - min) + min
	} else {
		while(true) {
			local rnado = (random() % max - min) + min
			if(!blacklist.find(rnado)) return rnado
			wait(0.01)
		}
	}
}

function random_in_list(list) {
	if(type(list) == "weakref") list = list.ref()
	if(type(list) == "array") {
		return list[random_between(1, list.len())]
	} else if(type(list) == "table") {
		return list[list.keys()[random_between(1, list.keys().len())]]
	} else {
		throw("Expected type \"table\" or \"array\" but got type " + type(list) + ".")
	}
}
function random_string() {
	//display(random() % 2)
	switch(random() % 2) {
		case 0:
			try{
				local items = "`~!@#$%^&*()-_=+[{]};:'\\|,<.>/?'] abcdefghijklmnopqrstuvwxyz  abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ      ----------\t\t\t\t\t\t\t\t\t\t**********##########!!!!!!!!!!"
				local strang = ""
				local length = random_between(1, 100)
				for(local i = 0; i < length; i++) {
					local num = random_between(1, items.len())
					strang = strang + items.slice(num - 1, num)
				}
				return strang
			} catch(e) {
				if(e == "wrong indexes") {
					return "!images/engine/missing.png"
				} else return "-ERROR: " + e
			}
		break
		case 1:
			//display("we got one")
			local strang = ""
			local order = []
			switch(random() % 10) {
				case 0:
					order = split("adverb adjective noun verb adverb adverb", " ")
				break
				case 1:
					order = split("adjective noun verb adverb", " ")
				break
				case 2:
					order = split("adjective noun verb adverb adjective", " ")
				break
				case 3:
					order = split("verb noun verb adverb noun adverb", " ")
				break
				case 4:
					order = split("noun verb adverb adjective noun", " ")
				break
				case 5:
					order = split("adjective noun verb", " ")
				break
				case 6:
					order = split("adverb adjective noun verb adverb", " ")
				break
				case 7:
					order = split("noun verb adjective noun adverb", " ")
				break
				case 8:
					order = ["noun"] //done differently to avoid errors
				break
				case 9:
					order = split("adjective noun", " ")
				break
			}
			foreach(v in order) {
				strang = strang + " " + random_in_list(sector[v])
			}
			return strang.slice(1, 2).toupper() + strang.slice(2, strang.len()) + "."
		break
	}
}

function make_bonus_block(x, y, tilemap = null) {
	if(tilemap != null && tilemap.get_tile_id(x, y) == 0) {
		local chance = random() % 10
		if(chance == 0) {
			spawn_object("infoblock", x, y, "(message (_ \"" + random_string() + "\"))")
		} else if(chance > 6) {
			//spawn_object("bonusblock", x, y, "(data " + random_between(1, 16, [6, 8, 9, 14]).tostring() + ")")
			//spawn_object("bonusblock", x, y)
			spawn_object("bonusblock", x, y, "(data " + random_between(1, 14).tostring() + ")")
		} else if(random() % 3 == 0) {
			spawn_object("brick", x, y, "(breakable #f)")
		} else {
			spawn_object("brick", x, y, "(breakable #t)")
		}
		tilemap.change(x, y, 0)
	}
}

function spawn_object(object, x, y, data = "", direction = "auto", name = null) {
	if(name) {
		sector.settings.add_object(object, name, x * 32, y * 32, direction, data)
	} else {
		sector.settings.add_object(object, object + inc.tostring(), x * 32, y * 32, direction, data)
		inc++
	}
}

//////////////////-EXTERNAL UTILITY-//////////////////

function tilemap_get_width(tilemap) {
	if(tilemap.tostring() + "_x" in sector) {
	   return sector[tilemap.tostring() + "_x"] 
	} else {
		local inc = 0
		while(true) {
			local oldid = tilemap.get_tile_id(inc, 0)
			tilemap.change(inc, 0, 1)
			if(tilemap.get_tile_id(inc, 0) == 1) {
				tilemap.change(inc, 0, oldid)
				inc++
			} else break
			//wait(0.01)
		}
		tilemap.change(0, 1, 0)
		sector[tilemap.tostring() + "_x"] <- inc
		return inc
	}
}

function tilemap_get_height(tilemap) {
	if(tilemap.tostring() + "_y" in sector) {
	   return sector[tilemap.tostring() + "_y"] 
	} else {
		local inc = 0
		while(true) {
			local oldid = tilemap.get_tile_id(0, inc)
			tilemap.change(0, inc, 1)
			if(tilemap.get_tile_id(0, inc) == 1) {
				tilemap.change(0, inc, oldid)
				inc ++
			} else break
			//wait(0.01)
		}
		tilemap.change(0, 1, 0)
		sector[tilemap.tostring() + "_y"] <- inc
		return inc
	}
}