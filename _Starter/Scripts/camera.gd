class_name Camera extends Camera2D

@export var rotation_amount := 0.1

var duration := 0.0
var amount := 0.0

func shake(amt: float, dur: float):
	if amt > amt and duration > 0: return
	duration = dur
	amount = amt

func _process(delta):
	if duration > 0:
		duration -= delta

	var amt := amount if duration > 0 else 0.0
	offset = Vector2.ONE.rotated(randf() * PI) * amt
	rotation_degrees = randf_range(-1, 1) * amt * rotation_amount
