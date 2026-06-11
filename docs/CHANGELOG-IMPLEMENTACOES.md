# CHANGELOG — Implementações Realizadas

> **Data:** 2026-06-09
> **Autor:** Flutter PM + UI/UX Lead + flutter-especialist

---

## Sumário

Este documento registra todas as alterações feitas no projeto Bugigangas Go até o momento, incluindo implementações técnicas de i18n, autenticação, persistência de dados e segurança.

---

## 1. Histórico de Alterações por Arquivo

### 📁 `lib/l10n/app_strings.dart`

**O quê:** Adição de ~60 novas chaves de tradução (pt-BR e en-US)

**Chaves adicionadas:**

| Chave | pt-BR | en-US |
|-------|-------|-------|
| `homeWelcomeBack` | "Bem-vindo de volta," | "Welcome back," |
| `homeTrackYourPackage` | "Rastreie seu Pacote" | "Track your Package" |
| `homeAllPackagesOnePlace` | "Todos os seus pacotes em um só lugar." | "All your packages in one place." |
| `homeTrackingByParcel` | "Rastrear por código" | "Tracking by parcel" |
| `homePostNordParcel` | "Encomendas PostNord" | "PostNord parcels" |
| `homeSeeAll` | "Ver todos" | "See all" |
| `homeFilterPickUp` | "Coleta" | "Pick Up" |
| `homeFilterPackageClaim` | "Reclamação" | "Package Claim" |
| `homeFilterAllPackages` | "Todos" | "All Packages" |
| `homeFilterInternational` | "Internacional" | "International" |
| `homeNoPackagesYet` | "Nenhum pacote ainda" | "No packages yet" |
| `homeStartTrackingYourFirst` | "Comece a rastrear seu primeiro pacote!" | "Start tracking your first package!" |
| `homeNoNotifications` | "Nenhuma notificação" | "No new notifications" |
| `trackingTitle` | "Meus Pacotes" | "My Packages" |
| `trackingRefresh` | "Atualizar" | "Refresh" |
| `trackingSearchHint` | "Buscar por código ou descrição" | "Search by code or description" |
| `trackingAddPackage` | "Adicionar pacote" | "Add package" |
| `trackingTrackingCode` | "Código de rastreio" | "Tracking code" |
| `trackingCancel` | "Cancelar" | "Cancel" |
| `trackingAdd` | "Adicionar" | "Add" |
| `trackingRemove` | "Remover" | "Remove" |
| `trackingLastUpdate` | "Última atualização:" | "Last update:" |
| `trackingNoResults` | "Nenhum resultado encontrado" | "No results found" |
| `trackingNoPackagesYet` | "Nenhum pacote ainda" | "No packages yet" |
| `trackingTryDifferent` | "Tente buscar por um código ou descrição diferente." | "Try a different code or description." |
| `trackingAddFirstCode` | "Adicione seu primeiro código de rastreio para começar." | "Add your first tracking code to get started." |
| `searchTitle` | "Buscar" | "Search" |
| `searchHint` | "Buscar pacotes" | "Search packages" |
| `searchDescription` | "Encontre seus pacotes por código ou descrição." | "Find your packages by tracking code or description." |
| `supportTitle` | "Suporte" | "Support" |
| `supportChat` | "Chat" | "Chat" |
| `supportFaq` | "FAQ" | "FAQ" |
| `supportLoginForChat` | "Faça login com MitID para usar o chat." | "Log in with MitID for chat." |
| `supportAccessChat` | "Acesse o chat e recursos fazendo login com MitID." | "Access chat and features by logging in with MitID." |
| `supportStartNewChat` | "Iniciar novo chat" | "Start new chat" |
| `supportComingSoon` | "Chat em breve!" | "Chat feature coming soon!" |
| `buyPostageTitle` | "Comprar Postagem" | "Buy Postage" |
| `buyPostageDestination` | "Destino" | "Destination" |
| `buyPostageDenmark` | "Dinamarca" | "Denmark" |
| `buyPostageShippingOptions` | "Opções de Envio" | "Shipping Options" |
| `buyPostageLetter` | "Carta" | "Letter" |
| `buyPostageLetterDesc` | "Documentos e itens pequenos até 2 kg. Entrega em 3-5 dias úteis." | "Documents and small items up to 2 kg. Delivery in 3-5 business days." |
| `buyPostageParcel` | "Pacote" | "Parcel" |
| `buyPostageParcelDesc` | "Pacotes até 30 kg. Entrega em 1-3 dias úteis com rastreio." | "Packages up to 30 kg. Delivery in 1-3 business days with tracking." |
| `buyPostagePostcards` | "Cartão Postal" | "Postcards" |
| `buyPostagePostcardsDesc` | "Cartões postais e pequenos presentes até 0.5 kg. Entrega em 5-7 dias úteis." | "Postcards and small gifts up to 0.5 kg. Delivery in 5-7 business days." |
| `buyPostageFrom` | "A partir de" | "From" |
| `profileTitle` | "Perfil" | "Profile" |
| `profileSettingsSoon` | "Configurações de perfil em breve." | "Profile settings coming soon." |
| `profileWorkingOnIt` | "Estamos trabalhando nisso!" | "We're working on it!" |
| `profileLogout` | "Sair" | "Log out" |
| `profileLogoutConfirm` | "Tem certeza que deseja sair?" | "Are you sure you want to log out?" |
| `profileLogoutSuccess` | "Você saiu da sua conta." | "You have been logged out." |
| `navHome` | "Início" | "Home" |
| `navMarket` | "Mercado" | "Market" |
| `navChat` | "Chat" | "Chat" |
| `navProfile` | "Perfil" | "Profile" |
| `navSearchAccessibility` | "Buscar" | "Search" |
| `splashTitle` | "Bugigangas Go" | "Bugigangas Go" |
| `splashSubtitle` | "Rastreador de Pacotes" | "Package Tracker" |
| `emailLabel` | "Email" | "Email" |
| `passwordLabel` | "Senha" | "Password" |
| `confirmPasswordLabel` | "Repetir Senha" | "Confirm Password" |
| `nameLabel` | "Nome" | "Name" |
| `invalidEmail` | "Email inválido" | "Invalid email" |
| `invalidPassword` | "Mínimo de 6 caracteres" | "Minimum 6 characters" |
| `passwordsDoNotMatch` | "Senhas não conferem" | "Passwords do not match" |
| `fieldRequired` | "Campo obrigatório" | "This field is required" |
| `createAccount` | "Criar Conta" | "Create Account" |
| `createAccountSubtitle` | "Preencha os dados para se cadastrar" | "Fill in your details to register" |
| `registerButton` | "Cadastrar" | "Register" |
| `registerSuccess` | "Conta criada com sucesso! Faça login." | "Account created successfully! Please log in." |
| `loginButton` | "Entrar" | "Log in" |
| `loginError` | "Email ou senha inválidos" | "Invalid email or password" |
| `noAccount` | "Não tem conta? Cadastre-se" | "Don't have an account? Sign up" |
| `hasAccount` | "Já tem conta? Faça login" | "Already have an account? Log in" |
| `errorTitle` | "Erro" | "Error" |
| `backToHome` | "Voltar ao início" | "Back to home" |

---

### 📁 `lib/features/home/presentation/home_screen.dart`

**Antes:** Strings hardcoded em inglês + nome "Andrew Hawkins" fixo.

**Depois:**
- Strings substituídas por `AppStrings.of(context)`
- `_GradientHeader` convertido para `ConsumerWidget` (era `StatelessWidget`)
- Consulta `authStateProvider` para exibir nome real do usuário logado
- Avatar exibe a primeira letra do nome do usuário
- Tratamento de estados: `loading` (texto genérico), `data` (nome real), `error` (fallback)

**Linhas alteradas:** ~30 linhas modificadas

---

### 📁 `lib/features/profile/presentation/profile_screen.dart`

**Antes:** Placeholder com dados fixos ("Andrew Hawkins", "andrew@example.com"), sem logout.

**Depois:**
- Consulta `authStateProvider` para exibir nome e email reais
- Avatar com inicial do nome do usuário
- Botão "Sair" com diálogo de confirmação
- Ao confirmar logout, chama `authActionsProvider.logout()` e redireciona para `/login`
- Strings substituídas por `AppStrings.of(context)`

---

### 📁 `lib/features/tracking/presentation/tracking_screen.dart`

**Antes:** Strings misturadas (português e inglês) hardcoded.

**Depois:** Todas as strings substituídas por `AppStrings.of(context)`:
- Título, tooltips, hint text, labels de botões
- Textos de estado vazio, resultados não encontrados
- Rótulo "Última atualização:"

---

### 📁 `lib/features/auth/presentation/login_screen.dart`

**Antes:** Labels "Email", "Senha" e mensagens de erro hardcoded.

**Depois:** Strings substituídas por `AppStrings.of(context)`:
- Labels dos campos
- Mensagens de validação
- Texto do link "Não tem conta?"
- Mensagem de erro de login inválido

---

### 📁 `lib/features/auth/presentation/register_screen.dart`

**Antes:** Todas as strings hardcoded em português.

**Depois:** Strings substituídas por `AppStrings.of(context)`:
- Título e subtítulo
- Labels dos campos
- Mensagens de validação
- Texto dos botões
- Mensagem de sucesso

---

### 📁 `lib/features/search/presentation/search_screen.dart`

**Antes:** Strings hardcoded em inglês.

**Depois:** Strings substituídas por `AppStrings.of(context)`

---

### 📁 `lib/features/support/presentation/support_screen.dart`

**Antes:** Strings hardcoded em inglês.

**Depois:** Strings substituídas por `AppStrings.of(context)`:
- Título da tela
- Labels das abas (Chat, FAQ)
- Textos da área de chat
- Botão CTA

---

### 📁 `lib/features/postage/presentation/buy_postage_screen.dart`

**Antes:** Strings hardcoded em inglês.

**Depois:** Strings substituídas por `AppStrings.of(context)`:
- Título da tela
- Seção "Destination"
- Seção "Shipping options" com descrições e preços

---

### 📁 `lib/shared/widgets/floating_bottom_nav.dart`

**Antes:** Labels "Home", "Market", "Chat", "Profile" hardcoded.

**Depois:** Labels e accessibility labels substituídos por `AppStrings.of(context)`

---

### 📁 `lib/core/router.dart`

**Antes:** Página de erro com strings hardcoded em português.

**Depois:** Strings substituídas por `AppStrings.of(context)`

---

### 📁 `lib/features/auth/presentation/splash_screen.dart`

**Antes:** Subtítulo "Package Tracker" hardcoded.

**Depois:** Subtítulo via `AppStrings.of(context)`

---

### 📁 `lib/core/database/neon_service.dart`

**Antes:** Apenas tabelas `settings` e `users`.

**Depois:**
- Nova tabela `packages` criada no `ensureSchema()`:

```sql
CREATE TABLE IF NOT EXISTS packages (
  id          SERIAL PRIMARY KEY,
  user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  code        TEXT NOT NULL,
  description TEXT DEFAULT '',
  status      TEXT DEFAULT 'Registrado',
  origin      TEXT DEFAULT '',
  destination TEXT DEFAULT '',
  last_update TEXT,
  created_at  TEXT NOT NULL,
  UNIQUE(user_id, code)
)
```

- Novos métodos CRUD:
  - `getUserPackages(int userId)` → `List<PackageModel>`
  - `insertPackage(int userId, PackageModel package)` → `void`
  - `deletePackage(int userId, String code)` → `void`

---

### 📁 `lib/features/tracking/presentation/tracking_providers.dart`

**Antes:**
- `PackageListNotifier` com dados mock em `_initialPackages`
- Pacotes puramente em memória, sem persistência

**Depois:**
- `_initialPackages` removido (lista vazia `[]`)
- `PackageListNotifier` recebe `userId` do `authStateProvider`
- Ao iniciar, carrega pacotes do Neon via `getUserPackages(userId)`
- `addPackage()` persiste no Neon após buscar dados
- `removePackage()` remove do Neon
- Provider depende de `neonServiceProvider` e `authStateProvider`

---

### 📁 `lib/features/tracking/data/package_repository.dart`

**Antes:** Apenas dados mock.

**Depois:**
- Suporte à API do Melhor Rastreio via `MELHOR_RASTREIO_API_KEY`
- Se chave válida configurada → tenta API real
- Se chave ausente/placeholder ou erro → fallback para dados mock
- Provider lê chave e base URL do `dotenv`

---

### 📁 `pubspec.yaml`

**Antes:** Sem dependência `crypto`.

**Depois:**
```yaml
dependencies:
  crypto: ^3.0.6
```

---

### 📁 `lib/core/security/password_hasher.dart` — **NOVO ARQUIVO 🆕**

**Descrição:** Serviço puro Dart para hash de senhas usando SHA-256 com salt.

```dart
class PasswordHasher {
  static String hashPassword(String password);     // salt + hash
  static bool verifyPassword(String password, String storedHash);  // verificação
}
```

- Salt: 16 bytes gerados com `dart:math.Random.secure()`
- Hash: SHA-256(salt + password)
- Formato armazenado: `salt_base64:hash_hex`

---

### 📁 `lib/features/auth/presentation/auth_providers.dart`

**Antes:**
- `register()`: salva senha em texto puro
- `login()`: compara `user.password != password` (comparação em texto puro)

**Depois:**
- `register()`: `PasswordHasher.hashPassword(password)` antes de salvar
- `login()`: `PasswordHasher.verifyPassword(password, user.password)` para comparar

---

### 📁 `.env.example`

**Antes:** Apenas `DATABASE_URL`.

**Depois:**
```
DATABASE_URL="postgresql://..."
MELHOR_RASTREIO_API_KEY=suachaveaqui
MELHOR_RASTREIO_BASE_URL=https://api.melhorrastreio.com.br/api/v1
```

---

## 2. Resumo por Tipo de Alteração

| Tipo | Quantidade | Arquivos |
|------|-----------|----------|
| **Arquivos novos** | 1 | `lib/core/security/password_hasher.dart` |
| **Arquivos modificados (i18n)** | 14 | `app_strings.dart`, `home_screen.dart`, `tracking_screen.dart`, `login_screen.dart`, `register_screen.dart`, `search_screen.dart`, `support_screen.dart`, `buy_postage_screen.dart`, `profile_screen.dart`, `floating_bottom_nav.dart`, `router.dart`, `splash_screen.dart`, `auth_providers.dart`, `package_repository.dart` |
| **Arquivos modificados (banco)** | 2 | `neon_service.dart`, `tracking_providers.dart` |
| **Arquivos modificados (segurança)** | 2 | `auth_providers.dart`, `pubspec.yaml` |
| **Arquivos de config** | 1 | `.env.example` |
| **Documentação** | 2 | `REQUISITOS-CORRECOES.md`, `CHANGELOG-IMPLEMENTACOES.md` |
| **Total** | **~20 arquivos** | |

---

## 3. Melhorias de Segurança 🔒

| Aspecto | Antes | Depois |
|---------|-------|--------|
| Armazenamento de senha | Texto puro | SHA-256 + salt de 16 bytes |
| Comparação de login | `user.password != password` | `PasswordHasher.verifyPassword()` |
| Geração de salt | ❌ Não existia | `dart:math.Random.secure()` |
| Exposição em logs | Potencial (senha no fluxo) | Nenhuma — senha hasheada antes de qualquer I/O |
| SQL Injection | ✅ Já usava parametrized queries | ✅ Mantido |

---

## 4. Serviços e Dependências

### Dependências adicionadas
| Pacote | Versão | Uso |
|--------|--------|-----|
| `crypto` | ^3.0.6 | SHA-256 para hash de senhas |

### Novos serviços
| Serviço | Arquivo | Responsabilidade |
|---------|---------|------------------|
| `PasswordHasher` | `lib/core/security/password_hasher.dart` | Hash e verificação de senhas |

---

## 5. Observações Técnicas

### i18n (Internacionalização)
- O sistema `AppStrings` usa `LocalizationsDelegate` padrão do Flutter
- A troca de idioma é reativa via `localeProvider` (Riverpod StateProvider)
- `MaterialApp.router` escuta o provider e reconstrói com o novo locale
- `AppStrings.of(context)` resolve as strings com base no locale atual

### Persistência de Pacotes
- Os pacotes agora são armazenados por usuário no Neon
- A tabela `packages` tem `UNIQUE(user_id, code)` para evitar duplicatas
- `ON DELETE CASCADE` garante que ao deletar um usuário, seus pacotes são removidos
- O `PackageListNotifier` inicializa com lista vazia e carrega do banco

### API Melhor Rastreio
- Configurada com fallback para mock data
- Requer chave de API no `.env` para funcionar em produção
- Timeout e tratamento de erro implementados

### Criptografia
- Senhas nunca transitam ou são armazenadas em texto puro
- Usuários com senhas em texto puro (criados antes desta mudança) precisarão recadastrar
- O hash SHA-256 é deterministico para o mesmo salt+password, permitindo verificação

---

## 6. Próximos Passos Recomendados

1. ✅ **i18n completo** — Concluído
2. ✅ **Nome do usuário logado** — Concluído
3. ✅ **Pacotes no banco Neon** — Concluído
4. ✅ **Criptografia de senha** — Concluído
5. ⬜ **API Melhor Rastreio** — Configurada com fallback, pendente de chave real para testes
6. ⬜ **Testes de integração** — Verificar fluxo completo no emulador Android
7. ⬜ **Build de produção** — `flutter build apkg --release`

---

## Sprint — Dark Mode + Correios API + Offline Cache
**Date:** 2026-06-10

### Dark Mode
- Added `AppTheme.dark` with full dark color scheme (`#121416` background, `#00B3B3` primary)
- Added `themeModeProvider` (StateProvider<ThemeMode>) in auth_providers.dart
- Added dark-mode-specific color tokens in `app_colors.dart` (darkBackground, darkSurface, darkTextPrimary, etc.)
- Added dark-mode status badge color pairs (processingDark, inTransitDark, etc.)
- `StatusBadge.colorForStatus()` now accepts optional `Brightness` parameter for dark-mode colors
- Theme toggle (System / Light / Dark) added to Profile screen via bottom sheet
- Theme preference persisted in Neon settings table as `theme_mode`
- `main.dart`: Added `_AppInitializer` to load saved locale and theme from Neon on startup
- `main.dart`: MaterialApp.router now includes `darkTheme: AppTheme.dark` and `themeMode:` from provider

### API Migration (Correios RapidAPI)
- `.env.example`: Replaced `SEU_RASTREIO_TOKEN` with `RAPIDAPI_KEY`, `RAPIDAPI_HOST`, `RAPIDAPI_BASE_URL`
- `package_model.dart`: Added `carrier`, `packageType`, `packageCategory`, `estimatedDelivery`, `delayed`, `lockerDelivery` fields
- `tracking_event.dart`: Added `eventCode`, `unitName`, `unitCity`, `unitState`, `destinationCity`, `destinationState`, `frontEndDescription`, `iconPath`, `detail`, `comment`, `isFinal` fields
- `package_repository.dart`: Replaced Seu Rastreio API with Correios RapidAPI (`/track` endpoint with `tracking_code` query param and RapidAPI headers)
- Added `_parseCorreiosResponse()` to parse the Correios API response format
- Added `_parseBrazilianDate()` for Brazilian date format `dd/MM/yyyy`
- Mock data updated to include new fields (carrier, packageType, eventCode, unitName, etc.)
- `neon_service.dart`: Added new columns (`carrier`, `package_type`, `package_category`, `estimated_delivery`, `delayed`, `locker_delivery`) to schema migration
- Updated `getUserPackages()`, `insertPackage()`, `updatePackage()` to read/write new fields
- `status_badge.dart`: Added Correios-specific status patterns (`postagem`, `transito`, `saiu-entrega`, `entregue`)
- `package_detail_screen.dart`: Added `_DeliveryInfoCard` showing package type, carrier, estimated delivery, delay/locker badges
- Enhanced `_TimelineEntry` to show event codes, unit names, and comments

### Offline Cache (Hive)
- Added `hive: ^2.2.3` and `hive_flutter: ^1.1.0` to `pubspec.yaml`
- Created `lib/core/cache/cache_service.dart`: Hive-based local caching for packages and settings
- Created `lib/core/cache/cache_provider.dart`: Riverpod `Provider<CacheService>`
- `main.dart`: Hive initialized before app start, `CacheService` created and overridden in `ProviderScope`
- `tracking_providers.dart` (`PackageListNotifier`): Cache-first strategy — loads from Hive instantly, then fetches fresh data from Neon
- All CRUD methods (add, update, remove, archive, unarchive) update Hive cache immediately after state change

### New Files
| File | Purpose |
|------|---------|
| `lib/core/cache/cache_service.dart` | Hive-based caching service |
| `lib/core/cache/cache_provider.dart` | Riverpod provider for CacheService |

### Modified Files
| File | Changes |
|------|---------|
| `lib/core/theme/app_colors.dart` | Added dark mode color tokens and status pairs |
| `lib/core/theme/app_theme.dart` | Added `AppTheme.dark` getter |
| `lib/features/auth/presentation/auth_providers.dart` | Added `themeModeProvider`, `setTheme()` method |
| `lib/l10n/app_strings.dart` | Added theme strings (themeMode, themeSystem, themeLight, themeDark) |
| `lib/features/profile/presentation/profile_screen.dart` | Added theme toggle and language selection settings |
| `lib/main.dart` | Added dark theme, Hive init, theme/locale loading |
| `lib/features/tracking/domain/package_model.dart` | Added 6 new fields |
| `lib/features/tracking/domain/tracking_event.dart` | Added 11 new fields |
| `lib/features/tracking/data/package_repository.dart` | Replaced API with Correios RapidAPI |
| `lib/core/database/neon_service.dart` | Added new columns to schema and CRUD |
| `lib/shared/widgets/status_badge.dart` | Added dark mode support, Correios status patterns |
| `lib/features/tracking/presentation/tracking_providers.dart` | Added cache-first strategy |
| `lib/features/tracking/presentation/package_detail_screen.dart` | Added delivery info card and enhanced timeline |
| `pubspec.yaml` | Added hive, hive_flutter |
| `.env.example` | Replaced Seu Rastreio with Correios RapidAPI config |

### Dependencies Added
| Package | Version | Purpose |
|---------|---------|---------|
| `hive` | ^2.2.3 | Local key-value storage |
| `hive_flutter` | ^1.1.0 | Flutter support for Hive |

### Notes
- Generated files (`.freezed.dart`, `.g.dart`) need regeneration: `dart run build_runner build --delete-conflicting-outputs`
- Correios API requires a valid RapidAPI key in `.env` for real tracking data
- Theme mode is persisted in Neon `settings` table and loaded on app startup
- Cache provides instant loading and offline support

---

---

## Sprint — Lottie Animations
**Date:** 2026-06-10

### Lottie Animations
- Added `lottie: ^3.1.3` to `pubspec.yaml`
- Created `assets/animations/` directory with 9 Lottie animation JSON placeholders:
  - `anim_splash.json` — Teal pulsing circle
  - `anim_hero_processing.json` — Rotating arc spinner
  - `anim_hero_intransit.json` — Circle moving left-to-right
  - `anim_hero_outfordelivery.json` — Box moving along arc path
  - `anim_hero_delivered.json` — Expanding circle with checkmark reveal
  - `anim_hero_exception.json` — Red pulsing circle with shake
  - `anim_empty_search.json` — Magnifying glass rotating
  - `anim_empty_packages.json` — Box with opening lid
  - `anim_support_chat.json` — Chat bubble with bouncing dots
- Updated `pubspec.yaml` assets section to include `assets/animations/`
- Replaced splash `Image.asset` GIF with `Lottie.asset` in `splash_screen.dart`
- Replaced Status Hero `Icon` with animated Lottie per status category in `package_detail_screen.dart` (added `_statusAnimationPath()` helper)
- Replaced empty state `Icon` with Lottie in `tracking_screen.dart`
- Replaced empty packages `Icon` with Lottie in `home_screen.dart`
- Replaced support chat placeholder `Icon` with Lottie in `support_screen.dart`

### Generated Files Fix
- **build_runner could not run** due to Flutter SDK toolchain issue (WSL path resolution)
- Manually updated 4 generated files to match model changes:
  - `package_model.freezed.dart` — Added 6 new fields (carrier, packageType, packageCategory, estimatedDelivery, delayed, lockerDelivery) across mixin, copyWith, impl, abstract class
  - `package_model.g.dart` — Added JSON serialization for 6 new fields
  - `tracking_event.freezed.dart` — Added 11 new fields (eventCode, unitName, unitCity, unitState, destinationCity, destinationState, frontEndDescription, iconPath, detail, comment, isFinal)
  - `tracking_event.g.dart` — Added JSON serialization for 11 new fields

### Notes
- `dart analyze lib/` passes with **0 errors** (28 info-level items are pre-existing non-blocking warnings)
- `flutter pub get` and `dart run build_runner` require a working Flutter SDK installation
- All Lottie JSON files are minimal placeholders — they can be replaced with professionally designed animations later
- `lottie` package v3.1.3 is compatible with Flutter 3.x SDK

---

### QA Fixes Sprint (2026-06-10)
- Fixed `lastUpdate` using oldest event instead of newest (C01)
- Fixed hardcoded white/light backgrounds breaking dark mode in HomeScreen, BottomNav, SupportScreen (DM-01 to DM-04)
- Fixed StatusHero colors in dark mode (DM-05)
- Fixed timeline comment colors in dark mode (DM-06)
- Fixed cache race condition in removePackage (CACHE-01)
- Fixed delayed/locker badges hidden when no estimated delivery (API-02)
- Extracted `_formatDateTime` to shared utility `lib/shared/utils/date_formatter.dart` (N02)
- Added debug logging to `_parseBrazilianDate` (N06)
- Updated delayed/locker badge colors to use semantic theme colors (DM-08)

---

*Fim do documento de alterações*
