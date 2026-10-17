class_name Flasher extends Node

@export var use_material: Material
@export var nodes: Array[Node2D]
@export var hide_nodes: Array[Node2D]
@export var duration := 0.075

var defaults: Dictionary[Node2D, Defaults] = {}
var active := false

func do_node(node: Node2D) -> void:
	defaults[node] = Defaults.new(node.material, node.modulate, node.self_modulate)
	if node is Line2D: defaults[node].default_color = node.default_color
	node.material = use_material
	node.modulate = Color.WHITE
	node.self_modulate = Color.WHITE
	if node is Line2D: node.default_color = Color.WHITE
	if node is Flashable:
		for sub_node in node.nodes:
			do_node(sub_node)

func undo_node(node: Node2D) -> void:
	node.material = defaults[node].material
	node.modulate = defaults[node].modulate
	node.self_modulate = defaults[node].self_modulate
	if node is Line2D: node.default_color = defaults[node].default_color
	if node is Flashable:
		for sub_node in node.nodes:
			undo_node(sub_node)

func flash() -> void:
	if active: return

	active = true
	for node in nodes:
		do_node(node)

	for node in hide_nodes:
		node.hide()

	await get_tree().create_timer(duration).timeout

	for node in nodes:
		undo_node(node)

	for node in hide_nodes:
		node.show()

	active = false

class Defaults:
	var material: Material
	var modulate: Color
	var self_modulate: Color
	var default_color: Color

	func _init(mat: Material, m: Color, sm: Color) -> void:
		material = mat
		modulate = m
		self_modulate = sm
