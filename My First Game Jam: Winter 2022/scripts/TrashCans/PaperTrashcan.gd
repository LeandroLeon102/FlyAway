extends Area2D


var player_entered = false
var player = null

func _physics_process(_delta):
	if player_entered:

		if len(player.carried_paper) != 0:
			$icon.show()
			if Input.is_action_just_pressed("ui_accept"):
				player.carried_paper[0].kill()
				get_tree().get_nodes_in_group('main_game')[0].set_item('paper', 1)

				
		else:
			$icon.hide()
	else:
		$icon.hide()

func _on_PaperTrashcan_body_entered(body):
	if body.is_in_group('player'):
		player_entered = true
		player = body


func _on_PaperTrashcan_body_exited(body):
	if body.is_in_group('player'):
		player_entered = false
		player = null
