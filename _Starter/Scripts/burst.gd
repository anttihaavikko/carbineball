class_name Burst extends Node2D

@export var hide_chance := 0.3

var lines: Array[Line2D]

func _ready() -> void:
	for c in get_children():
		if c is Line2D:
			lines.append(c)

func play() -> void:
	for line in lines: animate(line)
	get_tree().create_tween().tween_property(self, "rotation_degrees", randf_range(-5, 5), 0.2).set_trans(Tween.TRANS_SPRING)

func animate(line: Line2D):
	if randf() < hide_chance: return
	var w := line.width
	line.width = 0
	line.show()
	get_tree().create_tween().tween_property(line, "width", w, 0.1).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(0.2).timeout
	get_tree().create_tween().tween_property(line, "width", 0, 0.3).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(0.3).timeout
	line.hide()
	line.width = w
