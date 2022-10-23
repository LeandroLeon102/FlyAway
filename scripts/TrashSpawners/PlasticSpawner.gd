extends Area2D

export (PackedScene) var garbage

var explosion = preload("res://scenes/SpawnerExplosion.tscn")

var player_is_in = false

export var max_plastic_available = 0
onready var plastic_available

var is_active = true

func _ready():
	var _tmp = $TextureProgress.connect('ended', self, 'spawn_garbage')
	max_plastic_available = max_plastic_available
	plastic_available = max_plastic_available
func _process(_delta):
	if is_active:
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
		if plastic_available == 0:
			$Sprite.hide()
			monitorable = false
			monitoring = false
			$Particles2D.emitting = true
		
		

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
