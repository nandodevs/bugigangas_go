# 📦 Bugigangas Go

**Rastreador de pacotes inteligente** — Acompanhe suas encomendas em tempo real com suporte a múltiplas transportadoras, interface moderna e persistência na nuvem.

[![Flutter](https://img.shields.io/badge/Flutter-3.12+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart)](https://dart.dev)
[![Neon](https://img.shields.io/badge/Neon-PostgreSQL-00E59B?logo=postgresql)](https://neon.tech)

---

## ✨ Funcionalidades

- **🔍 Rastreamento em tempo real** — Integração com API Seu Rastreio + fallback mock
- **📊 Filtros inteligentes** — Pendentes, Pra Entregar, Entregues e Arquivados
- **🔎 Busca avançada** — Por código, descrição ou tags
- **📝 Gerenciamento de pacotes** — Adicionar, editar descrição/tags, arquivar e excluir
- **📋 Timeline de eventos** — Histórico completo de cada etapa da entrega
- **🌐 Internacionalização** — Português (Brasil) e Inglês
- **🔒 Autenticação segura** — Cadastro/login com senha hasheada (SHA-256 + salt)
- **☁️ Persistência na nuvem** — Neon PostgreSQL serverless
- **🎨 Design System consistente** — Material 3 com tema teal

---

## 📱 Screens

| Tela | Descrição |
|------|-----------|
| **Home / Dashboard** | Header gradiente, busca, filtros de status, lista de pacotes |
| **Detalhes do Pacote** | Status hero, informações, timeline de eventos |
| **Adicionar Pacote** | Bottom sheet com código, descrição e tags |
| **Editar Pacote** | Bottom sheet pré-preenchida para alterar descrição e tags |
| **Comprar Postagem** | Opções de envio (carta, pacote, cartão postal) |
| **Suporte** | Chat e FAQ |
| **Perfil** | Dados do usuário e logout |
| **Autenticação** | Splash, Welcome, Login e Cadastro |

---

## 🚀 Começando

### Pré-requisitos

- Flutter SDK 3.12.1+
- Dart 3.12.1+
- Conta no [Neon](https://neon.tech) (PostgreSQL serverless)
- (Opcional) Token da [API Seu Rastreio](https://seurastreio.com.br)

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/bugigangas_go.git
cd bugigangas_go

# Configure as variáveis de ambiente
cp .env.example .env
# Edite .env com suas credenciais do Neon e token da API

# Instale as dependências
flutter pub get

# Gere os arquivos (freezed, riverpod)
dart run build_runner build

# Gere os ícones nativos
dart run flutter_launcher_icons

# Execute
flutter run
```

### Variáveis de Ambiente

| Variável | Obrigatório | Descrição |
|----------|-------------|-----------|
| `DATABASE_URL` | ✅ Sim | String de conexão PostgreSQL do Neon |
| `SEU_RASTREIO_TOKEN` | ❌ Opcional | Token da API Seu Rastreio (deixe vazio para usar dados mock) |

---

## 🏗️ Arquitetura

```
lib/
├── core/              # Configurações, tema, segurança, navegação
├── features/          # Módulos por funcionalidade
│   ├── auth/          # Autenticação (login, cadastro, onboarding)
│   ├── home/          # Dashboard principal
│   ├── postage/       # Compra de postagem
│   ├── profile/       # Perfil do usuário
│   ├── search/        # Busca
│   ├── support/       # Suporte e chat
│   └── tracking/      # Rastreamento (core)
├── l10n/              # Internacionalização pt-BR / en-US
└── shared/            # Widgets compartilhados
```

### Stack

| Camada | Tecnologia |
|--------|-----------|
| **UI** | Flutter + Material 3 |
| **Estado** | Riverpod (StateNotifier + StateProvider + Provider) |
| **Navegação** | GoRouter (ShellRoute + rotas standalone) |
| **Rede** | Dio |
| **Modelos** | Freezed + JsonSerializable |
| **Banco** | Neon (PostgreSQL) via `postgres` package |
| **Senhas** | SHA-256 + salt (`crypto` package) |

---

## 📖 Documentação

- [Project Status](docs/PROJECT_STATUS.md) — Status atual, arquitetura e changelog
- [Design Spec](docs/DESIGN-SPEC.md) — Especificação completa de UI/UX
- [Changelog](docs/CHANGELOG-IMPLEMENTACOES.md) — Histórico detalhado de implementações
- [Requisitos](docs/REQUISITOS-CORRECOES.md) — Requisitos e correções realizadas
- [App Design](docs/APP-DESIGN.md) — Visão geral do design

---

## 🧪 Testes

```bash
# Rodar todos os testes
flutter test

# Testes específicos
flutter test test/features/tracking/presentation/tracking_providers_test.dart
flutter test test/features/tracking/data/package_repository_test.dart
```

---

## 🤝 Contribuindo

1. Faça um Fork do projeto
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto é privado. Todos os direitos reservados.

---

## 👥 Equipe

- **Flutter PM + UI/UX Lead** — Decisões de produto, design e arquitetura
- **flutter-especialist** — Implementação técnica Flutter/Dart
- **ui-ux-architect** — Design de interface e experiência do usuário
