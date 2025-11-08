class_name PersonMachineStats
extends Resource

@export_range(0, 1, 0.01) var win_chance := 0.5
@export_range(0, 100) var irritation_on_loss := 50
## This is -irritation
@export_range(10, 100) var satisfaction_on_win := 60
