extends Sprite

var _animations:Dictionary
var _heading = Global.Heading.Down

var offset_x := 0
var offset_y := 0

var _started:bool = false 
var _current_animation_id = "down"
var _current_frame = 0
var _current_time = 0
var _frames := Dictionary()
var _frame_time = 0

class FrameKey:
	var frames = []
	var speed = 0
		
	func _init(grh_id:int) -> void:
		if grh_id == 0 or grh_id > Global.grh_data.size():
			return
			
		var frame_count = Global.grh_data[grh_id].frames.size()
		var array = Global.grh_data[grh_id].frames
		
		for i in range(1, frame_count):
			frames.append(Global.grh_data[grh_id].frames[i])
			
		speed = Global.grh_data[grh_id].speed
		 
	func size() -> int:
		return frames.size()
	
	func get_frame(id) -> Rect2:
		if frames.size() == 0: return Rect2()
		return Global.grh_data[frames[id]].region 
		
	func get_texture(frame_id) -> Texture:
		if frames.size() == 0: return null
		
		var texture = load("res://assets/graphics/%d.png" % Global.grh_data[frames[frame_id]].file_num) 
		return texture 
		
func initalize(data:Dictionary) -> void:
	_animations = data
	
	_frames.left = FrameKey.new(data.left)
	_frames.right = FrameKey.new(data.right)
	_frames.up = FrameKey.new(data.up)
	_frames.down = FrameKey.new(data.down) 
	
	_update_animation()
	_frame_time = 0.05 #frames[_current_animation_id].speed
	#tiempo para que cambie al otro frame 
	
	
func set_heading(heading:int) -> void:
	if _heading == heading: return 
	_heading = heading
	
	match _heading:
		Global.Heading.Down:
			_current_animation_id = "down"
		Global.Heading.Left:
			_current_animation_id = "left"
		Global.Heading.Right:
			_current_animation_id = "right"
		Global.Heading.Up:
			_current_animation_id = "up" 
				
	_update_animation()
  
func play() -> void:
	_started = true
	
func stop() -> void:
	_started = false
	_current_frame = 0
	_update_animation()

func _process(delta: float) -> void:
	if !_started: return
	if _frames.size() == 0: return
	if _frames[_current_animation_id].size() == 0: return
	
	_current_time += 0.02
	if(_current_time >= _frame_time):
		_current_time = 0
		_current_frame = (_current_frame + 1) % _frames[_current_animation_id].size() 
		_update_animation()
	
	
func _update_animation():
	if _frames.size() > 0:
		texture = _frames[_current_animation_id].get_texture(_current_frame)
		region_rect = _frames[_current_animation_id].get_frame(_current_frame) 
		
		position.y = offset_y - (region_rect.size.y / 2)
	
