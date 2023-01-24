extends TouchScreenButton

onready var big_circle = $BigCircle
onready var small_circle = $BigCircle/SmallCircle

var velocity = Vector2.ZERO 
var _touched = false
 
func _process(_delta: float) -> void:
	if _touched:
		var offset = _get_texture_size() / 2
		var center = position + offset
		velocity = center.direction_to(get_global_mouse_position()).round() 
	else:
		velocity = Vector2.ZERO
		
func _get_texture_size() -> Vector2:
	if normal: return normal.get_size()
	return Vector2.ZERO

func _on_VirtualJoystick_pressed() -> void:
	_touched = true
	
func _on_VirtualJoystick_released() -> void:
	_touched = false 
