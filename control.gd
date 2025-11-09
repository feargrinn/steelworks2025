extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lb_file = FileAccess.open("user://leaderboard", FileAccess.READ) 
	var existing_lb = lb_file.get_as_text()
	var lb_array_p1 : Array = existing_lb.split('\n')
	var lb_array_p2 : Array
	for i in lb_array_p1:
		if !i == '':
			lb_array_p2.append(i.split(' '))
	lb_array_p2.sort()
	
	
	for i in lb_array_p2:
		var sep = HSeparator.new()
		var sep2 = HSeparator.new()
		var add_num = Label.new()
		add_num.text = str(i[0])
		add_num.add_theme_font_size_override('',36)
		var add_name = Label.new()
		add_name.text = str(i[1])
		add_name.add_theme_font_size_override('',36)
		
		%GridContainer.add_child(sep)
		%GridContainer.add_child(sep2)
		
		%GridContainer.add_child(add_name)
		%GridContainer.add_child(add_num)
		
		
	



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://UI/main_menu.tscn')
