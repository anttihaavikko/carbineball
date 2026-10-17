class_name Ball extends RigidBody2D

var board: Board
var locked := false

func _ready() -> void:
	body_entered.connect(hit)

func _process(_delta) -> void:
	if global_position.y > 2500:
		board.die(self)

func hit(other: Node):
	var mid = (global_position + other.global_position) * 0.5;
	if other is Dude:
		board.pop("666", mid)
		board.start()
	if other is Bumpable:
		if other.score > 0:
			board.add_score(other.score, mid)
			board.cam.shake(5, 0.1)
		other.bump()
