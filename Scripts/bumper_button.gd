class_name BumperButton extends Node2D

@export var area: Area2D
@export var sprite: Node2D
@export var state := false
@export var locked := false
@export var in_set: ButtonSet
@export var toggles := true
@export var label: RichTextLabel

var cooling := 0.0
var origin: Vector2

signal used

func _ready() -> void:
	origin = position
	colorize()
	area.body_entered.connect(enter)
	if in_set: in_set.buttons.append(self)

func _process(delta) -> void:
	cooling -= delta

func colorize():
	sprite.modulate = Color.WHITE if state else Color(0.25, 0.25, 0.25)
	if label: label.modulate = sprite.modulate

func toggle(to: bool):
	state = to
	colorize()

func enter(node: Node):
	if cooling > 0: return

	if node is Ball:
		cooling = 0.1
		if not locked and (toggles or not state): state = !state
		if in_set: in_set.check()
		colorize()
		used.emit()
		var dir = Vector2(0, -10).rotated(rotation)
		get_tree().create_tween().tween_property(self, "position", origin + dir, 0.1).set_trans(Tween.TRANS_BOUNCE)
		await get_tree().create_timer(0.1).timeout
		get_tree().create_tween().tween_property(self, "position", origin, 0.1).set_trans(Tween.TRANS_BOUNCE)
