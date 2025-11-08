extends Control

var win_condition : bool
var time_left : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#win
	if win_condition:
		%Label.text = "You've won with the time " + time_left
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
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	#print('shitbutmore')
	pass # Replace with function body.
