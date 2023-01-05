extends VBoxContainer

var stats:PlayerStats
var protocol:GameProtocol
var spell_selected = 0

onready var spellList = find_node("SpellList")


func initialize(stats:PlayerStats, protocol:GameProtocol) -> void:
	self.stats = stats
	self.protocol = protocol
	
	for i in stats.spells:
		spellList.add_item(i)
		
	stats.connect("change_spell_slot", self, "_on_change_spell_slot")

func _on_BtnCast_pressed() -> void:
	if spellList.get_item_text(spell_selected) != "(None)":
		protocol.write_cast_spell(spell_selected + 1)
		protocol.write_work(Global.eSkill.Magia)
 
func _on_BtnUp_pressed() -> void:
	if spell_selected <= 0: return
	var new_text = stats.spells[spell_selected - 1]
	var old_text = stats.spells[spell_selected]
	
	stats.set_spell(spell_selected - 1, old_text)
	stats.set_spell(spell_selected,     new_text)
	
	protocol.write_move_sell(true,  spell_selected + 1)
	spellList.select(spell_selected - 1)
	
	spell_selected -= 1
 
func _on_BtnDown_pressed() -> void:
	if spell_selected == Global.MAXHECHI - 1: return
	
	var old_text = stats.spells[spell_selected]
	var new_text = stats.spells[spell_selected + 1]
	
	stats.set_spell(spell_selected + 1, old_text)
	stats.set_spell(spell_selected,     new_text)
	
	protocol.write_move_sell(false,  spell_selected + 1)
	spellList.select(spell_selected + 1)
	
	spell_selected += 1

func _on_change_spell_slot(slot:int, name:String) -> void:
	spellList.set_item_text(slot, name)
 
func _on_SpellList_item_selected(index: int) -> void:
	spell_selected = index
	
func _on_BtnInfo_pressed() -> void:
	protocol.write_spell_info(spell_selected + 1)
