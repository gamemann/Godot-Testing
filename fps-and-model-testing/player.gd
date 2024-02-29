extends CharacterBody3D

@export_category("Movement")
@export var MAX_G_SPEED := 5.0
@export var MAX_G_ACCEL := 20.0 * MAX_G_SPEED
@export var MAX_AIR_SPEED := 0.5
@export var MAX_AIR_ACCEL := 100.0
@export var JUMP_FORCE := 4.5
@export var GRAVITY_FORCE := 15.0
@export var MAX_SLOPE := deg_to_rad(46.0)

@export_category("Settings")
@export var FLOOR_RAY_POS := Vector3.ZERO
@export var FLOOR_RAY_REACH := 0.8

@export_category("Node")
@export var cam_pivot : Node3D

var on_floor := false
var floor_check := {}

func _check_floor() -> bool:
	var origin = global_position + FLOOR_RAY_POS
	var target = Vector3.DOWN * FLOOR_RAY_REACH
	
	var query = PhysicsRayQueryParameters3D.create(origin, origin + target)
	
	var check = get_world_3d().direct_space_state.intersect_ray(query)
	
	var collided = check.size() > 0
	
	if collided:
		floor_check = check
	
	return collided
	
func get_slope_angle(normal): return normal.angle_to(up_direction)

func _physics_process(delta):
	var vel_planar := Vector2(velocity.x, velocity.z)
	var vel_vertical := velocity.y
	
	if on_floor:
		var collided = _check_floor()
		var slope_angle = get_slope_angle(floor_check.normal) if floor_check else 0
		
		on_floor = collided and slope_angle < MAX_SLOPE
		
	var wish_dir := Input.get_vector("player_l", "player_r", "player_f", "player_b")
	wish_dir = wish_dir.rotated(-cam_pivot.rotation.y)
	
	if on_floor and Input.is_action_pressed("player_jump"):
		on_floor = false
		vel_vertical = JUMP_FORCE
		
	if not on_floor:
		vel_vertical -= GRAVITY_FORCE * delta
	else:
		vel_planar -= vel_planar.normalized() * delta * (MAX_G_ACCEL / 2.0)
		if vel_planar.length_squared() < 1.0 and wish_dir.length_squared() < 0.01:
			vel_planar = Vector2.ZERO
			
	var current_speed = vel_planar.dot(wish_dir)
	
	var max_speed = MAX_G_SPEED if on_floor else MAX_AIR_SPEED
	var max_accel = MAX_G_ACCEL if on_floor else MAX_AIR_ACCEL
	
	var add_speed = clamp(max_speed - current_speed, 0.0, max_accel * delta)
	
	vel_planar += wish_dir * add_speed
	
	velocity = Vector3(vel_planar.x, vel_vertical, vel_planar.y)
	
	#print("vel: %s" % velocity)
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		move_and_collide(collision.get_remainder().slide(collision.get_normal()))
		
		if not on_floor:
			velocity = velocity.slide(collision.get_normal())
			
			var slope_angle = get_slope_angle(collision.get_normal())
			
			if slope_angle < MAX_SLOPE:
				on_floor = true
				velocity.y = 0.0
	else:
		if on_floor:
			if _check_floor():
				move_and_collide(floor_check.position - global_position)

func _input(event):
	if event is InputEventMouseMotion:
		cam_pivot.rotation.y += -event.relative.x * 0.001
		cam_pivot.rotation.x += -event.relative.y * 0.001
		cam_pivot.rotation_degrees.x = clamp(cam_pivot.rotation_degrees.x, -89.0, 89.0)
