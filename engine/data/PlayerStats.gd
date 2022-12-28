extends Reference
class_name PlayerStats
 
signal change_hp(value, max_value)
signal change_mp(value, max_value)
signal change_sta(value, max_value)

signal change_sed(value, max_value)
signal change_ham(value, max_value)

signal change_gold(value)
signal change_level(value)
signal change_elu(value)
signal change_elv(value)

var hp:int setget set_hp
var max_hp:int setget set_max_hp

var mp:int setget set_mp
var max_mp:int setget set_max_mp
  
var sta:int setget set_sta
var max_sta:int setget set_max_sta

var ham:int setget set_ham
var max_ham:int setget set_max_ham

var sed:int setget set_sed
var max_sed:int setget set_max_sed

var gold:int setget set_gold

var level:int setget set_level
var elu:int setget set_elu
var elv:int setget set_elv

func set_hp(value:int) -> void:
	hp	= value
	emit_signal("change_hp", hp, max_hp)
	
func set_max_hp(value:int) -> void:
	max_hp = value
	emit_signal("change_hp", hp, max_hp)
 
func set_mp(value:int) -> void:
	mp	= value
	emit_signal("change_mp", mp, max_mp)
	
func set_max_mp(value:int) -> void:
	max_mp	= value
	emit_signal("change_mp", mp, max_mp)

func set_sta(value:int) -> void:
	sta	= value
	emit_signal("change_sta", sta, max_sta)
	
func set_max_sta(value:int) -> void:
	max_sta	= value
	emit_signal("change_sta", sta, max_sta)
	
func set_ham(value:int) -> void:
	ham	= value
	emit_signal("change_ham", ham, max_ham)
	
func set_max_ham(value:int) -> void:
	max_ham	= value
	emit_signal("change_ham", ham, max_ham)
	
func set_sed(value:int) -> void:
	sed	= value
	emit_signal("change_sed", sed, max_sed)
	
func set_max_sed(value:int) -> void:
	max_sed	= value
	emit_signal("change_sed", sed, max_sed)

func set_gold(value:int) -> void:
	gold = value;
	emit_signal("change_gold", gold)

func set_level(value:int) -> void:
	level = value
	emit_signal("change_level", level)

func set_elu(value:int) -> void:
	elu	= value
	emit_signal("change_elu", elu)
	
func set_elv(value:int) -> void:
	elv	= value
	emit_signal("change_elv", elv)
