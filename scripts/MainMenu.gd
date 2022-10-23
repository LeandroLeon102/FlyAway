extends Node

func _ready():
	pass


func _on_Button3_pressed():
	get_tree().quit()


func _on_Button_pressed():
	get_tree().get_nodes_in_group('game')[0].game()


func _on_Button2_pressed():
	get_tree().get_nodes_in_group('game')[0].tutorial()
	



func _on_Button4_pressed():
	get_tree().get_nodes_in_group('game')[0].credits()
