extends ScrollContainer

var inventory:Inventory
onready var itemsContainer = find_node("ItemsContainer")

func set_inventory(inventory:Inventory) -> void:
	self.inventory = inventory
	itemsContainer.set_inventory(inventory)
