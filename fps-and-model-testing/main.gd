extends Node

@export var player: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	print("Spawning in player")
	var ply = player.instantiate()
	
	var loc = Vector3(0, 5.0, 0)
	ply.position = loc
	
	add_child(ply)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
