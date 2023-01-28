extends Node

export(PackedScene) var initial_scene  

var current_scene:Node = null
var _protocol:GameProtocol = null

func _ready():
	Connection.connect("message_received", self, "_on_message_received")	
	var scene = initial_scene.instance()
	_protocol = GameProtocol.new()

	scene._protocol = _protocol	
	switch_scene(scene)
	  
func switch_scene(scene):
	if current_scene:
		current_scene.queue_free() 
	
	current_scene = scene
	add_child(scene) 

func _on_message_received(data):
	_protocol.handle_incoming_data(data)
