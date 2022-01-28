extends KinematicBody2D

var target = null
var player 
var motion = Vector2.ZERO

var gravity = 9

func _ready():
	player = get_tree().get_nodes_in_group('player')[0]

func _physics_process(delta):
	
	var overlaped = $Area2D.get_overlapping_bodies()
	for body in overlaped:
		if body.is_in_group('fly'):
			erase_lists()
			if not body.carried_item:
				target = body
				body.carried_item = self
		if body.is_in_group('player'):
			if not player.carried_items.has(self):
				if target and target.is_in_group('fly'):
					target.carried_item = null
					target.target = null
					target.state = target.CHASE
				target = body
				if not player.carried_items.has(self):
					player.carried_items.append(self)
					player.order_carried_items()
	
	if target:
		
		global_position = lerp(global_position, target.global_position, .1)
	else:
		if not is_on_floor():
			motion.y += gravity *delta
			move_and_collide(motion)
		else:
			motion.y = 0
	
func _on_Area2D_body_exited(body):
	pass
#	if body.is_in_group('player'):
#		pass
#

func _on_Area2D_body_entered(body):
	pass
	
	
func disapear():
	erase_lists()
	queue_free()

func erase_lists():
	if target.is_in_group('player'):
		if get_tree().get_nodes_in_group('player')[0].carried_items.has(self):
			get_tree().get_nodes_in_group('player')[0].carried_plastic.erase(self)
			get_tree().get_nodes_in_group('player')[0].carried_items.erase(self)
	if target.is_in_group('fly'):
		target.carried_item = null
	
			
