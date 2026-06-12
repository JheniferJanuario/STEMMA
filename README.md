# 🐾 STEMMA — Sistema de Gestão Veterinária

STEMMA é uma aplicação fullstack para gestão de clínicas veterinárias, permitindo o cadastro de tutores, pets e veterinários, agendamento e controle de consultas, e geração de prontuários médicos.

---

## 🏗️ Arquitetura

O projeto é dividido em duas partes principais:

```text
STEMMA/
├── backend/       # API REST em ASP.NET Core 8 (Clean Architecture)
└── frontend/      # Aplicativo mobile/web em Flutter
```

### Backend — Clean Architecture

```text
STEMMA.Api            # Controllers, configuração e entry point
STEMMA.Application    # Use Cases, DTOs e Mappers
STEMMA.Domain         # Entidades e interfaces de repositório
STEMMA.Infrastructure # EF Core, DbContext e repositórios
```

### Frontend — Flutter

```text
lib/
├── Core/
│   ├── Constants/   # Paleta de cores
│   ├── Services/    # ApiService (HTTP)
│   ├── Widgets/     # Componentes reutilizáveis
│   └── vet/         # Páginas do veterinário (Core)
└── Features/
    ├── Login/       # Login, cadastro tutor/vet
    ├── Splash/      # Splash, welcome, calendário
    ├── tutor/       # Home, pets, consultas, perfil
    └── vet/         # Home e calendário do veterinário
```

---

## ✨ Funcionalidades

* **Autenticação** — login com diferenciação de perfil (Tutor / Veterinário)
* **Cadastro de Tutores** — criar, listar, atualizar e remover tutores
* **Cadastro de Pets** — criar, listar, atualizar e inativar pets vinculados a tutores
* **Cadastro de Veterinários** — criar, listar, atualizar e remover veterinários
* **Disponibilidade** — veterinário configura agenda de horários disponíveis
* **Consultas** — agendar, iniciar, finalizar e cancelar consultas
* **Prontuários** — adicionar e consultar prontuários por consulta ou por pet

---

## 🛠️ Tecnologias

### Backend

| Tecnologia            | Versão |
| --------------------- | ------ |
| .NET / ASP.NET Core   | 8.0    |
| Entity Framework Core | 8.0    |
| SQL Server (LocalDB)  | —      |
| Swagger (Swashbuckle) | 6.6.2  |

### Frontend

| Tecnologia         | Versão      |
| ------------------ | ----------- |
| Flutter / Dart     | SDK ^3.11.0 |
| http               | ^1.2.2      |
| shared_preferences | ^2.3.3      |

### Ferramenta para teste no celular

| Tecnologia | Uso                                                |
| ---------- | -------------------------------------------------- |
| ngrok      | Expor a API local para acessar pelo celular físico |

---

## 🚀 Como rodar o projeto

### Pré-requisitos

* [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8)
* [SQL Server LocalDB](https://learn.microsoft.com/sql/database-engine/configure-windows/sql-server-express-localdb) (instalado junto com o Visual Studio)
* [Flutter SDK](https://flutter.dev/docs/get-started/install) (^3.11.0)
* [ngrok](https://ngrok.com/) para testar a API no celular físico

---

## 🖥️ Rodando o Backend

```bash
# 1. Navegue até a pasta da API
cd backend/src/STEMMA.Api

# 2. Restaure as dependências
dotnet restore

# 3. Execute a API
dotnet run
```

A API ficará disponível localmente em:

```text
http://localhost:5215
```

A documentação Swagger local estará em:

```text
http://localhost:5215/swagger
```

> **Connection string padrão** (`appsettings.json`):
> `Server=(localdb)\MSSQLLocalDB;Database=STEMMA;Trusted_Connection=True`
> Altere conforme seu ambiente se necessário.

---

## 🌐 Rodando a API com ngrok

O ngrok é usado para criar uma URL pública que aponta para a API local.
No projeto STEMMA, a API está rodando na porta `5215`.

Com o backend já rodando, abra outro terminal e execute:

```bash
ngrok http 5215
```

Depois disso, o ngrok irá gerar uma URL pública.

Atualmente, a URL configurada no projeto é:

```text
https://bonding-agreed-said.ngrok-free.dev
```

A documentação Swagger pelo ngrok pode ser acessada em:

```text
https://bonding-agreed-said.ngrok-free.dev/swagger
```

> O terminal do ngrok precisa ficar aberto enquanto o app estiver sendo testado.
> Se o ngrok for fechado e aberto novamente, a URL pode mudar.
> Se a URL mudar, atualize também o `baseUrl` no Flutter.

---

## 📱 Rodando o Frontend

```bash
# 1. Navegue até a pasta do app
cd frontend/stemma_app

# 2. Instale as dependências
flutter pub get

# 3. Execute o app
flutter run
```

A URL da API está definida no arquivo:

```text
frontend/stemma_app/lib/Core/Services/api_service.dart
```

Atualmente, o `baseUrl` está configurado assim:

```dart
static const String baseUrl = 'https://bonding-agreed-said.ngrok-free.dev';
```

Essa URL é a conexão do Flutter com a API exposta pelo ngrok.

---

## 🔗 URLs por ambiente

| Ambiente                 | URL da API                                   |
| ------------------------ | -------------------------------------------- |
| Flutter Web / Windows    | `http://localhost:5215`                      |
| Android Emulator         | `http://10.0.2.2:5215`                       |
| Celular físico com ngrok | `https://bonding-agreed-said.ngrok-free.dev` |
| Celular físico sem ngrok | `http://<IP_DA_MAQUINA>:5215`                |

> Para testar no celular físico, use preferencialmente a URL do ngrok no `baseUrl`.

---

## ✅ Ordem correta para rodar tudo

1. Abrir o backend:

```bash
cd backend/src/STEMMA.Api
dotnet run
```

2. Abrir o ngrok em outro terminal:

```bash
ngrok http 5215
```

3. Conferir se o Swagger abre pelo ngrok:

```text
https://bonding-agreed-said.ngrok-free.dev/swagger
```

4. Abrir o frontend:

```bash
cd frontend/stemma_app
flutter pub get
flutter run
```

---

## 📡 Endpoints principais

| Recurso                       | Método             | Rota                                        |
| ----------------------------- | ------------------ | ------------------------------------------- |
| Login                         | POST               | `/api/Auth/login`                           |
| Tutores                       | GET / POST         | `/api/tutores`                              |
| Tutor por ID                  | GET / PUT / DELETE | `/api/tutores/{id}`                         |
| Pets                          | GET / POST         | `/api/pets`                                 |
| Pet por ID                    | GET / PUT          | `/api/pets/{id}`                            |
| Veterinários                  | GET / POST         | `/api/Veterinario`                          |
| Veterinário por ID            | GET / PUT / DELETE | `/api/Veterinario/{id}`                     |
| Consultas                     | GET / POST         | `/api/Consulta`                             |
| Iniciar consulta              | POST               | `/api/Consulta/{id}/start`                  |
| Finalizar consulta            | POST               | `/api/Consulta/{id}/complete`               |
| Cancelar consulta             | POST               | `/api/Consulta/{id}/cancel`                 |
| Prontuário por consulta       | GET                | `/api/prontuarios/{consultaId}`             |
| Prontuários por pet           | GET                | `/api/prontuarios/pet/{petId}`              |
| Adicionar prontuário          | POST               | `/api/Consulta/medical-record`              |
| Disponibilidade (agenda)      | POST               | `/api/Disponibilidade/agenda`               |
| Horários disponíveis          | GET                | `/api/Disponibilidade/horarios-disponiveis` |
| Histórico de consultas do pet | GET                | `/api/Consulta/historico-pet/{petId}`       |

Consulte a documentação completa via Swagger após subir a API.

---

## 📁 Estrutura de pastas resumida

```text
STEMMA/
├── backend/
│   └── src/
│       ├── STEMMA.Api/
│       ├── STEMMA.Application/
│       ├── STEMMA.Domain/
│       └── STEMMA.Infrastructure/
├── frontend/
│   └── stemma_app/
│       ├── lib/
│       │   ├── Core/
│       │   └── Features/
│       ├── assets/
│       └── pubspec.yaml
└── STEMMA.sln
```

---

## 🤝 Contribuindo

1. Faça um fork do repositório
2. Crie uma branch para sua feature:

```bash
git checkout -b feature/minha-feature
```

3. Commit suas alterações:

```bash
git commit -m "feat: minha feature"
```

4. Push para a branch:

```bash
git push origin feature/minha-feature
```

5. Abra um Pull Request

---
