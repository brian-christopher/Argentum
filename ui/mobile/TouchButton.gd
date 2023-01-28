extends Button
 
 
func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and OS.get_name() == "Android":
			emit_signal("pressed")
