class_name Retractor extends Node2D

@export var body: StaticBody2D

var layers: int

func _ready() -> void:
	layers = body.collision_layer

func retract():
	modulate.a = 0.25
	body.collision_layer = 0

func reset():
	modulate.a = 1
	body.collision_layer = layers
