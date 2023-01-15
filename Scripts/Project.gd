extends Control
class_name ListedProjectItem
onready var UI_projectName:LineEdit = $Top/Control/ContentBackground/HBoxContainer/Project_Name
onready var UI_projectPercentage:Label = $Top/Control/ContentBackground/HBoxContainer/P
onready var UI_menuButton:MenuButton = $Top/Control/ContentBackground/HBoxContainer/MenuButton
onready var taskListContainer:VBoxContainer = $VTaskContainer
onready var colorRect:ColorRect = $Top/ColorRect
onready var percentLabel:Label = $Top/Control/ContentBackground/HBoxContainer/P

onready var sizeTween:Tween = $Top/ColorRect/SizeTween
onready var colorTween:Tween = $Top/ColorRect/ColorTween
onready var percentTween:Tween = $Top/Control/ContentBackground/HBoxContainer/P/LabelTween

var newUpdateVisuals:bool = false
var listedTask_ref
var appRoot
var myIndex
var hidden:bool = false
var percentDone = 0.0
var tasks = []
var startColor:Color = Color.coral
var endColor:Color = Color.darkolivegreen
export var spacingPerTask:int = 60

func save():
	#Convert Tasks arry to dict array?!
	var dictArray = []
	for task in tasks:
		var cTask:ListedTaskItem = task
		dictArray.append(cTask.save())
	var dict = {
		"text":UI_projectName.text,
		"tasks":dictArray,
		"index":myIndex
		}
	return dict

func _ready():
	UI_menuButton.get_popup().connect("id_pressed", self, "OnMenuItemPressed")
	listedTask_ref = load("res://UI Prefabs/TaskItem.tscn")
	CalculateRectSize()

func PopulateRefs():
	UI_projectName = get_node("Top/Control/ContentBackground/HBoxContainer/Project_Name")
	UI_projectPercentage = get_node("Top/Control/ContentBackground/HBoxContainer/P")
	UI_menuButton = get_node("Top/Control/ContentBackground/HBoxContainer/MenuButton")
	taskListContainer = get_node("VTaskContainer")
	colorRect = get_node("Top/ColorRect")
	percentLabel = get_node("Top/Control/ContentBackground/HBoxContainer/P")

	sizeTween = get_node("Top/ColorRect/SizeTween")
	colorTween = get_node("Top/ColorRect/ColorTween")
	percentTween = get_node("Top/Control/ContentBackground/HBoxContainer/P/LabelTween")
	listedTask_ref = load("res://UI Prefabs/TaskItem.tscn")

func OnMenuItemPressed(id:int):
	match id:
		0:
			print("Add new task")
			var newTask = listedTask_ref.instance()
			taskListContainer.call_deferred("add_child",newTask)
			var createdInstance:ListedTaskItem = newTask
			tasks.append(createdInstance)
			createdInstance.myIndex = len(tasks)
			CalculateRectSize()
			newUpdateVisuals = true
		1:
			print("Show/Hide")
			ShowHideTasks()
			#UiEvents.emit_signal("ShowHideToggle",myIndex)
		2:
			print("Delete Project")
			appRoot.RemoveProject(myIndex)
			#UiEvents.emit_signal("RemoveProject",myIndex)

	
func CreateNewTask(taskName:String = "Task Name",taskState:int = 0):
	var newTask = listedTask_ref.instance()
	taskListContainer.call_deferred("add_child",newTask)
	var createdInstance:ListedTaskItem = newTask
	if(createdInstance.UI_TaskName == null):
		createdInstance.PopulateRefs()
	tasks.append(createdInstance)
	createdInstance.myIndex = len(tasks)
	createdInstance.UI_TaskName.text = taskName
	createdInstance.UI_StateButton.select(taskState)
	
		
func CalculateRectSize():
	var newY:int = spacingPerTask
	if hidden == false:
		newY = newY + (spacingPerTask * len(tasks))
		#Spacing
		newY = newY + (5 * len(tasks))
	else:
		newY = newY + 5
	self.rect_min_size.y = newY
	print(self.rect_min_size)
	
func UpdateProjectProgress():
	var taskCount:int = len(tasks)
	var doneCount:int = 0
	for task in tasks:
		var t:ListedTaskItem = task
		match(t.UI_StateButton.selected):
			4:#Complete
				doneCount = doneCount + 1
			5:#On Hold
				doneCount = doneCount + 1
			6:#Cancelled
				doneCount = doneCount + 1
	var p:float = inverse_lerp(0,taskCount,doneCount)
	sizeTween.interpolate_property(colorRect,"anchor_right",colorRect.anchor_right,p,0.5,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	sizeTween.start()
	var targetColor:Color = lerp(startColor,endColor,p)
	colorTween.interpolate_property(colorRect,"color",colorRect.color,targetColor, 0.5,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	colorTween.start()
	percentTween.interpolate_method(self, "UpdatePercentLabel", (colorRect.anchor_right * 100), (p * 100), 0.5)
	percentTween.start()
	print("Done updating.")
	
func UpdatePercentLabel(value: int):
	percentLabel.text = str(value) + "%"

func UpdateIndex():
	myIndex = get_index()

func RemoveTask(index):
	index = index - 1
	var taskToRemove = tasks[index]
	tasks[index].get_parent().remove_child(tasks[index])
	tasks.erase(taskToRemove)
	for i in range(tasks.size()):
		tasks[i].UpdateIndex()
		tasks[i].UpdateVisuals()
	CalculateRectSize()
	UpdateProjectProgress()

func ShowHideTasks():
	if hidden == false:
		for task in tasks:
			task.visible = false
			hidden = true
	else:
		for task in tasks:
			task.visible = true
			hidden = false
	CalculateRectSize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(newUpdateVisuals):
		for task in tasks:
			task.UpdateVisuals()
		UpdateProjectProgress()
		newUpdateVisuals = false
#	pass
