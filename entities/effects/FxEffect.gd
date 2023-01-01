extends Node2D

var _loops = -1
var _fx_id = 0
var _offset_y = 0
var _frames = []

var _current_frame = 0

func _initialize(fx_id:int, loops:int) -> void:
	if fx_id <= 0 or fx_id > Global.grh_data.size():
		queue_free()
		return
 
	_frames = Global.fxs_data[fx_id]
	_offset_y = Global.fxs_data[fx_id].offsetY 
	_loops = loops
	
	if _frames.size() == 0:
		queue_free()
		return
	
	var grh_id = _frames[0]
	var region = Global.grh_data[grh_id]

	$Sprite.position.y = _offset_y - (region.size.y / 2)

func _process(delta: float) -> void:
	pass
	
func _update_frame():
	pass
