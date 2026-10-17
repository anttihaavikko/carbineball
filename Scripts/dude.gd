class_name Dude extends AnimatableBody2D

func _process(_delta) -> void:
	global_position = get_global_mouse_position()
