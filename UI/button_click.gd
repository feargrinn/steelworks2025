extends Button

func _init() -> void:
	pressed.connect(func(): AudioManager.play_sfx("click"))


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
