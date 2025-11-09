extends Control

var highscore 

func _ready() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Label.text = str(highscore)	
	
func set_high_score(high):
	highscore = high


func _on_button_pressed() -> void:
	if $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.text == null:
		$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.edit()
	else: 
		var lb_file = FileAccess.open("user://leaderboard", FileAccess.READ_WRITE) 
		var existing_lb = lb_file.get_as_text()
		existing_lb = existing_lb  +str(highscore) +' '+ str($PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.text)
		lb_file.store_line(existing_lb)
		lb_file.flush()
		
		queue_free()
	
