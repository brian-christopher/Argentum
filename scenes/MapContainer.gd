extends Node2D


var _main_character_id := 0
var current_map:Map = null

func _ready() -> void:
	pass # Replace with function body.


func set_main_character_id(id:int) -> void:
	_main_character_id = id
	
	if current_map:
		current_map.set_main_character_id(id)

func switch_map(id:int) -> void:
	if current_map:
		current_map.queue_free()
		current_map = null
		
	current_map = load("res://engine/Map.tscn").instance()
	add_child(current_map)
	
	current_map.load_map(id)
	current_map.set_main_character_id(_main_character_id) 
