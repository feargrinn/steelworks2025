extends Node

const GAME_LENGTH := 300.0
var time_left := 300.0
var no_collected_tickets: int = 0
var currently_selected_person: Person = null
var high_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists("user://save") == false:
		var file = FileAccess.open("user://save", FileAccess.WRITE)
		file.store_string('0')
		file.close()
	pass # Replace with function body.
