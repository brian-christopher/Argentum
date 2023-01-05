extends Area2D
class_name Character

onready var char_name = $Name

onready var _body_sprite = find_node("Body")
onready var _head_sprite = find_node("Head")
onready var _helmet_sprite = find_node("Helmet")
onready var _weapon_sprite = find_node("Weapon")
onready var _shield_sprite = find_node("Shield")

const FXS_SCENE = preload("res://entities/effects/Fxs.tscn")
 
#identificador unico que el serve asigna al char
var guid := 0

var is_moving := false setget set_is_moving
var heading:int =  Global.Heading.Down setget set_heading
var speed := 130

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
	self.is_moving = false
	
func set_is_moving(value:bool) -> void:
	is_moving = value
	
	var method = "play"
	if !is_moving:
		method = "stop"
		
	for node in get_node("Outfit").get_children():
		if node.has_method(method):
			node.call(method)
	
func set_character_name(name:String) -> void:
	if(! is_inside_tree()):
		yield(self, "ready")
	
	char_name.text = name	

func destroy():
	queue_free()

func move_to_heading(heading:int) -> void:
	if is_moving:
		position = _target_position
		self.is_moving = false
	
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
	self.is_moving = true
	self.heading = heading

func _process(delta: float) -> void:
	_process_movement(delta) 
	_process_animation()
	
func _process_animation() -> void:
	var state = "walk" if is_moving else "idle"
	var direction = "down"
	
	match heading:
		Global.Heading.Up:
			direction = "up"
		Global.Heading.Left:
			direction = "left"
		Global.Heading.Right:
			direction = "right"
			
	play_animation(state + "_" + direction)
	
func _process_movement(delta:float) -> void:
	if !is_moving: return
	
	position = position.move_toward(_target_position, delta * speed)
	if position == _target_position:
		self.is_moving = false
	  
func set_heading(p_heading:int) -> void:
	heading = p_heading

func set_weapon(id:int) -> void:
	weapon = id
	_set_animation(_weapon_sprite, "res://resources/weapons/weapon_%d.tres" % id)

func set_shield(id:int) -> void:
	shield = id
	_set_animation(_shield_sprite, "res://resources/shields/shield_%d.tres" % id)
	
func set_body(id:int) -> void:
	body = id
	_set_animation(_body_sprite, "res://resources/bodies/bodie_%d.tres" % id, true)
	
func set_head(id:int) -> void:
	head = id
	_set_animation(_head_sprite, "res://resources/heads/head_%d.tres" % id)
  
func set_helmet(id:int) -> void: 
	helmet = id
	_set_animation(_helmet_sprite, "res://resources/helmets/helmet_%d.tres" % id)
  
func _set_animation(node:AnimatedSprite, resource_path:String, is_body:bool = false):
	if !ResourceLoader.exists(resource_path):
		node.visible = false
	else:
		var resource = load(resource_path)
		
		node.visible = true
		node.frames = resource.animation
		
		var texture = resource.animation.get_frame("idle_down", 0)
		node.offset.y = -texture.get_height() / 2
		
		if is_body:
			_head_sprite.position.y = (resource.head_offset_y) 
			_helmet_sprite.position.y = (resource.head_offset_y) 
			

func talk(message:String, color:Color = Color.white) -> void:
	$Dialog.text = message
	$Dialog.self_modulate = color
	
	$RemoveDialog.start()

func _on_RemoveDialog_timeout() -> void:
	$Dialog.text = ""

func add_effect(effectId:int, loops:int) -> void:
	var resource = load("res://resources/fxs/effect_%d.tres" % effectId) as SpriteFrames
	if !resource:
		return
	
	var texture = resource.get_frame("default", 1)
	var offset_y = texture.get_height() / 2
	
	if resource:
		var fx = FXS_SCENE.instance()
		$Effects.add_child(fx)
		
		if texture.get_width() != 128:
			fx.position.y -= offset_y
		else:
			fx.position.y -= 16
			 
		fx.intialize(resource)	
	
func play_animation(animation_name:String) -> void:	
	if _body_sprite.frames:
		_body_sprite.play(animation_name)
	
	if _weapon_sprite.frames:
		_weapon_sprite.play(animation_name)
	
	if _shield_sprite.frames:
		_shield_sprite.play(animation_name)
	
	if _head_sprite.frames:
		_head_sprite.play(animation_name.replace("walk", "idle"))
	
	if _helmet_sprite.frames:
		_helmet_sprite.play(animation_name.replace("walk", "idle"))
	
		
