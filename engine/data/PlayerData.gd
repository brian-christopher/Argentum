extends Reference
class_name PlayerData

const INT_ATTACK = 1500
const INT_ARROWS = 1400
const INT_CAST_SPELL = 1400
const INT_CAST_ATTACK = 1000
const INT_WORK = 700
const INT_USEITEMU = 450
const INT_USEITEMDCK = 220
const INT_SENTRPU = 2000

enum TimersIndex{
	Attack 
	Work 
	UseItemWithU 
	UseItemWithDblClick 
	SendRPU 
	CastSpell 
	Arrows 
	CastAttack 
}

var stats:PlayerStats
var inventory:Inventory

var using_skill:= 0
var navigated = false
var timers = []

func _init(max_inventory_slots:int) -> void:
	stats = PlayerStats.new()
	inventory = Inventory.new(max_inventory_slots) 
	set_timers()

func set_timers():
	for i in TimersIndex.size():
		var timer = TickTimer.new()
		
		timer.connect("restart_tick", self, "_on_restart_tick", [i])
		timers.append(timer)
	
	timers[TimersIndex.Attack].interval = INT_ATTACK
	timers[TimersIndex.Work].interval = INT_WORK
	timers[TimersIndex.UseItemWithU].interval = INT_USEITEMU
	timers[TimersIndex.UseItemWithDblClick].interval = INT_USEITEMDCK
	timers[TimersIndex.SendRPU].interval = INT_SENTRPU
	timers[TimersIndex.CastSpell].interval = INT_CAST_SPELL
	timers[TimersIndex.Arrows].interval = INT_ARROWS
	timers[TimersIndex.CastAttack].interval = INT_CAST_ATTACK 

func _on_restart_tick(index:int) -> void:
	if index == TimersIndex.Attack or index == TimersIndex.CastSpell:
		timers[TimersIndex.CastSpell].restart()
	elif index == TimersIndex.CastAttack:
		timers[TimersIndex.Attack].restart()
		timers[TimersIndex.CastSpell].restart()
		
func is_alive() -> bool:
	return stats.hp > 0
	
func check_timer(index:int, restart:bool = true) -> bool:
	return timers[index].check(restart)
