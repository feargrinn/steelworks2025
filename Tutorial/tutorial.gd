extends AnimatedSprite2D

const no_animations = 5

var current_animation = 0

func _ready() -> void:
	animation = str(current_animation)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
		current_animation += 1
		
		if current_animation >= no_animations:
			get_tree().change_scene_to_file("res://game.tscn")
			return
		
		animation = str(current_animation)
