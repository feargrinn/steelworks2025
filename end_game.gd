extends Control

var win_condition : bool
var formatted_time_left : String
var time_left : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#win
	if win_condition:
		if time_left > int(GameManager.high_score):
			print(time_left)
			var save_access_file = FileAccess.open("user://save", FileAccess.WRITE) 
			save_access_file.store_string(str(time_left))
			save_access_file.flush()

		%Label.text = "You've won with the time " + formatted_time_left
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
