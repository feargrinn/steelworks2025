extends Control

func _ready() -> void:
	var new_high_score = FileAccess.open("user://save", FileAccess.READ)
	GameManager.high_score = int(new_high_score.get_as_text())
	$VBoxContainer/VBoxContainer/Label.text = 'Best Time: ' + new_high_score.get_as_text()
	new_high_score.close()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Tutorial/tutorial.tscn") # Game is opened in tutorial sccene

func _on_settings_pressed() -> void:
	var settings = preload('res://UI/settings.tscn').instantiate()
	add_child(settings)
	#settingsy są na instantiate po ewentualne kliknięcie na pauzie
	
func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/credits.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
