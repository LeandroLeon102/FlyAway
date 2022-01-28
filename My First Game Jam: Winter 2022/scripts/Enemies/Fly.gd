extends KinematicBody2D

onready var tree = get_tree()
onready var player = tree.get_nodes_in_group('player')[0]
var target = null

var wander_radius = 100

var initial_position 
export var MAX_SPEED = 100
export var alert_timeout = 3
enum {
	WANDER,
	ALERT
	CHASE, 
	STEAL 
}
export var ACCELERATION = 300
var state = WANDER
var motion = Vector2.ZERO

var carried_item = null

func _ready():
	initial_position = global_position


func _physics_process(delta):

	randomize()
	if carried_item:
		state = STEAL
	match state:
		
		WANDER:
			motion = Vector2.ZERO
			$Sprite.hide()
			var num = randf()
			if num < .01:
				target = Vector2(initial_position.x + int(rand_range(-wander_radius, wander_radius)), initial_position.y + int(rand_range(-wander_radius, wander_radius)))
			if target != null:
				
				$Node2D.look_at(target)
				global_position = lerp(global_position, target, 0.01)
			var alert_detection = $PlayerDetection.get_overlapping_bodies()
			for body in alert_detection:
				if body.is_in_group('player'):
					state = ALERT
					return
			state = WANDER
		CHASE:
			target = player.global_position
			$Sprite.hide()
			$Node2D.look_at(target)
			
			
			var direction = (target - global_position).normalized()
			motion = motion.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			var _tmp = move_and_slide(motion)
			
			var chase_detection = $PlayerChase.get_overlapping_bodies()
			for body in chase_detection:
				if body.is_in_group('player'):
					state = CHASE
					return


			state = ALERT
		ALERT:
			target = null
			motion = Vector2.ZERO
			$Node2D.look_at(player.global_position)
			$Sprite.show()
			var chase_detection = $PlayerChase.get_overlapping_bodies()
			for body in chase_detection:
				if body.is_in_group('player'):
					state = CHASE
					return
					
			var alert_detection = $PlayerDetection.get_overlapping_bodies()
			for body in alert_detection:
				if body.is_in_group('player'):
					state = ALERT
					yield(get_tree().create_timer(alert_timeout), "timeout")
					if state == ALERT:
						state = CHASE
					return
			state = WANDER
		STEAL:
			motion = Vector2.ZERO
			$Node2D.look_at(initial_position)
			global_position = global_position.move_toward(initial_position, 2)
			if global_position == initial_position:
				yield(get_tree().create_timer(2), "timeout")
				if carried_item:
					carried_item.kill()
					state = ALERT
					return

	print(carried_item,', '+ _get_state())
	var _tmp = move_and_slide(motion)
	
func _get_state():
	match state:
		WANDER:
			return 'wander'
		ALERT:
			return 'alert'
		CHASE:
			return 'chase'
		STEAL:
			return 'steal'


func _on_ItemKill_timeout():
	carried_item.kill()
	carried_item = null
	
