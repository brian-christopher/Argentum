extends Node

onready var _music_stream:AudioStreamPlayer

func _ready() -> void:
	_music_stream = AudioStreamPlayer.new()
	_music_stream.bus = "music"
	
	add_child(_music_stream)
	 
func play_sfx2d_from_id(id:int, x:int, y:int) -> void:
	var audi_resource = load("res://assets/sounds/%d.wav" % id)
	if !audi_resource: return
	
	var audio_stream = AudioStreamPlayer.new()
	
	audio_stream.bus = "sfx"
	audio_stream.stream = audi_resource
	audio_stream.play()
	
	add_child(audio_stream)
	yield(audio_stream, "finished")
	audio_stream.queue_free()
	 
func play_music_from_id(id:int, loops:int = -1) -> void:
	var audio_resource = load("res://assets/music/%d.mp3" % id)  
	if !audio_resource:
		return

	_music_stream.stream = audio_resource
	_music_stream.play() 
