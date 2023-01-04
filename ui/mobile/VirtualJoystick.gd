extends TouchScreenButton

onready var big_circle = $BigCircle
onready var small_circle = $BigCircle/SmallCircle

onready var max_distance = $CollisionShape2D.shape.radius

var touched = false

func _input(event: InputEvent) -> void:
	return
	if event is InputEventScreenTouch:
		var distance = event.position.distance_to(big_circle.global_position)
		if not touched:
			if distance < max_distance:
				touched = true
		else:
			small_circle.position = Vector2(0, 0)
			touched = false

func _process(delta: float) -> void:
	if touched:
		small_circle.global_position = get_global_mouse_position()
		small_circle.position = big_circle.position + (small_circle.position - big_circle.position).clamped(max_distance)

func get_velocity() -> Vector2:
	var joy_velo = Vector2.ZERO
	return joy_velo
	joy_velo.x = small_circle.position.x / max_distance
	joy_velo.y = small_circle.position.y / max_distance
	
	return joy_velo


func _on_VirtualJoystick_pressed() -> void:
	print("pressed")
	
func _on_VirtualJoystick_released() -> void:
	print("release")
