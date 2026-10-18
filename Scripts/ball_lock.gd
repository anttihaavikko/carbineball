class_name BallLock extends Node2D

@export var area: Area2D
@export var board: Board
@export var markers: Array[Node2D]
@export var label: RichTextLabel
@export var count_label: RichTextLabel
@export var off_color := Color(0.25, 0.25, 0.25)
@export var left_trigger: BumperButton
@export var right_trigger: BumperButton

var balls := 0
var mid := false
var left := false
var right := false
var spawning := false
var multiball_duration := 0.0

func _ready() -> void:
	area.body_entered.connect(enter)
	left_trigger.used.connect(hit_trigger)
	right_trigger.used.connect(hit_trigger)
	# await get_tree().create_timer(5).timeout
	# left_trigger.state = true
	# right_trigger.state = true
	# hit_trigger()

func _process(delta) -> void:
	if board.balls.size() > 1:
		multiball_duration += delta

func hit_trigger():
	if spawning: return
	if left_trigger.state and right_trigger.state:
		multiball_duration = 0
		spawning = true
		for i in balls:
			await get_tree().create_timer(0.7).timeout
			board.add_extra_ball()
			balls -= 1
			toggle_markers()
		spawning = false
		reset()

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
	if is_enabled():
		var msg = ["ONLINE!", "WELCOME!", "PLEASE!", "AWAITING!"].pick_random()
		board.pop(msg, global_position, board.yellow)
	label.text = "[wave]LOCK ONLINE" if is_enabled() else "LOCK OFFLINE"
	count_label.text = str(balls) + (" BALL" if balls == 1 else " BALLS")
	var can_start = balls > 0
	count_label.modulate = Color.BLACK if can_start else off_color
	label.modulate = Color.BLACK if is_enabled() else off_color
	left_trigger.locked = !can_start
	right_trigger.locked = !can_start
	left_trigger.label.visible = can_start
	right_trigger.label.visible = can_start

func reset():
	left = false
	mid = false
	right = false
	left_trigger.toggle(false)
	right_trigger.toggle(false)
	toggle_markers()

func is_enabled() -> bool:
	return mid and left and right

func enter(node: Node):
	if not is_enabled(): return

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
