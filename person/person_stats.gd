class_name PersonStats
extends Resource

@export var game_station_stats: Dictionary[int, PersonMachineStats]

@export var speed: float = 100
## When exceeded, this guy won't want to play
@export_range(0, 200) var patience: int = 100
## Per second
@export_range(1, 30) var calming_down_speed: int = 10 # Should it go down faster when walking :D?
## Doesn't do anything:)
@export var ghosts_before_heart_attack: int = 3
@export var coins: int = 30

var irritation := 0.0 : set = set_irritation
var ghosts_survived := 0 :set = set_ghosts_survived

signal died_of_heart_attack()
signal irritation_changed(irritation_factor: float)

func set_irritation(value) -> void:
	irritation = value
	irritation = clamp(irritation, 0, patience)
	irritation_changed.emit(irritation/patience)

func set_ghosts_survived(value: int) -> void:
	ghosts_survived = value
	if ghosts_survived >= ghosts_before_heart_attack:
		died_of_heart_attack.emit()


func _on_loss(machine_id: int) -> void:
	assert(game_station_stats.has(machine_id), "No personal stats for this machine!")
	irritation += game_station_stats[machine_id].irritation_on_loss


func _on_win(machine_id: int) -> void:
	assert(game_station_stats.has(machine_id), "No personal stats for this machine!")
	irritation -= game_station_stats[machine_id].satisfaction_on_win
