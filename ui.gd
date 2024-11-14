extends CanvasLayer

@onready var slab = $Slab
@onready var drawGrid = $"Slab/Draw Grid"
var visiblePos
var hidePos
var spriteOffset

signal main_window_size_changed()

var last_size : Vector2i


var hideState = false

func _ready():
	last_size = DisplayServer.window_get_size()
	main_window_size_changed.connect(_on_main_window_size_changed)
	
	
	spriteOffset = $"Slab/Grid Marker".position
	setSlabPos()
	
	drawGrid.setup(spriteOffset)


func _physics_process(_delta):
	if last_size != DisplayServer.window_get_size():
		last_size = DisplayServer.window_get_size()
		main_window_size_changed.emit()
	
func _on_main_window_size_changed():
	setSlabPos()
	print("Window size changed: " + str(last_size)) 

func setSlabPos():
	visiblePos = Vector2.ZERO
	hidePos = Vector2(last_size.x + 500, 0)

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
			tween.tween_property(slab, "modulate:a", 1, 0)
		tween.tween_property(slab, "position", pos, .3)
		if hideState:
			tween.tween_property(slab, "modulate:a", 0, 0)
		
