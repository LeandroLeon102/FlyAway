extends Control

var max_paper
var max_plastic
var max_glass

var current_paper = 0
var current_plastic = 0
var current_glass = 0

var missed_paper = 0
var missed_plastic = 0
var missed_glass = 0

var total_items
var current_items = 0
var total_missed = 0

onready var PaperItemTexture = preload("res://scr/paperItem.tres")
onready var PlasticItemTexture = preload("res://scr/PlasticItem.tres")
onready var GlassItemTexture = preload("res://scr/GlassItem.tres")
onready var EmptyItemTexture = preload("res://scr/EmptyItem.tres")

onready var tree = get_tree()
onready var main_game = tree.get_nodes_in_group('main_game')[0]

var ready_start = true
var process = false
func _ready():
	get_parent().get_node("Transition/ColorRect").show()
	$UI.show()
	$Pause.hide()
	process = false

	
func _process(_delta):
	randomize()
	if process:
		if Input.is_action_just_pressed("ui_cancel"):

			get_tree().set_pause(not get_tree().is_paused())
		if get_tree().paused:
			$UI.hide()
			$Pause.show()
		else:
			$Pause.hide()
			$UI.show()
			
	#	print(['missed: ' + str(total_missed), 'current: '+str(current_items - total_missed), 'total: ' + str(total_items)])
	#	print(current_items - total_missed)
		$UI/CenterContainer7/Label.text = str(get_tree().get_nodes_in_group('player')[0].carried_stones) + '/'  + str(get_tree().get_nodes_in_group('player')[0].max_carried_stones)
		get_new_level()


		var children_inventory = $UI/CenterContainer3/GridContainer2.get_children()
		for case in children_inventory:
			case.texture = EmptyItemTexture
		for i in range(len(get_tree().get_nodes_in_group('player')[0].carried_items)):
			var it =  get_tree().get_nodes_in_group('player')[0].carried_items[i]
			if it.is_in_group('paper'):
				children_inventory[i].texture = PaperItemTexture
				children_inventory[i].show()
			if it.is_in_group('plastic'):
				children_inventory[i].texture = PlasticItemTexture
				children_inventory[i].show()
			if it.is_in_group('glass'):
				children_inventory[i].texture = GlassItemTexture
				children_inventory[i].show()
			$UI/GridContainer/Label4.text = str(total_missed)
		
			
func add_item(type, num, subtype=null):
	
	if type == 'missed_item':
		total_missed += 1
		if subtype != null:
			if subtype == 'glass':
				missed_glass += 1
			if subtype == 'paper':
				missed_paper += 1
			if subtype == 'plastic':
				missed_plastic += 1
	if type == 'paper':
		current_paper += num
		$UI/GridContainer/HBoxContainer/Label.text = str(current_paper) 
		$UI/GridContainer/HBoxContainer/Label5.text = '/' + str(max_paper - missed_paper)
			
	if type == 'plastic':
		current_plastic += num
		$UI/GridContainer/HBoxContainer2/Label2.text = str(current_plastic)
		$UI/GridContainer/HBoxContainer2/Label6.text =  '/' + str(max_plastic - missed_plastic)
			
	if type == 'glass':
		current_glass += num
		$UI/GridContainer/HBoxContainer3/Label3.text = str(current_glass) 
		$UI/GridContainer/HBoxContainer3/Label7.text =  '/' + str(max_glass - missed_glass)
		
	if missed_plastic > 0:
		$UI/GridContainer/HBoxContainer2/Label6.self_modulate = Color(.82, .19, .19, 1)
	else:
		$UI/GridContainer/HBoxContainer2/Label6.self_modulate = Color(1, 1, 1, 1)
		
	if missed_glass > 0:
		$UI/GridContainer/HBoxContainer3/Label7.self_modulate = Color(.82, .19, .19, 1)
	else:
		$UI/GridContainer/HBoxContainer3/Label7.self_modulate = Color(1, 1, 1, 1)
		
	if missed_paper > 0:
		$UI/GridContainer/HBoxContainer/Label5.self_modulate = Color(.82, .19, .19, 1)
	else:
		$UI/GridContainer/HBoxContainer/Label5.self_modulate = Color(1, 1, 1, 1)
		
	if total_missed > 0:
		$UI/GridContainer/Label4.self_modulate = Color(.82, .19, .19, 1)
	else:
		$UI/GridContainer/Label4.self_modulate = Color(0.254902, 0.819608, 0.188235)
		
	
		
	$UI/GridContainer/HBoxContainer/Label5.text = '/' + str(max_paper - missed_paper)
	$UI/GridContainer/HBoxContainer2/Label6.text =  '/' + str(max_plastic - missed_plastic)
	$UI/GridContainer/HBoxContainer3/Label7.text =  '/' + str(max_glass - missed_glass)
		
	$UI/GridContainer/Label4.text = str(total_missed)
			
	current_items += num 
		
func start():
	reset_counters()

	max_paper = int(len(get_tree().get_nodes_in_group('paper')) + get_tree().get_nodes_in_group('paper_spawner')[0].max_paper_available)

	max_plastic = len(get_tree().get_nodes_in_group('plastic')) + get_tree().get_nodes_in_group('plastic_spawner')[0].max_plastic_available
	max_glass = len(get_tree().get_nodes_in_group('glass')) + get_tree().get_nodes_in_group('glass_spawner')[0].max_glass_available
	
	$UI/GridContainer/HBoxContainer/Label.text = str(current_paper) 
	$UI/GridContainer/HBoxContainer/Label5.text = '/' + str(max_paper)
	
	$UI/GridContainer/HBoxContainer2/Label2.text = str(current_plastic)
	$UI/GridContainer/HBoxContainer2/Label6.text =  '/' + str(max_plastic)
	
	$UI/GridContainer/HBoxContainer3/Label3.text = str(current_glass) 
	$UI/GridContainer/HBoxContainer3/Label7.text =  '/' + str(max_glass)
	
	total_items = max_paper+max_plastic+max_glass
	$UI/GridContainer/Label4.text = str(total_missed)
	
	$UI/GridContainer/HBoxContainer2/Label6.self_modulate = Color(1, 1, 1, 1)
	$UI/GridContainer/HBoxContainer/Label5.self_modulate = Color(1, 1, 1, 1)
	$UI/GridContainer/HBoxContainer3/Label7.self_modulate = Color(1, 1, 1, 1)
	$UI/GridContainer/Label4.self_modulate = Color(0.254902, 0.819608, 0.188235)
	$UI/CenterContainer7/Label.text = str(get_tree().get_nodes_in_group('player')[0].carried_stones) + '/'  + str(get_tree().get_nodes_in_group('player')[0].max_carried_stones)
	process = true

func get_new_level():
	var finished = total_missed
	if current_items - total_missed == total_items - total_missed:
		var dir = Directory.new()
		var files = []
		dir.open("res://scenes/Worlds/")
		dir.list_dir_begin()
		var run = true

		for x in range(8):
			var file =  dir.get_next()
			if file != '' and file != '.' and file != '..' :
				files.append(file)
			
		dir.list_dir_end()
#			print(files)
		process = false
		reset_counters()
		main_game.change_level(load("res://scenes/Worlds/"+str(files[int(rand_range(0, 5))])), finished)
func reset_counters():
	max_paper
	max_plastic
	var max_glass

	current_paper = 0
	current_plastic = 0
	current_glass = 0

	missed_paper = 0
	missed_plastic = 0
	missed_glass = 0

	total_items
	current_items = 0
	total_missed = 0
