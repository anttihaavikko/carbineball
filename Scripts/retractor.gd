class_name Retractor extends Node2D

@export var body: StaticBody2D

var layers: int
var retracted := false

func _ready() -> void:
	layers = body.collision_layer

func retract():
	modulate.a = 0.25
	if body: body.collision_layer = 0
	retracted = true

func reset():
	modulate.a = 1
	if body: body.collision_layer = layers
	retracted = false
