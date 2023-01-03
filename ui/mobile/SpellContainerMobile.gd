extends HBoxContainer

onready var _container = find_node("GridContainer") 

const SPELL_SLOT_SCENE = preload("res://ui/mobile/SpellSlotMobile.tscn")

var _stats:PlayerStats
var _protocol:GameProtocol

func intialize(stats:PlayerStats, protocol:GameProtocol) -> void:
	_stats = stats
	_protocol = protocol
	
	_stats.connect("change_spell_slot", self, "_on_change_spell_slot")
	
	for i in range(Global.MAXHECHI -1, -1, -1):
		var slot = SPELL_SLOT_SCENE.instance()
		slot.slot_index = i
		_container.add_child(slot)
	
func _on_change_spell_slot(slot:int, spell_name:String):
	for spell_slot in _container.get_children():
		if spell_slot.slot_index == slot:
			spell_slot.spell_name = spell_name
			break
			
