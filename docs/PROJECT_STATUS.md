# 📋 Project Status — Bugigangas Go

> **Última atualização:** 2026-06-09
> **Status:** Em desenvolvimento ativo

---

## 1. Visão Geral

**Bugigangas Go** é um aplicativo de rastreamento de pacotes desenvolvido em Flutter, com backend PostgreSQL (Neon) e integração com a API Seu Rastreio.

| Aspecto | Detalhe |
|---------|---------|
| **Plataformas** | Android, iOS, Web |
| **SDK** | Flutter 3.12.1+ / Dart 3.12.1+ |
| **Estado** | MVP funcional com autenticação, rastreamento real e persistência |
| **Banco de dados** | Neon (PostgreSQL serverless) + Hive (local cache) |
| **API de rastreio** | Correios RapidAPI (correios-rastreamento-de-encomendas) com fallback mock |

---

## 2. Arquitetura

### Estrutura de Pastas

```
lib/
├── main.dart                          # Entry point + ProviderScope
├── core/
│   ├── database/
│   │   ├── neon_config.dart           # Neon connection config
│   │   └── neon_service.dart          # CRUD operations (users, packages)
│   ├── security/
│   │   └── password_hasher.dart       # SHA-256 + salt password hashing
│   ├── router.dart                    # GoRouter configuration
│   └── theme/
│       ├── app_colors.dart            # Color tokens
│       ├── app_spacing.dart           # Spacing tokens
│       ├── app_theme.dart             # Material 3 ThemeData
│       └── app_typography.dart        # Typography tokens
├── features/
│   ├── auth/
│   │   ├── data/app_database.dart     # Local SQLite (unused)
│   │   ├── domain/user_model.dart     # UserModel
│   │   └── presentation/
│   │       ├── auth_providers.dart    # Auth state + actions (Riverpod)
│   │       ├── language_screen.dart   # Language selection
│   │       ├── login_screen.dart      # Login form
│   │       ├── register_screen.dart   # Registration form
│   │       ├── splash_screen.dart     # Splash with auto-redirect
│   │       └── welcome_screen.dart    # Onboarding carousel
│   ├── home/
│   │   └── presentation/
│   │       └── home_screen.dart       # Main dashboard with filters + package list
│   ├── postage/
│   │   └── presentation/
│   │       └── buy_postage_screen.dart # Shipping options screen
│   ├── profile/
│   │   └── presentation/
│   │       └── profile_screen.dart    # User profile + logout
│   ├── search/
│   │   └── presentation/
│   │       └── search_screen.dart     # Search placeholder
│   ├── support/
│   │   └── presentation/
│   │       └── support_screen.dart    # Chat/FAQ support
│   └── tracking/
│       ├── data/
│       │   ├── package_repository.dart     # API + mock data
│       │   └── package_repository.g.dart   # Generated Riverpod provider
│       ├── domain/
│       │   ├── package_model.dart          # PackageModel (freezed)
│       │   ├── package_model.freezed.dart
│       │   ├── package_model.g.dart
│       │   ├── tracking_event.dart         # TrackingEvent (freezed)
│       │   ├── tracking_event.freezed.dart
│       │   └── tracking_event.g.dart
│       └── presentation/
│           ├── add_package_sheet.dart       # Add package bottom sheet
│           ├── edit_package_sheet.dart      # Edit package bottom sheet
│           ├── package_detail_screen.dart   # Package detail + timeline
│           ├── tracking_providers.dart      # State management (Riverpod)
│           └── tracking_screen.dart         # Full tracking list
├── l10n/
│   └── app_strings.dart             # i18n pt-BR + en-US
└── shared/
    └── widgets/
        ├── floating_bottom_nav.dart  # Custom 5-item bottom nav
        ├── app_shell.dart            # ShellRoute wrapper
        └── status_badge.dart         # Status badge + StatusCategory enum
```

### Gerenciamento de Estado (Riverpod)

| Provider | Tipo | Finalidade |
|----------|------|------------|
| `authStateProvider` | `StateNotifierProvider` | Usuário logado (UserModel?) |
| `authActionsProvider` | `Provider` | Ações de login/register/logout |
| `localeProvider` | `StateProvider<Locale>` | Idioma ativo |
| `packageListProvider` | `StateNotifierProvider` | Lista de pacotes (Neon + API) |
| `packageRepositoryProvider` | `Provider` (generated) | Repositório de dados |
| `neonServiceProvider` | `Provider` | Conexão Neon |
| `searchQueryProvider` | `StateProvider<String>` | Texto da busca |
| `statusFilterProvider` | `StateProvider<int>` | Índice do filtro ativo (0-3) |
| `archivedCodesProvider` | `StateProvider<Set<String>>` | Códigos arquivados |
| `filteredPackageListProvider` | `Provider` | Lista filtrada (status + busca) |
| `packageByCodeProvider` | `Provider.family` | Lookup de pacote único |
| `themeModeProvider` | `StateProvider<ThemeMode>` | Modo do tema (system/light/dark) |
| `cacheServiceProvider` | `Provider<CacheService>` | Cache local Hive |

---

## 3. Fluxo de Dados

```
Auth Flow:
  SplashScreen → WelcomeScreen (1st time) → LanguageScreen → LoginScreen → HomeScreen
                                                              → RegisterScreen

Package Flow:
  HomeScreen / TrackingScreen
    → searchQueryProvider + statusFilterProvider
      → filteredPackageListProvider
        → ListView.builder(_PackageCard)
          → onTap → _showPackageActions (bottom sheet)
              ├── Ver Detalhes → PackageDetailScreen
              ├── Editar → EditPackageSheet
              ├── Arquivar → archivedCodesProvider
              └── Excluir → packageListProvider.removePackage()

API Flow:
  AddPackageSheet → packageListProvider.addPackageWithDetails()
    → packageRepository.getPackage(code)
      → Correios RapidAPI (if key available)
        → _parseCorreiosResponse()
      → Fallback mock data
    → Persist to Neon (if logged in)
    → Update Hive cache

Cache Flow:
  App start → PackageListNotifier._initialize()
    1. Load from Hive cache (instant UI)
    2. Fetch from Neon (fresh data)
    3. Update Hive cache with fresh data
```

---

## 4. Filtros de Status

Os pacotes são categorizados automaticamente pelo método `StatusBadge.categorizeStatus()` usando `contains()` case-insensitive:

| Filtro | Índice | Categorias | Status de Exemplo |
|--------|--------|------------|-------------------|
| **Pendentes** | 0 | `processing` + `inTransit` + `exception` | "Objeto postado", "Em trânsito", "Não encontrado" |
| **Pra Entregar** | 1 | `outForDelivery` | "Objeto saiu para entrega ao destinatário" |
| **Entregues** | 2 | `delivered` | "Objeto entregue ao destinatário", "Entrega Realizada" |
| **Arquivados** | 3 | Códigos em `archivedCodesProvider` | Ação manual do usuário |

### Tabela de Matching (StatusBadge.categorizeStatus)

| Padrão (contains) | Categoria |
|-------------------|-----------|
| `"saiu para entrega"`, `"saiu p/ entrega"`, `"out for delivery"` | `outForDelivery` (verificado 1º) |
| `"entreg"`, `"delivered"` | `delivered` |
| `"trânsito"`, `"transit"` | `inTransit` |
| `"postado"`, `"registrado"`, `"processing"` | `processing` |
| `"não encontrado"`, `"exception"`, `"erro"`, `"error"`, `"não localizado"` | `exception` |
| Qualquer outro | `processing` (default) |

---

## 5. Design System

### Paleta de Cores

| Token | Hex | Uso |
|-------|-----|-----|
| `primary` | `#009696` | Botões, abas ativas, nav |
| `primaryContainer` | `#B2F0F0` | Tags, backgrounds leves |
| `background` | `#F5F7F9` | Fundo do scaffold |
| `textPrimary` | `#1A1A1A` | Títulos e corpo |
| `textSecondary` | `#757575` | Subtítulos |
| `textHint` | `#9CA3AF` | Placeholders |

### Cores de Status

| Categoria | Background | Foreground |
|-----------|-----------|------------|
| Processing | `#FFF3E0` | `#E65100` |
| In Transit | `#E3F2FD` | `#0D47A1` |
| Out for Delivery | `#F3E5F5` | `#4A148C` |
| Delivered | `#E8F5E9` | `#1B5E20` |
| Exception | `#FFEBEE` | `#B71C1C` |

### Tipografia

- **Fonte:** Poppins (Google Fonts) com fallback para Inter/Roboto
- **Títulos:** SemiBold (600) a Bold (700)
- **Corpo:** Regular (400)
- **Códigos:** `font-family: monospace`, `letter-spacing: 1.5`

### Bordas

| Componente | Raio |
|------------|------|
| Cards principais | `24` |
| Search bar | `28` |
| Badges de status | `20` |
| Bottom nav | `24` (topo) |
| Botões CTA | `16` |
| Header home | `32` (inferior) |

---

## 6. Funcionalidades Implementadas

### ✅ Autenticação
- [x] Cadastro com nome, email e senha
- [x] Login com verificação de senha hasheada (SHA-256 + salt)
- [x] Splash com redirect automático
- [x] Onboarding (welcome carousel)
- [x] Seleção de idioma (pt-BR / en-US)
- [x] Logout com confirmação

### ✅ Rastreamento
- [x] Adicionar pacote por código de rastreio
- [x] Editar descrição e tags do pacote
- [x] Excluir pacote (com confirmação)
- [x] Arquivar pacote
- [x] Busca por código/descrição/tags
- [x] Filtros por status (Pendentes / Pra Entregar / Entregues / Arquivados)
- [x] Integração com API Seu Rastreio (com fallback mock)
- [x] Refresh manual (pull-to-refresh + botão)
- [x] Detalhes do pacote com timeline de eventos
- [x] Badge de status com cor e ícone

### ✅ Persistência
- [x] Neon PostgreSQL (usuários + pacotes)
- [x] Pacotes persistidos por usuário
- [x] CRUD completo de pacotes no banco
- [x] Criptografia de senha (SHA-256 + salt)
- [x] Cache offline com Hive (cache-first strategy)

### ✅ UI/UX
- [x] Design System consistente (Material 3)
- [x] Navegação inferior flutuante com 5 itens
- [x] Botão de busca central destacado
- [x] Header gradiente com avatar + notificações
- [x] Cards de pacote com cores alternadas
- [x] Cores de status acessíveis (ícone + cor)
- [x] Dark mode completo (toggle no perfil, persistido)
- [x] Internacionalização pt-BR e en-US
- [x] Bottom sheet de ações (detalhes/editar/arquivar/excluir)
- [x] Tela de compra de postagem
- [x] Tela de suporte (chat/FAQ)

---

## 7. Changelog Recente

### 2026-06-09 — Sprint atual

| Mudança | Arquivos | Descrição |
|---------|----------|-----------|
| Status filter refactor | `status_badge.dart`, `tracking_providers.dart` | `categorizeStatus` migrado de `switch` exato para `if-else` com `contains()` |
| Edit package | `edit_package_sheet.dart` (novo), `tracking_providers.dart` | Bottom sheet para editar descrição e tags |
| Archive packages | `tracking_providers.dart`, `home_screen.dart` | `archivedCodesProvider` + filtro Arquivados |
| Package actions | `home_screen.dart` | Bottom sheet com Ver/Editar/Arquivar/Excluir |
| Launcher icons | `pubspec.yaml` | Configuração `flutter_launcher_icons` adicionada |
| Remove PostNord | `home_screen.dart` | Seção "Encomendas PostNord" removida |
| Filter labels | `home_screen.dart`, `app_strings.dart` | Sub-menus substituídos por Pendentes/Pra Entregar/Entregues/Arquivados |
| Persist edits | `neon_service.dart` | Método `updatePackage` no Neon |

### Sprints anteriores

| Mudança | Descrição |
|---------|-----------|
| i18n completo | 14 telas migradas para `AppStrings.of(context)` |
| Nome do usuário | Home e Profile exibem nome real do banco |
| Pacotes no Neon | Tabela `packages` + CRUD no banco |
| Criptografia | `PasswordHasher` com SHA-256 + salt |
| API Seu Rastreio | Integração com fallback mock |
| Floating nav | Bottom nav customizada com 5 itens |
| Home redesign | Header gradiente + busca + filtros + cards |

---

## 8. Configuração do Ambiente

### Variáveis de ambiente (`.env`)

```
DATABASE_URL="postgresql://usuario:senha@host.neon.tech/nomedb?sslmode=require"
RAPIDAPI_KEY=minha_key_aqui
RAPIDAPI_HOST=correios-rastreamento-de-encomendas.p.rapidapi.com
RAPIDAPI_BASE_URL=https://correios-rastreamento-de-encomendas.p.rapidapi.com
```

### Comandos úteis

```bash
flutter pub get                  # Instalar dependências
dart run build_runner build      # Gerar código (freezed, riverpod)
dart run flutter_launcher_icons  # Gerar ícones nativos
flutter analyze                  # Análise estática
flutter test                     # Rodar testes
flutter run                      # Executar em dispositivo/emulador
```

### Dependências principais

| Pacote | Versão | Uso |
|--------|--------|-----|
| `flutter_riverpod` | ^2.6.1 | Estado global |
| `go_router` | ^14.8.1 | Navegação |
| `dio` | ^5.8.0 | HTTP client |
| `freezed` | ^2.5.8 | Modelos imutáveis |
| `json_serializable` | ^6.9.0 | JSON serialization |
| `google_fonts` | ^6.1.0 | Tipografia Poppins |
| `flutter_svg` | ^2.0.10+1 | SVG rendering |
| `shimmer` | ^3.0.0 | Loading skeletons |
| `postgres` | ^3.0.0 | Conexão Neon |
| `flutter_dotenv` | ^5.2.1 | Variáveis de ambiente |
| `crypto` | ^3.0.6 | SHA-256 hashing |
| `hive` | ^2.2.3 | Local key-value storage |
| `hive_flutter` | ^1.1.0 | Flutter support for Hive |

---

## 9. Próximos Passos Recomendados

1. ⬜ **Testes de integração** — Fluxo completo de autenticação + rastreamento
2. ⬜ **Build de produção** — `flutter build apk --release` / `flutter build ios`
3. ⬜ **Notificações push** — Alertas de mudança de status
4. ⬜ **Widget tests** — Cobertura para telas principais
5. ⬜ **CI/CD** — GitHub Actions para build + test
6. ⬜ **Regenerar código freezed** — `dart run build_runner build --delete-conflicting-outputs`
7. ⬜ **Testar API Correios** — Validar com chave RapidAPI real

---

## 10. Estrutura do Banco (Neon)

### Tabela `users`
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id` | `SERIAL PRIMARY KEY` | ID auto-incremento |
| `name` | `TEXT NOT NULL` | Nome do usuário |
| `email` | `TEXT NOT NULL UNIQUE` | Email (login) |
| `password` | `TEXT NOT NULL` | Hash SHA-256 + salt |
| `created_at` | `TEXT NOT NULL` | ISO 8601 |

### Tabela `packages`
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id` | `SERIAL PRIMARY KEY` | ID auto-incremento |
| `user_id` | `INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE` | Dono do pacote |
| `code` | `TEXT NOT NULL` | Código de rastreio |
| `description` | `TEXT DEFAULT ''` | Nome/descrição |
| `status` | `TEXT DEFAULT 'Registrado'` | Status atual |
| `origin` | `TEXT DEFAULT ''` | Origem |
| `destination` | `TEXT DEFAULT ''` | Destino |
| `last_update` | `TEXT` | Última atualização |
| `tags` | `TEXT DEFAULT ''` | Tags (JSON array) |
| `created_at` | `TEXT NOT NULL` | ISO 8601 |
| **UNIQUE** | `(user_id, code)` | Sem duplicatas por usuário |

---

*Documento gerado e mantido pela equipe de desenvolvimento.*
