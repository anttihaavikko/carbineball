@tool
extends EditorPlugin

var dock
var button: Button
var label: Label

func _enter_tree():
	dock = preload("res://addons/info/info_inspector.gd").new()
	add_inspector_plugin(dock)
#	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
#	label = dock.get_node("VBoxContainer/Label")
#	button = dock.get_node("VBoxContainer/Button")
#	button.button_up.connect(_update)

func _exit_tree():
	remove_inspector_plugin(dock)
	
func _update():
	label.text = "Effects:\n--------------------"
	var i := 0
	for e in Effects.singleton.effects:
		label.text += "%d: %s" % [1, e.resource_name]
		i += 1
