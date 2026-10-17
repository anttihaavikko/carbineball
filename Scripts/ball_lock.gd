class_name BallLock extends Node2D

@export var area: Area2D
@export var board: Board
@export var markers: Array[Node2D]

var balls := 0
var mid := false
var left := false
var right := false

func _ready() -> void:
	area.body_entered.connect(enter)

func toggle():
	mid = !mid
	toggle_markers()

func toggle_left():
	left = true
	toggle_markers()

func toggle_right():
	right = true
	toggle_markers()

func toggle_markers():
	markers[0].visible = mid
	markers[1].visible = right
	markers[2].visible = left

func reset():
	left = false
	mid = false
	right = false

func enter(node: Node):
	if not mid or not left or not right: return

	if node is Ball:
		node.linear_velocity = Vector2.ZERO
		node.angular_velocity = 0
		node.gravity_scale = 0
		node.locked = true
		balls += 1
		get_tree().create_tween().tween_property(node, "global_position", global_position, 0.3).set_trans(Tween.TRANS_QUAD)
		await get_tree().create_timer(0.5).timeout
		reset()
		toggle_markers()
		node.queue_free()
		await get_tree().create_timer(0.2).timeout
		board.call_deferred("spawn_ball")
