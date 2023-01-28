extends CanvasLayer

onready var spellContainer = find_node("SpellContainerGUI")
onready var inventoryContainer = find_node("InventoryContainerGUI")

onready var _main_panel = find_node("MobileMainPanel") 

var _protocol:GameProtocol
var _player_data:PlayerData


func initialize(player_data:PlayerData, protocol:GameProtocol) -> void:
	_protocol = protocol
	_player_data = player_data
	
	protocol.connect("parse_data", self, "_on_parse_data")
	if !is_inside_tree():
		yield(self, "ready")
	
	_main_panel.initialize(_player_data, protocol)
	
func _on_parse_data(packet_id, data):
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_combat_mode"):
		_protocol.write_combat_mode_toggle()
	
	if event.is_action_pressed("attack"):
		if !_player_data.timers[PlayerData.TimersIndex.Arrows].check(false): return
		
		if !_player_data.timers[PlayerData.TimersIndex.CastSpell].check(false):
			if !_player_data.timers[PlayerData.TimersIndex.CastAttack].check(): return
		else:
			if !_player_data.timers[PlayerData.TimersIndex.Attack].check(): return
			
				
		_protocol.write_attack()
	
	if event.is_action_pressed("pickup"):
		_protocol.write_pick_up() 
	
	if event.is_action_pressed("hide"):
		_protocol.write_work(Global.eSkill.Ocultarse) 
	
	if event.is_action_pressed("use_object"):
		if inventoryContainer.selected_slot:
			if _player_data.timers[PlayerData.TimersIndex.UseItemWithU].check():
				_protocol.write_use_item(inventoryContainer.selected_slot.slot_index + 1)
			 
	if event.is_action_pressed("exit_game"):
		_protocol.write_quit() 
		
	if event.is_action_pressed("request_refresh"):
		if _player_data.check_timer(PlayerData.TimersIndex.SendRPU): 
			_protocol.write_request_position_update()
		
func _on_TouchScreenButton_pressed() -> void:
	print("pressed")
