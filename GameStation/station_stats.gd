class_name StationStats
extends Resource

## In seconds
@export_range(0.3, 1.0, 0.1) var min_game_length: float = 0.5
## In seconds
@export_range(0.5, 30.0, 0.1) var max_game_length: float = 10.0
@export_range(0.0, 1.0, 0.01) var base_win_chance: float = 0.5
@export var min_tickets: int = 1
@export var max_tickets: int = 5
@export_range(0, 1000) var available_tickets: int = 3
@export_range(1, 10) var price: int = 1

signal tickets_used_up()
var game_length: float

func get_prize() -> int:
	if available_tickets == 0:
		return 0
	var prize := randi_range(min_tickets, max_tickets)
	prize = min(prize, available_tickets)
	available_tickets -= prize
	if available_tickets == 0:
		tickets_used_up.emit()
	return prize

func get_game_result(player_chances := 1.) -> bool:
	return randf_range(0, 1) <= base_win_chance * player_chances

func get_game_length(player_chances := 1.) -> float:
	var result := get_game_result(player_chances)
	if result:
		game_length = max_game_length
		return max_game_length
	game_length = randf_range(min_game_length, max_game_length)
	return game_length

func is_round_won() -> bool:
	return is_equal_approx(game_length, max_game_length)


func calculate_profitability(player_win_chance := 0.5) -> float:
	var average_tickets_on_win := float(max_tickets - min_tickets) / 2
	var average_game_time := (max_game_length - min_game_length) / 2
	var average_tickets_on_win_per_second := (
			average_tickets_on_win / average_game_time)
	
	var win_probability := base_win_chance * player_win_chance
	var average_tickets_per_second := (
			average_tickets_on_win_per_second * win_probability)
	
	return average_tickets_per_second


func is_possible_to_use_up_tickets() -> bool:
	var tickets_per_second := calculate_profitability()
	return tickets_per_second * GameManager.time_left > available_tickets
