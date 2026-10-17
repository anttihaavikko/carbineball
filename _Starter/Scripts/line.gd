@tool
extends Line2D

@export var targets: Array[Node2D]
@export var bezier := false
@export var per_segment := 5

func _process(_delta: float) -> void:
	var limit = floori(targets.size() / 2.0 * (per_segment - 1) + 1) if bezier else targets.size()
	if points.size() < limit:
		add_point(Vector2.ZERO)
		return

	if bezier:
		for i in range(floori(targets.size() / 2.0)):
			for p in range(per_segment + 1):
				var t = p * 1.0 / per_segment;
				var start = targets[i * 2].global_position
				var mid = targets[i * 2 + 1].global_position
				var end = targets[i * 2 + 2].global_position
				var pos = pow(1 - t, 2) * start + 2 * (1 - t) * t * mid + pow(t, 2) * end;
				set_point_position(i * per_segment + p, pos - global_position);
	else:
		for i in range(targets.size()):
			set_point_position(i, to_local(targets[i].global_position) - to_local(global_position))
