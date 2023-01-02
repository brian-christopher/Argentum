extends PanelContainer
class_name ItemSlot

signal item_selected

onready var quantityLabel = find_node("QuantityLabel")
onready var equippedLabel = find_node("EquippedLabel")
onready var iconTexture = find_node("IconTexture")

export (int, -1, 1000, 1) var inventory_index:int = -1

var item:Item = null setget _set_item
var quantity:int = 0 setget _set_quantity
var equipped:bool = false setget _set_equipped

var inventory_slot:int = -1

func set_item(index:int, item:Item, quantity:int, equipped:bool) -> void:
	self.inventory_index = index
	self.item = item
	
	if not item:
		quantity = 0
	
	self.quantity = quantity
	self.equipped = equipped

func _set_item(new_item:Item) -> void:
	item = new_item
	
	if not is_inside_tree():
		yield(self, "ready")
		
	if not item:
		iconTexture.texture = null
	else:
		iconTexture.texture = item.texture
	 
func _set_quantity(new_quantity:int) -> void:
	quantity = new_quantity

	if not is_inside_tree():
		yield(self, "ready")
	
	if quantity <= 1:
		quantityLabel.visible = false
	else:
		quantityLabel.visible = true
		quantityLabel.text = String(quantity)

func _set_equipped(new_equipped:bool) -> void:
	equipped = new_equipped
	
	if not is_inside_tree():
		yield(self, "ready")
	
	if equipped:
		equippedLabel.visible = true
	else:
		equippedLabel.visible = false
