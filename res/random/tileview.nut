function display_between(tilemap, id = 1, ignorezero = false) {
	local willdisplay = false
	for(local y = 0; y < tilemap_get_height(tilemap); y++) {
		local strang = ""
		for(local x = 0; x < tilemap_get_width(tilemap); x++) {
			if(tilemap.get_tile_id(x, y) == id) willdisplay = !willdisplay
			if((ignorezero && tilemap.get_tile_id(x, y) != 0) || !ignorezero)
				strang = strang + tilemap.get_tile_id(x, y).tostring() + " "
		}
		if(willdisplay) display(y.tostring() + " : " + strang)
	}
}

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