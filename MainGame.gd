extends Node2D

const SNAKE = 0 #constante para elejir el tile de la serpiente
const APPLE = 1 #constante para elejir el tile de la manzana 
const ROTTEN_APPLE = 2 #constante para elejir el tile de la manzana podrida
var apple_pos # posicion de la manzana
var rotten_apple_pos # posicion de la manzana podrida
var snake_body = [Vector2(5,10),Vector2(4,10),Vector2(3,10)]
var snake_direction = Vector2(1,0)
var add_apple = false
var add_rotten_apple = false

func _ready():
	apple_pos = place_apple() #setea la posicion de la manzana utilizando la funcion que coloca la manzana en una posicion random
	rotten_apple_pos = place_rotten_apple()  #setea la posicion de la manzana podrida utilizando la funcion que coloca la manzana en una posicion random

#funcion que posiciona de manera random la manzana
func place_apple():
	randomize()
	var x = randi() % 20 
	var y = randi() % 20
	return Vector2(x,y)
	
#funcion que posiciona de manera random la manzana podrida
func place_rotten_apple():
	randomize()
	var x = randi() % 20 
	var y = randi() % 20
	return Vector2(x,y)

#funcion que dibuja la manzana
func draw_apple():
	$SnakeApple.set_cell(apple_pos.x,apple_pos.y,APPLE)

#funcion que dibuja la manzana podrida
func draw_rotten_apple():
	$SnakeApple.set_cell(rotten_apple_pos.x,rotten_apple_pos.y,ROTTEN_APPLE)
	
#funcion que dibuja la serpiente 
func draw_snake():
	for block_index in snake_body.size():
		var block = snake_body[block_index]
		
		if block_index == 0:
			var head_dir = relation2(snake_body[0],snake_body[1])
			if head_dir == 'right':
				$SnakeApple.set_cell(block.x,block.y,SNAKE,true,false,false,Vector2(2,0))
			if head_dir == 'left':
				$SnakeApple.set_cell(block.x,block.y,SNAKE,false,false,false,Vector2(2,0))
			if head_dir == 'bottom':
				$SnakeApple.set_cell(block.x,block.y,SNAKE,false,true,false,Vector2(3,0))
			if head_dir == 'top':
				$SnakeApple.set_cell(block.x,block.y,SNAKE,false,false,false,Vector2(3,0))
		
		elif block_index == snake_body.size() -1:
			var tail_dir = relation2(snake_body[-1],snake_body[-2])
			if tail_dir == 'right':
				$SnakeApple.set_cell(block.x,block.y,SNAKE,false,false,false,Vector2(0,0))
			if tail_dir == 'left':
				$SnakeApple.set_cell(block.x,block.y,SNAKE,true,false,false,Vector2(0,0))
			if tail_dir == 'bottom':
				$SnakeApple.set_cell(block.x,block.y,SNAKE,false,false,false,Vector2(0,1))
			if tail_dir == 'top':
				$SnakeApple.set_cell(block.x,block.y,SNAKE,false,true,false,Vector2(0,1))
				
		else:
			var previuos_block = snake_body[block_index + 1] - block
			var next_block = snake_body[block_index - 1] - block
			if previuos_block.x == next_block.x:
				$SnakeApple.set_cell(block.x,block.y,SNAKE,false,false,false,Vector2(4,1))
			elif previuos_block.y == next_block.y:
				$SnakeApple.set_cell(block.x,block.y,SNAKE,false,false,false,Vector2(4,0))
			else: # esquinas
				if previuos_block.x == -1 and next_block.y == -1 or next_block.x == -1 and previuos_block.y == -1:
					$SnakeApple.set_cell(block.x,block.y,SNAKE,true,true,false,Vector2(5,0))
				if previuos_block.x == -1 and next_block.y == 1 or next_block.x == -1 and previuos_block.y == 1:
					$SnakeApple.set_cell(block.x,block.y,SNAKE,true,false,false,Vector2(5,0))
				if previuos_block.x == 1 and next_block.y == -1 or next_block.x == 1 and previuos_block.y == -1:
					$SnakeApple.set_cell(block.x,block.y,SNAKE,false,true,false,Vector2(5,0))
				if previuos_block.x == 1 and next_block.y == 1 or next_block.x == 1 and previuos_block.y == 1:
					$SnakeApple.set_cell(block.x,block.y,SNAKE,false,false,false,Vector2(5,0))

func relation2(first_block:Vector2,second_block:Vector2):
		var block_relation = second_block - first_block
		if block_relation == Vector2(-1,0): return 'left'
		if block_relation == Vector2(1,0): return 'right'
		if block_relation == Vector2(0,1): return 'bottom'
		if block_relation == Vector2(0,-1): return 'top'
		
#funcion que realiza el movimiento de la serpiente
func move_snake():
	if add_apple:
		delete_tiles(SNAKE)
		var body_copy = snake_body.slice(0,snake_body.size() - 1) #hacemos una copia de la serpiente sin la cola
		var new_head = body_copy[0] + snake_direction
		body_copy.insert(0,new_head)
		snake_body = body_copy
		add_apple = false
	else:
		delete_tiles(SNAKE)
		var body_copy = snake_body.slice(0,snake_body.size() - 2) #hacemos una copia de la serpiente sin la cola
		var new_head = body_copy[0] + snake_direction
		body_copy.insert(0,new_head)
		snake_body = body_copy

func delete_tiles(id:int):
	var cells = $SnakeApple.get_used_cells_by_id(id) #obtenemos todas las celdas correspondientes al Id
	for cell in cells:
		$SnakeApple.set_cell(cell.x,cell.y,-1)
		
func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		if not snake_direction == Vector2(0,1): #cheque si no me estoy moviendo para abajo
			snake_direction = Vector2(0,-1)
	if Input.is_action_just_pressed("ui_right"):#cheque si no me estoy moviendo para la izquierda
		if not snake_direction == Vector2(-1,0):
			snake_direction = Vector2(1,0)
	if Input.is_action_just_pressed("ui_left"):#cheque si no me estoy moviendo para la derecha
		if not snake_direction == Vector2(1,0):
			snake_direction = Vector2(-1,0)
	if Input.is_action_just_pressed("ui_down"):#cheque si no me estoy moviendo para arriba
		if not snake_direction == Vector2(0,-1):
			snake_direction = Vector2(0,1)
	
#funcion que chequea cuando como una manzana
func check_apple_eaten():
	if apple_pos == snake_body[0]: #si la posicion de la manzana y la posicion del la cabeza de la serpiente es la misma
		apple_pos = place_apple() #posiciono la manzana en un nuevo lugar random con la funcion place_apple()
		rotten_apple_pos = place_rotten_apple()
		add_apple = true
		get_tree().call_group('ScoreGroup','update_score',snake_body.size())
		$CrounchSound.play()

#funcion que chequea cuando como una manzana podrida
func check_rotten_apple_eaten():
	if rotten_apple_pos in snake_body:
		$CrounchSound.play()
		return true

#funcion que chequea si se termino el juego y resetea
func check_game_over():
	var head = snake_body[0]
	#Cuando la serpiente sale de la pantalla
	if head.x > 20 or head.x < 0 or head.y < 0 or head.y > 20:
		reset()
	elif check_rotten_apple_eaten():
		reset()
	#Cuando la serpiente se muerde a si misma
	for block in snake_body.slice(1,snake_body.size() - 1):
		if block == head:
			reset()
			
#funcion que resetea la posicion de la serpiente y el tamaño
func reset():
	snake_body = [Vector2(5,10),Vector2(4,10),Vector2(3,10)]
	snake_direction = Vector2(1,0)
	
func _on_SnakeTick_timeout():
	move_snake()
	draw_apple()
	draw_rotten_apple()
	draw_snake()
	check_apple_eaten()
	check_game_over()
	
func _process(delta):
	check_game_over()
	if apple_pos in snake_body:
		apple_pos = place_apple()



