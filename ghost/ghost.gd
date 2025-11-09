class_name Ghost
extends Area2D

@export var SPEED: int = 100

@onready var node_to_follow: Node2D = get_tree().get_nodes_in_group("person").pick_random()
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var fade_animation: AnimationPlayer = $AnimationPlayer
const material_hover := preload("res://materials/person.tres")
var dead: bool = false

func _physics_process(delta: float) -> void:
	if dead: return
	
	var goal = node_to_follow.global_position if node_to_follow else get_viewport_rect().get_center()
	var direction := (goal - global_position).normalized()
	
	if direction.x > 0.0: sprite_animation.flip_h = true
	else: sprite_animation.flip_h = false
	
	if (goal - global_position).length_squared() < pow(SPEED * delta, 2):
		global_position = goal
		return
	global_position += direction * SPEED * delta


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dead = true
			AudioManager.play_sfx("ghost_death")
			sprite_animation.animation = "death"
			fade_animation.current_animation = "death"
			

func _dispose(): # Called from death animation
	queue_free()

func _on_mouse_entered() -> void:
	sprite_animation.material = material_hover


func _on_mouse_exited() -> void:
	sprite_animation.material = null
