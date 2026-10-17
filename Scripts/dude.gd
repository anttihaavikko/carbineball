class_name Dude extends AnimatableBody2D

@export var left: Hand
@export var right: Hand

func _process(_delta) -> void:
	global_position = get_global_mouse_position()

	if Input.is_action_just_pressed("shoot_left"):
		left.shoot()

	if Input.is_action_just_pressed("shoot_right"):
		right.shoot()
