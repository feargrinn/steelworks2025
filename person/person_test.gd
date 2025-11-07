extends Node2D
@onready var person: Person = $Person

func _physics_process(_delta: float) -> void:
	person.set_target_position(get_global_mouse_position())
