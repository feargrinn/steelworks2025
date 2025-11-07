extends Control

func _on_back_to_game_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_settings_pressed() -> void:
	var settings = preload('res://UI/settings.tscn').instantiate()
	add_child(settings)
	pass # Replace with function body.


func _on_back_to_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	queue_free()
	pass # Replace with function body.
