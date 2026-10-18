class_name Hand extends Node2D

@export var gun: Node2D
@export var flip := 1
@export var ray: RayCast2D
@export var wrapper: Wrapper
@export var lines: LineDrawer
@export var root: Node2D
@export var fill: Node2D
@export var zero_angle := 0.0

var origin: Vector2
var gun_rot: float
var cooling := 0.0

func _ready() -> void:
	origin = position
	gun_rot = gun.rotation

func toggle_visibility(state: bool):
	root.visible = state
	fill.visible = state

func _process(delta) -> void:
	cooling -= delta
	var board = wrapper.board
	if board and board.dude_personality == Dude.Personality.Loon and board.balls.size() > 0:
		var ball = board.balls[0]
		gun.rotation_degrees = zero_angle
		look_at(ball.global_position)

func shoot():
	if cooling > 0: return

	cooling = 0.2

	ray.force_raycast_update()
	if ray.is_colliding():
		SoundEffects.singleton.add(0, global_position, 1.1)
		var board = wrapper.board
		# board.sun.point(ray.global_position)
		var hit = ray.get_collider()
		var cp = ray.get_collision_point()
		lines.add(ray.global_position, cp)
		Effects.singleton.add_many([1, 3], cp)
		board.cam.shake(10, 0.1)
		if hit is Ball:
			if hit.locked: return
			var dir = cp - ray.global_position
			hit.apply_impulse(dir.normalized() * 2500)
			Effects.singleton.add_many([2, 4], cp)
			board.start()
			var is_loon = board.dude_personality == Dude.Personality.Loon
			if hit.bonked:
				board.pop("[font_size=40]%s!" % [board.get_pop()], cp, board.yellow)
			if is_loon:
				board.pop("[font_size=40]%s!" % [board.get_pop()], cp + Vector2.UP * 10)
				board.increment_multi(cp + Vector2.DOWN * 20, 1)
			hit.bonked = false
	recoil()

func recoil():
	position = position + Vector2(20 * flip, 15)
	gun.rotate(flip * 0.3)
	await get_tree().create_timer(0.2).timeout
	get_tree().create_tween().tween_property(self, "position", origin, 0.2).set_trans(Tween.TRANS_BOUNCE)
	get_tree().create_tween().tween_property(gun, "rotation", gun_rot, 0.2).set_trans(Tween.TRANS_BOUNCE)
