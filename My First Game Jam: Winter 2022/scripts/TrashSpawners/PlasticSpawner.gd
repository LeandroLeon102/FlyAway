extends Area2D

export (PackedScene) var garbage

var player_is_in = false

var max_plastic_available = 6
var plastic_available = max_plastic_available

func _ready():
	var _tmp = $TextureProgress.connect('ended', self, 'spawn_garbage')

func _physics_process(_delta):
	if player_is_in:
		if plastic_available > 0:
			$TextureProgress.show()
			$TextureProgress.count(true)
		else:
			player_is_in = false
	else:
		$TextureProgress.hide()
		$TextureProgress.count(false)
		$TextureProgress.value = 0
		

func _on_PlasticSpawner_body_entered(body):
	if body.is_in_group('player'):
		player_is_in = true



func _on_PlasticSpawner_body_exited(body):
	if body.is_in_group('player'):
		player_is_in = false

func spawn_garbage():
	randomize()
	if plastic_available > 0:
		plastic_available -= 1
		var g = garbage.instance()
		g.global_position = Vector2(global_position.x + rand_range(-5, 5), global_position.y + rand_range(-5, 5))
		get_tree().get_nodes_in_group('main_game')[0].add_child(g)
