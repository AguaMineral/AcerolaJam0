extends TextureRect

var dragging = false
var drag_offset = Vector2()
var velocity = Vector2()
var deceleration = 2000  # La tasa de desaceleración
var bounce_factor = -0.9  # Factor de rebote al tocar los bordes

func _ready():
	# Hacer que el nodo pueda recibir eventos de ratón
	set_mouse_filter(MOUSE_FILTER_STOP)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Comenzar a arrastrar
				dragging = true
				drag_offset = global_position - get_global_mouse_position()
				velocity = Vector2()  # Resetear la velocidad al comenzar a arrastrar
			else:
				# Dejar de arrastrar
				dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			# Calcular la nueva posición
			var new_position = get_global_mouse_position() + drag_offset
			# Actualizar la velocidad basada en el movimiento del ratón
			velocity = event.relative * 100
			# Limitar la nueva posición al área del Control padre
			new_position = limit_position_to_parent(new_position)
			# Mover la carta con el ratón
			global_position = new_position

func _process(delta: float) -> void:
	if not dragging and velocity.length() > 0:
		# Aplicar desaceleración
		velocity -= velocity.normalized() * deceleration * delta
		# Detener la carta si la velocidad es muy baja
		if velocity.length() < 100:
			velocity = Vector2()
	
		# Mover la carta basado en la velocidad
		var new_position = global_position + velocity * delta
		# Limitar la nueva posición al área del Control padre y aplicar rebote
		new_position = limit_position_to_parent_with_bounce(new_position, delta)
		# Actualizar la posición de la carta
		global_position =  new_position

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

func limit_position_to_parent_with_bounce(new_position: Vector2, delta: float) -> Vector2:
	var board: Control = get_parent()
	var board_rect: Rect2 = board.get_rect()
	var card_rect: Vector2 = get_rect().size  # Usar rect_size para obtener el tamaño de la carta
	
	# Convertir la posición local del tablero a una posición global
	var board_global_position: Vector2 = board.get_global_position()
	
	# Limitar horizontalmente y aplicar rebote
	if new_position.x < board_global_position.x:
		new_position.x = board_global_position.x
		velocity.x *= bounce_factor
	elif new_position.x + card_rect.x > board_global_position.x + board_rect.size.x:
		new_position.x = board_global_position.x + board_rect.size.x - card_rect.x
		velocity.x *= bounce_factor
	
	# Limitar verticalmente y aplicar rebote
	if new_position.y < board_global_position.y:
		new_position.y = board_global_position.y
		velocity.y *= bounce_factor
	elif new_position.y + card_rect.y > board_global_position.y + board_rect.size.y:
		new_position.y = board_global_position.y + board_rect.size.y - card_rect.y
		velocity.y *= bounce_factor
	
	return new_position

