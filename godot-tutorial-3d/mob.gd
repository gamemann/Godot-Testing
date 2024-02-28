extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

signal squashed
	
func _physics_process(_delta):
	move_and_slide()
	
func initialize(start_position, player_position):
	# Spawn the mob at `start_position` and make it look at `player_position`.
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	# Rotate randomly so that we aren't aimed at the player each time.
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# Calculate speed (random).
	var rand_speed = randi_range(min_speed, max_speed)
	
	velocity = Vector3.FORWARD * rand_speed
	
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	# Set more accurate animation speeds.
	$AnimationPlayer.speed_scale = rand_speed / min_speed

func _on_visible_on_screen_enabler_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()
