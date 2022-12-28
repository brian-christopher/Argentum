extends Node2D
class_name Map 

var _triggers := PoolIntArray()
var _obstacles := PoolByteArray()
var _items := []

onready var entities_container = $Overlap/Entities

func _init() -> void: 
	_triggers.resize(Global.MAP_WIDTH * Global.MAP_HEIGHT)
	_triggers.fill(0)

	_obstacles.resize(Global.MAP_WIDTH * Global.MAP_HEIGHT)
	_obstacles.fill(0) 
	
	
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
	pass

func add_character(character:Character) -> void:
	entities_container.add_child(character)  

func set_tile_blocked(x:int, y:int, value:bool) -> void:
	_obstacles[x + y * Global.MAP_WIDTH] = value

func set_tile_trigger(x:int, y:int, trigger:int) -> void:
	_triggers[x + y * Global.MAP_WIDTH] = trigger
	
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
	
	for y in range(Global.MAP_HEIGHT):
		for x in range(Global.MAP_WIDTH):
			var flags = buffer.get_u8()
			set_tile_blocked(x, y, flags & 1)
			
			layer1[x + y * Global.MAP_WIDTH] = buffer.get_16()
			
			if flags & 2:
				layer2.append({
					x =  x,
					y =  y,
					id =  buffer.get_16()
				})
				
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
