extends Node
  
export(PackedScene) var character_scene

onready var _main_camera = $MainCamera
var _protocol:GameProtocol
var _player_stats:PlayerStats
var _current_map:Map

var _characters = []
var _main_character:Character = null

onready var _server_packet_names:Array = GameProtocol.ServerPacketID.keys()

func initiaze(protocol:GameProtocol):
	_protocol = protocol
	_player_stats = PlayerStats.new()
	
	protocol.connect("parse_data", self, "_on_parse_data")
	Connection.connect("disconnected", self, "_on_disconnected")
	
 
func _ready():
	pass # Replace with function body.
	
func _on_disconnected():
	var scene = load("res://scenes/LobbyScene.tscn").instance()
	scene._protocol = _protocol
	
	get_parent().switch_scene(scene) 
	
func _on_parse_data(packet_id:int, data): 
	match packet_id:
		#ignorar
		GameProtocol.ServerPacketID.Logged:
			pass 
		
		GameProtocol.ServerPacketID.ChangeMap:
			_change_map(data)
		
		GameProtocol.ServerPacketID.UpdateUserStats:
			_update_player_stats(data)
		GameProtocol.ServerPacketID.CharacterCreate:
			_create_character(data) 
		GameProtocol.ServerPacketID.CharacterRemove: 
			_parse_character_remove(data) 	
		GameProtocol.ServerPacketID.UserCharIndexInServer:
			_parse_user_char_index_in_server(data)
			
		GameProtocol.ServerPacketID.ObjectCreate:
			_parse_object_create(data)
		_:
			print(_server_packet_names[packet_id])
		
		 
func _update_player_stats(stats:Dictionary) -> void:
	_player_stats.hp = stats.max_hp
	_player_stats.max_hp = stats.min_hp 
	
	_player_stats.mp = stats.max_mp
	_player_stats.max_mp = stats.min_mp 

	_player_stats.sta = stats.max_sta
	_player_stats.max_sta = stats.min_sta 
	
	_player_stats.gold = stats.gold
	_player_stats.level = stats.lvl 
	_player_stats.elu = stats.elu
	_player_stats.elv = stats.u_lvl   
	
func _create_character(data:Dictionary) -> void:
	var character = character_scene.instance() as Character
	character.guid = data.char_id
	
	character.set_grid_positioon(data.x - 1, data.y - 1)
	character.set_character_name(data.name)
	
	_characters.append(character)
	if _current_map:	
		_current_map.add_character(character)
	
func _change_map(data:Dictionary) -> void:
	if _current_map:
		_current_map.queue_free()
		_current_map = null
	
	_current_map = load("res://engine/Map.tscn").instance()
	add_child(_current_map) 
	_current_map.load_map(data.map_id) 
	
func _parse_character_remove(char_id:int) -> void:
	var character = find_character_by_id(char_id)
	
	if character:
		_characters.erase(character)
		character.destroy()
	
func _parse_user_char_index_in_server(char_id:int) -> void:
	_main_character = find_character_by_id(char_id)
		
func _parse_object_create(data:Dictionary) -> void:
	if !_current_map: return
	
	_current_map.add_item(data.x - 1, data.y - 1, data.grh_index)
	
func find_character_by_id(char_id:int) -> Character:
	for i in _characters:
		if i.guid == char_id:
			return i
	return null

func _process(delta: float) -> void:
	_follow_character(delta)
	
func _follow_character(_delta:float) -> void:
	if(!_main_character): return
	
	_main_camera.position = _main_character.position

