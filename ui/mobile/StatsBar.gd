tool
extends Control

var _bar_width = 0 

var value:int = 1 setget set_value
var max_value:int = 1 setget set_max_value 
	
func _ready() -> void: 
	_bar_width = $Color.rect_size.x 
	
func set_value(v:int) -> void:
	value = v
	_update_info() 

func set_max_value(v:int) -> void:
	max_value = v
	_update_info()
	
func _update_info():
	$Info.text = "%d/%d" % [value, max_value] 
	if max_value != 0:
		$Color.rect_size.x = (value / max_value) * _bar_width
