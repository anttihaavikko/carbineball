class_name Wrapper extends Node

@export var board: Board
@export var dude: Dude
@export var moves := true
@export var looker: Looker

func _ready() -> void:
	dude.moves = moves
	if looker: looker.board = board
