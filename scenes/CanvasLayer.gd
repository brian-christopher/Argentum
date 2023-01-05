extends CanvasLayer


onready var spellContainer = find_node("SpellContainerGUI")

func initialize(stats:PlayerStats, inventory:Inventory, protocol:GameProtocol) -> void:
	spellContainer.initialize(stats, protocol)
	
	protocol.connect("parse_data", self, "_on_parse_data")

func _unhandled_input(event: InputEvent) -> void:
	return
	if event is InputEventMouseButton:
		if event.pressed:
			var position = get_parent().get_node("MainCamera").get_global_mouse_position()
			position = (position.round() / 32.0).floor()
			position += Vector2(1, 1)
			
			#get_parent()._protocol.write_double_click(position.x, position.y)
			#print(position)
func _on_parse_data(packetId:int, data) -> void:
	if packetId == GameProtocol.ServerPacketID.ConsoleMsg:
		$Console.text += "\n" + data.message
