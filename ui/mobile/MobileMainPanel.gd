extends HBoxContainer

onready var _spellContainer = find_node("SpellContainerMobile")
onready var _inventoryContainer = find_node("InventoryContainerMobile")
onready var _ntnSwitchPanel = find_node("BtnSwitchPanel")

const _spellTexture = preload("res://assets/graphics/531.png")
const _inventoryTexture = preload("res://assets/graphics/572.png")

onready var _barHP = find_node("StatsBarHP")
onready var _barMP = find_node("StatsBarMP")
onready var _barSTA = find_node("StatsBarSTA")
onready var _barSED = find_node("StatsBarSED")
onready var _barHAM = find_node("StatsBarHAM")
onready var _goldLabel = find_node("GoldLabel")


func initialize(stats:PlayerStats,inventory:Inventory, protocol:GameProtocol) -> void:
	_spellContainer.intialize(stats, protocol)
	_inventoryContainer.initialize(inventory, protocol)
	
	stats.connect("change_hp", self, "_on_change_hp")
	stats.connect("change_mp", self, "_on_change_mp")
	stats.connect("change_sta", self, "_on_change_sta")
	stats.connect("change_ham", self, "_on_change_ham")
	stats.connect("change_sed", self, "_on_change_sed")
	stats.connect("change_gold", self, "_on_change_gold")
 
func _on_BtnSwitchPanel_pressed() -> void:
	if _spellContainer.visible:
		_inventoryContainer.visible = true
		_spellContainer.visible = false
		_ntnSwitchPanel.texture_normal = _spellTexture
	else:
		_inventoryContainer.visible = false
		_spellContainer.visible = true 
		_ntnSwitchPanel.texture_normal = _inventoryTexture
		
func _on_change_hp(value:int, max_value:int) -> void:
	_barHP.value = value
	_barHP.max_value = max_value
	
func _on_change_mp(value:int, max_value:int) -> void:
	_barMP.value = value
	_barMP.max_value = max_value
	
func _on_change_sta(value:int, max_value:int) -> void:
	_barSTA.value = value
	_barSTA.max_value = max_value
	
func _on_change_ham(value:int, max_value:int) -> void:
	_barHAM.value = value
	_barHAM.max_value = max_value
	
func _on_change_sed(value:int, max_value:int) -> void:
	_barSED.value = value
	_barSED.max_value = max_value
	
func _on_change_gold(value:int) -> void:
	_goldLabel.text = str(value)
