extends KinematicBody2D

export (int) var Acceleration = 512
export (float) var Friction = 0.25
export (Vector2) var MaxVelocity = Vector2(150, 250)
export var JumpForce = 350

var sprite_flip_h = false
var velocity = Vector2.ZERO
var gravity = 1000
var coyote_timer = false
var carried_items = []
var carried_paper = []
var carried_plastic = []
var carried_glass =  []

var max_carried_items = 5

var overlapping_stones = []

export var carried_stones = 0
export var max_carried_stones = 3

onready var stone = preload("res://scenes/Stone.tscn")

onready var animationTree = $AnimationTree
onready var animationMode = animationTree.get('parameters/playback')

var walking = false

func _physics_process(delta):
	overlapping_stones = []
	var stones = $Area2D.get_overlapping_areas()

	for body in stones:
		if body.is_in_group('stone'):
			overlapping_stones.append(body.get_parent())
			
		
	if Input.is_action_just_pressed("take"):
		if carried_stones < max_carried_stones:
			if len(overlapping_stones) > 0:
				overlapping_stones[0].queue_free()
				carried_stones += 1

	
	var x_input = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if Input.is_action_just_pressed("shoot"):
		if carried_stones > 0:
			carried_stones -= 1
			var s = stone.instance()
			s.global_position = global_position
			s.start(true)
			s.start(true)
			get_tree().get_nodes_in_group('stone_container')[0].add_child(s)
		

	if x_input != 0:
		
		velocity.x += x_input * Acceleration * delta
		velocity.x = clamp(velocity.x, -MaxVelocity.x, MaxVelocity.x)
		animationMode.travel('run')
	elif x_input == 0 and velocity.x == 0:
		animationMode.travel('idle')
		
	

		
	if x_input == 0 and is_on_floor():
		velocity.x = lerp(velocity.x, 0, Friction)

	elif not is_on_floor():
		velocity.x = lerp(velocity.x, 0, Friction / 4)
	
	if x_input != 0 and is_on_floor():
		$Particles2D.emitting = true
		play_walk_sound()
	else:
		$Particles2D.emitting = false
		
	if Input.is_action_pressed("ui_down") and is_on_floor():
		position.y += 1
	
	if is_on_floor():
		coyote_timer = true
	if Input.is_action_just_pressed("ui_up"):
		if coyote_timer:
			play_jump_sound()

			velocity.y = -JumpForce
	if Input.is_action_just_released("ui_up") and velocity.y < -JumpForce/2:
		
		velocity.y = -JumpForce / 2
	if velocity.x > 0:
		sprite_flip_h = false
	if  velocity.x < 0:
		sprite_flip_h = true
	if is_on_wall() and x_input != 0:
		if velocity.y > 0:
			
			velocity.y = velocity.y /1.5
			if Input.is_action_pressed("ui_up"):
				play_jump_sound()
				velocity.y = -JumpForce
				velocity.x += x_input * -1 * JumpForce
			
	$Sprite.flip_h = sprite_flip_h
	
	velocity.y += gravity * delta
	if not is_on_floor():
		animationMode.travel('fall')
		coyote_time()

	
	velocity = Vector2(int(velocity.x),int(velocity.y))
	velocity = move_and_slide(velocity, Vector2.UP)
#	print(carried_items, carried_glass)
	
func coyote_time():
	yield(get_tree().create_timer(.1), 'timeout')
	coyote_timer = false

func order_carried_items():
	
	for item in carried_items:
		if item != null:
			if item.is_in_group('paper'):
				if not carried_paper.has(item):
					carried_paper.append(item)
			if item.is_in_group('plastic'):
				if not carried_plastic.has(item):
					carried_plastic.append(item)
			if item.is_in_group('glass'):
				if not carried_glass.has(item):
					carried_glass.append(item)


func _on_Area2D_body_entered(body):
	if body.is_in_group('item'):
		if len(carried_items) != max_carried_items :
			if body.target and body.target.is_in_group('fly'):
				body.target.carried_item = null
				body.target.state = body.target.WANDER
			body.target = self
			if not carried_items.has(body):
				carried_items.append(body)
				order_carried_items()

func play_jump_sound():
	pass
	randomize()
	$JumpSound.pitch_scale = rand_range(0.75, 0.9)
	$JumpSound.play()
				

func play_walk_sound():
	pass
	if not walking:
		$GrassSounds/Timer.start(.3)
		walking = true



func _on_Timer_timeout():
	randomize()
	var sounds = $GrassSounds.get_children()
#		sound
	var s = sounds[randi() % 2]
	s.pitch_scale = rand_range(0.85, 1.0)
	s.play()
	walking = false
