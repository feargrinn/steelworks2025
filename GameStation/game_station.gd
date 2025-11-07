extends Area2D

@export var station_id: int = 0 # Maybe unnecessary
@export var retrieval_time: float = 2.0 # How much time between gambles for tickets

@onready var highlight_sprite = $Highlight
@onready var required_position: Node2D = $PlayerPosition

var reward_retrieval_timer: float = 0.0 # How much time left for the next gamble
var assigned_person: Node2D = null
var player_person: Node2D = null
var highlighted: bool = false

func _ready() -> void:
	highlight_sprite.hide()

func _process(delta: float) -> void:
	# Clicked on the station
	if Input.is_action_just_pressed("left_click") and highlighted:
		print("Clicked machine with id: ", station_id)
		
		# If there is a person selected we make him go towards the station (he is assigned)
		if game_manager.currently_selected_person != null:
			assigned_person = game_manager.currently_selected_person
			# TODO: make assigned person go towards required_position
	
	# Checking if the person has finished walking to the station
	if assigned_person != null:
		if assigned_person.global_position.distance_to(required_position.global_position):
			# TODO: make the former assigned_person go away
			player_person = assigned_person
			reward_retrieval_timer = retrieval_time # Reset the time for getting a new reward
			
	if player_person != null:
		if reward_retrieval_timer <= 0.0:
			reward_retrieval_timer = retrieval_time
			# TODO: gamble for tickets
			
		reward_retrieval_timer -= delta


func _on_mouse_entered() -> void:
	highlighted = true
	highlight_sprite.show()
	
func _on_mouse_exited() -> void:
	highlighted = false
	highlight_sprite.hide()
