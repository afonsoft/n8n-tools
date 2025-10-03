# n8n-tools

Projeto de apoio para execução local do n8n usando Docker Compose.

Este repositório contém artefatos e configurações para subir um ambiente
simples com n8n e PostgreSQL para desenvolvimento e testes locais.

## Descrição do projeto

`n8n-tools` fornece um `docker-compose.yml` pronto para executar o
workflow-automation n8n com PostgreSQL, um script `start.sh` para facilitar
o ciclo parar/iniciar e exemplos de configuração (timezone, limites de
recursos e bind-mounts locais para persistência de dados).

O objetivo é ser um repositório leve para ambiente de desenvolvimento
local, com foco em reproducibilidade e facilidade de uso.

## Estrutura do repositório

```
n8n-tools/
├── docker-compose.yml     # Compose para n8n + Postgres (bind mounts, logs, timezone)
├── start.sh               # Script simples para reiniciar o ambiente e abrir n8n
├── LICENSE                # GPLv3 (arquivo de licença do repositório)
├── README.md              # Este arquivo
└── postgres/              # Dados do Postgres (bind mount local)
		└── ...               # (será criado pelo compose se não existir)
```

Descrição sucinta dos arquivos/pastas:

- `docker-compose.yml`: define os serviços `n8n` e `postgres`. Usa bind
	mounts relativos (`./n8n` e `./postgres`) para persistência. Possui
	variáveis de ambiente, timezone configurado para `America/Sao_Paulo`,
	e blocos `deploy.resources` para recomendar limites de CPU/memória (úteis
	com Docker Swarm). Também inclui configuração básica de rotação de logs.
- `start.sh`: script shell simples (sem parâmetros) que dá `down`, faz
	`up --build -d`, aguarda e tenta abrir `http://localhost:5678`.
- `LICENSE`: contém GNU GPLv3 — isto significa que o projeto está licenciado
	sob a GPLv3. Consulte o arquivo `LICENSE` para os termos completos.

## Como rodar (desenvolvimento local)

Pré-requisitos

- Docker Desktop ou Docker Engine com Compose integrado.
- No mínimo 1 CPU livre e 1 GB de RAM para ambiente de desenvolvimento.

Passos básicos

```bash
# Na raiz do repositório
chmod +x ./start.sh    # se estiver em WSL/Git Bash
./start.sh
```

Ou manualmente:

```bash
docker compose down
docker compose up --build -d
```

Depois abra: http://localhost:5678

Observações

- O `docker-compose.yml` inclui chaves `deploy.resources` que são aplicadas
	quando você usa Docker Swarm (`docker stack deploy`) e são ignoradas pelo
	`docker compose up` tradicional. Se quiser limites aplicáveis no
	`docker-compose up`, posso adicionar chaves como `mem_limit` e `cpus`.
- Os dados do n8n e do Postgres são persistidos em `./n8n` e `./postgres`
	(bind mounts). As pastas serão criadas automaticamente; ajuste permissões
	se necessário.
- Variáveis importantes: `POSTGRES_PASSWORD` (obrigatória) — seja cauteloso
	ao colocá-la em arquivos públicos.

## Variáveis de ambiente

- POSTGRES_PASSWORD: senha do usuário `n8n` no Postgres (requerido).
- GENERIC_TIMEZONE / TZ: definidas como `America/Sao_Paulo` no compose.

Exemplo de uso no `.env` (opcional):

```env
# .env (opcional)
POSTGRES_PASSWORD=troque_aqui
```

## Stack tecnológica

- n8n (container oficial `n8nio/n8n`)
- PostgreSQL 15
- Docker / Docker Compose

## Observabilidade / Telemetria

Não foram encontrados arquivos de configuração para DataDog, OpenTelemetry
ou integração com QuickConfig no repositório. Se for necessário, posso
propor um esboço de integração (ex.: exporter, sidecar ou variáveis de
ambiente no compose).

## Segurança e SRE (recomendações rápidas)

- Nunca deixe `POSTGRES_PASSWORD` em texto plano em repositórios públicos.
- Para ambientes de produção, evite bind mounts em pastas de projeto; use
	volumes gerenciados e backup regular.
- Habilite rotação de logs e limites de recursos (já configurados como
	exemplo no compose). Para `docker-compose up` sem Swarm, adicione chaves
	compatíveis (`mem_limit`, `cpus`) se quiser que limites sejam aplicados.

## Licença

Este repositório inclui o arquivo `LICENSE` com a GNU General Public License
v3 (GPLv3).

## CHANGELOG

O changelog segue o formato "Keep a Changelog" e está em `CHANGELOG.md`.

## Status do projeto

Concluído (configuração inicial e scripts de suporte para desenvolvimento local).

## Notas para contribuidores

- Padrão de commits sugerido: Conventional Commits.
- Para alterações de documentação, use `docs(...)`.

---

Se quiser, eu crio/atualizo também um `CHANGELOG.md` (Preparei um a partir do
histórico recente). Se desejar, eu também adiciono um `start.bat` para Windows.
