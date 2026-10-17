extends Node2D

var angle := 0.0

func rotate_right():
	angle += 120
	do_rotate()

func rotate_left():
	angle -= 120
	do_rotate()

func do_rotate():
	get_tree().create_tween().tween_property(self, "rotation_degrees", angle, 0.5).set_trans(Tween.TRANS_QUAD)
