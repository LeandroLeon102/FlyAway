extends RigidBody2D

var velocity = 500

var direction
var motion = Vector2.ZERO
var on_floor

export var get_throwed = true

func _ready():
	start(get_throwed)
	
func start(throw = false):
	if throw:
		linear_velocity = Vector2(velocity, 0).rotated(get_angle_to(get_global_mouse_position()))

		
		
func _physics_process(_delta):


	if $RayCast2D.is_colliding():
		on_floor = true
		set_collision_mask_bit(3, false)
		
	else:
		set_collision_mask_bit(3, true)
		on_floor = false
		
	var overlapped = $Area2D.get_overlapping_bodies()
	for body in overlapped:
		if body.is_in_group('fly'):
			if not on_floor:
				body.state = body.DISSY
				#	if player_is_in:
#		if Input.is_action_just_pressed("take"):
#			print(true)
#			if len(overlapping_stones) > 0:
#				overlapping_stones[0].queue_free()
#			else:
#				queue_free()
