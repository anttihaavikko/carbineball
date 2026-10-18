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
@export var help_message: RichTextLabel
@export var score_label: RichTextLabel
@export var multi_label: RichTextLabel
@export var bonus_game_display: RichTextLabel
@export var balls_label: RichTextLabel

var started := false
var max_multi := 100
var balls: Array[Ball] = []
var multi := 1
var balls_left := 3
var score = 0
var bonus_game: BonusGame
var bonuses := [
	BonusGame.Carousel,
	BonusGame.SunnyBumpers,
	BonusGame.MultiBall
]

enum BonusGame {
	Carousel,
	SunnyBumpers,
	MultiBall
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	reset()
	bonuses.shuffle()
	change_bonus()

func change_bonus():
	bonus_game = bonuses.pop_front()
	bonuses.push_back(bonus_game)
	var game_name = [
		"Carousel",
		"Sunny Bumpers",
		"Multi Ball"
	][bonus_game]
	bonus_game_display.text = "BONUS GAME:\n%s" % [game_name]
	await get_tree().create_timer(30).timeout
	change_bonus()
	if started: pop("NEW BONUS GAME!", spawn_point.global_position + Vector2.DOWN * 100, yellow)

func spawn_ball():
	started = false
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
	help_message.text = "Okay, here we go!"
	holder_left.retract()
	holder_right.retract()
	started = true

func bonus_pop(pos: Vector2, for_multi: bool = false):
	pop("[font_size=35]BONUS INCREASE!", pos + Vector2.UP * 25, Color.WHITE if for_multi else yellow)

func add_score(amount: int, pos: Vector2, source: BonusGame = BonusGame.SunnyBumpers):
	var multiball_bonus = bonus_game == BonusGame.MultiBall and balls.size() > 1
	var extra = 10 if source == bonus_game or multiball_bonus else 1
	var amt = amount * multi * extra * balls.size()
	if extra > 1: bonus_pop(pos)
	pop(Utils.as_score(amt), pos)
	score += amt
	score_label.text = Utils.as_score(score)

func reset_after(delay: float):
	await get_tree().create_timer(delay).timeout
	next()

func reset():
	spawn_ball()
	saver_left.retract()
	saver_right.retract()
	saver_buttons.reset()
	ball_lock.reset()
	multi = 1
	show_multi()
	bonuses.shuffle()
	started = false

func show_multi():
	multi_label.text = "x%d" % [multi]

func get_pop() -> String:
	return ["POP", "POW", "KAPOW", "BOOM"].pick_random()

func get_bonk() -> String:
	return ["BONK", "THUD", "SPLAT"].pick_random()

func pop(text: String, pos: Vector2, color: Color = Color.WHITE):
	var eff = Effects.singleton.pop("[wave]%s" % [text], pos)
	eff.modulate = color

func increment_multi(pos: Vector2, amount: int = 1):
	if multi >= max_multi:
		pop("MAX MULTI!", pos, yellow)
		return
	multi = mini(multi + amount, max_multi)
	pop("x%d" % [multi], pos, yellow)
	show_multi()

func next():
	balls_left -= 1

	balls_label.text = ""
	for b in balls_left:
		balls_label.text += "•"

	if balls_left == 0:
		help_message.text = "GAME OVER!"
		return
	var left = "got 1 more ball" if balls_left == 1 else "still got %d balls" % [balls_left]
	help_message.text = "Aww, too bad!\nBut you've %s left..." % [left]
	reset()

func die(node: Node):
	if node is Ball:
		burst.global_position = node.global_position
		cam.shake(30, 0.3)
		burst.play()
		node.queue_free()
		balls.remove_at(balls.find(node))
		if balls.size() == 1 and not ball_lock.spawning:
			help_message.text = "Multi ball maddness over! You survived for %d seconds." % [roundi(ball_lock.multiball_duration)]
		if balls.size() == 0 and not ball_lock.spawning:
			await get_tree().create_timer(0.5).timeout
			call_deferred("next")

func entered_bad_zone(node: Node):
	if node is Dude:
		if multi > 1:
			cam.shake(20, 0.2)
			var msg = ["TOUCH", "TOO CLOSE", "WATCH IT", "KEEP THE DISTANCE", "TOUCHED", "BAD TOUCH", "NO TOUCHING", "FLEW TOO CLOSE"].pick_random()
			pop("[font_size=60][shake level=20]%s!" % [msg], node.global_position, red)
			sun.angry()
			multi = 1
