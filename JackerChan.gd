extends Control

var boards
var threadBlock = preload("res://ThreadInfo.tscn")


func _ready():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	populateSpinBox()

func populateSpinBox():
	$BoardsRequest.request("https://boards.4chan.org/boards.json")

func _on_BoardsRequest_request_completed(_result, _response_code, _headers, body):
	var text = body.get_string_from_utf8()
	var result_json = JSON.parse(text)
	
	if result_json.error == OK:
		var data = result_json.result
		boards = data["boards"]
		for board in boards:
			var boardLength = len(board["board"])
			var spaceAdjust=""
			for _i in range(5-boardLength):
				spaceAdjust+=" "
			var boardName = "/"+board["board"]+"/"+spaceAdjust+" - "+board["title"]
			$ScrollContainer/VBoxContainer/HBoxContainer/SpinBox.add_item(boardName)
	else:
		print("error")
	
	#$VBoxContainer/HBoxContainer/SpinBox.add_item("Test")
	#$VBoxContainer/TextEdit.set_text(body.get_string_from_utf8())

func _on_Button_pressed():
	if $ScrollContainer/VBoxContainer/HBoxContainer/SpinBox.items.size() <= 0:
		return
	var boardId = $ScrollContainer/VBoxContainer/HBoxContainer/SpinBox.get_selected_id()
	var newUrl="https://boards.4chan.org/"+boards[boardId]["board"]+"/catalog.json"
	$ThreadsRequest.request(newUrl, PoolStringArray(['Access-Control-Allow-Origin']))

func get_board():
	var boardId = $ScrollContainer/VBoxContainer/HBoxContainer/SpinBox.get_selected_id()
	return boards[boardId]["board"]

func _on_ThreadsRequest_request_completed(_result, _response_code, _headers, body):
	var text = body.get_string_from_utf8()
	var result_json = JSON.parse(text)
	var threadChildren = $ScrollContainer/VBoxContainer/ThreadList.get_children()
	for thread in threadChildren:
		thread.queue_free()
	
	if result_json.error == OK:
		var pages = result_json.result
		for page in pages:
			for thread in page["threads"]:
				var newBlock = threadBlock.instance()
				newBlock.addThreadNumber(str(thread["no"]))
				$ScrollContainer/VBoxContainer/ThreadList.add_child(newBlock)
	
				if "sub" in thread:
					newBlock.addLabelText(str(thread["sub"]))
				if "com" in thread:
					var regex = RegEx.new()
					regex.compile('<.*?>')
					var cleantext=str(thread["com"]).replace("<br>","\n")
					cleantext=regex.sub(cleantext,"", true)
					regex.compile('&#039;')
					cleantext = regex.sub(cleantext,"'", true)
					cleantext = cleantext.xml_unescape()
					newBlock.addContentText(cleantext)
	else:
		print("error")


func _on_LinkButton_pressed():
	OS.shell_open("https://risingthumb.xyz")
