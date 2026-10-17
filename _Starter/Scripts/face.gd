class_name Face extends Node2D

@export var left_eye: Node2D
@export var right_eye: Node2D
@export var wrapper: Node2D
@export var blushes: Node2D
@export var extra_eyes: Array[Node2D]
@export var mouth: Node2D
@export var opened_mouth: Node2D

var size: float
var removed: bool
var mouth_size: Vector2

func _ready() -> void:
	size = left_eye.scale.x
	mouth_size = opened_mouth.scale
	blink_both()

func blink_both():
	removed = false
	await get_tree().create_timer(randf_range(1, 3)).timeout
	if removed: return
	blink(left_eye)
	blink(right_eye)
	for eye in extra_eyes:
		blink(eye)
	if not removed: blink_both()

func _exit_tree() -> void:
	removed = true

func blink(eye: Node2D):
	await get_tree().create_timer(randf_range(-1, 1) * 0.2).timeout
	if removed: return
	get_tree().create_tween().tween_property(eye, "scale", Vector2(size, 0), 0.2).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(0.15).timeout
	if removed: return
	get_tree().create_tween().tween_property(eye, "scale", Vector2(size, size), 0.25).set_trans(Tween.TRANS_BOUNCE)

func set_colors(color: Color, blush: Color):
	wrapper.modulate = color
	blushes.modulate = blush

func open_mouth(duration: float = 0.3) -> void:
	mouth.hide()
	opened_mouth.scale = Vector2.ZERO
	opened_mouth.show()
	get_tree().create_tween().tween_property(opened_mouth, "scale", mouth_size, 0.1).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(duration).timeout
	get_tree().create_tween().tween_property(opened_mouth, "scale", Vector2.ZERO, 0.1).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(0.1).timeout
	mouth.show()
