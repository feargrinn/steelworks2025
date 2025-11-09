extends Area2D

class_name GameStation

const error_station_distance: float = 20.0

@export var station_id: int = 0 # Maybe unnecessary
@export var station_stats: StationStats

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var required_position: Node2D = $PlayerPosition
@onready var go_away_position: Node2D = $GoAwayPosition
@onready var timer: Timer = $Timer

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var won_prize_label: Label = $WonPrizeLabel
@onready var label_position: Vector2 = $WonPrizeLabel.position

signal won_prize(tickets: int)
signal game_won(id: int)
signal game_lost(id: int)

var tween: Tween
var assigned_person: Person = null
var player_person: Person = null
var highlighted: bool = false
var waiting_for_player: bool = false

var outline_material: Material = preload("res://materials/person.tres")

func _ready() -> void:
	timer.timeout.connect(end_round)
	progress_bar.max_value = station_stats.max_game_length
	station_stats.tickets_used_up.connect(_kill_station)
	if !GameManager.machines.has(station_id):
		GameManager.machines[station_id] = station_stats

func _process(_delta: float) -> void:
	_update_progress_bar()
	# Clicked on the station
	if Input.is_action_just_pressed("left_click") and highlighted:
		print("Clicked station with id: ", station_id)
		
		# If there is a person selected we make him go towards the station (he is assigned)
		if GameManager.currently_selected_person != null and GameManager.currently_selected_person != player_person:
			if assigned_person:
				assigned_person.set_target_position(assigned_person.global_position) # former assigned stops
				assigned_person = null
			if player_person: 
				player_person.set_target_position(go_away_position.global_position) # Former player goes away
			
			# new assigned goes towards station
			waiting_for_player = true
			assigned_person = GameManager.currently_selected_person
			assigned_person.set_target_position(required_position.global_position)
			print("Person ", assigned_person.id ," goes towards station with id: ", station_id)
			GameManager.set_selected_person(null)
		else:
			for i in get_tree().get_nodes_in_group('stattion_pop_ups'):
				i.queue_free()
			add_child(StationStatsViewer.instantiate(station_stats))
	#elif Input.is_action_just_pressed("left_click") and GameManager.currently_selected_person:
		#GameManager.currently_selected_person.set_target_position(get_global_mouse_position())
		#GameManager.set_selected_person(null)


	# Checking if the person has finished walking to the station
	if assigned_person != null:
		if waiting_for_player and assigned_person.global_position.distance_to(required_position.global_position) <= error_station_distance:
			# Assign new player
			waiting_for_player = false
			player_person = assigned_person
			player_person.current_machine = self
			player_person.is_playing = true
			assigned_person = null
			start_round()
			if !game_lost.has_connections():
				game_lost.connect(player_person.person_stats._on_loss)
				game_won.connect(player_person.person_stats._on_win)
	
	if player_person and player_person.global_position.distance_to(required_position.global_position) > error_station_distance:
		if animated_sprite_2d.animation != "ded":
			animated_sprite_2d.animation = "default"
		game_lost.disconnect(player_person.person_stats._on_loss)
		game_won.disconnect(player_person.person_stats._on_win)
		player_person.is_playing = false
		player_person.current_machine = null
		player_person = null
		progress_bar.hide()

func _kill_station() -> void: # Station becomes inactive
	if player_person: player_person.set_target_position(go_away_position.global_position)
	animated_sprite_2d.animation = "ded"
	progress_bar.hide()
	
	
func show_prize(prize: int) -> void:
	won_prize_label.text = "+ " + str(prize)
	won_prize_label.position = label_position
	won_prize_label.modulate.a = 1
	won_prize_label.show()
	if tween:
		tween.kill()
	tween = won_prize_label.create_tween()
	tween.tween_property(
			won_prize_label, "position", 
			won_prize_label.position + Vector2(0, -40), 1.
			)
	tween.parallel()
	tween.tween_property(
			won_prize_label, "modulate:a", 
			0, 1.
			)


func end_round() -> void:
	if !player_person:
		return
	if station_stats.is_round_won():
		AudioManager.play_sfx("ticket_collected")
		game_won.emit(station_id)
		var prize := station_stats.get_prize()
		won_prize.emit(prize)
		show_prize(prize)
		GameManager.no_collected_tickets += prize
		print("Tickets: ", GameManager.no_collected_tickets)
	else:
		game_lost.emit(station_id)
	start_round()

func start_round() -> void:
	if station_stats.available_tickets <= 0:
		return
	if player_person.person_stats.coins < station_stats.price:
		player_person.indicate_not_enough_coins()
		progress_bar.hide()
		return
	var person_chances := (
		player_person.person_stats.game_station_stats[station_id].win_chance
	)
	timer.start(station_stats.get_game_length(person_chances))
	_update_progress_bar()
	progress_bar.show()
	animated_sprite_2d.animation = "playing"

func _update_progress_bar() -> void:
	var time_passed: float = station_stats.game_length - timer.time_left
	progress_bar.value = time_passed

func _on_mouse_entered() -> void:
	highlighted = true
	animated_sprite_2d.material = outline_material
	
func _on_mouse_exited() -> void:
	highlighted = false
	animated_sprite_2d.material = null
