extends Control

onready var menu:MenuButton = $Top/MenuButton

var listedProject_ref
onready var projectContainer = $Body/ScrollContainer/VBoxContainer
onready var animation_player = $Top/Saved/AnimationPlayer

var projects = []


func _ready():
	menu.get_popup().connect("id_pressed", self, "OnMenuItemPressed")
	listedProject_ref = load("res://UI Prefabs/ListedProject.tscn")
	#UiEvents.connect("RemoveProject",self,"RemoveProject")
	#UiEvents.connect("StateUpdate",self, "UpdateProgress")
	#UiEvents.connect("ShowHideToggle",self, "ShowHideProject")
	Load()

func _process(delta):
	if Input.is_action_just_pressed("save"):
		Save()
	
func OnMenuItemPressed(id:int):
	print(id)
	match id:
		0:
			print("New project")
			CreateNewProject()
		1:
			print("Save")
			Save()
		2:
			print("Close App")
			CloseApp()

func CreateNewProject(projectName:String = "Project Name"):
	var newP = listedProject_ref.instance()
	projectContainer.call_deferred("add_child",newP)
	var createdInstance:ListedProjectItem = newP
	if(createdInstance.UI_projectName == null):
		createdInstance.PopulateRefs()
	createdInstance.appRoot = self
	createdInstance.myIndex = len(projects)
	createdInstance.UI_projectName.text = projectName
	print("Added New project, Index:" + str(createdInstance.myIndex))
	projects.append(createdInstance)
	

func RemoveProject(index):
	#index = index - 1
	print("length = " + str(projects.size()))
	print("Remove project:" + str(index))
	var projectToRemove = projects[index]
	projects[index].get_parent().remove_child(projects[index])
	projects.erase(projectToRemove)
	#Refresh indexes for all taskes
	for i in range(projects.size()):
		projects[i].UpdateIndex()
	
func ShowHideProject(index):
	projects[index].ShowHideTasks()
	pass
	
func UpdateProgress(projectIndex):
	print(projectIndex)

func Save():
	var arrayOfProjects = []
	for project in projects:
		var p:ListedProjectItem = project
		arrayOfProjects.append(p.save())
	print(arrayOfProjects)
	var saveFile = File.new()
	saveFile.open("user://taskTracker.save", File.WRITE)
	saveFile.store_line(JSON.print(arrayOfProjects,"\t"))
	print(saveFile.get_path_absolute())
	saveFile.close()
	animation_player.play("saveIconAnim")
	

func Load():    
	var readFile = File.new()
	if not readFile.file_exists("user://taskTracker.save"):
		return # Error! We don't have a save to load.
	readFile.open("user://taskTracker.save", File.READ)
	var arrayOfProjectsDict = []
	arrayOfProjectsDict = parse_json(readFile.get_as_text())
	print(arrayOfProjectsDict)
	var count:int = 0
	for project in arrayOfProjectsDict:
		#print(project["text"])
		#print(project["index"])
		#print(project["tasks"])
		CreateNewProject(project["text"])
		count = count + 1
		var newP:ListedProjectItem = projects[count -1]
		for task in project["tasks"]:
			newP.CreateNewTask(task["text"],task["state"])
			newP.newUpdateVisuals = true
			#print(task["text"])
			#print(task["index"])
			#print(task["state"])
	
	
func CloseApp():
	print("Close!")
	get_tree().quit(0)

