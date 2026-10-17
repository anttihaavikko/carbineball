
class_name Looker extends Node2D

@export var distance := 10
@export var board: Board

var target: Node2D
var original_pos: Vector2
var target_pos: Vector2
var look_speed := 1.0
var ignore_target := true

func _ready() -> void:
	original_pos = position

func _process(delta: float) -> void:
	if not target:
		if board.balls.size() > 0: target = board.balls[0]
		return
	var pos := target.global_position
	target_pos = original_pos.move_toward(to_local(pos), delta * 60 * 100).normalized() * distance
	position = position.move_toward(target_pos, delta * 300 * look_speed)
