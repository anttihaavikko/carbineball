class_name Ball extends RigidBody2D

var board: Board
var locked := false

func _ready() -> void:
	body_entered.connect(hit)

func _process(_delta) -> void:
	if global_position.y > 2500:
		board.die(self)

func hit(other: Node):
	if other is Dude:
		board.start()
	if other is Bumpable:
		other.bump()
