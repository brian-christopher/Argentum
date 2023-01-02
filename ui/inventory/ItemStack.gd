extends Resource
class_name ItemStack

var item:Item = null
var quantity:int = 0
var equipped:bool = false

func _init(item:Item = null, quantity:int = 0, equipped:bool = false) -> void:
	self.item = item
	self.quantity = quantity
	self.equipped = equipped
