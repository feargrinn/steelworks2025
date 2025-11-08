class_name IrritabilityDisplay
extends ColorRect

@export var gradient: Gradient

func update_color(irritability_percentage: float) -> void:
	color = gradient.sample(irritability_percentage)
