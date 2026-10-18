class_name Sunny extends Node2D

@export var left: HandSwap
@export var right: HandSwap
@export var face: Face
@export var brow: Node2D

var sequence := 0
var left_origin: Vector2
var right_origin: Vector2
var left_rot: float
var right_rot: float
var emoting := false

func _ready() -> void:
	left_origin = left.global_position
	right_origin = right.global_position
	left_rot = left.rotation
	right_rot = right.rotation

func angry():
	if emoting: return
	emoting = true
	brow.show()
	var mouth = face.mouth
	if mouth is Sprite2D: mouth.flip_v = true
	move_hand(true, global_position + Vector2(-200, -120), 0)
	move_hand(false, global_position + Vector2(200, -120), 0)
	change_hand(true, HandSwap.HandSprite.Palm)
	change_hand(false, HandSwap.HandSprite.Palm)
	await get_tree().create_timer(1.75).timeout
	if mouth is Sprite2D: mouth.flip_v = false
	brow.hide()
	emoting = false
	reset_hand(true)
	reset_hand(false)

func point_at_mouse():
	point(get_global_mouse_position())

func point(pos: Vector2):
	if emoting: return
	var use_left = sequence % 2 == 0
	var tip = pos.move_toward(global_position, 200)
	var angle = global_position.angle_to_point(pos) + PI * 0.5
	change_hand(use_left, HandSwap.HandSprite.Pointer)
	move_hand(use_left, tip, angle)
	sequence += 1
	await get_tree().create_timer(0.5).timeout
	reset_hand(use_left)

func change_hand(use_left: bool, target: HandSwap.HandSprite):
	var hand = left if use_left else right
	hand.change(target)

func move_hand(use_left: bool, pos: Vector2, angle: float):
	var hand = left if use_left else right
	get_tree().create_tween().tween_property(hand, "global_position", pos, 0.1).set_trans(Tween.TRANS_QUAD)
	get_tree().create_tween().tween_property(hand, "rotation", angle, 0.3).set_trans(Tween.TRANS_BOUNCE)

func reset_hand(use_left: bool):
	if emoting: return
	var hand = left if use_left else right
	var origin = left_origin if use_left else right_origin
	var rot = left_rot if use_left else right_rot
	get_tree().create_tween().tween_property(hand, "global_position", origin, 0.5).set_trans(Tween.TRANS_QUAD)
	get_tree().create_tween().tween_property(hand, "rotation", rot, 0.3).set_trans(Tween.TRANS_BOUNCE)
	hand.change(HandSwap.HandSprite.Shrug)
