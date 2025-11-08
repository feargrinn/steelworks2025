extends Button

func _init() -> void:
	pressed.connect(func(): AudioManager.play_sfx("click"))
