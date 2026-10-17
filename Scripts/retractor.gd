class_name Retractor extends Node2D

@export var body: StaticBody2D

func retract():
	modulate.a = 0.25
	body.collision_layer = 0
