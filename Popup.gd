extends ScrollContainer

var url

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setThreadInfo(board, threadNo):
	url = "https://boards.4chan.org/"+str(board)+"/thread/"+str(threadNo)+".json"
	print(url)
	$HTTPRequest.request(url)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var text = body.get_string_from_utf8()
	var result_json = JSON.parse(text)
	if result_json.error == OK:
		var thread = result_json.result["posts"]
		for post in thread:
			var threadBlock = load("res://Post.tscn")
			var newBlock = threadBlock.instance()
			if "sub" in post:
				newBlock.addLabelText(post["sub"])
			if "com" in post:
				var regex = RegEx.new()
				regex.compile('<.*?>')
				var cleantext=str(post["com"].xml_unescape()).replace("<br>","\n")
				cleantext=regex.sub(cleantext,"", true)
				cleantext = cleantext.xml_unescape()
				newBlock.addContentText(cleantext)
			$VBoxContainer/ThreadPosts.add_child(newBlock)
	else:
		print("error")


func _on_Button_pressed():
	queue_free()
