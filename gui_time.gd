extends Control
var time_formatted = 'not_formatted_yet'

func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	time_formatted = "%02d:%02d" % [int(int($Timer.time_left)/60),int(int($Timer.time_left)%60)]
	%Label.text = time_formatted
	%LabelTickets.text = str(GameManager.no_collected_tickets)
	
func _on_timer_timeout() -> void:
	$'../../'.lose()
	pass # Replace with function body.
