extends Reference
class_name TickTimer

signal restart_tick

var current_tick := 0
var start_tick := 0
var interval := 0

func check(restart:bool = true) -> bool:
	var now = Time.get_ticks_msec()
	var retval = false
	current_tick = now - start_tick
	
	if current_tick >= interval:
		retval = true
		if restart:
			restart() 
			emit_signal("restart_tick")
	return retval

func restart():
	start_tick = Time.get_ticks_msec()  
