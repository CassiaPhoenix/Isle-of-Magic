extends Node2D

var dotNodes = {}

@export var dotFirst:Vector2
@export var dotLast:Vector2
@export var dotRows:int
@export var dotColumns:int
@export var dotRadius:float
@export var dotColliderBuffer:float
@export var dotColour:Color
@export var pathThickness:int
@export var pathColour:Color

var translatePath = {[2, 1, 0, 4, 6, 7, 8]: "M",
					 [8, 7, 6, 4, 0, 1, 2]: "M",
					 [5, 4, 3]: "Up",
					 [3, 4, 5]: "Down",
					 [1, 4, 7]: "Right",
					 [7, 4, 1]: "Left"}

var currentNode
var selectedNodes = []
var mouseClicked = false

# Called when the node enters the scene tree for the first time.


func setup(offset):
	var dotPath = "res://dot.tscn"
	var dotResourse = load(dotPath)
	
	var x_range = dotLast.x - dotFirst.x
	var y_range = dotLast.y - dotFirst.y
	
	var x_space = 0
	var y_space = 0
	
	if dotRows > 1:
		x_space = x_range / (dotRows - 1)
	if dotColumns > 1:
		y_space = y_range / (dotColumns - 1)
	
	var id = 0
	
	for r in dotRows:
		for c in dotColumns:
			var coord = Vector2.ZERO
			coord.x = dotFirst.x + (x_space * r) + offset.x
			coord.y = dotFirst.y + (y_space * c) + offset.y
			var dot = dotResourse.instantiate()
			add_child(dot)
			dot._setup(id, coord.x, coord.y, dotRadius, dotColour, dotColliderBuffer)
			dot.mouse_enter.connect(_on_dot_mouse_enter)
			dot.mouse_leave.connect(_on_dot_mouse_leave)
			dotNodes[id] = coord
			id += 1


func _process(_delta):
	queue_redraw()
	
func _draw():
	if mouseClicked and selectedNodes.size() > 0:
		drawPath(-1)
		highlightDot(-1)
		for i in selectedNodes.size() - 1:
			if isAdjacent(i, i+1):
				drawPath(i, i+1)
			highlightDot(i)

func highlightDot(id):
	draw_arc(dotNodes[selectedNodes[id]], dotRadius + dotColliderBuffer, 0, 360, 50, pathColour, pathThickness)

func drawPath(start_id, end_id = null):
	var start = dotNodes[selectedNodes[start_id]]
	var end = 0
	if end_id == null:
		end = get_global_mouse_position()
	else:
		end = dotNodes[selectedNodes[end_id]]
	draw_line(start, end, pathColour, pathThickness)
	
func isAdjacent(start_id, end_id):
	var start = dotNodes[selectedNodes[start_id]]
	var end = dotNodes[selectedNodes[end_id]]
	
	var withinX = abs(start.x - end.x) <= (dotLast.x - dotFirst.x) / (dotRows - 1)
	var withinY = abs(start.y - end.y) <= (dotLast.y - dotFirst.y) / (dotColumns - 1)
	
	if withinX && withinY:
		return true
	return false

func _input(event):
	if event.is_action_pressed("click"): 
		mouseClicked = true
		if currentNode != null:
			registerDot()
	elif event.is_action_released("click"):
		mouseClicked = false
		parsePath()

func _on_dot_mouse_enter(id):
	currentNode = id
	if mouseClicked:
		registerDot()

func _on_dot_mouse_leave(_id):
	currentNode = null

func registerDot():
	if selectedNodes.size() > 0 && selectedNodes[-1] == currentNode:
		return
	else:
		selectedNodes.append(currentNode)

func parsePath():
	if translatePath.has(selectedNodes):
		print(translatePath[selectedNodes])
	else:
		print(selectedNodes)
	selectedNodes.clear()
