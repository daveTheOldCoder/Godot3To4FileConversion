extends Label

func _ready() -> void:
	text = Engine.get_version_info()["string"]
