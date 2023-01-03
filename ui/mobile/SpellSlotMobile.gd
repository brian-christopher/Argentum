extends PanelContainer

var slot_index = -1
var spell_name = "" setget _set_spell_name

func _set_spell_name(spell_name:String) -> void:
	if !is_inside_tree():
		yield(self, "ready")
		
	$NameLabel.text = spell_name
