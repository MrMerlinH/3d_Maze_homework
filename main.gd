extends Node3D

var maze = []
var MazeWall = preload("res://MazeWall.tscn")
var MazeFloor = preload("res://MazeFloor.tscn")

var mazeRows := 10
var mazeColumns := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	maze.resize(2*mazeRows-1)
	for r in range(2*mazeRows-1):
		var col = []
		col.resize(2*mazeColumns-1)
		col.fill(1)
		maze[r] = col
		
	
	#print(maze)
	Aldous_Broder_Algorithm()
	createMaze()
	createMazeBorder()
	placeGoal()
	pass # Replace with function body.

func createMazeBorder():
	#creating walls around maze
	for r in range(2*mazeRows-1):
		var initedMazeWall = MazeWall.instantiate()
		initedMazeWall.position.x = r*2
		initedMazeWall.position.z = -2
		$maze.add_child(initedMazeWall)
		
		var initedMazeWall2 = MazeWall.instantiate()
		initedMazeWall2.position.x = r*2
		initedMazeWall2.position.z = (2*mazeColumns-1)*2
		$maze.add_child(initedMazeWall2)
		
	for c in range(2*mazeColumns-1):
		var initedMazeWall = MazeWall.instantiate()
		initedMazeWall.position.x = -2
		initedMazeWall.position.z = c*2
		$maze.add_child(initedMazeWall)
		
		var initedMazeWall2 = MazeWall.instantiate()
		initedMazeWall2.position.x = (2*mazeRows-1)*2
		initedMazeWall2.position.z = c*2
		$maze.add_child(initedMazeWall2)

func placeGoal():
	for r in range(maze.size() -1, -1, -1):
		for c in range(maze[0].size() -1, -1, -1):
			if !(r%2 == 0 && c%2==0):
				if maze[r][c] == 0:
					$monitoring_screen_mp_1_12.position.x = (2*mazeRows-2)*2-0.2
					$monitoring_screen_mp_1_12.position.z = (2*mazeColumns-1)*2
					
					

func createMaze():
	for r in range(2*mazeRows-1):
		for c in range(2*mazeColumns-1):
			if !(r%2 == 0 && c%2==0):
				if maze[r][c] == 1:
					#spawns wall
					var initedMazeWall = MazeWall.instantiate()
					initedMazeWall.position.x = r*2
					initedMazeWall.position.z = c*2
					$maze.add_child(initedMazeWall)
				else:
					#spawns floor
					var initedMazeFloor = MazeFloor.instantiate()
					initedMazeFloor.position.x = r*2
					initedMazeFloor.position.z = c*2
					$maze.add_child(initedMazeFloor)
			else:
				#spawns floor
				var initedMazeFloor = MazeFloor.instantiate()
				initedMazeFloor.position.x = r*2
				initedMazeFloor.position.z = c*2
				$maze.add_child(initedMazeFloor)
				pass
	

func Aldous_Broder_Algorithm():
	var currentCell = [0, 0]
	maze[currentCell[0]][currentCell[1]] = 0
	
	var visited = 1      #terminate when all cells visited
	var steps = 100000
	
	while ((visited < mazeRows * mazeColumns) && (steps > 0)):
		steps-=1
		#pick ranodm neighbour
		var nl = []
		if (currentCell[0]+2) < maze.size():
			nl.append([currentCell[0]+2, currentCell[1]])
		if (currentCell[1]+2) < maze[0].size():
			nl.append([currentCell[0], currentCell[1]+2])
		if (currentCell[0]>0):
			nl.append([currentCell[0]-2, currentCell[1]])
		if (currentCell[1]>0):
			nl.append([currentCell[0], currentCell[1]-2])
		pass
		var n = nl.pick_random()
		if (maze[n[0]][n[1]] == 1): #1 == unvisited
			#set cell to visited
			maze[n[0]][n[1]] = 0
			#remove wall
			maze[(n[0]+currentCell[0])/2][(n[1]+currentCell[1])/2] = 0
			#terminate condition
			visited+=1
		currentCell = n
			


func _on_character_body_3d_freecamtoggle() -> void:
	$DirectionalLight3D.visible = !$DirectionalLight3D.visible
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("capture_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass
