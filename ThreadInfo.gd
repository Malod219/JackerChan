extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func addLabelText(labelText):
	$Label.set_text(labelText)

func addContentText(contentText):
	$Content.set_text(contentText)

func addThreadNumber(number):
	$HBoxContainer/Label.set_text(number)

func _on_Options_pressed():
	var threadno = $HBoxContainer/Label.get_text()
	var board = get_tree().get_root().get_child(0).get_board()
	var popup = load("res://Popup.tscn")
	var newPopup = popup.instance()
	get_tree().get_root().add_child(newPopup)
	newPopup.setThreadInfo(board, threadno)
