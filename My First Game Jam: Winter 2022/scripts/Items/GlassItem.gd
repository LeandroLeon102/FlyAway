extends KinematicBody2D

var target = null
var player 
var motion = Vector2.ZERO

var gravity = 9

func _ready():
	player = get_tree().get_nodes_in_group('player')[0]

func _physics_process(delta):
	if target:
		
		global_position = lerp(global_position, target.global_position, .1)
	else:
		if not is_on_floor():
			motion.y += gravity *delta
			move_and_collide(motion)
		else:
			motion.y = 0

		move_and_collide(motion)
func _on_Area2D_body_exited(body):
	pass
#	if body.is_in_group('player'):
#		pass


func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		if not player.carried_items.has(self):
			target = body
			if not player.carried_items.has(self):
				player.carried_items.append(self)
				player.order_carried_items()
	if body.is_in_group('fly'):
		erase_lists()
	
		target = body
	
func kill():
	erase_lists()
	queue_free()

func erase_lists():
	if player.carried_items.has(self):
		player.carried_glass.erase(self)
		player.carried_items.erase(self)
			
