class_name Board extends Node2D

@export var holder_left: Retractor
@export var holder_right: Retractor
@export var ball_prefab: PackedScene
@export var spawn_point: Node2D
@export var lines: LineDrawer
@export var saver_left: SaveBumper
@export var saver_right: SaveBumper
@export var saver_buttons: ButtonSet

var started := false
var balls: Array[Ball] = []

func _ready() -> void:
	reset()

func spawn_ball():
	var ball = ball_prefab.instantiate() as Ball
	ball.global_position = spawn_point.global_position
	ball.board = self
	add_child(ball)
	balls.append(ball)

func apply_savers():
	saver_left.reset()
	saver_right.reset()

func start():
	if started: return
	holder_left.retract()
	holder_right.retract()

func reset():
	spawn_ball()
	holder_left.reset()
	holder_right.reset()
	saver_left.retract()
	saver_right.retract()
	saver_buttons.reset()

func die(node: Node):
	if node is Ball:
		node.queue_free()
		balls.remove_at(balls.find(node))
		if balls.size() == 0:
			call_deferred("reset")
