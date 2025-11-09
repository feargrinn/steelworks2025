extends Control


func _on_timer_timeout() -> void:
	var ground_break_loaded = load("res://GroundBreak/ground_break.tscn").instantiate()
	var time_between_waves = randi_range(20,90)
	$Timer.wait_time = time_between_waves
	add_child(ground_break_loaded)
	await ground_break_loaded.tree_exited
	$Timer.start()
	print('sjedfhvzbiasdvjzx ')
