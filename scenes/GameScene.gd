extends Node
  
export(PackedScene) var character_scene

onready var _main_camera = find_node("MainCamera")
onready var _map_container = find_node("MapContainer")
 
onready var _fpsLabel = find_node("FPSLabel") 
onready var _virtualJoystick = find_node("VirtualJoystick")


 
var _protocol:GameProtocol 
var _player_data:PlayerData
  
var _main_character_id := 0

var input_map = {
	"move_left"  : Global.Heading.Left,
	"move_right" : Global.Heading.Right,
	"move_up"    : Global.Heading.Up,
	"move_down"  : Global.Heading.Down,
}
 
onready var _server_packet_names:Array = GameProtocol.ServerPacketID.keys()

func initiaze(protocol:GameProtocol):
	_protocol = protocol
	_player_data = PlayerData.new(Global.MAX_INVENTORY_SLOTS) 
	
	protocol.connect("parse_data", self, "_on_parse_data")
	Connection.connect("disconnected", self, "_on_disconnected")  
	 
		 
func _ready():  
	var ui = find_node("UI")
	ui.initialize(_player_data, _protocol)

func _on_disconnected():
	var scene = load("res://scenes/LobbyScene.tscn").instance()
	scene._protocol = _protocol
	get_parent().switch_scene(scene)
	
func _on_parse_data(packet_id:int, data):
	match packet_id:
		#ignorar
		GameProtocol.ServerPacketID.Logged:
			pass
		GameProtocol.ServerPacketID.RemoveDialogs:
			pass
		GameProtocol.ServerPacketID.UserIndexInServer:
			pass
			
		GameProtocol.ServerPacketID.Disconnect:
			_on_disconnected()
			
		GameProtocol.ServerPacketID.ChangeSpellSlot:
			_parse_change_spell_slot(data)
		GameProtocol.ServerPacketID.ChangeInventorySlot:
			_parse_change_inventory_slot(data)
		
		GameProtocol.ServerPacketID.ChangeMap:
			_change_map(data)
			
		GameProtocol.ServerPacketID.UpdateGold:
			_parse_update_gold(data)
			
		GameProtocol.ServerPacketID.UpdateHP:
			_player_data.stats.hp = data
			
		GameProtocol.ServerPacketID.UpdateSta:
			_player_data.stats.sta = data
		
		GameProtocol.ServerPacketID.UpdateUserStats:
			_parse_update_player_stats(data)
		GameProtocol.ServerPacketID.CharacterCreate:
			_parse_create_character(data)
		GameProtocol.ServerPacketID.CharacterRemove:
			_parse_character_remove(data)
		GameProtocol.ServerPacketID.UserCharIndexInServer:
			_parse_user_char_index_in_server(data)
		GameProtocol.ServerPacketID.PosUpdate:
			_parse_pos_update(data)
		GameProtocol.ServerPacketID.ObjectCreate:
			_parse_object_create(data)
		GameProtocol.ServerPacketID.AreaChanged:
			_parse_area_changed(data)
		GameProtocol.ServerPacketID.CharacterMove:
			_parse_character_move(data)
		GameProtocol.ServerPacketID.ObjectDelete:
			_parse_object_delete(data)
		GameProtocol.ServerPacketID.CharacterChange:
			_parse_character_change(data)
		GameProtocol.ServerPacketID.BlockPosition:
			_parse_block_position(data)
		GameProtocol.ServerPacketID.PlayMidi:
			_parse_play_midi(data)
		GameProtocol.ServerPacketID.PlayWave:
			_parse_play_wave(data)
		GameProtocol.ServerPacketID.ChatOverHead:
			_parse_chat_over_head(data)
		GameProtocol.ServerPacketID.RemoveCharDialog:
			_parse_remove_char_dialog(data)
		GameProtocol.ServerPacketID.UpdateHungerAndThirst:
			_parse_update_hunger_anb_thirst(data)
		GameProtocol.ServerPacketID.CreateFX:
			_parse_create_fx(data)
		GameProtocol.ServerPacketID.UpdateTagAndStatus:
			_parse_update_tag_and_status(data)
		GameProtocol.ServerPacketID.SetInvisible:
			_parse_set_invisible(data)
		GameProtocol.ServerPacketID.WorkRequestTarget:
			_parse_work_request_target(data)  
		
 
		_:
			print(_server_packet_names[packet_id])

func _parse_work_request_target(skill:int) -> void:
	_player_data.using_skill = skill
	Input.set_default_cursor_shape(Input.CURSOR_CROSS) 
	
func _parse_set_invisible(data:Dictionary) -> void:
	if !_map_container.current_map: return
	var map = _map_container.current_map
	var character = map.find_character(data.char_id)
	
	if character:
		character.invisible = data.invisible

func _parse_update_tag_and_status(data:Dictionary) -> void:
	if !_map_container.current_map: return
	var map = _map_container.current_map
	var character = map.find_character(data.char_id)
	
	if character:
		character.criminal = data.criminal
		character.set_character_name(data.userTag) 

func _parse_update_gold(value:int) -> void:
	_player_data.stats.gold = value

func _parse_update_hunger_anb_thirst(data:Dictionary) -> void:
	_player_data.stats.max_sed = data.max_agua
	_player_data.stats.sed = data.min_agua
	_player_data.stats.ham = data.min_ham 
	_player_data.stats.max_ham = data.max_ham 
			
func _parse_change_inventory_slot(data:Dictionary) -> void:
	var item = Item.new()
	item.name = data.name
	item.min_hit = data.min_hit
	item.max_hit = data.max_hit
	item.defense = data.defense
	item.value   = data.value
	item.type    = data.obj_type
	
	if data.grh_index:
		var texture_id = Global.grh_data[data.grh_index].file_num
		item.texture = Global.load_texture_from_id(texture_id) 

	_player_data.inventory.set_item_stack(data.slot - 1, item, data.amount, data.equipped)
			
func _parse_create_fx(data:Dictionary) -> void:
	if !_map_container.current_map: return
	var map = _map_container.current_map
	
	var character = map.find_character(data.char_id)
	if character:
		character.add_effect(data.fx, data.fx_loop)
			
func _parse_change_spell_slot(data:Dictionary) -> void:
	_player_data.stats.set_spell(data.slot - 1, data.spell_name)
			
func _parse_chat_over_head(data:Dictionary) -> void:
	if !_map_container.current_map: return
	
	var character = _map_container.current_map.find_character(data.char_id)
	if character:
		character.talk(data.message, data.color)
		
func _parse_remove_char_dialog(char_id:int) -> void:
	if !_map_container.current_map: return
	
	var character = _map_container.current_map.find_character(char_id)
	if character:
		character.talk("")
	
func _parse_play_wave(data:Dictionary) -> void:
	AudioManager.play_sfx2d_from_id(data.wave, data.x, data.y)

func _parse_play_midi(data:Dictionary) -> void:
	AudioManager.play_music_from_id(data.midi, data.loops)

func _parse_block_position(data:Dictionary) -> void:
	var x = data.x - 1
	var y = data.y - 1
	
	if _map_container.current_map:
		_map_container.current_map.set_tile_block(x, y, data.value)
		 
func _parse_update_player_stats(stats:Dictionary) -> void:
	_player_data.stats.hp = stats.min_hp
	_player_data.stats.max_hp = stats.max_hp
	
	_player_data.stats.mp = stats.min_mp
	_player_data.stats.max_mp = stats.max_hp

	_player_data.stats.sta = stats.min_sta
	_player_data.stats.max_sta = stats.max_sta
	
	_player_data.stats.gold = stats.gold
	_player_data.stats.level = stats.lvl
	_player_data.stats.elu = stats.elu
	_player_data.stats.elv = stats.u_lvl
	
func _parse_create_character(data:Dictionary) -> void:
	var character = character_scene.instance() as Character
	character.guid = data.char_id
	
	if _map_container.current_map:
		_map_container.current_map.add_character(character)
	
	character.set_grid_positioon(data.x - 1, data.y - 1)
	character.set_character_name(data.name)
	
	character.heading = data.heading
	character.weapon = data.weapon
	character.shield = data.shield
	character.body = data.body
	character.head = data.head
	character.helmet = data.helmet
	character.privs = data.privs
	character.criminal = data.criminal

func _parse_character_change(data:Dictionary) -> void:
	if _map_container.current_map:
		var character = _map_container.current_map.find_character(data.char_id) as Character
		if character:
			character.heading = data.heading
			character.body = data.body
			character.head = data.head
			character.weapon = data.weapon
			character.shield = data.shield
			character.helmet = data.helmet

func _change_map(data:Dictionary) -> void:
	_map_container.set_main_character_id(_main_character_id)
	_map_container.switch_map(data.map_id)

func _parse_character_remove(char_id:int) -> void:
	if _map_container.current_map:
		_map_container.current_map.remove_character_by_id(char_id)
	
func _parse_user_char_index_in_server(char_id:int) -> void:
	_main_character_id = char_id
	_map_container.set_main_character_id(_main_character_id)
		
func _parse_object_create(data:Dictionary) -> void:
	if !_map_container.current_map: return
	
	_map_container.current_map.add_item(data.x - 1, data.y - 1, data.grh_index)
	
func _parse_pos_update(data:Dictionary) -> void:
	if _map_container.current_map:
		var main_character = _map_container.current_map.find_character(_main_character_id)
		 
		if main_character:
			main_character.set_grid_positioon(data.x -1 , data.y - 1)
		
func _parse_area_changed(data:Dictionary) -> void:
	if !_map_container.current_map: return
	
	_map_container.current_map.area_changed(data.x, data.y)
	
func _parse_character_move(data:Dictionary) -> void:
	if !_map_container.current_map: return
	
	var character = _map_container.current_map.find_character(data.char_id)
	if character:
		var x = (data.x) - (character.grid_position_x + 1)
		var y = (data.y) - (character.grid_position_y + 1)
		
		var heading = Global.Heading.Down
		
		if(sign(x) == 1):
			heading = Global.Heading.Right
		
		if(sign(x) == -1):
			heading = Global.Heading.Left
		
		if(sign(y) == 1):
			heading = Global.Heading.Down
		
		if(sign(y) == -1):
			heading = Global.Heading.Up
 
		_map_container.current_map.move_character_by_heading(data.char_id, heading, Vector2(data.x, data.y))

func _parse_object_delete(data:Dictionary) -> void:
	if _map_container.current_map:
		_map_container.current_map.remove_item(data.x - 1, data.y - 1)
		
func _update_info() -> void:
	_fpsLabel.text = "FPS: %d" % Engine.get_frames_per_second() 
 
func _process_movement() -> void: 
	var heading = get_input_heading()
	
	if heading == 0: return
	if !_map_container.current_map: return
	
	var map = _map_container.current_map
	var main_char = map.find_character(_main_character_id)
	
	if main_char and !main_char.is_moving:
		var offset = Global.heading_to_vector(heading)
		var new_position_x = main_char.grid_position_x + offset.x
		var new_position_y = main_char.grid_position_y + offset.y
		
		if map.can_walk(new_position_x, new_position_y):
			main_char.move_to_heading(heading)
			_protocol.write_walk(heading) 
		else:
			if heading != main_char.heading:
				main_char.heading = heading
				_protocol.write_change_heading(heading)
		
func _process(delta: float) -> void:
	_update_info()
	_process_movement()
	_camera_follow_character()
  
	_protocol.flush_data()
	
func _camera_follow_character() -> void:
	if !_map_container.current_map: return
	
	var main_character = _map_container.current_map.find_character(_main_character_id)
	if main_character:
		_main_camera.position = main_character.position

func _get_movement_heading(velocity:Vector2) -> int:
	match velocity:
		Vector2.LEFT:
			return Global.Heading.Left
		Vector2.UP:
			return Global.Heading.Up
		Vector2.DOWN:
			return Global.Heading.Down
		Vector2.RIGHT:
			return Global.Heading.Right	
		Vector2(1, 1):
			return Global.Heading.Right
		Vector2(-1, -1):
			return Global.Heading.Left
		Vector2(1, -1):
			return Global.Heading.Right
		Vector2(-1, 1):
			return Global.Heading.Left
			
	return 0
	
func get_input_heading() -> int:
	return _get_movement_heading(_virtualJoystick.velocity)
	
	var input = 0
	
	for i in input_map:
		if Input.is_action_pressed(i):
			input = input_map[i]
	return input

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var viewport = get_viewport()
		var mouse_position = (get_viewport().canvas_transform.xform_inv(event.position) / 32).ceil() as Vector2
		if event.doubleclick:
			_protocol.write_double_click(mouse_position.x, mouse_position.y)
			Input.set_default_cursor_shape(Input.CURSOR_ARROW) 
			_player_data.using_skill = 0	
			return 
		
		if _player_data.using_skill != 0 : 
			
			if _player_data.using_skill == Global.eSkill.Magia:
				_protocol.write_work_left_click(mouse_position.x, mouse_position.y, _player_data.using_skill)
			 
			Input.set_default_cursor_shape(Input.CURSOR_ARROW) 
			_player_data.using_skill = 0	
		else:
			pass 
