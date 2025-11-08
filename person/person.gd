extends CharacterBody2D

class_name Person

@export var id: int = 0 # Maybe unnecessary
@export var person_stats: PersonStats

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var irritability_display: IrritabilityDisplay = $IrritabilityDisplay

var outline_material: Material = preload("res://materials/person.tres")
var highlighted: bool = false
var is_playing: bool = false
var current_machine: GameStation = null


func _ready() -> void:
	person_stats.irritation_changed.connect(irritability_display.update_color)
	irritability_display.update_color(0)

func _physics_process(delta: float) -> void:
	if is_playing:
		if person_stats.irritation >= person_stats.patience:
			set_target_position(current_machine.go_away_position.global_position)
	else:
		person_stats.irritation -= person_stats.calming_down_speed * delta
		person_stats.irritation = max(person_stats.irritation, 0)
	if Input.is_action_just_pressed("left_click") and highlighted:
		GameManager.currently_selected_person = self
	
	if not navigation_agent_2d.is_navigation_finished():
		var dir := to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = dir * person_stats.speed
		move_and_slide()


func set_target_position(target_position: Vector2) -> void:
	navigation_agent_2d.target_position = target_position


func _on_mouse_click_detection_mouse_entered() -> void:
	highlighted = true
	animated_sprite_2d.material = outline_material

func _on_mouse_click_detection_mouse_exited() -> void:
	highlighted = false
	animated_sprite_2d.material = null
