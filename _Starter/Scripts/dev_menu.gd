class_name DevMenu extends SlidingPanel

@export var container: Control
@export var button_prefab: PackedScene
@export var hotkey: String = "dev_menu"

func _ready() -> void:
	super._ready()
	if not OS.is_debug_build():
		hide()

func _process(_delta) -> void:
	if hotkey and Input.is_action_just_pressed(hotkey):
		toggle()

func add(title: String, action: Callable, icon: Texture2D = null) -> void:
	if not OS.is_debug_build(): return
	var button = button_prefab.instantiate() as Button
	if icon:
		button.icon = icon
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	container.add_child(button)
	button.text = title
	button.pressed.connect(action)
