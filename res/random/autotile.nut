local blobmaps = [
	"00000010" "00001010" "00011010" "00010010" "11011010" "00011011" "00011110" "01111010" "00001011" "01011111" "00011111" "00010110"
	"01000010" "01001010" "01011010" "01010010" "01001011" "01111111" "11011111" "01010110" "01101011" "01111110" "0"/* no*/ "11011110"
	"01000000" "01001000" "01011000" "01010000" "01101010" "11111011" "11111110" "11010010" "01111011" "11111111" "11011011" "11010110"
	"00000000" "00001000" "00011000" "00010000" "01011110" "01111000" "11011000" "01011011" "01101000" "11111000" "11111010" "11010000"
]

// yoinked
function blobmap_number(t, b, l, r, tl, tr, bl, br) {
	// corner tiles are false if surrounding tiles are false
	if(!(t && l)) tl = false
	if(!(t && r)) tr = false
	if(!(b && l)) bl = false
	if(!(b && r)) br = false
	
	local total = ""
	if(tl) {total = total + "1"} else {total = total + "0"}
	if(t) {total = total + "1"} else {total = total + "0"}
	if(tr) {total = total + "1"} else {total = total + "0"}
	if(l) {total = total + "1"} else {total = total + "0"}
	if(r) {total = total + "1"} else {total = total + "0"}
	if(bl) {total = total + "1"} else {total = total + "0"}
	if(b) {total = total + "1"} else {total = total + "0"}
	if(br) {total = total + "1"} else {total = total + "0"}
	return total
}

function blobmap_from_tile(x, y, tilemap)
	return blobmap_number(
		tilemap.get_tile_id(x, y - 1) != 0,
		tilemap.get_tile_id(x, y + 1) != 0,
		tilemap.get_tile_id(x - 1, y) != 0,
		tilemap.get_tile_id(x + 1, y) != 0,
		tilemap.get_tile_id(x - 1, y - 1) != 0,
		tilemap.get_tile_id(x + 1, y - 1) != 0,
		tilemap.get_tile_id(x - 1, y + 1) != 0,
		tilemap.get_tile_id(x - 1, y + 1) != 0
	)

function array_to_table(arroy) {
	local t = {}
	foreach(i, v in arroy)
		t[blobmaps[i]] <- v
	return t
}