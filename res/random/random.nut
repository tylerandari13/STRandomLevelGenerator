import("res/random/words.nut")
import("res/random/presets.nut")
import("res/random/autotile.nut")

local rseed = 0
local deftext = ""
local inc = 0
local loading = true
local powerup = 0
local autotiletable = []
local infotable = []

local seed_key = "menu-select"

local info_block_height = 13

local deco_table = {}

local themes = sector.presets

function start() {

	//for(local i = 0; i < 20; i++) spawn_object("bonusblock", 10 + i, 249, "(data " + i.tostring() + ")")
	
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

	local autotop = 0
	local autobottom = 500
	local tolerance = 0

	local cave_table = []

	deco_table = random_in_list(themes)
	local musoc = random_in_list(deco_table.musics) + ".music"
	if("bgs" in deco_table) background1.set_image(random_in_list(deco_table.bgs))
	if("gradient" in deco_table) Gradient.set_colors(deco_table.gradient[0], deco_table.gradient[1], deco_table.gradient[2], deco_table.gradient[3], deco_table.gradient[4], deco_table.gradient[5])
	if("lights" in deco_table) sector.settings.set_ambient_light(deco_table.lights[0], deco_table.lights[1], deco_table.lights[2])
	powerup = random_in_list(deco_table.allowed_flowers)

	if("cave" in deco_table && deco_table.cave) {
		y = 246
		x = 0
		tolerance = 1
		loading_text("Prepping...")
		make_square(0, 0, 500, 500, 1, interactive)
		while(true) {
			loading_text("Generating holes/blocks. (" + x.tostring() + " / 500)")
			local w = random_between(10, 15)
			local h = random_between(10, 15)
			
			make_square(x, y, w, h, 0, interactive)

			//if(y - 20 < autotop) autotop = y - 20
			//if(y + h + 20 > autobottom) autobottom = y + h + 20
			
			play_music(musoc)
		
			x = x + (w / 4).tointeger()
			y = y + (random() % 3) - 1

			if(x > 500) break
			//wait(0.01)
		}

	} else { // deco_map.cave == false

		while(true) {
			loading_text("Generating terrain/blocks. (" + x.tostring() + " / 500)")
			local w = random_between(1, 15)
			local h = random_between(1, 20)
			if(random() % 2 == 0) {
				make_square(x, y, w, h, 1, interactive)
				if(("castle" in deco_table && deco_table.castle)) cave_table.push([x + (random() % 7) - 3, y - h - 10, w + (random() % 7) - 3, h + (random() % 7) - 3])
			} else {
				make_square(x, y, w, 25, 1, interactive)
				if(("castle" in deco_table && deco_table.castle)) cave_table.push([x + (random() % 7) - 3, y - 45, w, 25, 1])
			}
			
			play_music(musoc)
		
			x = x + w + (random() % 6) - 3
			y = y + (random() % 8) - 4

			if(y < autotop) autotop = y
			if(y + h > autobottom) autobottom = y + h

			if(x > 500) break
			//wait(0.01)
		}

		make_square(0, 252, 10, 250, 1, interactive)
	}


	local space = (random() % 3)
	local g1 = get_floor(482, interactive, tolerance)
	local g2 = get_floor(483 + space, interactive, tolerance)
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
		local y1 = get_floor(x, interactive, tolerance)
		local y2 = get_floor(x + 1, interactive, tolerance)

		local offset = 0.5
		if(interactive.get_tile_id(x - 1, y1 - 1) == 1) offset = 0

		if(y1 - y2 > 5) {
			spawn_object("trampoline", x - offset, y1 - 1, "(portable #f)")
		}
		if(y1 == 500 && y2 < 500) for(local x2 = x; x2 > x - 10; x2--)  {
			local y3 = get_floor(x2, interactive, tolerance)
			local done = false
			if((y3 - y2 > 5) && y3 != 500) {
				done = true
				spawn_object("trampoline", x2, y3 - 1, "(portable #f)")
				//display(y1.tostring() + " : " + y2.tostring() + " : " + y3.tostring())
			}
			if(done) break
			if(x2 % 5 == 0) wait(0.01)
		}
		if(x % 50 == 0) {
			loading_text("Generating trampolines. (" + x.tostring() + " / 500)")
			wait(0.01)
		}
	}

	foreach(i, v in cave_table) {
		loading_text("Generating terrain again. (" + i.tostring() + " / " + cave_table.len().tostring() + ")")
		make_square(v[0], v[1], v[2], v[3], 1, interactive)
		if(i % 5 == 0) wait(0.01)
	}

	foreach(i, v in infotable) {
		loading_text("Adding extra holes. (" + i.tostring() + " / " + infotable.len().tostring() + ")")
		for(local y = v[1] + info_block_height; y > v[1] -1; y--) interactive.change(v[0], y, 0)
		if(i % 5 == 0) wait(0.01)
	}

	for(local autoy = autotop; autoy < autobottom; autoy++) {
		for(local autox = 0; autox < 500; autox++) {
			if(interactive.get_tile_id(autox, autoy) == 1) {
				autotile(autox, autoy, deco_table.autotile, interactive)
				if(autox % 50 == 0) {
					loading_text("Autotiling. (" + (autox + (autoy * 500)).tostring() + " / " + ((autobottom - autotop) * 500).tostring() + ")")
					//wait(0.01)
				}
			}
		}
		wait(0.01)
	}
	loading_text()
}

function seed_ui() {
	local newroottable = getroottable()
	newroottable.set_seed <- set_seed
	setroottable(newroottable)

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

function set_seed(seed) {

}

//////////////////-UTILITY-//////////////////

function make_square(x_, y_, w, h, id, tilemap) {
	for(local x = x_; x < x_ + w; x++) {
		for(local y = y_; y < y_ + h; y++)
			//if(x_ > 1 && y > 1 && x < tilemap_get_width(tilemap) && y < tilemap_get_height(tilemap)) {
			if(id != 0 && tilemap.get_tile_id(x, y) == 0) {
				tilemap.change(x, y, id)
			} else if(id == 0 && tilemap.get_tile_id(x, y) == 1) {
				tilemap.change(x, y, id)
			}
		if(x % 100 == 0) wait(0.01)
	}

	if(random() % 3 == 0) {
		local bonus_block_y = y_ - random_between(3, 7)
		if(id == 0) bonus_block_y = y_ + h - random_between(3, 7)
		local bonusmin = (random() % 5) - 3
		local bonusmax = random_between(1, 3)
		for(local bonus_block_x = x_ - bonusmin; bonus_block_x < x_ + bonusmax; bonus_block_x++) {
			make_bonus_block(bonus_block_x, bonus_block_y, interactive)
			wait(0.01)
		}
	}
}

function generate_goal(x, y_, tilemap, datamap = null) {
	if(datamap == null) datamap = tilemap
	local y = y_
	for(local i = 0; i < 500; i++) {
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

function get_floor(x, tilemap, lenience = 0) {
	local idk = true
	if(lenience == 0) {
		for(local y = 0; y < 500; y++) if(tilemap.get_tile_id(x, y) != 0) return y - 1

	} else for(local y = 0; y < 500; y++) {
		if(tilemap.get_tile_id(x, y) != 0 && idk == true) {
			idk = false
			lenience -= 0.5
		} else if(tilemap.get_tile_id(x, y) == 0 && idk == false) {
			idk = true
			lenience -= 0.5
		}
		if(lenience < 0) return y - 1
		//if(y % 10 == 0) wait(0.01)
	}
	return 500
}

function srand(seed) {
	rseed = seed
	Level.seed <- seed
}

function random() return rseed = (rseed * 1103515245 + 12345) & RAND_MAX //the core of the operation :trollcan:

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
		if(list.len() == 0) return null
		if(list.len() == 1) return list[0]
		return list[random_between(1, list.len())]
	} else if(type(list) == "table") {
		if(list.keys().len() == 0) return null
		if(list.keys().len() == 1) return list.values()[0]
		return list[list.keys()[random_between(1, list.keys().len())]]
	} else {
		throw("Expected type \"table\" or \"array\" but got type " + type(list) + ".")
	}
}

function random_string() {
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

function make_bonus_block(x, y, tilemap) {
	if(tilemap.get_tile_id(x, y) == 0) {
		local chance = random() % 10
		if(chance == 0) {
			spawn_object("infoblock", x, y, "(message (_ \"" + random_string() + "\"))")
		} else if(chance > 6) {
			local id = random_in_list(deco_table.allowed_powerups)
			if(id <= 0) id = powerup
			spawn_object("bonusblock", x, y, "(data " +  id.tostring() + ")")
			if(id == 7) {
				spawn_object("infoblock", x, y - info_block_height, "(message (_ \"" + random_string() + "\"))")
				infotable.push([x, y - info_block_height])
			}
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

function autotile(x, y, orray, tilemap) {
	//local data = array_to_table(orray)
	//local bitmask = blobmap_from_tile(x, y, tilemap)
	//local tiledata = data[bitmask]
	local tiledata = array_to_table(orray)[blobmap_from_tile(x, y, tilemap)]
	if(type(tiledata) == "integer") {
		tilemap.change(x, y, tiledata)
	} else if(type(tiledata) == "table") {
		tilemap.change(x, y, random_in_list(tiledata.tiles))
		if("top_tile" in tiledata) tilemap.change(x, y - 1, tiledata.top_tile)
	}
}

function endsequence() {
	//Tux.trigger_sequence("endsequence")
	play_music("music/misc/leveldone.ogg")
	wait(7)
	//if("seed" in Level) delete Level.seed
	srand(rand())
	restart()
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
		}
		tilemap.change(0, 1, 0)
		sector[tilemap.tostring() + "_y"] <- inc
		return inc
	}
}