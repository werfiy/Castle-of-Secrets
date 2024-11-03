extends CharacterBody2D

@export var patrol_distance: float = 20.0
@export var speed: float = 100.0
@export var detection_range: float = 200.0
@export var attack_range: float = 30.0
@export var attack_damage: int = 1
@export var max_health: int = 3

var health: int
var is_moving_left: bool = true
var is_chasing: bool = false


onready var player: CharacterBody2D = null  # Переменная для игрока, обновится в _ready()

func _ready() -> void:
	health = max_health
	# Поиск игрока в сцене
	player = get_tree().get_root().get_node("Player")  # Замените путь, если путь к игроку другой

func _physics_process(delta: float) -> void:
	if not is_chasing:
		patrol(delta)
	else:
		chase_player(delta)

	move_and_slide()

func patrol(delta: float) -> void:
	# Определение направления патрулирования и движения
	if is_moving_left:
		velocity.x = -speed
	else:
		velocity.x = speed

	animation_player.play("walk")

	# Переключение направления, если достигли предела патрулирования
	if abs(position.x - patrol_distance) >= patrol_distance:
		is_moving_left = not is_moving_left

	# Проверка на присутствие игрока в радиусе обнаружения
	if player and position.distance_to(player.position) <= detection_range:
		is_chasing = true

func chase_player(delta: float) -> void:
	# Если игрок в радиусе атаки, выполняем атаку
	if position.distance_to(player.position) <= attack_range:
		attack()
	else:
		# Перемещение к игроку
		velocity.x = speed * sign(player.position.x - position.x)
		animation_player.play("walk")

	# Выходим из состояния погони, если игрок выходит за пределы радиуса обнаружения
	if player and position.distance_to(player.position) > detection_range:
		is_chasing = false

func attack() -> void:
	# Играем анимацию атаки и наносим урон игроку
	animation_player.play("attack")
	if player and position.distance_to(player.position) <= attack_range:
		player.take_damage(attack_damage)

func take_damage(damage: int) -> void:
	health -= damage
	animation_player.play("hit")
	
	if health <= 0:
		die()

func die() -> void:
	animation_player.play("death")
	queue_free()  # Удаление объекта врага после смерти
