class_name Ball extends RigidBody2D

@export var visuals: Array[Node2D]
@export var shapes: Array[Node2D]
@export var face: Face
@export var brow: Node2D

var board: Board
var locked := false
var bonked := false
var last_hits: Array[Node] = []
var dupes := 0
var current: Personality = Personality.Broll

enum Personality {
	Broll,
	Skull,
	Starll,
	Diaball
}

static func get_title(p: Personality) -> String:
	return [
		"Broll",
		"Skull",
		"Starll",
		"Diaball"
	][p]

static func get_desc(p: Personality, is_locked: bool) -> String:
	if is_locked:
		var desc = [
			"None",
			"Die",
			"Multiball",
			"Have (666) appear in your (score)"
		][p]
		return "[color=#F1E8B8]UNLOCK METHOD[/color]: %s" % [desc]

	return [
		"A sentient (friendly) ball. No (special) powers.",
		"(Bumps) increase (multiplier) by your (death) amount.",
		"Gains an (extra ball) to all (multi ball) events.",
		"(Doubles) your (score) if the (carousel) reads (666)."
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
	brow.visible = personality == Personality.Diaball

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
		board.unlock_character(Dude.Personality.Loon)
		if board.dude_personality == Dude.Personality.Loon: board.balls_left += 1
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
		var is_loon = board.dude_personality == Dude.Personality.Loon
		if board.dude_personality == Dude.Personality.Starchild and other.global_position.y < 560 and board.multi > 1:
			board.reset_multi()
			board.cam.shake(20, 0.2)
			var msg = ["TOO HIGH!", "SCARY!", "VERTIGO!", "SO HIGH!", "SCARY HIGH!"].pick_random()
			board.reset_multi_with_message(msg, global_position)
			return
		if bonked or is_loon:
			if is_loon and board.multi > 1:
				var msg = ["EWW!", "ONLY SHOOT!", "NO TOUCH!", "JUST BULLETS!"].pick_random()
				board.reset_multi_with_message(msg, global_position)
			else:
				board.pop("[font_size=40]%s!" % [board.get_bonk()], mid)
		else:
			do_notes()
			board.increment_multi(mid, board.deaths if board.ball_personality == Ball.Personality.Skull else 1)
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
	board.deaths += 1
	SoundEffects.singleton.add(7, global_position)
	SoundEffects.singleton.add(8, global_position)
	SoundEffects.singleton.add(15, global_position)
