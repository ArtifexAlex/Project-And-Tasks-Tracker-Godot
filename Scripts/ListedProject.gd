extends Control
onready var projectState:OptionButton = $Control/ContentBackground/HBoxContainer/OptionButton
onready var background:ColorRect = $ColorRect
onready var percentageLabel:Label = $Control/ContentBackground/HBoxContainer/Label
onready var addTask:Button = $Control/ContentBackground/HBoxContainer/AddTask
onready var addTaskHint:PopupDialog = $Control/ContentBackground/HBoxContainer/AddTask/PopupDialog

var sizeTween:Tween
var colorTween:Tween
var labelTween:Tween
var currentP:int = 0

var colors = [
	Color.whitesmoke,#0
	Color.sandybrown,#1
	Color.lightseagreen,#2
	Color.darkgray,#3
	Color.lightgreen#4
	]
var percentage = [
	0.0,#0
	0.5,#1
	0.75,#2
	1.0,#3
	1.0,#4
]
var percentageLabels = [
	0,#0
	50,#1
	75,#2
	0,#3
	100,#4
]



var lastState:int = -1 setget set_lastState, get_lastState

func set_lastState(new_value):
	print(new_value)
	lastState = new_value
	colorTween.interpolate_property(background, "color", background.color, colors[lastState], 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	colorTween.start()
	sizeTween.interpolate_property(background, "anchor_right", background.anchor_right, percentage[lastState], 0.5,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	sizeTween.start()
	labelTween.interpolate_method(self, "UpdateLabel", currentP, percentageLabels[lastState], 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	labelTween.start()

func UpdateLabel(newVal:int):
	currentP = newVal
	percentageLabel.text = str(currentP) + "%"

func get_lastState():
	return lastState
	
func AddTask_Pressed():
	print("Task")
	
func AddTask_OnFocused():
	print("Focus")
	addTaskHint.visible = true
	
func AddTask_OnLostFocus():
	addTaskHint.visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	colorTween = background.get_node("ColorTween")
	sizeTween = background.get_node("SizeTween")
	labelTween = $Control/ContentBackground/HBoxContainer/Label/LabelTween
	addTask.connect("pressed", self, "AddTask_Pressed")
	addTask.connect("mouse_entered",self,"AddTask_OnFocused")
	addTask.connect("mouse_exited",self,"AddTask_OnLostFocus")
	pass # Replace with function body.

#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (lastState != projectState.selected):
		set_lastState(projectState.selected)
		#print(lastState)
	pass
