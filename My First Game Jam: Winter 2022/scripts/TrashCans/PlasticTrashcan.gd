extends Area2D

var player_entered = false
var player 

func _ready():
	player = null

func _physics_process(_delta):
	if player_entered:

		if len(get_tree().get_nodes_in_group('player')[0].carried_plastic) != 0:
			$icon.show()
			if Input.is_action_just_pressed("ui_accept"):
				get_tree().get_nodes_in_group('player')[0].carried_plastic[0].disapear()
				get_tree().get_nodes_in_group('main_game')[0].set_item('plastic', 1)

				
		else:
			$icon.hide()
	else:
		$icon.hide()


func _on_PlasticTrashcan_body_entered(body):
	if body.is_in_group('player'):
		player_entered = true
		


func _on_PlasticTrashcan_body_exited(body):
	if body.is_in_group('player'):
		player_entered = false

