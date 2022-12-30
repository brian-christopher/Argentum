extends Node2D
class_name Map 

enum TileFlags{
	None = 0,
	Blocked = 1 << 0,
	Water = 1 << 1
}


var _triggers := PoolIntArray()
var _flags := PoolIntArray()
var _items := []
var _characters := []

var _main_character_id := -1

var _min_limit_x := 0
var _min_limit_y := 0

var _max_limit_x := 0
var _max_limit_y := 0

onready var entities_container = $Overlap/Entities
 
func _init() -> void: 
	_triggers.resize(Global.MAP_WIDTH * Global.MAP_HEIGHT)
	_triggers.fill(0)

	_flags.resize(Global.MAP_WIDTH * Global.MAP_HEIGHT)
	_flags.fill(0) 
	
func area_changed(x:int, y:int) -> void:
	_min_limit_x = (int(x / 9) - 1) * 9
	_max_limit_x = _min_limit_x + 26
	
	_min_limit_y = (int(y / 9) - 1) * 9
	_max_limit_y = _min_limit_y + 26
	
	var rem_chars = []
	var rem_item = []
	
	for character in _characters:
		 if character.grid_position_y < _min_limit_y or character.grid_position_y > _max_limit_y or character.grid_position_x < _min_limit_x or character.grid_position_x > _max_limit_x:
				rem_chars.append(character)
				
	for item in _items:
		if item.y < _min_limit_y or item.y > _max_limit_y or item.x < _min_limit_x or item.x > _max_limit_x:
				rem_item.append({x= item.x, y = item.y})
				
	for i in rem_chars:
		if i.guid != _main_character_id:
			remove_character_by_id(i.guid)
		
	for i in rem_item:
		remove_item(i.x, i.y) 
	
func set_main_character_id(char_id:int) -> void:
	_main_character_id = char_id
	
func add_item(x:int, y:int, grh_id:int) -> void:
	if grh_id == 0 || !Global.grh_data.has(grh_id):
		print("grh con un id[%d] invalido en x[%d] y[%d]" % [grh_id, x, y])
		return
		
	if Global.grh_data[grh_id].num_frames > 1:
		grh_id = Global.grh_data[grh_id].frames[1]
		
	
	var item = Sprite.new()
	var region = Global.grh_data[grh_id].region
	item.texture = load("res://assets/graphics/%d.png" % Global.grh_data[grh_id].file_num)
	item.region_enabled = true
	item.region_rect = Global.grh_data[grh_id].region
	
	if region.size == Vector2(32, 32):
		item.position = Vector2(x * 32, y * 32) 
		item.centered = false 
		$Item.add_child(item)
	else:
		item.position = Vector2((x * 32) + 16, (y * 32) + 32)
		item.offset = Vector2(0, -item.region_rect.size.y / 2)
		$Overlap/Entities.add_child(item)
		 
	_items.append({x = x, y = y, node = item})
	
func remove_item(x:int, y:int):
	var index = -1
	
	for i in range(_items.size()):	
		if _items[i].x == x and _items[i].y == y:
			_items[i].node.queue_free()
			index = i
			break
	
	if index != -1:
		_items.remove(index)

func add_character(character:Character) -> void:
	_characters.append(character)
	entities_container.add_child(character)  

func remove_character_by_id(char_id:int) -> void:
	var character = find_character(char_id)
	if character:
		_characters.erase(character)
		character.destroy()
		
func move_character_by_heading(char_id:int, heading:int) -> void:
	var character = find_character(char_id)
	
	if character:
		character.move_to_heading(heading)
		
		var x = character.grid_position_x
		var y = character.grid_position_y
	
		if y < _min_limit_y or y > _max_limit_y or x < _min_limit_x or x > _max_limit_x:
			remove_character_by_id(char_id)
		
func find_character(char_id:int) -> Character:
	for i in _characters:
		if i.guid == char_id:
			return i
	return null


func set_tile_trigger(x:int, y:int, trigger:int) -> void:
	_triggers[x + y * Global.MAP_WIDTH] = trigger
	
func can_walk(x:int, y:int) -> bool:
#Limites del mapa
#    If x < MinXBorder Or x > MaxXBorder Or y < MinYBorder Or y > MaxYBorder Then
#        Exit Function
#    End If

	if _flags[x + y * Global.MAP_WIDTH] & TileFlags.Blocked:
		return false
	
	for character in _characters:
		if character.grid_position_x == x and character.grid_position_y == y:
			return false
			
	#if _flags[x + y *Global.MAP_WIDTH] & TileFlags.Water:
	#	return false
	
	#If UserNavegando <> HayAgua(x, y) Then
	#    Exit Function
	#End If
	
	return true

func hay_agua(x:int, y:int) -> bool:
	return _flags[x + y * Global.MAP_WIDTH] & TileFlags.Water
	
func _get_map_tiles(data:Dictionary) -> Array:
	var tiles = []
	
	for i in data.layer1:
		if i != 0 and !tiles.has(i):
			tiles.append(i)
	
	for i in data.layer2:
		if i.id != 0 and !tiles.has(i.id):
			tiles.append(i.id)

	for i in data.layer3:
		if i.id != 0 and !tiles.has(i.id):
			tiles.append(i.id)
			
	for i in data.layer4:
		if i.id != 0 and !tiles.has(i.id):
			tiles.append(i.id)
			
	return tiles
	
func _gen_tile_set(tiles:Array) -> TileSet:
	var tile_set = TileSet.new()
	
	for tile in tiles:
		if Global.grh_data.has(tile):
			var current_tile = tile
			if Global.grh_data[tile].num_frames > 1:
				current_tile = Global.grh_data[tile].frames[1]
				
			var source_rect = Global.grh_data[current_tile].region
			var texture = load("res://assets/graphics/%d.png" % Global.grh_data[current_tile].file_num)
			
			tile_set.create_tile(tile)
			tile_set.tile_set_region(tile, source_rect)
			tile_set.tile_set_texture(tile, texture) 
				
	return tile_set

func load_map(id:int) -> void:
	var file = File.new()
	var buffer = StreamPeerBuffer.new()
	
	var layer1 = PoolIntArray()
	layer1.resize(Global.MAP_WIDTH * Global.MAP_HEIGHT) 
	layer1.fill(0)
	
	var layer2 = []
	var layer3 = []
	var layer4 = []
		
	file.open("res://assets/maps/Mapa%d.map" % id, File.READ)
	buffer.data_array = file.get_buffer(file.get_len())

	buffer.seek(2 + 255 + 4 + 4 + 8)
	
	var agua_grh :=0
	var temp_layer := 0
	
	for y in range(Global.MAP_HEIGHT):
		for x in range(Global.MAP_WIDTH):
			var flags = buffer.get_u8()
			
			
			if flags & 1:
				_flags[ x + y * Global.MAP_WIDTH] |= TileFlags.Blocked
			
			#set_tile_blocked(x, y, flags & 1)
			
			layer1[x + y * Global.MAP_WIDTH] = buffer.get_16()

			if flags & 2:
				temp_layer = buffer.get_16()
				
				layer2.append({
					x =  x,
					y =  y,
					id =  temp_layer
				})
			else:
				temp_layer = 0
				
			if flags & 4:
				layer3.append({
					x = x,
					y = y,
					id = buffer.get_16()
				})
				
			if flags & 8:
				layer4.append({
					x = x,
					y =  y,
					id = buffer.get_16()
				})
				
			if flags & 16:
				_triggers[x + y * Global.MAP_HEIGHT] = buffer.get_16()
				
				
			agua_grh = layer1[x + y * Global.MAP_WIDTH]
			
			#parche para el agua. muy feo...
			if ((agua_grh >= 1505 && agua_grh <= 1520) or
				(agua_grh >= 5665 && agua_grh <= 5680) or
				(agua_grh >= 13547 && agua_grh <= 13562)) and (temp_layer == 0):
					_flags[x + y * Global.MAP_WIDTH] |= TileFlags.Water
				
	var tiles = _get_map_tiles(
		{
			layer1 = layer1,
			layer2 = layer2,
			layer3 = layer3,
			layer4 = layer4
		}
	)
	var tileset = _gen_tile_set(tiles)

	var floor_layer = find_node("Floor") as TileMap
	floor_layer.tile_set = tileset
	
	var wall_layer = find_node("Wall") as TileMap 
	wall_layer.tile_set = tileset
	
	var from_layer = find_node("Front") as Node2D
	var from_tiles_layer = from_layer.get_node("Tiles") as TileMap
	
	from_tiles_layer.tile_set = tileset 
	
	for y in range(Global.MAP_HEIGHT):
		for x in range(Global.MAP_WIDTH):
			if layer1[x + y * Global.MAP_WIDTH] > 1:
				floor_layer.set_cell(x, y, layer1[x + y * Global.MAP_WIDTH])
				 
	for i in layer2:
		wall_layer.set_cell(i.x, i.y, i.id)
		
	for i in layer3:
		if(i.id > 0):
			var tile_id = i.id
			if(Global.grh_data[tile_id].num_frames > 1):
				tile_id = Global.grh_data[tile_id].frames[1]
			
			var sprite = Sprite.new()
			sprite.region_enabled = true
			sprite.region_rect =  Global.grh_data[tile_id].region
			sprite.texture =  load("res://assets/graphics/%d.png" % Global.grh_data[tile_id].file_num)
			sprite.position = Vector2((i.x * 32) + 16, (i.y * 32) + 32)
			sprite.offset = Vector2(0, -sprite.region_rect.size.y / 2)
			
			$Overlap/Environment.add_child(sprite)
			
	for i in layer4:
		if i.id > 0:
			var tile_id = i.id
			if(Global.grh_data[tile_id].num_frames > 1):
				tile_id = Global.grh_data[tile_id].frames[1]
			
			var region = Global.grh_data[tile_id].region
			if region.size == Vector2(32, 32):
				from_tiles_layer.set_cell(i.x, i.y, tile_id)
			else:
				var sprite = Sprite.new()
				sprite.region_enabled = true 
				sprite.region_rect = region
				sprite.texture = load("res://assets/graphics/%d.png" % Global.grh_data[tile_id].file_num)
				sprite.position = Vector2((i.x * 32) + 16, (i.y * 32) + 32)
				sprite.offset = Vector2(0, -sprite.region_rect.size.y / 2)
				from_layer.add_child(sprite)

