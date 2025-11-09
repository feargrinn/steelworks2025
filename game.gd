extends Node2D
var game_end_node = load("res://UI/end_game.tscn")

@onready var timer: Timer = $Timer
@onready var gui: Gui = %Gui

#@export var level_time: float = 60.0
	
func _ready() -> void:
	GameManager.no_collected_tickets = 0
	timer.wait_time = GameManager.GAME_LENGTH
	timer.start()
	var navigation_arr := search_for_node(get_tree().root, NavigationRegion2D)
	if navigation_arr.size() > 0:
		var navigation := navigation_arr[0] as NavigationRegion2D
		navigation.navigation_polygon.agent_radius = 30
		navigation.bake_navigation_polygon()
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('pause'):
		var pause_screen = preload("res://UI/pause.tscn")
		$GUI.add_child(pause_screen.instantiate())
		get_tree().paused = true
	gui.show_time(timer.time_left)
	GameManager.time_left = timer.time_left
	var is_anyone_walking = get_tree().get_nodes_in_group("person") \
		.filter(func(person: Person): return person.velocity.length() > 0).size() > 0
	if is_anyone_walking:
		AudioManager.set_sfx_playing("footstep", true)
	else:
		AudioManager.set_sfx_playing("footstep", false)

	if GameManager.no_collected_tickets >= 1000:
		win()



func win():
	AudioManager.play_sfx("victory_jingiel")
	AudioManager.set_sfx_playing("footstep", false)
	var inst_end = game_end_node.instantiate()
	var time_node = $%Gui.time_formatted
	inst_end.win_condition = 1
	inst_end.formatted_time_left = time_node
	inst_end.time_left = $%Gui/Timer.time_left
	$GUI.add_child(inst_end)
	get_tree().paused = true
		
func lose():
	AudioManager.play_sfx("defeat")
	AudioManager.set_sfx_playing("footstep", false)
	var inst_end = game_end_node.instantiate()
	inst_end.win_condition = 0
	$GUI.add_child(inst_end)
	get_tree().paused = true


func _on_timer_timeout() -> void:
	lose()


func search_for_node(node: Node, node_type: Object) -> Array:
	var arr: Array
	for n in node.get_children():
		arr.append_array(search_for_node(n, node_type))
		if is_instance_of(n, node_type):
			arr.append(n)
	return arr
