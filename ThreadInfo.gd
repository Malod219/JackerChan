extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func addLabelText(labelText):
	$Label.set_text(labelText)

func addContentText(contentText):
	$Content.text = contentText

func addThreadNumber(number):
	$HBoxContainer/Label.set_text(number)

func _on_Options_pressed():
	var threadno = $HBoxContainer/Label.get_text()
	var board = get_tree().get_root().get_child(0).get_board()
	var popup = load("res://Popup.tscn")
	var newPopup = popup.instance()
	get_tree().get_root().add_child(newPopup)
	newPopup.setThreadInfo(board, threadno)


func _on_CopyButton_pressed():
	OS.clipboard = $Content.text
	$HBoxContainer/CopyButton.text = "Copied!"
	timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout():
	timer.stop()
	timer.queue_free()
	$HBoxContainer/CopyButton.text = "Copy"
