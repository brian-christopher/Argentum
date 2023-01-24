extends HBoxContainer

signal pressed_previus
signal pressed_next
 
onready var _label = find_node("Label")

func set_text(new_text:String) -> void:
	if !is_inside_tree():
		yield(self, "ready")
		
	_label.text = new_text
	
func _on_BtnPrev_pressed() -> void:
	emit_signal("pressed_previus")

func _on_BtnNext_pressed() -> void:
	emit_signal("pressed_next")
