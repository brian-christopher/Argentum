extends PanelContainer

const ITEM_SLOT_GUI_SCENE = preload("res://UI-DEMO/ItemSlotGUI.tscn")

onready var itemsContainer = find_node("ItemsContainer")

var _protocol:GameProtocol 
var selected_slot = null

func initialize(inventory:Inventory, protocol:GameProtocol) -> void:
	_protocol = protocol
	inventory.connect("slot_changed", self, "_on_inventory_changed")
	
	for i in Global.MAX_INVENTORY_SLOTS:
		var slot =  ITEM_SLOT_GUI_SCENE.instance()
		slot.init_item(i, null, 0, false)
		
		itemsContainer.add_child(slot)
		slot.connect("slot_selected", self, "_on_slot_selected", [slot])
		
func _on_inventory_changed(slot_index:int, old_item:ItemStack, new_item:ItemStack) -> void:
	for slot in itemsContainer.get_children():
		if slot.slot_index == slot_index:
			slot.init_item(slot_index, new_item.item, new_item.quantity, new_item.equipped)
			break

func _on_slot_selected(slot) -> void:
	if selected_slot != slot:
		if selected_slot:
			selected_slot.self_modulate = Color.white
		selected_slot = slot
		selected_slot.self_modulate = Color.orange 
	else:
		_protocol.write_use_item(selected_slot.slot_index + 1) 

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_E:
			if selected_slot:
				_protocol.write_equip_item(selected_slot.slot_index + 1)
