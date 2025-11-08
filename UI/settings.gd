extends Control



func _ready() -> void:
	%MusicSlider.value = AudioManager.music_value
	%SfxSlider2.value = AudioManager.sfx_value
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	if DisplayServer.window_get_mode(DisplayServer.WINDOW_MODE_WINDOWED):
		%CheckBox.disabled = true
	else:
		%CheckBox.disabled = false
	#$VBoxContainer/MusicSlider.value = 
	#$VBoxContainer/SfxSlider2.value = 


func _on_quit_settings_pressed() -> void:
	queue_free()

func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.music_value = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(AudioManager.music_value))

func _on_sfx_slider_2_value_changed(value: float) -> void:
	AudioManager.sfx_value = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(AudioManager.sfx_value))



func _on_check_box_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1152, 648))
