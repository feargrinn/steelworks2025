extends Area2D

@export var station_id: int = 0 # Maybe unnecessary
@export var station_stats: StationStats

@onready var highlight_sprite = $Highlight
@onready var required_position: Node2D = $PlayerPosition
@onready var timer: Timer = $Timer

signal won_prize(tickets: int)

var assigned_person: Node2D = null
var player_person: Node2D = null
var highlighted: bool = false

func _ready() -> void:
	highlight_sprite.hide()
	timer.timeout.connect(end_round)

func _process(_delta: float) -> void:
	# Clicked on the station
	if Input.is_action_just_pressed("left_click") and highlighted:
		print("Clicked machine with id: ", station_id)
		
		# If there is a person selected we make him go towards the station (he is assigned)
		if GameManager.currently_selected_person != null:
			assigned_person = GameManager.currently_selected_person
			# TODO: make assigned person go towards required_position
	
	# Checking if the person has finished walking to the station
	if assigned_person != null:
		if assigned_person.global_position.distance_to(required_position.global_position):
			# TODO: make the former assigned_person go away
			player_person = assigned_person
			start_round()


func end_round() -> void:
	if !player_person:
		return
	if station_stats.is_round_won():
		var prize := station_stats.get_prize()
		won_prize.emit(prize)
	start_round()

func start_round() -> void:
	# TODO: if paid
	timer.start(station_stats.get_game_length())

func _on_mouse_entered() -> void:
	highlighted = true
	highlight_sprite.show()
	
func _on_mouse_exited() -> void:
	highlighted = false
	highlight_sprite.hide()
