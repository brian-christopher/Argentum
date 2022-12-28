extends Area2D
class_name Character

onready var char_name = $Name
 
#identificador unico que el serve asigna al char
var guid := 0

var is_moving := false

var grid_position_x := 0
var grid_position_y := 0

func _ready() -> void:
	pass # Replace with function body. 
	
func set_grid_positioon(x:int, y:int) -> void:
	var offset = Vector2(16, 32)
	
	grid_position_x = x 
	grid_position_y = y  
	
	position.x = grid_position_x * Global.TILE_SIZE
	position.y = grid_position_y * Global.TILE_SIZE
	
	position += offset
	 
func set_character_name(name:String) -> void:
	if(! is_inside_tree()):
		yield(self, "ready")
	
	char_name.text = name	

func destroy():
	queue_free()
