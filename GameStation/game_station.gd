extends Area2D

class_name GameStation

@export var station_id: int = 0 # Maybe unnecessary
@export var retrieval_time: float = 2.0 # How much time between gambles for tickets
const error_station_distance: float = 20.0

@onready var highlight_sprite = $Highlight
@onready var required_position: Node2D = $PlayerPosition
@onready var go_away_position: Node2D = $GoAwayPosition

var reward_retrieval_timer: float = 0.0 # How much time left for the next gamble
var assigned_person: Person = null
var player_person: Person = null
var highlighted: bool = false
var waiting_for_player: bool = false

func _ready() -> void:
	highlight_sprite.hide()

func _process(delta: float) -> void:
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
			reward_retrieval_timer = retrieval_time # Reset the time for getting a new reward
			print("Person ", player_person.id ," started playing station with id: ", station_id)
			
	if player_person and player_person.global_position.distance_to(required_position.global_position) > error_station_distance:
		player_person = null
	
	# gambling for tickets
	if player_person != null and !waiting_for_player:
		if reward_retrieval_timer <= 0.0:
			reward_retrieval_timer = retrieval_time
			GameManager.no_collected_tickets += 1
			print("Tickets: ", GameManager.no_collected_tickets)
		reward_retrieval_timer -= delta


func _on_mouse_entered() -> void:
	highlighted = true
	highlight_sprite.show()
	
func _on_mouse_exited() -> void:
	highlighted = false
	highlight_sprite.hide()
