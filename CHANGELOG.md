# Changelog — Bugigangas GO

Todas as alterações significativas neste projeto serão documentadas aqui.

---

## Sprint 1 — Dark Mode, API Correios, Cache Offline, Lottie

### Adicionado
- **Tema escuro (Dark Mode):** `AppTheme.dark` com ColorScheme completo, teal primário `#00B3B3`, superfícies escuras `#1A1C1E`.
- **Provider de tema:** `themeModeProvider` (StateProvider<ThemeMode>) com valores `system`/`light`/`dark`. Toggle na tela de Perfil. Persistido no Neon (`settings` table, chave `theme_mode`).
- **Correios RapidAPI:** Migração de dados mock para API real via `_parseCorreiosResponse()` no `PackageRepository`. Headers: `x-rapidapi-key`, `x-rapidapi-host`. Fallback para mock em caso de falha.
- **Novos campos em `PackageModel`:** `carrier`, `packageType`, `packageCategory`, `estimatedDelivery`, `delayed`, `lockerDelivery` — parseados da resposta da API.
- **Novos campos em `TrackingEvent`:** `eventCode`, `unitName`, `unitCity`, `unitState`, `destinationCity`, `destinationState`, `frontEndDescription`, `iconPath`, `detail`, `comment`, `isFinal`.
- **Cache offline:** `CacheService` usando Hive. Estratégia cache-first: dados do cache são exibidos instantaneamente, depois atualizados do Neon em background.
- **Animações Lottie:** 9 arquivos JSON integrados:
  - `anim_splash.json` — Splash
  - `anim_hero_processing.json`, `anim_hero_intransit.json`, `anim_hero_outfordelivery.json`, `anim_hero_delivered.json`, `anim_hero_exception.json` — Status hero
  - `anim_empty_packages.json`, `anim_empty_search.json` — Empty states
  - `anim_support_chat.json` — Suporte

### Modificado
- **`main.dart`:** Inicialização do Hive antes do `runApp()`. `ensureSchema()` chamado com try-catch.
- **`splash_screen.dart`:** Exibição splash de 5s com Lottie, depois roteia para home/welcome/login.
- **`home_screen.dart`:** StatusHero com Lottie animado. Cards de pacotes integrados com cache.
- **`tracking_screen.dart`:** Empty states com Lottie. Refresh com cache-first.
- **`package_detail_screen.dart`:** _StatusHero com Lottie por status. _DeliveryInfoCard com novos campos Correios.
- **`app_strings.dart`:** Novas strings de tema (themeMode, themeSystem, themeLight, themeDark).

### Corrigido
- **`lastUpdate`:** Usava `events.first.date` (evento mais antigo) → corrigido para `events.last.date` (evento mais recente).
- **Badges `delayed`/`lockerDelivery`:** Movidos para fora do bloco `estimatedDelivery` null-check.
- **Cache race condition:** `removePackage` mudou de `void` para `Future<void>` com `await` na atualização do cache.
- **`_formatDateTime` duplicado:** Extraído para `lib/shared/utils/date_formatter.dart`.

---

## Sprint 2 — QA, Dark Mode Hardening, Neon Persistence

### Modificado
- **`home_screen.dart` (filtros dark mode):** `AppColors.textPrimary` → `Theme.of(context).colorScheme.onSurface` para texto não selecionado nos chips de filtro (linha 540).
- **`app_strings.dart`:** Valor de `navMarket` alterado de "Mercado"/"Market" para "Promoções"/"Promotions".
- **`buy_postage_screen.dart`:** Tela completamente reescrita — removeu cards de frete, adicionou Lottie `anim_splash.json` (animação "Aguarde") + texto "Promoções diárias dos melhores sites de compras" + "Em breve".
- **`app_theme.dart` (tema escuro):** Adicionado `.apply(bodyColor: colorScheme.onSurface, displayColor: colorScheme.onSurface)` ao `GoogleFonts.poppinsTextTheme(...)` — corrige globalmente texto preto em dark mode (linhas 281-284).
- **`package_detail_screen.dart`:** 4 ocorrências de `AppColors.textHint` → `Theme.of(context).colorScheme.onSurfaceVariant`.
- **`tracking_screen.dart`:** 4 ocorrências de `AppColors.textHint`/`AppColors.textSecondary` → `Theme.of(context).colorScheme.onSurfaceVariant`.
- **`home_screen.dart`:** 5 ocorrências de `AppColors.textHint`/`AppColors.textSecondary` → `Theme.of(context).colorScheme.onSurfaceVariant`.
- **`splash_screen.dart`:** Substituiu Lottie `anim_splash.json` por `Image.asset('assets/intro/intro_app.gif')`. Fundo `#009696` (teal primary). GIF em tela cheia (`BoxFit.cover`). Removeu `CircularProgressIndicator`.

### Adicionado
- **`neon_service.dart` (toBool):** Função de conversão segura para booleanos do PostgreSQL — aceita `bool`, `int` (0/1) e `string` ('t'/'f'/'true'/'1') (linhas 294-299).
- **`neon_service.dart` (debug logging):** Logs em `ensureSchema()`, `getUserPackages()`, `insertPackage()`.

### Corrigido
- **Neon DB — cache-first hardening em `tracking_providers.dart`:** `_loadPackages()` só sobrescreve estado se o Neon retornar dados não-vazios. Preserva cache se Neon falhar ou retornar vazio.
- **Neon DB — race condition de autenticação em `tracking_providers.dart`:** `PackageListNotifier` agora recebe `Ref` em vez de `userId` fixo. Lê `_userId` dinamicamente via `ref.read(authStateProvider).valueOrNull?.id`. Adicionado listener `_ref.listen(authStateProvider)` que recarrega pacotes quando auth resolve. Isso impede que o notifier seja recriado (perdendo pacotes em memória) quando o `authStateProvider` (FutureProvider) resolve (discussão Riverpod #1176).
- **Neon DB — coluna `tags` faltando em `neon_service.dart`:** Adicionado `ALTER TABLE packages ADD COLUMN IF NOT EXISTS tags TEXT DEFAULT ''` na migração (linha 234). O erro era: `column "tags" of relation "packages" does not exist` (PostgreSQL 42703). A coluna estava apenas no `CREATE TABLE IF NOT EXISTS` — quando a tabela já existia (de schema anterior sem `tags`), nunca era materializada.

---

## Estrutura de Arquivos (alterados nesta sprint)

```
lib/
├── core/
│   ├── database/
│   │   └── neon_service.dart          ← toBool(), ALTER TABLE tags, debug logs
│   ├── theme/
│   │   ├── app_colors.dart            ← Dark mode tokens (já existiam)
│   │   ├── app_theme.dart             ← .apply() no textTheme dark
│   │   └── app_typography.dart        ← Hardcoded colors (não alterado, .apply() contorna)
│   └── router.dart                    ← Rota /buy-postage mantida
├── features/
│   ├── auth/presentation/
│   │   └── splash_screen.dart         ← GIF substitui Lottie, full-screen
│   ├── home/presentation/
│   │   └── home_screen.dart           ← Filter chip text color, textHint→onSurfaceVariant
│   ├── postage/presentation/
│   │   └── buy_postage_screen.dart    ← Rewrite completo para Promoções placeholder
│   ├── tracking/
│   │   ├── presentation/
│   │   │   ├── tracking_providers.dart  ← Ref-based userId, listener auth, cache-first hardening
│   │   │   ├── tracking_screen.dart     ← textHint→onSurfaceVariant
│   │   │   ├── package_detail_screen.dart ← textHint→onSurfaceVariant
│   │   │   └── add_package_sheet.dart   ← Sem mudanças (herda do textTheme)
│   │   └── data/
│   │       └── package_repository.dart  ← Já existia
│   └── ...
├── l10n/
│   └── app_strings.dart              ← navMarket: "Promoções"/"Promotions"
├── shared/
│   └── widgets/
│       └── floating_bottom_nav.dart   ← Sem mudanças (usa strings.navMarket)
└── main.dart                         ← Teste de conexão Neon (SELECT 1)
assets/
└── intro/
    └── intro_app.gif                  ← GIF de abertura (já existia)
```

---

## Decisões Técnicas

| Decisão | Alternativa | Motivo |
|---------|------------|--------|
| `.apply()` no textTheme dark vs copiar cada estilo | Copiar cada estilo manualmente | `.apply()` é 1 linha vs 14 linhas. Cascateia para todos os estilos. |
| `Ref` em vez de `userId` no notifier | `ref.watch(authStateProvider)` no factory | Evita recriação do notifier quando auth resolve (Riverpod #1176) |
| `ALTER TABLE IF NOT EXISTS` para tags vs recrear tabela | Recrear tabela | Idempotente, seguro, não perde dados existentes |
| `Image.asset` GIF vs `Lottie` para splash | Lottie | GIF combina melhor com o estilo do projeto. Suporte nativo do Flutter. |
| `BoxFit.cover` vs `BoxFit.contain` no splash | contain | Cover preenche a tela inteira sem bordas |

---

## Comandos Úteis

```bash
# Rodar o app
flutter run

# Verificar análise estática
flutter analyze lib/

# Limpar e reconstruir (se houver problemas de cache)
flutter clean
flutter pub get
```

---

## Sprint 3 — Correções de Persistência, Registro e Ícones

### Corrigido

- **Registro de usuário quebrando após INSERT:** `auth_providers.dart` — o `register()` descartava o ID retornado por `insertUser()` e usava `user.id!` em `null`, causando TypeError com mensagem "Falha ao criar conta". Correção: capturar `final userId = await neon.insertUser(user)` e usar `userId` em vez de `user.id!` nas operações seguintes (migrateAnonymousPackages, createSession). Retornar `UserModel` completo com `id: userId`.
- **Ícones nativos regenerados:** Limpeza completa dos PNGs gerados em `android/app/src/main/res/` (11 arquivos: 5 mipmap + 5 drawable foreground + 1 XML adaptativo + 1 órfão). Regenerados via `flutter_launcher_icons` a partir do novo `assets/icons/app_icon.png` (fundo transparente). 5 arquivos XML manuais preservados.

### Modificado

- **`CHANGELOG.md`:** Documentação desta sprint adicionada.

### Arquivos Alterados

```
lib/
└── features/
    └── auth/presentation/
        └── auth_providers.dart          ← register() captura userId de insertUser()
android/
└── app/
    └── src/
        └── main/
            └── res/
                ├── mipmap-*/
                │   └── ic_launcher.png  ← Regenerado (10 densities)
                └── drawable/
                    └── ic_launcher_foreground.png  ← Regenerado
assets/
└── icons/
    └── app_icon.png                     ← Novo ícone base (fundo transparente)
```

---```
