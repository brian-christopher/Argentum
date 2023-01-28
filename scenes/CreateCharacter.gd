extends Node

var _protocol:GameProtocol 

var _current_class_id = 1
var _current_home_id = 1
var _current_gender_id = 1
var _current_race_id = 1

onready var select_class = find_node("SelectClase") 
onready var select_gender = find_node("SelectGenero") 
onready var select_home = find_node("SelectHogar")  
onready var select_race = find_node("SelectRaza") 
 
func initialize(protocol:GameProtocol) -> void:
	_protocol = protocol 

func _ready() -> void:
	select_class.connect("pressed_next", self, "_on_select_class", [1])
	select_class.connect("pressed_previus", self, "_on_select_class", [-1])
	
	select_gender.connect("pressed_next", self, "_on_select_gender", [1])
	select_gender.connect("pressed_previus", self, "_on_select_gender", [-1])
	
	select_home.connect("pressed_next", self, "_on_select_home", [1])
	select_home.connect("pressed_previus", self, "_on_select_home", [-1])
	
	select_race.connect("pressed_next", self, "_on_select_race", [1])
	select_race.connect("pressed_previus", self, "_on_select_race", [-1])
	 
	_protocol.connect("parse_data", self, "_on_parse_data")
	Connection.connect("disconnected", self, "_on_disconnected")
	
	_update_info()
	
func _on_ThrowDices_pressed():
	_protocol.write_throw_dices() 
	_protocol.flush_data()

func _on_select_class(id:int) -> void:
	_current_class_id = clamp(_current_class_id + id, 1, Global.NUMCLASES)
	_update_info()
	
func _on_select_home(id:int) -> void:
	_current_home_id = clamp(_current_home_id + id, 1, Global.NUMCIUDADES)
	_update_info()
	
func _on_select_race(id:int) -> void:
	_current_race_id = clamp(_current_race_id + id, 1, Global.NUMRAZAS)
	_update_info()
	
func _on_select_gender(id:int) -> void:
	_current_gender_id = clamp(_current_gender_id + id, 1, 2)
	_update_info()
	 
func _update_info(): 
	select_class.set_text(Global.ClassNames.get(_current_class_id))
	select_gender.set_text(Global.GenderNames.get(_current_gender_id))
	select_race.set_text(Global.RaceNames.get(_current_race_id))
	select_home.set_text(Global.HomeNames.get(_current_home_id))
	
func _on_parse_data(packet_id:int, data) -> void:
	match packet_id:
		GameProtocol.ServerPacketID.Logged:
			var scene = load("res://scenes/GameScene.tscn").instance()
			scene.initialize(_protocol)
			
			get_parent().switch_scene(scene)
		GameProtocol.ServerPacketID.ErrorMsg:
			print(data)

func _on_disconnected():
	var scene = load("res://scenes/LobbyScene.tscn").instance()
	scene._protocol = _protocol
	
	get_parent().switch_scene(scene) 

func _on_BtnExit_pressed() -> void:
	Connection.disconnect_from_server()

func _on_BtnSubmit_pressed() -> void:
	var user_name = find_node("UserName").text
	var user_password = find_node("UserPassword").text
	var user_email = find_node("UserEmail").text
	
	_protocol.write_login_new_char(user_name, user_password, _current_race_id, _current_gender_id, _current_class_id, user_email, _current_home_id)
	_protocol.flush_data()
