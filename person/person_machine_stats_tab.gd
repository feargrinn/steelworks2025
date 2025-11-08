class_name PersonMachineStatsTab
extends MarginContainer

const PERSON_MACHINE_STATS_TAB = preload("uid://dak5y162eigfa")

@onready var win_chance: Label = %WinChance
@onready var irritation: Label = %Irritation

var machine_id: int
var stats: PersonMachineStats

static func instantiate(id: int, person_machine_stats: PersonMachineStats) -> PersonMachineStatsTab:
	var scene = PERSON_MACHINE_STATS_TAB.instantiate()
	scene.machine_id = id
	scene.stats = person_machine_stats
	return scene

func _ready() -> void:
	win_chance.text = str(stats.win_chance)
	irritation.text = (
			str(stats.irritation_on_loss) + " or " + 
			str(stats.satisfaction_on_win))
	name = str(machine_id)
