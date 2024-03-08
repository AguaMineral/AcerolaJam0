extends Area2D

var dragging = false
var drag_offset = Vector2()

func _ready():
	# Hacer que el nodo pueda recibir eventos de ratón
	pass

func _input_event(viewport, event: InputEvent, shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Comenzar a arrastrar
				dragging = true
				drag_offset = position - get_global_mouse_position()
			else:
				# Dejar de arrastrar
				dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			# Mover la carta con el ratón
			position = get_global_mouse_position() + drag_offset
