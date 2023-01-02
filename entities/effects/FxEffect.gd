extends Node2D

var _loops = -1
var _fx_id = 0
var _offset_y = 0
var _frames = []

var _current_frame = 0

func initialize(fx_id:int, loops:int) -> void:
	if fx_id <= 0 or fx_id > Global.fxs_data.size():
		queue_free()
		return
	 
	var data = Global.fxs_data[fx_id]
	_offset_y = data.offsetY
	_loops = loops

	for i in Global.grh_data[data.id].frames:
		if i != 0:
			_frames.append(i)
	 
	var grh_id = _frames[0]  
	var region = Global.grh_data[grh_id].region

	$Sprite.position.y = _offset_y - (region.size.y / 2)
	$Sprite.region_rect = region
	$Sprite.texture = load("res://assets/graphics/%d.png" % Global.grh_data[grh_id].file_num)

func _process(delta: float) -> void:
	pass
	
func _update_frame():
	pass
