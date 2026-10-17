class_name Bumpable extends CollisionObject2D

@export var score := 0
@export var visuals: Node2D

signal hit

func bump():
	hit.emit(self)
	if not visuals: return
	get_tree().create_tween().tween_property(visuals, "scale", Vector2.ONE * 1.1, 0.1).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(0.1).timeout
	get_tree().create_tween().tween_property(visuals, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_QUAD)
