extends TextureRect

var dragging = false
var drag_offset = Vector2()
var target_position = Vector2()
@export var mouse_follow_speed = 15.0  # Velocidad de seguimiento del mouse
@onready var info_panel = $InfoPanel

func _ready():
	# Hacer que el nodo pueda recibir eventos de ratón
	set_mouse_filter(MOUSE_FILTER_STOP)
	info_panel.visible = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Comenzar a arrastrar
				dragging = true
				drag_offset = global_position - get_global_mouse_position()
			else:
				# Dejar de arrastrar
				dragging = false
		if  event.double_click:
				info_panel.visible = !info_panel.visible
	elif event is InputEventMouseMotion:
		if dragging:
			# Calcular la nueva posición objetivo
			target_position = get_global_mouse_position() + drag_offset
			# Limitar la nueva posición al área del Control padre
			target_position = limit_position_to_parent(target_position)

func _process(delta: float) -> void:
	if dragging:
		# Mover la carta suavemente hacia la posición objetivo
		global_position = global_position.lerp(target_position, mouse_follow_speed * delta)

func limit_position_to_parent(new_position: Vector2) -> Vector2:
	var board: Control = get_parent()  # Asumiendo que el nodo padre inmediato es el tablero
	var board_rect: Rect2 = board.get_rect()  # Obtener el rectángulo del tablero en su espacio local
	var card_rect: Rect2 = get_rect()  # Usar rect_size para obtener el tamaño de la carta
	
	# Convertir la posición local del tablero a una posición global
	var board_global_position: Vector2 = board.get_global_position()
	
	# Limitar horizontalmente
	if new_position.x < board_global_position.x:
		new_position.x = board_global_position.x
	elif new_position.x + card_rect.size.x > board_global_position.x + board_rect.size.x:
		new_position.x = board_global_position.x + board_rect.size.x - card_rect.size.x
	
	# Limitar verticalmente
	if new_position.y < board_global_position.y:
		new_position.y = board_global_position.y
	elif new_position.y + card_rect.size.y > board_global_position.y + board_rect.size.y:
		new_position.y = board_global_position.y + board_rect.size.y - card_rect.size.y
	
	return new_position
