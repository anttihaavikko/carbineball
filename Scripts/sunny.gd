class_name Sunny extends Node2D

@export var left: Node2D
@export var right: Node2D

var sequence := 0
var left_origin: Vector2
var right_origin: Vector2
var left_rot: float
var right_rot: float

func _ready() -> void:
	left_origin = left.global_position
	right_origin = right.global_position
	left_rot = left.rotation
	right_rot = right.rotation

func point(pos: Vector2):
	var use_left = sequence % 2 == 0
	var hand = left if use_left else right
	var origin = left_origin if use_left else right_origin
	var rot = left_rot if use_left else right_rot
	var tip = pos.move_toward(global_position, 200)
	get_tree().create_tween().tween_property(hand, "global_position", tip, 0.1).set_trans(Tween.TRANS_QUAD)
	# var rot_mod = -1 if use_left else 1
	# hand.look_at(tip)
	var angle = global_position.angle_to_point(pos) + PI * 0.5
	get_tree().create_tween().tween_property(hand, "rotation", angle, 0.3).set_trans(Tween.TRANS_BOUNCE)
	sequence += 1
	await get_tree().create_timer(0.5).timeout
	get_tree().create_tween().tween_property(hand, "global_position", origin, 0.5).set_trans(Tween.TRANS_QUAD)
	get_tree().create_tween().tween_property(hand, "rotation", rot, 0.3).set_trans(Tween.TRANS_BOUNCE)
