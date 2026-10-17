extends AnimationPlayer

@export var min_speed := 0.9
@export var max_speed := 1.1

func _ready() -> void:
	speed_scale = randf_range(min_speed, max_speed)
