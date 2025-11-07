class_name StationStats
extends Resource

## In seconds
@export var min_game_length: float
## In seconds
@export var max_game_length: float
@export var base_win_chance: float
@export var min_tickets: int
@export var max_tickets: int

var game_length: float

func get_prize() -> int:
	return randi_range(min_tickets, max_tickets)

func get_game_result(player_chances := 1) -> bool:
	return randf_range(0, 1) <= base_win_chance * player_chances

func get_game_length() -> float:
	var result := get_game_result()
	if result:
		game_length = max_game_length
		return max_game_length
	game_length = randf_range(min_game_length, max_game_length)
	return game_length

func is_round_won() -> bool:
	return is_equal_approx(game_length, max_game_length)
