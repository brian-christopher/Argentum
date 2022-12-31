extends Area2D
class_name Character

onready var char_name = $Name
 
#identificador unico que el serve asigna al char
var guid := 0

var is_moving := false
var heading:int =  Global.Heading.Down
var speed := 150

var grid_position_x := 0
var grid_position_y := 0

var criminal := 0
var privs := 0

var _target_position := Vector2.ZERO

var body := 0 setget set_body
var head := 0 setget set_head
var helmet := 0 setget set_helmet
var weapon := 0 setget set_weapon
var shield := 0 setget set_shield

func _ready() -> void:
	pass # Replace with function body. 
	
func set_grid_positioon(x:int, y:int) -> void:
	var offset = Vector2(16, 32)
	
	grid_position_x = x 
	grid_position_y = y  
	
	position.x = grid_position_x * Global.TILE_SIZE
	position.y = grid_position_y * Global.TILE_SIZE
	
	position += offset
	is_moving = false
	 
func set_character_name(name:String) -> void:
	if(! is_inside_tree()):
		yield(self, "ready")
	
	char_name.text = name	

func destroy():
	queue_free()

func move_to_heading(heading:int) -> void:
	if is_moving:
		position = _target_position
		is_moving = false
	
	var direction = Vector2.ZERO
	
	match heading:
		Global.Heading.Down:
			direction = Vector2.DOWN
		Global.Heading.Up:
			direction = Vector2.UP
		Global.Heading.Left:
			direction = Vector2.LEFT
		Global.Heading.Right:
			direction = Vector2.RIGHT
			
		
	grid_position_x += Global.heading_to_vector(heading).x
	grid_position_y += Global.heading_to_vector(heading).y
		
	_target_position = position + (direction * 32.0)
	is_moving = true

func _process(delta: float) -> void:
	_process_movement(delta)
	
func _process_movement(delta:float) -> void:
	if !is_moving: return
	
	position = position.move_toward(_target_position, delta * speed)
	if position == _target_position:
		is_moving = false

func set_weapon(id:int) -> void:
	if id == 0 or id == Global.NO_ANIMAR:
		$Outfit/Weapon.visible = false

func set_shield(id:int) -> void:
	if id == 0 or id == Global.NO_ANIMAR:
		$Outfit/Shield.visible = false
 
func set_body(id:int) -> void:
	if id == 0 or id == Global.NO_ANIMAR:
		$Outfit/Body.visible = false

func set_head(id:int) -> void:
	if id == 0 or id == Global.NO_ANIMAR:
		$Outfit/Head.visible = false
		
func set_helmet(id:int) -> void:
	if id == 0 or id == Global.NO_ANIMAR:
		$Outfit/Helmet.visible = false
