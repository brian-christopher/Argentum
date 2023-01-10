extends CanvasLayer


onready var spellContainer = find_node("SpellContainerGUI")
onready var inventoryContainer = find_node("InventoryContainerGUI")
onready var send_txt = find_node("SendTxt")

var _protocol:GameProtocol

func _ready() -> void:
	send_txt.visible = false

func initialize(player_data:PlayerData, protocol:GameProtocol) -> void:
	_protocol = protocol
	
	spellContainer.initialize(player_data, protocol)
	inventoryContainer.initialize(player_data.inventory, protocol)
	
	protocol.connect("parse_data", self, "_on_parse_data")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			match event.scancode: 
				KEY_ENTER:
					send_txt.visible = !send_txt.visible
					send_txt.grab_focus()
	
	if event.is_action_pressed("toggle_combat_mode"):
		_protocol.write_combat_mode_toggle()
	
	if event.is_action_pressed("attack"):
		_protocol.write_attack()
	
	if event.is_action_pressed("pickup"):
		_protocol.write_pick_up() 
	
	if event.is_action_pressed("hide"):
		_protocol.write_work(Global.eSkill.Ocultarse) 
	
	if event.is_action_pressed("use_object"):
		if inventoryContainer.selected_slot:
			_protocol.write_use_item(inventoryContainer.selected_slot.slot_index + 1)
			 
	if event.is_action_pressed("exit_game"):
		_protocol.write_quit() 
			
func _on_parse_data(packetId:int, data) -> void:
	if packetId == GameProtocol.ServerPacketID.ConsoleMsg:
		$Console.text += "\n" + data.message


func _on_SendTxt_text_entered(new_text: String) -> void:
	if new_text.length() > 0:
		_protocol.write_talk(new_text)
	
	send_txt.visible = false
	send_txt.text = ""
