class_name HealthDisplay extends Control

@export var max_hp := 10
@export var label: Label
@export var bar: ColorRect

var hp: int

func _ready() -> void:
	hp = max_hp
	update_shown()

func hurt(amount: int) -> void:
	hp = max(hp - amount, 0)
	update_shown()

func heal(amount: int) -> void:
	hp = min(hp + amount, max_hp)
	update_shown()

func is_alive() -> bool:
	return hp > 0

func update_shown() -> void:
	if label:
		label.text = "%d/%d" % [hp, max_hp]
	if bar:
		get_tree().create_tween().tween_property(bar, "scale", Vector2(clampf(hp * 1.0 / max_hp, 0, 1), 1), 0.1).set_trans(Tween.TRANS_QUAD)
