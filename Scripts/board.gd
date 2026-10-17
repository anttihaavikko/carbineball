class_name Board extends Node2D

@export var holder_left: Retractor
@export var holder_right: Retractor
@export var ball_prefab: PackedScene
@export var spawn_point: Node2D
@export var lines: LineDrawer
@export var saver_left: SaveBumper
@export var saver_right: SaveBumper
@export var saver_buttons: ButtonSet
@export var ball_lock: BallLock
@export var sun: Sunny
@export var burst: Burst
@export var cam: Camera
@export var yellow: Color
@export var red: Color

var started := false
var balls: Array[Ball] = []
var multi := 1

func _ready() -> void:
	reset()

func spawn_ball():
	create_ball(spawn_point.global_position)
	holder_left.reset()
	holder_right.reset()

func add_extra_ball():
	var ball = create_ball(ball_lock.global_position)
	ball.apply_impulse(Vector2(500, 2500))

func create_ball(pos) -> Ball:
	var ball = ball_prefab.instantiate() as Ball
	ball.global_position = pos
	ball.board = self
	add_child(ball)
	balls.append(ball)
	return ball

func apply_savers():
	saver_left.reset()
	saver_right.reset()

func start():
	if started: return
	holder_left.retract()
	holder_right.retract()

func add_score(amount: int, pos: Vector2):
	pop(str(amount * multi), pos)

func reset():
	spawn_ball()
	saver_left.retract()
	saver_right.retract()
	saver_buttons.reset()
	ball_lock.reset()
	multi = 1

func get_pop() -> String:
	return ["POP", "POW", "KAPOW", "BOOM"].pick_random()

func get_bonk() -> String:
	return ["BONK", "THUD", "SPLAT"].pick_random()

func pop(text: String, pos: Vector2, color: Color = Color.WHITE):
	var eff = Effects.singleton.pop(text, pos)
	eff.modulate = color

func increment_multi(pos: Vector2):
	multi += 1
	pop("x%d" % [multi], pos, yellow)

func die(node: Node):
	if node is Ball:
		burst.global_position = node.global_position
		cam.shake(30, 0.3)
		burst.play()
		node.queue_free()
		balls.remove_at(balls.find(node))
		if balls.size() == 0:
			await get_tree().create_timer(0.5).timeout
			call_deferred("reset")

func entered_bad_zone(node: Node):
	if node is Dude:
		if multi > 1:
			cam.shake(20, 0.2)
			pop("[font_size=60]TOUCH!", node.global_position, red)
			multi = 1
