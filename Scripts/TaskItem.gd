extends Control
class_name ListedTaskItem

#onready var menu:MenuButton = $Control/ContentBackground/HBoxContainer/MenuButton
onready var delete_button = $Control/ContentBackground/HBoxContainer/DeleteButton

onready var UI_StateButton:OptionButton = $Control/ContentBackground/HBoxContainer/OptionButton
#onready var UI_TaskName:LineEdit = $Control/ContentBackground/HBoxContainer/LineEdit
onready var UI_TaskName:TextEdit = $Control/ContentBackground/HBoxContainer/TextEdit
onready var lineHalf:TextureRect = $LineHalf
onready var lineFull:TextureRect = $LineFull
onready var lineRight:TextureRect = $LineRight
onready var colorRect:ColorRect = $ColorRect
#onready var percentLabel:Label = $Control/ContentBackground/HBoxContainer/Label

#onready var sizeTween:Tween = $ColorRect/SizeTween
onready var colorTween:Tween = $ColorRect/ColorTween
#onready var percentTween:Tween = $Control/ContentBackground/HBoxContainer/Label/LabelTween

var myIndex:int

var parentProject

var rightAnchorStates = [
	1.0,#New
	0.25,#Started
	0.5,#WIP
	0.75,#Testing
	1.0,#Complete
	1.0,#On Hold
	1.0#Cancelled
]
var colorStates = [
	Color.gray,#New
	Color.plum,#Started
	Color.cornflower,#WIP
	Color.darkseagreen,#Testing
	Color.darkolivegreen,#Complete
	Color.darkslateblue,#On Hold
	Color.firebrick#Cancelled
]

func save():
	var dict = {
		"text":UI_TaskName.text,
		"state":UI_StateButton.selected,
		"index":myIndex
		}
	return dict


func _ready():
	delete_button.connect("pressed", self, "OnDeletePressed")
	UI_StateButton.get_popup().connect("id_pressed",self,"OnStateChanged")
	parentProject = get_parent().get_parent()
	
func PopulateRefs():
	delete_button = get_node("Control/ContentBackground/HBoxContainer/DeleteButton")
	#menu = get_node("Control/ContentBackground/HBoxContainer/MenuButton")
	UI_StateButton = get_node("Control/ContentBackground/HBoxContainer/OptionButton")
	UI_TaskName = get_node("Control/ContentBackground/HBoxContainer/TextEdit")
	lineHalf = get_node("LineHalf")
	lineFull = get_node("LineFull")
	lineRight = get_node("LineRight")
	colorRect = get_node("ColorRect")

	#sizeTween = get_node("ColorRect/SizeTween")
	colorTween = get_node("ColorRect/ColorTween")

func UpdateIndex():
	myIndex = get_index()

func OnStateChanged(index:int):
	parentProject.appRoot.UpdateProgress(parentProject.myIndex)
	#UiEvents.emit_signal("StateUpdate",parentProject.myIndex)
	
	match(index):
		0:
			print("New")#New
		1:
			print("Started")#Started
		2:
			print("WIP")#WIP
		3:
			print("Testing")#Testing
		4:
			print("Complete")#Complete
		5:
			print("On Hold")#On Hold
		6:
			print("Cancelled")#Cancelled
	parentProject.newUpdateVisuals = true
	#interpolate_property($Node2D, "position",Vector2(0, 0), Vector2(100, 100), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#sizeTween.interpolate_property(colorRect,"anchor_right",colorRect.anchor_right,rightAnchor[index],0.5,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	#sizeTween.start()
	#newUpdateVisuals = true


func UpdateVisuals():
	#sizeTween.interpolate_property(colorRect,"anchor_right",colorRect.anchor_right,rightAnchorStates[UI_StateButton.selected],0.5,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	#sizeTween.start()
	colorTween.interpolate_property(colorRect,"color",colorRect.color,colorStates[UI_StateButton.selected],0.5,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	colorTween.start()
	if  myIndex + 1 > len(parentProject.tasks):
		lineHalf.visible = true;
		lineFull.visible = false;
		lineRight.visible = true;
	if len(parentProject.tasks) > myIndex:
		lineHalf.visible = false;
		lineFull.visible = true;
		lineRight.visible = true;
	
	#percentTween.interpolate_method(self, "UpdatePercentLabel", (colorRect.anchor_right * 100), (rightAnchorStates[stateButton.selected] * 100), 0.5)
	#percentTween.start()

	
#func UpdatePercentLabel(value: int):
#	percentLabel.text = str(value)
	
func OnDeletePressed():
	parentProject.RemoveTask(myIndex)



