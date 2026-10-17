class_name Dude extends AnimatableBody2D

@export var left: Hand
@export var right: Hand

@export var scarf_front: Node2D
@export var scarf_back: Node2D
@export var eyepatch: Node2D
@export var eyepatch_string: Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	if randf() < 0.5:
		color_scarf(Color.WHITE)
		eyepatch.show()
		eyepatch_string.show()

func color_scarf(color: Color):
	scarf_front.self_modulate = color
	scarf_back.self_modulate = color

func _process(_delta) -> void:
	global_position = get_global_mouse_position()

	if Input.is_action_just_pressed("shoot_left"):
		left.shoot()

	if Input.is_action_just_pressed("shoot_right"):
		right.shoot()
