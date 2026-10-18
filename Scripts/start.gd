extends Node

@export var scene: String
@export var blinders: Blinders

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func start():
	blinders.change_scene(scene)
