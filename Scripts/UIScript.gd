extends Control

onready var menu:MenuButton = $VBoxContainer/Top/MenuButton;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	menu.get_popup().connect("id_pressed", self, "OnMenuItemPressed")
	pass # Replace with function body.

func OnMenuItemPressed(id:int):
	if id == 3:
		CloseApp()

func CloseApp():
	print("Close!")
	get_tree().quit(0)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
