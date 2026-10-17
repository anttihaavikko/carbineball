class_name Ball extends RigidBody2D

var board: Board
var locked := false

func _ready() -> void:
	body_entered.connect(hit)

func hit(other: Node):
	if other is Dude:
		board.start()
	if other is Bumpable:
		other.bump()
