extends StreamPeerBuffer
class_name ByteQueue 

#clase temporal, hasta que pasa las cadenas del server a utf8

func _ready():
	pass
 
func get_utf8_string(_bytes = -1):
	var length = get_16()
	return .get_string(length)

func put_utf8_string(value):
	var bytes = value.to_ascii()
	put_16(bytes.size())
	put_data(bytes)
