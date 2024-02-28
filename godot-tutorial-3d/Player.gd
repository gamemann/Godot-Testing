extends CharacterBody3D

signal hit

@export var speed = 14
@export var fall_accel = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	# Check if our movement keys are pressed. If so, adjust directions.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	# Normalize vector if needed.
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
		$Pivot.basis = Basis.looking_at(direction)
		
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1

	# Calculate ground velocity.
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Check if we're in the air. If so, apply gravity.
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_accel * delta)
	
	# Handle jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# Check for collisions.
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		if collision.get_collider() == null:
			continue
			
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				
				target_velocity.y = bounce_impulse
				
				break
	# Set velocity and move.
	velocity = target_velocity
	move_and_slide()
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	hit.emit()
	queue_free()

func _on_mod_detector_body_entered(body):
	die()
