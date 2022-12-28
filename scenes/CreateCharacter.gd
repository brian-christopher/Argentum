extends Node

var _protocol:GameProtocol 
 
func initialize(protocol:GameProtocol) -> void:
	_protocol = protocol 
	
func _on_ThrowDices_pressed():
	_protocol.write_throw_dices() 
