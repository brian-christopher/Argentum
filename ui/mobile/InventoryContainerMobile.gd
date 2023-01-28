extends HBoxContainer

onready var _gridContainer = find_node("GridContainer")
 
var _protocol:GameProtocol
var _player_data:PlayerData
var slot_selected:ItemSlot

func initialize(player_data:PlayerData, protocol:GameProtocol): 
	_player_data = player_data
	_protocol = protocol
	
	player_data.inventory.connect("slot_changed", self, "_on_slot_changed")

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
	var index = itemslot.inventory_index + 1
	var item = itemslot.item

	if item and item.type:
		if item.is_consumable():
			_protocol.write_use_item(index)
		elif item.is_equippable():
			_protocol.write_equip_item(index)
		 
func _on_BtnAttack_pressed() -> void:
	_protocol.write_attack()
 
func _on_BtnPickup_pressed() -> void:
	_protocol.write_pick_up()

func _on_BtnLag_pressed() -> void:
	if _player_data.check_timer(PlayerData.TimersIndex.SendRPU):
		_protocol.write_request_position_update()
 
func _on_BtnUsar_pressed() -> void:
	if _player_data.check_timer(PlayerData.TimersIndex.UseItemWithU):
		if slot_selected:
			_protocol.write_use_item(slot_selected.inventory_index + 1)
