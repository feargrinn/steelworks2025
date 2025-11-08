extends Control

func _process(delta: float) -> void:
	%Label.text = "%02d:%02d" % [int(int($Timer.time_left)/60),int(int($Timer.time_left)%60)]

func _on_timer_timeout() -> void:
	#lose
	pass # Replace with function body.
