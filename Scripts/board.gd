class_name Board extends Node2D

@export var holder_left: Retractor
@export var holder_right: Retractor

var started := false

func start():
	if started: return
	holder_left.retract()
	holder_right.retract()
