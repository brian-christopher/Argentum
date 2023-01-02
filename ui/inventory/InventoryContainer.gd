extends PanelContainer 

var inventory:Inventory = null
onready var panelContainer = find_node("PanelContainer")

func set_inventory(inventory:Inventory) -> void:
	self.inventory = inventory
	panelContainer.set_inventory(inventory) 
