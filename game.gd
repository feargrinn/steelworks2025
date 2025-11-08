extends Node2D


# Called when the node enters the scene tree for the first time.
	
	
func _process(delta: float) -> void:
	if GameManager.no_collected_tickets >= 1000:
		win()



func win():
	var time_node = get_node("GuiTime").time_formatted
	print('you won!!! time left:' + time_node)
		
func lose():
	print('huh you lost. Lser')
