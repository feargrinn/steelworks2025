extends Control

class_name Gui

var time_formatted = 'not_formatted_yet'

func _process(_delta: float) -> void:
	%LabelTickets.text = str(GameManager.no_collected_tickets)

func show_time(time_left: float):
	@warning_ignore("integer_division")
	time_formatted = "%02d:%02d" % [int(int(time_left)/60),int(int(time_left)%60)]
	%Label.text = time_formatted
