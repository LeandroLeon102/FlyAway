extends Control

var max_paper
var max_plastic
var max_glass

var current_paper = 0
var current_plastic = 0
var current_glass = 0

func _ready():

	max_paper = int(len(get_tree().get_nodes_in_group('paper')) + get_tree().get_nodes_in_group('paper_spawner')[0].max_paper_available)



	max_plastic = len(get_tree().get_nodes_in_group('plastic')) + get_tree().get_nodes_in_group('plastic_spawner')[0].max_plastic_available
	max_glass = len(get_tree().get_nodes_in_group('glass')) + get_tree().get_nodes_in_group('glass_spawner')[0].max_glass_available
	$VBoxContainer/Paper/Label.text = str(current_paper) + '/' + str(max_paper)
	$VBoxContainer/Plastic/Label.text = str(current_plastic) + '/' + str(max_plastic)
	$VBoxContainer/Glass/Label.text = str(current_glass) + '/' + str(max_glass)

func add_item(type, num):
	if type == 'paper':
		current_paper += num
		$VBoxContainer/Paper/Label.text = str(current_paper) + '/' + str(max_paper)
	if type == 'plastic':
		current_plastic += num
		$VBoxContainer/Plastic/Label.text = str(current_plastic) + '/' + str(max_plastic)
	if type == 'glass':
		current_glass += num
		$VBoxContainer/Glass/Label.text = str(current_glass) + '/' + str(max_glass)
