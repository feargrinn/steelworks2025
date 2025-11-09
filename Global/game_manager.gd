extends Node

const GAME_LENGTH := 300.0
var time_left := 300.0
var no_collected_tickets: int = 0
var currently_selected_person: Person = null
var high_score : int

var machines: Dictionary[int, StationStats]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists("user://save") == false:
		var file = FileAccess.open("user://save", FileAccess.WRITE)
		file.store_string('0')
		file.close()
	pass # Replace with function body.

func set_selected_person(person: Person):
	if currently_selected_person:
		currently_selected_person.deselect()
	currently_selected_person = person
	if person:
		person.select()
