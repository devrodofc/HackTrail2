extends Node

var current_day: int = 1
var player_score: int = 0
var hacked_tasks_to_fix: Array = []

func _ready() -> void:
	# Exemplo: O GameManager escutando o próprio EventBus para alterar seus dados
	EventBus.day_ended.connect(_on_day_ended)

func start_game() -> void:
	current_day = 1
	player_score = 0
	EventBus.game_started.emit()
	EventBus.day_started.emit(current_day)

func _on_day_ended(passed: bool) -> void:
	if passed:
		current_day += 1
	# Aqui depois decidiremos se chamamos uma tela de transição ou repetimos o dia
