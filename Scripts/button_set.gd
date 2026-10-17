class_name ButtonSet extends Node2D

@export var locks := true

var buttons: Array[BumperButton] = []
signal when_all_on

func reset():
	for b in buttons:
		b.locked = false
		b.state = false
		b.colorize()

func check():
	if buttons.all(func(b: BumperButton): return b.state):
		when_all_on.emit()
		if locks:
			for b in buttons:
				b.locked = true
