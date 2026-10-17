extends Node2D

@export var bumper1: RichTextLabel
@export var bumper2: RichTextLabel
@export var bumper3: RichTextLabel
@export var board: Board

var angle := 0.0
var values := [1, 1, 1]
var cur := 0
var cooling := 0.0

func score(bumper: Node2D):
	if cooling > 0: return
	var sum = values[0] * values[1] * values[2]
	board.add_score(roundi(pow(sum, 2)), bumper.global_position)
	cooling = 0.1

func _process(delta) -> void:
	cooling -= delta

func increment(_node: Node2D):
	values[cur] = (values[cur] + 1) % 9 + 1
	update_labels()

func rotate_right():
	change(1)
	angle += 120
	do_rotate()

func rotate_left():
	change(-1)
	angle -= 120
	do_rotate()

func change(dir: int):
	cur += dir
	if cur < 0: cur = 2
	if cur > 2: cur = 0

func do_rotate():
	get_tree().create_tween().tween_property(self, "rotation_degrees", angle, 0.5).set_trans(Tween.TRANS_QUAD)
	for label in [bumper1, bumper2, bumper3]:
		get_tree().create_tween().tween_property(label, "rotation_degrees", -angle, 0.3).set_trans(Tween.TRANS_QUAD)

func update_labels():
	bumper1.text = str(values[0])
	bumper2.text = str(values[1])
	bumper3.text = str(values[2])
