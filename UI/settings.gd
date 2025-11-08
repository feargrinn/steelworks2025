extends Control



func _ready() -> void:
	$VBoxContainer/MusicSlider.value = AudioManager.music_value
	$VBoxContainer/SfxSlider2.value = AudioManager.sfx_value
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
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
