extends Resource
class_name Inventory

signal slot_changed(index, old_content, new_contet)

var max_slots = 30 setget _set_max_slots
var _slots = []

func _init(max_slots:int) -> void:
	self.max_slots = max_slots
	
func set_item_stack(index:int, item:Item, quantity:int, equipped:bool) -> void:
	var old_content = _slots[index]
	_slots[index] = ItemStack.new(item, quantity, equipped)
	emit_signal("slot_changed", index, old_content, _slots[index])

func get_item_stack(index:int) -> ItemStack:
	return _slots[index]

func _set_max_slots(value:int) -> void:
	max_slots = value
	
	_slots.resize(max_slots)
	for i in range(max_slots):
		if _slots[i] and _slots[i].item:
			continue
		else:
			set_item_stack(i, null, 0, false)
