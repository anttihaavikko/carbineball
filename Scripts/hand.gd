class_name Hand extends Node2D

@export var gun: Node2D
@export var flip := 1
@export var ray: RayCast2D
@export var board: Board

var origin: Vector2
var gun_rot: float
var cooling := 0.0

func _ready() -> void:
	origin = position
	gun_rot = gun.rotation

func _process(delta) -> void:
	cooling -= delta

func shoot():
	if cooling > 0: return

	cooling = 0.2

	ray.force_raycast_update()
	if ray.is_colliding():
		var hit = ray.get_collider()
		var cp = ray.get_collision_point()
		board.lines.add(ray.global_position, cp)
		if hit is Ball:
			var dir = cp - ray.global_position
			hit.apply_impulse(dir.normalized() * 2500)
			board.start()
	recoil()

func recoil():
	position = position + Vector2(20 * flip, 15)
	gun.rotate(flip * 0.3)
	await get_tree().create_timer(0.2).timeout
	get_tree().create_tween().tween_property(self, "position", origin, 0.2).set_trans(Tween.TRANS_BOUNCE)
	get_tree().create_tween().tween_property(gun, "rotation", gun_rot, 0.2).set_trans(Tween.TRANS_BOUNCE)
