class_name Dude extends AnimatableBody2D

@export var left: Hand
@export var right: Hand

@export var scarf_front: Node2D
@export var scarf_back: Node2D
@export var eyepatch: Node2D
@export var eyepatch_string: Node2D
@export var red: Color
@export var skins: Array[Node2D]
@export var colors: Array[Color]
@export var scarf_colors: Array[Color]

var moves := true

enum Personality {
	Vanillad,
	Veteran,
	Starchild
}

static func get_title(p: Personality) -> String:
	return [
		"Vanillad",
		"Veteran",
		"Starchild"
	][p]

static func get_desc(p: Personality, locked: bool) -> String:
	if locked:
		var desc = [
			"None",
			"Achieve a score of a million",
			"Survive 30 seconds of multi ball"
		][p]
		return "[color=#F1E8B8]UNLOCK METHOD[/color]: %s" % [desc]

	return [
		"Basic (grunt). Nothing (special) about him.",
		"Can only operate (one gun), but has (2x) the (max multiplier).",
		"Ironically (afraid) of (heights). Can freely (hug) the (sun)."
	][p]

func use(personality: Personality):
	var is_vet = personality == Personality.Veteran
	eyepatch.visible = is_vet
	eyepatch_string.visible = is_vet
	color_scarf(scarf_colors[personality])
	right.toggle_visibility(not is_vet)
	for s in skins: s.self_modulate = colors[personality]

func color_scarf(color: Color):
	scarf_front.self_modulate = color
	scarf_back.self_modulate = color

func _process(_delta) -> void:
	if not moves: return
	global_position = get_global_mouse_position()

	if Input.is_action_just_pressed("shoot_left") and left.root.visible:
		left.shoot()

	if Input.is_action_just_pressed("shoot_right") and right.root.visible:
		right.shoot()
