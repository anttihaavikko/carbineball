class_name Ball extends RigidBody2D

var board: Board
var locked := false
var bonked := false
var last_hits: Array[Node] = []
var dupes := 0

func _ready() -> void:
	body_entered.connect(hit)

func _process(_delta) -> void:
	if global_position.y > 2500:
		board.die(self)

func hit(other: Node):
	if last_hits.has(other):
		dupes += 1
	else:
		dupes = 0
		last_hits.append(other)
	if dupes == 10:
		board.pop("[font_size=75][shake level 20]TILT WARNING!", global_position, board.red)
		board.cam.shake(10, 0.2)
	if dupes == 15:
		Effects.singleton.add_many([0, 1, 2, 3, 4], global_position)
		board.pop("[font_size=80][shake level 20]TILT!", global_position, board.red)
		board.cam.shake(20, 0.3)
		board.balls.remove_at(board.balls.find(self))
		board.reset_after(1.0)
		queue_free()
		return
	if last_hits.size() > 2: last_hits.pop_front()
	var mid = (global_position + other.global_position) * 0.5;
	if other is not FakeParticle and linear_velocity.length() > 100:
		Effects.singleton.add(4, global_position)
	if other is Sunny:
		var bonus = board.bonus_game == Board.BonusGame.SunnyBumpers
		if bonus: board.bonus_pop(mid, true)
		board.increment_multi(mid, 5 if bonus else 1)
		board.cam.shake(7, 0.12)
		board.ball_lock.toggle()
	if other is Dude:
		if bonked:
			board.pop("[font_size=40]%s!" % [board.get_bonk()], mid)
		else:
			board.increment_multi(mid)
		bonked = true
		board.cam.shake(7, 0.12)
		board.start()
	if other is Bumpable:
		if other.score > 0:
			board.add_score(other.score, mid)
			board.cam.shake(5, 0.1)
		other.bump()
