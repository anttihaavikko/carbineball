class_name Bumpable extends CollisionObject2D

@export var score := 0

signal hit

func bump():
	hit.emit()
