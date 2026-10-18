extends Node

@export var scene: String
@export var blinders: Blinders

func start():
	blinders.change_scene(scene)
