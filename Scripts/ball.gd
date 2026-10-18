class_name Ball extends RigidBody2D

@export var visuals: Array[Node2D]
@export var shapes: Array[Node2D]
@export var face: Face

var board: Board
var locked := false
var bonked := false
var last_hits: Array[Node] = []
var dupes := 0
var current: Personality = Personality.Broll

enum Personality {
	Broll,
	Skull,
	Starll
}

static func get_title(p: Personality) -> String:
	return [
		"Broll",
		"Skull",
		"Starll"
	][p]

static func get_desc(p: Personality, is_locked: bool) -> String:
	if is_locked:
		var desc = [
			"None",
			"Die",
			"Multiball"
		][p]
		return "[color=#F1E8B8]UNLOCK METHOD[/color]: %s" % [desc]

	return [
		"A sentient friendly ball. No special powers.",
		"Lorem ipsum dolor.",
		"Loremer imsumer dolorer."
	][p]

func _ready() -> void:
	body_entered.connect(hit)

func _process(_delta) -> void:
	if global_position.y > 2500:
		board.die(self)

func use(personality: Personality):
	visuals[current].hide()
	shapes[current].disabled = true
	current = personality
	visuals[current].show()
	shapes[current].disabled = false
	face.visible = personality != Personality.Skull

func hit(other: Node):
	if linear_velocity.length() > 40:
		SoundEffects.singleton.add(3, global_position, minf(linear_velocity.length() * 0.005, 1))
	if last_hits.has(other):
		dupes += 1
	else:
		dupes = 0
		last_hits.append(other)
	if dupes == 10 and board.started:
		board.pop("[font_size=75][shake level 20]TILT WARNING!", global_position, board.red)
		board.cam.shake(10, 0.2)
	if dupes == 15 and board.started:
		Effects.singleton.add_many([0, 1, 2, 3, 4], global_position)
		board.pop("[font_size=80][shake level 20]TILT!", global_position, board.red)
		board.cam.shake(20, 0.3)
		board.balls.remove_at(board.balls.find(self))
		board.reset_after(1.0)
		die()
		queue_free()
		return
	if last_hits.size() > 2: last_hits.pop_front()
	var mid = (global_position + other.global_position) * 0.5;
	if other is not FakeParticle and linear_velocity.length() > 100:
		Effects.singleton.add(4, global_position)
	if other is Sunny:
		SoundEffects.singleton.add(4, global_position)
		var bonus = board.bonus_game == Board.BonusGame.SunnyBumpers
		if bonus: board.bonus_pop(mid, true)
		board.increment_multi(mid, 5 if bonus else 1)
		board.cam.shake(7, 0.12)
		do_notes()
		board.ball_lock.toggle()
	if other is Dude:
		if bonked:
			board.pop("[font_size=40]%s!" % [board.get_bonk()], mid)
		else:
			do_notes()
			board.increment_multi(mid)
		bonked = true
		board.cam.shake(7, 0.12)
		board.start()
	if other is Bumpable:
		SoundEffects.singleton.add(4, global_position)
		if other.score > 0:
			board.add_score(other.score, mid)
			board.cam.shake(5, 0.1)
		other.bump()

func do_notes():
	board.do_notes(global_position)

func die():
	SoundEffects.singleton.add(7, global_position)
	SoundEffects.singleton.add(8, global_position)
	SoundEffects.singleton.add(15, global_position)
