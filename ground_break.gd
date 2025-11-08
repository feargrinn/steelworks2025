extends Node2D
@onready var viewport_rect = get_viewport_rect()
var get_random_down_pos := func() -> Vector2: return Vector2(
	viewport_rect.position.x + viewport_rect.size.x * randf_range(0, 1),
	viewport_rect.end.y
)
var get_random_top_pos := func() -> Vector2: return Vector2(
	viewport_rect.position.x + viewport_rect.size.x * randf_range(0, 1),
	viewport_rect.position.y
)
var get_random_right_pos := func() -> Vector2: return Vector2(
	viewport_rect.end.x, 
	viewport_rect.position.y + viewport_rect.size.y * randf_range(0, 1)
)
var get_random_left_pos := func() -> Vector2: return Vector2(
	viewport_rect.position.x,
	viewport_rect.position.y + viewport_rect.size.y * randf_range(0, 1)
)
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var start_point
	var end_point
	$Timer.wait_time = randi_range(5,15)
	
	if randi_range(0,1) == 0:
		start_point = get_random_top_pos.call()
	else:
		start_point = get_random_left_pos.call()
		
	if randi_range(0,1) == 0:
		end_point = get_random_down_pos.call()
	else:
		end_point = get_random_right_pos.call()
	
	
	var points : Array
	var midpoints : Array
	points.append(start_point)
	for i in range(randi_range(2,5)):
		midpoints.append(Vector2i(randi_range(0,1152),randi_range(0,648)))
	midpoints.sort()
	for i in midpoints:
		points.append(i)
	points.append(end_point)
	
	
	if randi_range(0,1) == 0:
		points.reverse()
	print(points)
	for i in points:
		$Path2D.curve.add_point(i)




func _process(_delta: float) -> void:
	for fakegost in get_tree().get_nodes_in_group('fake_ghost_support_club'):
		fakegost.progress += 100 * _delta
		if fakegost.progress_ratio == 1.0:
			fakegost.queue_free()
	if len(get_tree().get_nodes_in_group('fake_ghost_support_club')) == 0 and $Timer.is_stopped():
		queue_free()
		
	


func _on_spawn_cooldown_timeout() -> void:
	if !$Timer.is_stopped():
		var fakeghost = preload("res://GroundBreak/fake_ghost.tscn").instantiate()
		fakeghost.add_to_group('fake_ghost_support_club') 
		$Path2D.add_child(fakeghost)
