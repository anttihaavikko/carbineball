class_name Wrapper extends Node

@export var board: Board
@export var dude: Dude
@export var moves := true

func _ready() -> void:
	dude.moves = moves
