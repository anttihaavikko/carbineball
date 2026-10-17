class_name Ball extends RigidBody2D

var board: Board
var locked := false
var bonked := false

func _ready() -> void:
	body_entered.connect(hit)

func _process(_delta) -> void:
	if global_position.y > 2500:
		board.die(self)

func hit(other: Node):
	var mid = (global_position + other.global_position) * 0.5;
	if other is not FakeParticle and linear_velocity.length() > 100:
		Effects.singleton.add(4, global_position)
	if other is Sunny:
		board.increment_multi(mid)
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
