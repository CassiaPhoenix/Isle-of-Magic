extends Area2D

signal mouse_enter(id:int)
signal mouse_leave(id:int)


@export var id = -1
@export var drawOnReady = false
@export var x = 0.0
@export var y = 0.0
@export var r = 0.0
@export var c = Color(1,1,1)
@export var b = 0

func _ready():
	position = Vector2(x,y)
	$CollisionShape2D.shape.radius = r + b
	if drawOnReady:
		queue_redraw()
		

func _setup(i, pos_x, pos_y, rad, col, buff):
	id = i
	x = pos_x
	y = pos_y
	r = rad
	c = col
	b = buff
	_ready()

func _draw():
	draw_circle(Vector2.ZERO, r, c)

func _on_mouse_entered():
	emit_signal("mouse_enter", id)

func _on_mouse_exited():
	emit_signal("mouse_leave", id)
