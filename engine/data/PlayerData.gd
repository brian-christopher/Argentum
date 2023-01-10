extends Reference
class_name PlayerData

var stats:PlayerStats
var inventory:Inventory

var using_skill:= 0

func _init(max_inventory_slots:int) -> void:
	stats = PlayerStats.new()
	inventory = Inventory.new(max_inventory_slots) 
