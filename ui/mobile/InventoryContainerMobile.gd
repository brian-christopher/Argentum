extends HBoxContainer

onready var _gridContainer = find_node("GridContainer")

var _inventory:Inventory
var _protocol:GameProtocol

func initialize(inventory:Inventory, protocol:GameProtocol):
	_inventory = inventory
	_protocol = protocol
	
	_inventory.connect("slot_changed", self, "_on_slot_changed")

	var i = 0
	for slot in _gridContainer.get_children():
		slot = slot as ItemSlot
		slot.inventory_index = i
		slot.connect("item_selected", self, "_on_item_selected", [slot])
		i += 1
	
	
func _on_slot_changed(slot:int, old_content:ItemStack, new_context:ItemStack) -> void:
	for i in _gridContainer.get_children():
		if i is ItemSlot and i.inventory_index == slot:
			i.set_item(slot, new_context.item, new_context.quantity, new_context.equipped)
			break
			
func _on_item_selected(itemslot:ItemSlot) -> void:
	_protocol.write_use_item(itemslot.inventory_index + 1)
  
func _on_BtnAttack_pressed() -> void:
	_protocol.write_attack()
