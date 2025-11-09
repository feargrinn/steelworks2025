extends Control
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var win_condition : bool
var formatted_time_left : String
var time_left : int
var inst_high_score_input = preload("res://UI/high_score_pop_up.tscn").instantiate()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if win_condition:
		if time_left > int(GameManager.high_score):
			print(time_left)
			var save_access_file = FileAccess.open("user://save", FileAccess.WRITE) 
			save_access_file.store_string(str(time_left))
			save_access_file.flush()
			
			inst_high_score_input.get_node('PanelContainer/MarginContainer/VBoxContainer/Label').text = 'NEW HIGH SCORE!'
		else:
			inst_high_score_input.get_node('PanelContainer/MarginContainer/VBoxContainer/Label').text = 'Your score:'
		inst_high_score_input.set_high_score(time_left)
		
		cpu_particles_2d.emitting = true
		await cpu_particles_2d.finished
		add_child(inst_high_score_input)
		%Label.text = "You've won!" + formatted_time_left
		pass
	else:
		%Label.text = "You loooooooooooooost"
		pass


func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game.tscn")
	#print('shit')
	pass # Replace with function body.


func _on_go_back_pressed() -> void:
	get_tree().paused = false
	queue_free()
	#print('shitbutmore')
	pass # Replace with function body.
