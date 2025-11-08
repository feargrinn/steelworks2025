extends CharacterBody2D

class_name Person

@export var id: int = 0 # Maybe unnecessary
@export var scary_distance: float = 100
@export var person_stats: PersonStats

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var irritability_display: IrritabilityDisplay = $IrritabilityDisplay
@onready var moni_label: Label = $MoniLabel

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
	if Input.is_action_just_pressed("left_click") and highlighted:
		GameManager.currently_selected_person = self
	
	var ghosts := get_tree().get_nodes_in_group("ghost")
	ghosts.sort_custom(
		func(ghost1: Node2D, ghost2: Node2D): return (position - ghost1.position).length() < (position - ghost2.position).length())
	if len(ghosts) > 0 and (position - ghosts[0].position).length() < scary_distance:
		var dir = ghosts[0].position.direction_to(position)
		dir = dir if not dir.length() == 0 else Vector2.from_angle(randf_range(0, 2*PI))
		velocity = dir * person_stats.speed
		move_and_slide()
	elif not navigation_agent_2d.is_navigation_finished():
		var dir := to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = dir * person_stats.speed
		move_and_slide()

func set_target_position(target_position: Vector2) -> void:
	navigation_agent_2d.target_position = target_position


func indicate_not_enough_coins() -> void:
	var tween = moni_label.create_tween()
	moni_label.modulate.a = 1
	tween.tween_property(moni_label, "modulate:a", 0, 1)
	tween.tween_callback(tween.kill)

func _on_mouse_click_detection_mouse_entered() -> void:
	highlighted = true
	animated_sprite_2d.material = outline_material

func _on_mouse_click_detection_mouse_exited() -> void:
	highlighted = false
	animated_sprite_2d.material = null
