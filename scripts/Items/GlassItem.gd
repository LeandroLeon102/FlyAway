extends KinematicBody2D
var target = null
var player 
var motion = Vector2.ZERO

var gravity = 9
var counting = false

func _ready():
	player = get_tree().get_nodes_in_group('player')[0]

func _physics_process(delta):
	
	

	if target:

		if target.is_in_group('fly'):
			if target.global_position == target.initial_position:

				if not counting:
					$Timer.start($Timer.wait_time)
					counting = true
		else:
			counting = false
			$Timer.stop()
			
		
		global_position = lerp(global_position, target.global_position, .1)
	else:
		counting = false
		$Timer.stop()
		if not is_on_floor():
			motion.y += gravity *delta
			var _tmp = move_and_collide(motion)
		else:
			motion.y = 0
func _on_Area2D_body_exited(_body):
	pass
#	if body.is_in_group('player'):
#		pass


func _on_Area2D_body_entered(_body):
	pass
#	if body.is_in_group('player'):
#		if not player.carried_items.has(self):
#			target = body
#			if not player.carried_items.has(self):
#				player.carried_items.append(self)
#				player.order_carried_items()
#	if body.is_in_group('fly'):
#		erase_lists()
#
#		target = body
	
func disapear():
	erase_lists()
	queue_free()

func erase_lists():
	
	if get_tree().get_nodes_in_group('player')[0].carried_items.has(self):
		get_tree().get_nodes_in_group('player')[0].carried_glass.erase(self)
		get_tree().get_nodes_in_group('player')[0].carried_items.erase(self)

			

func _on_Timer_timeout():
	target.carried_item = null
	get_tree().get_nodes_in_group('main_game')[0].set_item('missed_item', 1, 'glass')
	queue_free()
