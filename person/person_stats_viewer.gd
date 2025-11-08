class_name PersonStatsViewer
extends PanelContainer


const PERSON_STATS_VIEWER = preload("uid://dum8w0fd4kyw3")

@export var stats: PersonStats

@onready var speed: Label = %Speed
@onready var patience: Label = %Patience
@onready var calming_down_speed: Label = %CalmingDownSpeed
@onready var coins: Label = %Coins
@onready var tab_container: TabContainer = %TabContainer



static func instantiate(person_stats : PersonStats) -> PersonStatsViewer:
	var scene := PERSON_STATS_VIEWER.instantiate()
	scene.stats = person_stats
	return scene

func _ready() -> void:
	set_stats(stats)
	for key in stats.game_station_stats:
		tab_container.add_child(
			PersonMachineStatsTab.instantiate(key, stats.game_station_stats[key]))


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		queue_free()


func set_stats(value: PersonStats) -> void:
	stats = value
	speed.text = str(stats.speed)
	patience.text = str(stats.patience)
	calming_down_speed.text = str(stats.calming_down_speed) + "/s"
	coins.text = str(stats.coins) + " $"
