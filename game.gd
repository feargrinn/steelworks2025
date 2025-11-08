extends Node2D
var game_end_node = load("res://UI/end_game.tscn")

# Called when the node enters the scene tree for the first time.
	
	
func _ready() -> void:
	GameManager.no_collected_tickets = 0
	
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('pause'):
		var pause_screen = preload("res://UI/pause.tscn")
		$GUI.add_child(pause_screen.instantiate())
		get_tree().paused = true
	
	
	if GameManager.no_collected_tickets >= 100:
		win()
	#GameManager.no_collected_tickets += 1
	#print(GameManager.no_collected_tickets)



func win():
	var inst_end = game_end_node.instantiate()
	var time_node = $%GuiTime.time_formatted
	inst_end.win_condition = 1
	inst_end.time_left = time_node
	$GUI.add_child(inst_end)
	get_tree().paused = true
	#print('you won!!! time left: ' + time_node)
		
func lose():
	var inst_end = game_end_node.instantiate()
	inst_end.win_condition = 0
	$GUI.add_child(inst_end)
	get_tree().paused = true
	#print('huh you lost. Lser')
