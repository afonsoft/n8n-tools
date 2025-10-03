# n8n-tools

Projeto de apoio para executar localmente o n8n (workflow automation) usando Docker Compose.

Este repositório fornece um ambiente leve e reproduzível para desenvolvimento e testes locais com n8n + PostgreSQL.

## Descrição do projeto

`n8n-tools` tem como objetivo facilitar a execução local do n8n com configurações sensatas por padrão (timezone, persistência via bind-mounts locais, rotação de logs via Docker, e recomendações de recursos). O repositório contém um `docker-compose.yml`, um `start.sh` para levantar o ambiente rapidamente e diretórios de dados persistidos (`./n8n`, `./postgres`).

## Estrutura do repositório

```
n8n-tools/
├─ .env (opcional)              # Variáveis de ambiente locais
├─ .gitignore
├─ CHANGELOG.md                 # Histórico de mudanças (Keep a Changelog)
├─ LICENSE                      # Licença do repositório (GPLv3)
├─ README.md                    # Documentação (este arquivo)
├─ docker-compose.yml           # Compose para n8n + Postgres
├─ start.sh                     # Script para parar/levantar o ambiente
├─ n8n/                         # Dados persistidos do n8n (bind mount)
│  ├─ config/
│  ├─ binaryData/
│  └─ n8nEventLog.log
└─ postgres/                    # Dados persistidos do Postgres (bind mount)
```

Breve descrição dos itens-chave:

- `docker-compose.yml`: define os serviços `n8n` e `postgres` com variáveis de ambiente, bloqueios de logs e recomendações de recursos. Usa bind-mounts `./n8n` e `./postgres` para persistência.
- `start.sh`: script auxiliar para reiniciar o ambiente e abrir a URL do n8n.
- `n8n/` e `postgres/`: diretórios locais usados como volumes bind; serão criados pelo Compose se não existirem.

## Como rodar (desenvolvimento local)

Pré-requisitos:

- Docker Desktop / Docker Engine com Compose
- Pelo menos 1 CPU livre e 1 GB de RAM disponível para o ambiente

Comandos rápidos (no Windows use Git Bash ou WSL para executar `start.sh`):

```bash
# Torna o script executável (se em Linux/WSL)
chmod +x ./start.sh
./start.sh
```

Ou manualmente:

```bash
docker compose down
docker compose up --build -d
```

Abra em: http://localhost:5678

Observações:

- As chaves `deploy.resources` do `docker-compose.yml` são aplicáveis em Docker Swarm (ex.: `docker stack deploy`). Para `docker compose up` clássico, adicione `mem_limit`/`cpus` se quiser limites aplicáveis sem Swarm.
- Mantenha o `POSTGRES_PASSWORD` fora do repositório; prefira um arquivo `.env` ou Docker secrets.

## Variáveis de ambiente relevantes

Recomendadas para o uso com `.env` (coloque em `.env` ou em variáveis de ambiente do seu sistema):

```env
# Postgres
POSTGRES_PASSWORD=troque_por_senha_segura

# n8n
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
GENERIC_TIMEZONE=America/Sao_Paulo
TZ=America/Sao_Paulo

# Opcional: autenticação básica
N8N_BASIC_AUTH_ACTIVE=false
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=troque_por_senha

# Criptografia de credenciais do n8n (32+ chars)
N8N_ENCRYPTION_KEY=uma_chave_forte_aqui
```

Outras variáveis que o n8n pode aceitar (consulte a documentação oficial para detalhes adicionais):

- `DB_TYPE`, `DB_POSTGRESDB_HOST`, `DB_POSTGRESDB_DATABASE`, `DB_POSTGRESDB_USER`, `DB_POSTGRESDB_PASSWORD`
- `EXECUTIONS_MODE`, `EXECUTIONS_PROCESS`, `QUEUE_BULL_REDIS_*` (quando usar modo de filas)
- `N8N_LOG_LEVEL` (ex.: `error`, `warn`, `info`, `debug`)

## Postgres: logs e otimizações sugeridas

As configurações recomendadas para reduzir ruído de logs e ajustar recursos são aplicadas via `command: postgres -c "param=valor"` no `docker-compose.yml`. Exemplo de parâmetros:

- `log_min_messages = error`  (apenas erros serão registrados)
- `log_statement = none`      (não logar cada query)
- `shared_buffers = 256MB`    (ajuste conforme RAM disponível)
- `effective_cache_size = 512MB`

Trade-offs: reduzir logs facilita I/O e armazenamento, mas reduz visibilidade para debug. Ajuste conforme ambiente e necessidades de suporte.

## Observabilidade e Telemetria

Não foram encontrados arquivos de integração com DataDog, OpenTelemetry ou QuickConfig neste repositório. Recomendações rápidas:

- Enviar métricas básicas e logs para um coletor (Prometheus + Grafana ou DataDog)
- Expor métricas do Postgres (pg_exporter) e do sistema
- Habilitar tracing se necessário (OpenTelemetry) para analisar execução de workflows complexos

## SRE: boas práticas e recomendações

- Nunca versionar segredos. Use `.env`, Docker secrets ou um vault.
- Fazer backups regulares do diretório `postgres/` (dump ou snapshot do volume).
- Usar `healthcheck` para o serviço Postgres (`pg_isready`) e para o n8n se aplicável.
- Considerar `pgbouncer` para reduzir número de conexões simultâneas ao Postgres em cenários com muitos workflows.

## Exemplos práticos de engenharia (visões técnicas)

Visão de negócio: este repositório entrega um ambiente local confiável para desenvolvedores criarem e testarem workflows do n8n rapidamente, reduzindo o tempo de setup.

Visão técnica: arquitetura simples baseada em containers (n8n + Postgres), armazenamento local para persistência e recomendações para produção (HTTPS, proxy reverso, volumes gerenciados).

## Padrão de commits

Use Conventional Commits. Exemplos:

- feat(auth): adicionar basic auth no n8n
- fix(postgres): ajustar parâmetros de logging
- docs(readme): atualizar instruções de execução

## Contribuindo

- Abra uma issue antes de grandes mudanças.
- Crie uma branch feature com o padrão `feature/YYYY-MM-DD-descrição`.
- Siga os testes (se existirem) e o padrão de commits.

## Licença

Este repositório inclui `LICENSE` com GNU GPLv3. Se essa licença não for desejada, atualize o arquivo `LICENSE` conforme política interna.

## Changelog

O histórico de mudanças está em `CHANGELOG.md` (formato Keep a Changelog). Veja também a seção "CHANGELOG" abaixo.

---

Se quiser, eu posso:

1. Criar um `.env.example` com placeholders seguros;
2. Adicionar um `start.bat` para Windows;
3. Montar um `postgresql.conf` de exemplo e alterar o `docker-compose.yml` para usá-lo.

Diga qual opção prefere e eu continuo.
