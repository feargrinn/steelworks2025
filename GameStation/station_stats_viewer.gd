class_name StationStatsViewer
extends PanelContainer

const STATION_STATS_VIEWER = preload("uid://b8ymtc5uqe1xt")
@export var stats: StationStats

@onready var win_chance: Label = %WinChance
@onready var ticket_range: Label = %TicketRange
@onready var game_length: Label = %GameLength
@onready var price: Label = %Price
@onready var available_tickets: Label = %AvailableTickets
@onready var calculated_profitability: Label = %CalculatedProfitability


static func instantiate(station_stats : StationStats) -> StationStatsViewer:
	var scene := STATION_STATS_VIEWER.instantiate()
	scene.stats = station_stats
	return scene

func _ready() -> void:
	set_stats(stats)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		queue_free()


func set_stats(value: StationStats) -> void:
	stats = value
	win_chance.text = str(stats.base_win_chance * 100) + " %"
	ticket_range.text = (
			str(stats.min_tickets) + " - " + str(stats.max_tickets)
			)
	game_length.text = (
			str(stats.min_game_length) + " - " + str(stats.max_game_length)
			)
	price.text = str(stats.price) + " $"
	available_tickets.text = str(stats.available_tickets)
	calculated_profitability.text = (
			str(stats.calculate_profitability()) + " (" +
			("Y" if stats.is_possible_to_use_up_tickets() else "N") + ")"
			)
