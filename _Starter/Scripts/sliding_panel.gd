class_name SlidingPanel
extends Control

@export var direction := Vector2.RIGHT
@export var duration := 0.2
@export var in_transition: Tween.TransitionType = Tween.TRANS_BOUNCE
@export var out_transition: Tween.TransitionType = Tween.TRANS_BOUNCE
@export var backdrop: Control

var pos: Vector2
var open: bool
var can_toggle := true
var mouse_mode: Input.MouseMode
var sound := 2

signal on_toggle

func _ready():
	pos = position
	position += get_axis_size() * direction

func get_axis_size() -> float:
	return size.x if abs(direction.x) > abs(direction.y) else size.y

func toggle():
	if not can_toggle: return
	if sound >= 0 and SoundEffects.singleton.effects.size() > sound: SoundEffects.singleton.add(sound, global_position)
	pos = position if open else position - get_axis_size() * direction
	open = !open
	on_toggle.emit(open)
	if backdrop: backdrop.visible = open
	if open: mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if open else mouse_mode
	can_toggle = false
	get_tree().create_tween().tween_property(self, "position", pos if open else pos + get_axis_size() * direction, duration).set_trans(in_transition if open else out_transition)
	await get_tree().create_timer(duration).timeout
	can_toggle = true
