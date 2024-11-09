extends Node3D

var character
var camera
var camera_pos

@export var speed = 5.0
@export var acceleration = 4.0
@export var camera_size = 5.0
@export var camera_x = 0
@export var camera_y = 3
@export var camera_z = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	character = $PlayerModel
	camera = $Camera3D
	
	camera_pos = Vector3.ZERO
	camera_pos.x = camera_x
	camera_pos.y = camera_y
	camera_pos.z = camera_z
	_update_camera_position()
	
	camera.size = camera_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _physics_process(_delta):
	
	var move_input = Vector3.ZERO
	
	move_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_input.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	
	move_input = move_input.normalized()
	
	character.velocity.x = move_input.x * speed
	character.velocity.z = move_input.z * speed
	
	if move_input != Vector3.ZERO:
		var rotation_value = atan2(move_input.x, move_input.z)
		character.rotation.y = lerp_angle(character.rotation.y, rotation_value, 1)
		_update_camera_position()
	
	character.move_and_slide()

func _update_camera_position():
	camera.global_position = character.global_position + camera_pos
	# camera.global_position = camera_point.global_position
