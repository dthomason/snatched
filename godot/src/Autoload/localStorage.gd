extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save(name: String, content: String):
		if not name or not content:
			print("Error: You must provide a name and content")

			return
		var file = File.new()
		file.open("user://" + name + ".dat", File.WRITE)
		file.store_string(content)
		
		file.close()

func load(name: String):
		var file = File.new()
		var content = str(file.open("user://" + name + ".dat", File.READ))
		if content:
			return content
			file.close()
		else:
			file.close()
			print("Something went wrong")

			
