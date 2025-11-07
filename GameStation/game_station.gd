extends Area2D

class_name GameStation

const error_station_distance: float = 20.0

@export var station_id: int = 0 # Maybe unnecessary
@export var station_stats: StationStats

@onready var highlight_sprite = $Highlight
@onready var required_position: Node2D = $PlayerPosition
@onready var go_away_position: Node2D = $GoAwayPosition
@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

signal won_prize(tickets: int)

var assigned_person: Node2D = null
var player_person: Node2D = null
var highlighted: bool = false
var waiting_for_player: bool = false

func _ready() -> void:
	highlight_sprite.hide()
	timer.timeout.connect(end_round)
	progress_bar.max_value = station_stats.max_game_length

func _process(_delta: float) -> void:
	_update_progress_bar()
	# Clicked on the station
	if Input.is_action_just_pressed("left_click") and highlighted:
		print("Clicked station with id: ", station_id)
		
		# If there is a person selected we make him go towards the station (he is assigned)
		if GameManager.currently_selected_person != null:
			if assigned_person:
				assigned_person.set_target_position(assigned_person.global_position) # former assigned stops
				assigned_person = null
			if player_person: 
				player_person.set_target_position(go_away_position.global_position) # Former player goes away
				player_person = null
			
			# new assigned goes towards station
			waiting_for_player = true
			assigned_person = GameManager.currently_selected_person
			assigned_person.set_target_position(required_position.global_position)
			print("Person ", assigned_person.id ," goes towards station with id: ", station_id)
	
	# Checking if the person has finished walking to the station
	if assigned_person != null:
		if waiting_for_player and assigned_person.global_position.distance_to(required_position.global_position) <= error_station_distance:
			# Assign new player
			waiting_for_player = false
			player_person = assigned_person
			assigned_person = null
			start_round()
	
	if player_person and player_person.global_position.distance_to(required_position.global_position) > error_station_distance:
		player_person = null


func end_round() -> void:
	if !player_person:
		return
	if station_stats.is_round_won():
		var prize := station_stats.get_prize()
		won_prize.emit(prize)
		GameManager.no_collected_tickets += prize
		print("Tickets: ", GameManager.no_collected_tickets)
	start_round()

func start_round() -> void:
	# TODO: if paid
	timer.start(station_stats.get_game_length())
	print("Person ", player_person.id ," started playing station with id: ", station_id)

func _update_progress_bar() -> void:
	var time_passed: float = station_stats.max_game_length - timer.time_left
	progress_bar.value = time_passed

func _on_mouse_entered() -> void:
	highlighted = true
	highlight_sprite.show()
	
func _on_mouse_exited() -> void:
	highlighted = false
	highlight_sprite.hide()
