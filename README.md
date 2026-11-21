# oficina-lex-banco-de-dados
Modelagem conceitual, lógica e física (MySQL) do sistema de gerenciamento da Oficina Lex.

# Oficina Lex — Modelagem de Banco de Dados

Projeto final da disciplina de **Modelagem de Banco de Dados**, referente ao sistema de gestão da **Oficina Lex** (clientes, veículos, funcionários, cargos, ordens de serviço, serviços executados, peças e estoque).

## Autoria
- **Alunas:** Anne Naiub e Lays Martins
- **Professora:** Josyanne Lannes

## Etapas do Projeto
1. **Modelagem Conceitual (MER):** Identificação das entidades, atributos, relacionamentos, cardinalidades e regras de negócio.
2. **Modelagem Lógica (DER):** Conversão das entidades e relacionamentos N:N (`servico_executado` e `peca_utilizada`) em tabelas com chaves primárias, chaves estrangeiras e restrições.
3. **Modelagem Física (MySQL):** Criação da base de dados `oficina_lex`, tabelas (`DDL`), inserção de dados iniciais (`DML`), `triggers`, *stored procedure* (`fechar_os`) e consultas SQL (básicas, intermediárias e avançadas).

## Estrutura do Repositório
- `docs/` — Documento final em PDF e diagramas/modelos do projeto.
- `sql/` — Scripts SQL separados por etapa (`DDL`, `DML`, `triggers` e `procedure`, e consultas).
