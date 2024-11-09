extends CanvasLayer

@onready var background = $Background
@onready var drawGrid = $"Background/Draw Grid"
var visiblePos
var hidePos
var spriteOffset

signal main_window_size_changed()

var last_size : Vector2i


var hideState = false

func _ready():
	last_size = DisplayServer.window_get_size()
	main_window_size_changed.connect(_on_main_window_size_changed)
	
	spriteOffset = background.position
	background.position = Vector2.ZERO
	background.offset = spriteOffset
	visiblePos = background.position
	hidePos = Vector2(-100, -100)
	
	drawGrid.setup(spriteOffset)


func _physics_process(_delta):
	if last_size != DisplayServer.window_get_size():
		last_size = DisplayServer.window_get_size()
		main_window_size_changed.emit()
	
func _on_main_window_size_changed():
	print("Window size changed: " + str(last_size)) 

func _input(event):
	if event.is_action_pressed("rightclick"):
		hideState = !hideState
		var pos
		if hideState:
			pos = hidePos
		else:
			pos = visiblePos
		var tween = create_tween()
		if !hideState:
			tween.tween_property(background, "modulate:a", 1, 0)
		tween.tween_property(background, "position", pos, .3)
		if hideState:
			tween.tween_property(background, "modulate:a", 0, 0)
		
