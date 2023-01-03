extends PanelContainer

onready var _spells = find_node("Spells")
var _protocol:GameProtocol
var _stats:PlayerStats

var _spell_index = -1

func initialize(stats:PlayerStats, protocol:GameProtocol) -> void:
	stats.connect("change_spell_slot", self, "_on_change_spell_slot")
	_protocol = protocol
	_stats = stats
	
	for i in stats.spells.size():
		_spells.add_item(stats.spells[i])

func _on_change_spell_slot(slot:int, name:String) -> void:
	_spells.set_item_text(slot, name)


func _on_BtnMoveUp_pressed() -> void:
	if _spell_index <= 0: return
	var new_text = _stats.spells[_spell_index - 1]
	var old_text = _stats.spells[_spell_index]
	
	_stats.set_spell(_spell_index - 1, old_text)
	_stats.set_spell(_spell_index,     new_text)
	
	_protocol.write_move_sell(true,  _spell_index + 1) 
	_spells.select(_spell_index - 1)
	
	_spell_index -= 1
 
func _on_BtnMoveDown_pressed() -> void:
	if _spell_index == Global.MAXHECHI - 1: return
	
	var old_text = _stats.spells[_spell_index]
	var new_text = _stats.spells[_spell_index + 1]
	
	_stats.set_spell(_spell_index + 1, old_text)
	_stats.set_spell(_spell_index,     new_text)
	
	_protocol.write_move_sell(false,  _spell_index + 1)
	_spells.select(_spell_index + 1)
	_spell_index += 1
 
func _on_Spells_item_selected(index: int) -> void:
	_spell_index = index
