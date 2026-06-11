# Bugigangas Go — Documentação do Estado Atual

> Data: 10/06/2026  
> Projeto: Rastreador de pacotes em Flutter  
> Stack: Flutter 3.x + Riverpod + GoRouter + Neon PostgreSQL

---

## Sumário

1. [Visão Geral](#1-visão-geral)
2. [Estrutura do Projeto](#2-estrutura-do-projeto)
3. [Esquema do Banco de Dados](#3-esquema-do-banco-de-dados)
4. [Fluxo de Navegação](#4-fluxo-de-navegação)
5. [Fluxo de Autenticação](#5-fluxo-de-autenticação)
6. [Fluxo de Pacotes](#6-fluxo-de-pacotes)
7. [Tela de Splash](#7-tela-de-splash)
8. [Design System](#8-design-system)
9. [Assets](#9-assets)
10. [Dependências](#10-dependências)
11. [Últimas Alterações](#11-últimas-alterações)
12. [Problemas Conhecidos / Pendências](#12-problemas-conhecidos--pendências)
13. [Testes](#13-testes)

---

## 1. Visão Geral

App para rastreio de encomendas. O usuário adiciona códigos de rastreio, o app consulta a API Seu Rastreio (ou usa dados mockados) e exibe o status, histórico de eventos, origem/destino e tags personalizadas.

### Público-alvo
- Usuários que compram produtos online e querem rastrear entregas
- Suporte a português (BR) e inglês

### Funcionalidades implementadas
- Cadastro e login de usuário (com sessão via tokens)
- Modo anônimo (pacotes associados a `user_id = NULL`)
- Adicionar pacotes por código de rastreio
- Nome personalizado + tags para cada pacote
- Filtros por status (Pendentes, Pra Entregar, Entregues, Arquivados)
- Busca por código, descrição ou tag
- Cards de pacote com Nome, Data/Hora e Status
- Splash animado com GIF
- Onboarding em 3 páginas
- Seleção de idioma (pt-BR / en)
- Suporte básico (chat/FAQ)
- Tema Material 3 com design system próprio

---

## 2. Estrutura do Projeto

```
bugigangas_go/
├── lib/
│   ├── main.dart                          # Entry point
│   ├── core/
│   │   ├── router.dart                    # GoRouter (18 rotas)
│   │   ├── database/
│   │   │   ├── neon_service.dart          # PostgreSQL CRUD (425 linhas)
│   │   │   └── neon_config.dart           # DATABASE_URL do .env
│   │   ├── theme/
│   │   │   ├── app_colors.dart            # Paleta de cores
│   │   │   ├── app_theme.dart             # ThemeData Material 3
│   │   │   ├── app_typography.dart        # Estilos tipográficos
│   │   │   └── app_spacing.dart           # Constantes de espaçamento
│   │   └── security/
│   │       └── password_hasher.dart       # SHA-256 + salt
│   ├── features/
│   │   ├── auth/
│   │   │   ├── domain/user_model.dart     # UserModel (id, name, email, password, createdAt)
│   │   │   └── presentation/
│   │   │       ├── auth_providers.dart    # Riverpod providers de auth
│   │   │       ├── splash_screen.dart     # Tela de carregamento
│   │   │       ├── welcome_screen.dart    # Onboarding 3 páginas
│   │   │       ├── language_screen.dart   # Seleção de idioma
│   │   │       ├── login_screen.dart      # Login
│   │   │       └── register_screen.dart   # Cadastro
│   │   ├── tracking/
│   │   │   ├── domain/
│   │   │   │   ├── package_model.dart     # PackageModel (freezed)
│   │   │   │   └── tracking_event.dart    # TrackingEvent (freezed)
│   │   │   ├── data/
│   │   │   │   └── package_repository.dart # API Seu Rastreio + mock
│   │   │   └── presentation/
│   │   │       ├── tracking_providers.dart # State management pacotes
│   │   │       ├── tracking_screen.dart   # Lista de pacotes
│   │   │       ├── package_detail_screen.dart # Detalhes + timeline
│   │   │       ├── add_package_sheet.dart  # Adicionar pacote
│   │   │       └── edit_package_sheet.dart # Editar nome/tags
│   │   ├── home/
│   │   │   └── presentation/home_screen.dart # Tela principal
│   │   ├── search/
│   │   │   └── presentation/search_screen.dart # Placeholder
│   │   ├── support/
│   │   │   └── presentation/support_screen.dart # Suporte
│   │   ├── profile/
│   │   │   └── presentation/profile_screen.dart # Perfil
│   │   └── postage/
│   │       └── presentation/buy_postage_screen.dart # Comprar postagem
│   ├── l10n/
│   │   └── app_strings.dart              # ~170 strings pt-BR/en
│   └── shared/
│       └── widgets/
│           ├── status_badge.dart          # Badge de status (pill)
│           ├── floating_bottom_nav.dart   # Nav inferior customizada
│           └── app_shell.dart            # ShellRoute wrapper
├── assets/
│   ├── icons/app_icon.png                # Ícone do app
│   ├── imgs/model.png                    # Imagem placeholder
│   └── intro/intro_app.gif               # GIF da splash
├── test/
│   ├── widget_test.dart
│   └── features/
│       └── tracking/
│           ├── presentation/
│           │   ├── tracking_screen_test.dart
│           │   └── tracking_providers_test.dart
│           ├── data/
│           │   └── package_repository_test.dart
│           └── domain/
│               └── package_model_test.dart
├── pubspec.yaml
├── .env.example
├── .env                                   # IGNORADO - não comitar
└── CLAUDE.md
```

---

## 3. Esquema do Banco de Dados

Banco: **Neon PostgreSQL**. Conexão via `DATABASE_URL` no `.env`.

### Tabela: `users`

```sql
CREATE TABLE IF NOT EXISTS users (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  email      TEXT NOT NULL UNIQUE,
  password   TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

### Tabela: `sessions`

```sql
CREATE TABLE IF NOT EXISTS sessions (
  id         SERIAL PRIMARY KEY,
  user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token      TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL
);
```

### Tabela: `packages`

```sql
CREATE TABLE IF NOT EXISTS packages (
  id          SERIAL PRIMARY KEY,
  user_id     INTEGER REFERENCES users(id) ON DELETE CASCADE,
  code        TEXT NOT NULL,
  description TEXT DEFAULT '',
  tags        TEXT DEFAULT '',
  status      TEXT DEFAULT 'Registrado',
  origin      TEXT DEFAULT '',
  destination TEXT DEFAULT '',
  last_update TEXT,
  created_at  TEXT NOT NULL,
  UNIQUE(user_id, code)
);
```

- `user_id` pode ser **NULL** para pacotes anônimos
- `tags` armazenadas como texto separado por vírgula

### Tabela: `settings`

```sql
CREATE TABLE IF NOT EXISTS settings (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
```

Usada para: `language`, `onboarding_done`, `session_token`.

### Settings padrão

| key | value inicial |
|-----|--------------|
| `language` | `pt` |
| `onboarding_done` | `0` |
| `session_token` | (token temporário durante login) |

---

## 4. Fluxo de Navegação

### Rotas (GoRouter)

| Rota | Tela | Bottom Nav? |
|------|------|-------------|
| `/splash` | SplashScreen | ❌ |
| `/welcome` | WelcomeScreen | ❌ |
| `/language` | LanguageScreen | ❌ |
| `/login` | LoginScreen | ❌ |
| `/register` | RegisterScreen | ❌ |
| `/` | HomeScreen | ✅ |
| `/buy-postage` | BuyPostageScreen | ✅ |
| `/search` | SearchScreen | ✅ |
| `/support` | SupportScreen | ✅ |
| `/profile` | ProfileScreen | ✅ |
| `/tracking` | TrackingScreen | ❌ |
| `/tracking/:code` | PackageDetailScreen | ❌ |

### Fluxo de inicialização

```
App inicia → main() → ensureSchema() → SplashScreen (5s)
                                                        │
                                          ┌─────────────┼─────────────┐
                                          ▼             ▼             ▼
                                     Logado?     1ª vez?       Retornando
                                          │             │             │
                                          ▼             ▼             ▼
                                        /home      /welcome       /login
                                                      │
                                                      ▼
                                               /language
                                                      │
                                                      ▼
                                                /login → /home
```

---

## 5. Fluxo de Autenticação

### Providers (Riverpod)

| Provider | Tipo | Descrição |
|----------|------|-----------|
| `neonServiceProvider` | `Provider<NeonService>` | Singleton do NeonService |
| `localeProvider` | `StateProvider<Locale>` | Idioma atual (default: pt-BR) |
| `authStateProvider` | `FutureProvider<UserModel?>` | Usuário logado (null se não) |
| `authActionsProvider` | `Provider<AuthActions>` | Ações: register, login, logout |

### AuthActions

**`register(name, email, password)`**
1. Cria UserModel com senha hasheada
2. Insere na tabela `users`
3. **Migra pacotes anônimos** (`user_id IS NULL → user_id do novo usuário`)
4. Cria sessão na tabela `sessions`
5. Salva `session_token` na tabela `settings`

**`login(email, password)`**
1. Busca usuário por email
2. Verifica senha com `PasswordHasher.verifyPassword()`
3. **Migra pacotes anônimos**
4. Cria sessão
5. Salva `session_token`

**`logout()`**
1. Lê `session_token` das settings
2. Deleta sessão da tabela `sessions`
3. Limpa `session_token` nas settings
4. **NÃO deleta o usuário** (diferente do comportamento anterior)

### Sessão

- Token gerado via `_generateToken()` (microssegundos + milissegundos do timestamp)
- Armazenado na tabela `sessions` com FK para `users`
- `getCurrentUser()` lê o token das settings e busca o usuário via JOIN com `sessions`

---

## 6. Fluxo de Pacotes

### PackageListNotifier (StateNotifier)

Gerencia a lista de pacotes em memória. Criado com `_userId` (pode ser null para anônimo).

| Método | O que faz | Persistência |
|--------|-----------|-------------|
| `_loadPackages()` | Carrega pacotes do Neon | `getUserPackages(userId)` |
| `addPackage(code)` | Busca na API + adiciona | `insertPackage(userId, package)` |
| `addPackageWithDetails(...)` | Busca + customiza nome/tags | `insertPackage(userId, package)` |
| `updatePackage(...)` | Atualiza nome/tags | `updatePackage(userId, package)` |
| `removePackage(code)` | Remove da lista | `deletePackage(userId, code)` |
| `refresh()` | Re-busca todos da API | Apenas atualiza estado |

### PackageRepository

- Se `SEU_RASTREIO_TOKEN` configurado → consulta API real (`https://seurastreio.com.br/api/public/rastreio/{code}`)
- Caso contrário → dados mockados com 600ms de delay simulado
- Mock inclui 3 pacotes predefinidos: BR123456789, US987654321, CN555666777

### Migração de pacotes anônimos

Quando o usuário registra ou loga, `migrateAnonymousPackages(userId)` no NeonService:
1. Atualiza pacotes com `user_id IS NULL` para o novo `userId` (pulando códigos que já existem para o usuário)
2. Remove pacotes anônimos conflitantes (mesmo código já existe para o usuário)

---

## 7. Tela de Splash

### Arquivo: `lib/features/auth/presentation/splash_screen.dart`

**Timer**: 5 segundos

**Decisão de rota após timer:**
1. `getCurrentUser()` → se logado, vai para `/` 
2. `getSetting('onboarding_done')` → se null ou '0', vai para `/welcome`
3. Senão, vai para `/login`

**Layout:**
- Fundo: `Color(0xFFD8D8FF)` (lavanda claro — cor dominante do GIF)
- GIF: `assets/intro/intro_app.gif` em tela cheia (`Expanded` + `BoxFit.cover`)
- Loading: `CircularProgressIndicator` teal `#009696` no centro inferior

---

## 8. Design System

### Paleta principal
- **Primary**: `#009696` (teal)
- **Primary Light**: `#0B9B9B`
- **Primary Dark**: `#007A7A`
- **Background**: `#F5F7F9`
- **Surface**: `#FFFFFF`

### Tipografia
- Fonte: Poppins (via `google_fonts`)
- Display, Headline, Title, Body, Label — todos usando `AppTypography`

### Componentes compartilhados
- `StatusBadge` — pill com ícone + cor por categoria (processing, inTransit, outForDelivery, delivered, exception)
- `FloatingBottomNav` — 5 itens flutuantes (Home, Market, Search, Chat, Profile)
- `AppShell` — wrapper com `FloatingBottomNav` para rotas do ShellRoute

---

## 9. Assets

| Arquivo | Caminho | Uso |
|---------|---------|-----|
| `app_icon.png` | `assets/icons/` | Ícone do app + launcher icon |
| `intro_app.gif` | `assets/intro/` | Animação da splash |
| `model.png` | `assets/imgs/` | Placeholder |

Declarados no `pubspec.yaml`:
```yaml
assets:
  - assets/imgs/
  - assets/icons/
  - assets/intro/
  - .env
```

---

## 10. Dependências

### Principais (runtime)

| Package | Versão | Uso |
|---------|--------|-----|
| `flutter_riverpod` | ^2.6.1 | State management |
| `riverpod_annotation` | ^2.6.1 | Anotações Riverpod |
| `go_router` | ^14.8.1 | Navegação |
| `dio` | ^5.8.0 | HTTP client (API Seu Rastreio) |
| `freezed_annotation` | ^2.4.4 | Modelos imutáveis |
| `json_annotation` | ^4.9.0 | Serialização JSON |
| `google_fonts` | ^6.1.0 | Fonte Poppins |
| `flutter_svg` | ^2.0.10+1 | SVG support |
| `shimmer` | ^3.0.0 | Efeito shimmer loading |
| `postgres` | ^3.0.0 | Driver PostgreSQL |
| `flutter_dotenv` | ^5.2.1 | .env loading |
| `crypto` | ^3.0.6 | Hashing SHA-256 |
| `intl` | 0.20.2 | Internacionalização |

### Dev

| Package | Versão | Uso |
|---------|--------|-----|
| `build_runner` | ^2.4.15 | Gerador de código |
| `riverpod_generator` | 2.6.4 | Riverpod code gen |
| `json_serializable` | ^6.9.0 | JSON code gen |
| `freezed` | ^2.5.8 | Freezed code gen |
| `mocktail` | ^1.0.4 | Mocking para testes |
| `flutter_launcher_icons` | ^0.14.3 | Ícones nativos |

---

## 11. Últimas Alterações

### Sprint 2026-06-10 — Dark Mode + Correios API + Offline Cache

### Dark Mode
- `AppTheme.dark` adicionado com color scheme completo para modo escuro
- `themeModeProvider` (StateProvider<ThemeMode>) em auth_providers.dart
- Cores específicas para dark mode em app_colors.dart (darkBackground, darkSurface, etc.)
- StatusBadge adaptado para usar cores dark mode baseado no Brightness do contexto
- Alternador de tema (Sistema / Claro / Escuro) na tela de Perfil
- Preferência de tema persistida no Neon (settings > theme_mode)
- `_AppInitializer` em main.dart carrega locale e tema salvos na inicialização

### Correios RapidAPI
- API Seu Rastreio substituída pela Correios RapidAPI
- `PackageModel`: novos campos carrier, packageType, packageCategory, estimatedDelivery, delayed, lockerDelivery
- `TrackingEvent`: novos campos eventCode, unitName, unitCity, unitState, destinationCity, destinationState, frontEndDescription, iconPath, detail, comment, isFinal
- `_parseCorreiosResponse()` implementado para parse do formato Correios
- Mock data atualizado com todos os novos campos
- Neon: novas colunas adicionadas ao schema (ALTER TABLE IF NOT EXISTS)
- StatusBadge: novos padrões Correios (postagem, transito, saiu-entrega, entregue)
- PackageDetailScreen: novo card de informações de entrega + timeline melhorada com códigos de evento

### Offline Cache
- Hive implementado como cache local
- `CacheService` em lib/core/cache/ para cache de pacotes e settings
- Estratégia cache-first: carrega do Hive instantaneamente, depois atualiza do Neon
- Todos os métodos CRUD atualizam o cache Hive imediatamente

### Sessão 1: Splash + Estrutura da Encomenda
- Splash: `Icons.inventory_2_rounded` substituído por `Image.asset('assets/icons/app_icon.png')`
- HomeScreen `_PackageCard`: reordenado para Nome → Status → Data → Tags
- TrackingScreen `_PackageCard`: reordenado para Status badge → Nome → Código → Data → Tags → Origem→Destino

### Sessão 2: GIF na Splash
- Splash: `app_icon.png` substituído por `assets/intro/intro_app.gif` (280px, centralizado)
- `assets/intro/` adicionado ao pubspec.yaml

### Sessão 3: Splash simplificada
- Splash: GIF em tela cheia (`Expanded` + `BoxFit.cover`), textos removidos, loading no centro inferior
- Import `app_strings.dart` removido

### Sessão 4: Cards simplificados
- Splash: fundo `Colors.white`, loading `#009696`
- HomeScreen `_PackageCard`: Nome → Data/Hora absoluta → StatusBadge
- TrackingScreen `_PackageCard`: Nome → Data/Hora → StatusBadge (compartilhado)
- Código, tags, origem/destino removidos dos cards
- `_statusColor`, `_statusIcon`, `_formatDate` (relativo) removidos

### Sessão 5: Login persistence + Database
- **Problema**: `deleteAllUsers()` no logout destruía contas
- **Correção**: Sessão via tabela `sessions` com token
- Login/Register criam sessão e salvam `session_token` nas settings
- Logout deleta sessão, **NÃO** o usuário
- `packages.user_id` tornado nullable para suporte anônimo
- Pacotes anônimos salvos diretamente na `packages` (sem JSON em settings)
- `migrateAnonymousPackages()` criado para transferir pacotes anônimos ao registrar/logar

### Sessão 6: Cor do GIF na splash
- Fundo da splash alterado para `#D8D8FF` (cor dominante do GIF, ~40% dos pixels)
- Loading spinner permanece `#009696` (visível contra fundo claro)

---

## 12. Problemas Conhecidos / Pendências

### 🔴 Críticos
- Nenhum no momento.

### 🟡 Importantes
1. **`removePackage()` com `_userId` null**: Se `_userId` for null (recém-logout), `deletePackage()` tenta deletar de `WHERE user_id IS NULL` — mas o pacote pode ter `user_id = X`. Ao relogar, o `PackageListNotifier` é recriado e carrega os pacotes corretos, mas durante o logout o botão de deletar pode chamar com userId errado. **Solução**: desabilitar o delete quando userId for null, ou desabilitar a UI após logout.

2. **`_generateToken()`**: Usa timestamp, não é criptograficamente seguro. Para produção, usar `uuid` package ou `SecureRandom`.

3. **Tags armazenadas como CSV**: Impedem busca SQL eficiente. Migrar para `TEXT[]` do PostgreSQL seria ideal.

4. **Métricas de data como `TEXT`**: `created_at`, `last_update` armazenados como `TEXT` em vez de `TIMESTAMPTZ`.

5. **Arquivos freezed desatualizados**: Após adicionar novos campos aos modelos, os arquivos `.freezed.dart` e `.g.dart` precisam ser regenerados com `dart run build_runner build --delete-conflicting-outputs`.

### 🔵 Melhorias
1. **Índices faltantes**: Criar `idx_packages_user_id`, `idx_packages_created_at`, `idx_packages_code`.
2. **Testes**: Apenas 4 arquivos de teste existem. Faltam testes para splash, auth e home screen.
3. **Placeholder screens**: Search, Support (partial), Profile — conteúdo mínimo.
4. **Duplicação `_formatDateTime`**: Existe tanto em `home_screen.dart` quanto em `tracking_screen.dart`. Extrair para utilitário compartilhado.
5. **Método obsoleto**: `app_database.dart` não é mais usado (substituído por NeonService).
6. **`deleteAllUsers()`**: Mantido no NeonService mas não chamado em produção. Pode ser removido ou restrito.
7. **Dependências Hive adicionadas**: `hive` e `hive_flutter` foram adicionadas ao pubspec.yaml. Executar `flutter pub get` para instalar.

---

## 13. Testes

### Arquivos existentes

```
test/
├── widget_test.dart                      # Teste genérico do WidgetsApp
└── features/
    └── tracking/
        ├── presentation/
        │   ├── tracking_screen_test.dart  # Testes da tela de tracking
        │   └── tracking_providers_test.dart # Testes dos providers
        ├── data/
        │   └── package_repository_test.dart # Testes do repositório
        └── domain/
            └── package_model_test.dart    # Testes do modelo
```

### Cobertura atual
- `PackageModel`: serialização JSON ✅
- `PackageRepository`: API + mock ✅
- `TrackingScreen`: renderização, busca ✅
- `TrackingProviders`: filtros, busca ✅

### Faltando
- `SplashScreen` (timer, navegação, GIF)
- `AuthActions` (register, login, logout, migração)
- `HomeScreen` (cards, filtros, busca)
- `NeonService` (CRUD, sessões, migração)
- Testes de integração (fluxo completo)

---

## Configuração para Desenvolvimento

1. Copie `.env.example` para `.env`
2. Preencha `DATABASE_URL` com sua URL do Neon PostgreSQL
3. (Opcional) Configure `RAPIDAPI_KEY` com sua chave do Correios RapidAPI para API real
4. Execute `dart run flutter_launcher_icons` para gerar ícones nativos
5. Execute `dart run build_runner build --delete-conflicting-outputs` para regenerar código freezed
6. Execute `flutter pub get`
7. Execute `flutter run`

> ⚠️ O arquivo `.env` NÃO deve ser commitado. Está no `.gitignore`.
