extends Node

onready var MainMenu = preload("res://MainMenu.tscn")
onready var TutorialWorld = preload("res://Tutorial.tscn")

onready var Tutorial 
onready var Game = preload("res://Main.tscn")

func _ready():
	$CanvasLayer/Transition/AnimationPlayer.play("Reset")
	yield(get_tree().create_timer(2),"timeout")
	var childs = get_children()
	for child in childs:
		if child.is_in_group('transition'):
			pass
		else:
			child.queue_free()
	var new_scene = MainMenu.instance()
	add_child(new_scene)
	$CanvasLayer/Transition/AnimationPlayer.play("fade_out")

func main_menu():
	
	$CanvasLayer/Transition/AnimationPlayer.play("fade_in")
	yield(get_tree().create_timer(2),"timeout")
	var childs = get_children()
	for child in childs:
		if child.is_in_group('transition'):
			pass
		else:
			child.queue_free()
	var new_scene = MainMenu.instance()
	add_child(new_scene)
	$CanvasLayer/Transition/AnimationPlayer.play("fade_out")

	
	
func tutorial():
	$CanvasLayer/Transition/AnimationPlayer.play("fade_in")
	var childs = get_children()
	yield(get_tree().create_timer(2),"timeout")
	for child in childs:
		if child.is_in_group('transition'):
			pass
		else:
			child.queue_free()
	var new_scene = TutorialWorld.instance()
	add_child(new_scene)

	$CanvasLayer/Transition/AnimationPlayer.play("fade_out")
	
func game():
	var childs = get_children()
	for child in childs:
		if child.is_in_group('transition'):
			pass
		else:
			child.queue_free()
	var new_scene = MainMenu.instance()
	add_child(new_scene)
	
func credits():
	pass
