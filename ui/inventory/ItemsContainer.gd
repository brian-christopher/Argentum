extends MarginContainer 

const ITEM_SLOT_SCENE = preload("res://ui/inventory/ItemSlot.tscn")

onready var itemGrid = find_node("ItemGrid")

var inventory:Inventory = null
var slot_selected:int = -1

func set_inventory(inventory:Inventory) -> void:
	self.inventory = inventory
	
	inventory.connect("slot_changed", self, "_on_inventory_changed")
	
	for i in inventory.max_slots:
		var stack = inventory.get_item_stack(i)
		var slot = ITEM_SLOT_SCENE.instance()
		itemGrid.add_child(slot)
		
		slot.set_item(i, stack.item, stack.quantity, stack.equipped)
		#slot.connect("item_selected", self, "_on_item_slot_selected", [slot])

func _on_item_slot_selected(slot:ItemSlot):
	print(slot.inventory_index)

func _on_inventory_changed(index:int, old_content:ItemStack, new_content:ItemStack) -> void:
	for child in itemGrid.get_children():
		if not child is ItemSlot:
			continue
		
		if child.inventory_index == index:
			child.set_item(index, new_content.item, new_content.quantity, new_content.equipped)
			break
