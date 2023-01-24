extends Node

export(PackedScene) var create_scene  
export(PackedScene) var game_scene  

enum State{
	None,
	Login,
	Create	
}
 
const IP_SERVER = "127.0.0.1"#"0.tcp.sa.ngrok.io"#"190.194.38.143"
const IP_PORT = 443 
#tcp://0.tcp.sa.ngrok.io:17560 

onready var user_name:LineEdit = find_node("UserName")
onready var user_password:LineEdit = find_node("UserPassword")
 
var _protocol:GameProtocol = null
var current_state:int = State.None

func _ready(): 
	Connection.connect("connected", self, "_on_client_connected")
	Connection.connect("disconnected", self, "_on_client_disconnected")

	_protocol.connect("logged", self, "_on_client_logged")
	_protocol.connect("error_message", self, "_on_error_message") 
	
func _on_BtnExit_pressed():
	get_tree().quit()
 
func _on_BtnConnect_pressed():
	if(current_state != State.None): return
	
	current_state = State.Login
	Connection.connect_to_server(IP_SERVER, IP_PORT)

func _on_BtnCreate_pressed():
	if(current_state != State.None): return
	
	current_state = State.Create
	Connection.connect_to_server(IP_SERVER, IP_PORT)

func _on_client_connected():
	if(current_state == State.Create):
		var scene = create_scene.instance()
		
		scene.initialize(_protocol) 
		get_parent().switch_scene(scene)
	else:
		_protocol.write_login_existing_char(user_name.text, user_password.text)
		_protocol.flush_data()
		 
	print("conexion establecida")

func _on_client_disconnected():
	current_state = State.None
 
func _on_client_logged():
	var scene = game_scene.instance()
	scene.initiaze(_protocol)
	
	get_parent().switch_scene(scene)

func _on_error_message(message:String):
	print(message) 
