extends Node

var messages = {
	'losser':['...', 'better leave this to the flies...', 'are you there?...', 'stop feeding flies...', 'try harder!...', "can't do it better?..."],
	'winner':['you are on the next level!', 'OMG, what skills!', 'Fly Master!', 'you are saving the world!', 'keep going!', 'keep it up!']
}

func _ready():
	$CanvasLayer/Control.start()

func set_item(type, num, subtype=null):
	$CanvasLayer/Control.add_item(type, num, subtype)

func change_level(lvl, amount):

	$CanvasLayer/Transition/AnimationPlayer.play('fade_in')
	var childs = $WorldContainer.get_children()
	yield(get_tree().create_timer(2), "timeout")
	var level = lvl.instance()
	for c in childs:
	 c.queue_free()
	$WorldContainer.add_child(level)
	if amount > 0:
		$CanvasLayer/Message/Label.text = str(messages['losser'][int(rand_range(0, len(messages['losser'])))])
		$CanvasLayer/Message/AnimationPlayer.play("fade_in")
	else:
		$CanvasLayer/Message/Label.text = str(messages['winner'][int(rand_range(0, len(messages['winner'])))])
		$CanvasLayer/Message/AnimationPlayer.play("fade_in")
	
	yield(get_tree().create_timer(3), "timeout")
	$CanvasLayer/Message/AnimationPlayer.play("fade_out")
	yield(get_tree().create_timer(2), "timeout")	
	
	yield(get_tree().create_timer(2), "timeout")

	$CanvasLayer/Control.start()
	$CanvasLayer/Transition/AnimationPlayer.play('fade_out')





func _on_Button_pressed():
	get_tree().quit()
