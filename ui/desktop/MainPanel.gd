extends VBoxContainer
onready var _player_hp = find_node("UserHP")
onready var _player_mp = find_node("UserMP")
onready var _player_sta = find_node("UserSTA")
onready var _player_sed = find_node("UserSed")
onready var _player_ham = find_node("UserHam")

onready var _inventory_container = find_node("InventoryContainer")
onready var _spell_container = find_node("SpellsContainer")

func initialize(stats:PlayerStats, inventory:Inventory, protocol:GameProtocol) -> void:
	_inventory_container.set_inventory(inventory)
	_spell_container.initialize(stats, protocol) 
	   
	stats.connect("change_hp", self, "_on_change_hp")
	stats.connect("change_mp", self, "_on_change_mp")
	stats.connect("change_ham", self, "_on_change_ham")
	stats.connect("change_sed", self, "_on_change_sed")
	stats.connect("change_sta", self, "_on_change_sta")
	
func _on_change_mp(value:int, max_value:int) -> void:
	_player_mp.value = value
	_player_mp.max_value = max_value
	
func _on_change_ham(value:int, max_value:int) -> void:
	_player_ham.text = "hambre:\n%d/%d" % [value, max_value] 

func _on_change_sed(value:int, max_value:int) -> void:
	_player_sed.text = "sed:\n%d/%d" % [value, max_value] 
	
func _on_change_sta(value:int, max_value:int) -> void:
	_player_sta.value = value
	_player_sta.max_value = max_value

func _on_change_hp(value:int, max_value:int) -> void:
	_player_hp.value = value
	_player_hp.max_value = max_value
