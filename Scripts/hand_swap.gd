class_name HandSwap extends Node2D

@export var sprites: Array[Node2D]

enum HandSprite {
	Pointer,
	Shrug,
	Palm,
	ThumbsUp
}

var current: Node2D

func _ready() -> void:
	current = sprites[HandSprite.Shrug]

func change(sprite: HandSprite):
	current.hide()
	current = sprites[sprite]
	current.show()
