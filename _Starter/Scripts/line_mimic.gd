@tool
class_name LineMimic extends Line2D

@export var target: Line2D

func _process(_delta: float) -> void:
	if not target: return
	global_position = target.global_position
	points = target.points
