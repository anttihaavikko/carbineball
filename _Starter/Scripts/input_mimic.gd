class_name InputMimic extends Label

@export var input: LineEdit

func _ready() -> void:
	text = input.text
	input.text_changed.connect(text_changed)
	input.focus_exited.connect(focus_exited)

func text_changed(content: String) -> void:
	text = content

func focus_exited() -> void:
	text = input.text
