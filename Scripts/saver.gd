class_name SaveBumper extends Retractor

@export var area: Area2D

signal used

func _ready() -> void:
	area.body_entered.connect(enter)

func enter(node: Node):
	if retracted: return

	if node is Ball:
		node.linear_velocity = Vector2.ZERO
		var msg = ["SPROING!", "SWOOSH!", "HUUMPH!", "OOMPH!"].pick_random()
		node.board.pop(msg, node.global_position)
		node.apply_impulse(Vector2.UP * 2500)
		retract()
		used.emit()
		SoundEffects.singleton.add(11, global_position, 1.2)
		node.board.cam.shake(15, 0.2)
