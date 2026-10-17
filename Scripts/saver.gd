class_name SaveBumper extends Retractor

@export var area: Area2D

signal used

func _ready() -> void:
	area.body_entered.connect(enter)

func enter(node: Node):
	if retracted: return

	if node is Ball:
		node.linear_velocity = Vector2.ZERO
		node.apply_impulse(Vector2.UP * 2500)
		retract()
		used.emit()
