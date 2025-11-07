extends Node

var no_collected_tickets: int = 0
var currently_selected_person: Node2D = null
var pause_screen = preload("res://UI/pause.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('pause'):
		add_child(pause_screen.instantiate())
		get_tree().paused = true
