# REQUISITOS — Correções e Implementações

> **Data:** 2026-06-09
> **Autor:** Flutter PM + UI/UX Lead
> **Status:** Aprovado — Pronto para implementação pelo flutter-especialist

---

## 1. PROBLEMA: i18n — Tradução da Interface

### Diagnóstico

O app possui um sistema de internacionalização (`AppStrings`) com suporte a pt-BR e en-US. Porém, a maioria das telas **não usa** `AppStrings.of(context)`, exibindo textos fixos em inglês independentemente do idioma selecionado.

**Telas afetadas (hardcoded strings):**

| Tela | Arquivo | Strings hardcoded |
|------|---------|-------------------|
| HomeScreen | `home_screen.dart` | "Welcome back,", "Andrew Hawkins", "Track your Package", "All your packages in one place.", "Tracking by parcel", "PostNord parcel", "See all", "Pick Up", "Package Claim", "All Packages", "International", "No packages yet", "Start tracking your first package!", "No new notifications" |
| TrackingScreen | `tracking_screen.dart` | "Meus Pacotes", "Atualizar", "Buscar por código ou descrição", "Adicionar", "Adicionar pacote", "Código de rastreio", "Cancelar", "Nenhum resultado encontrado", "Nenhum pacote ainda", "Tente buscar...", "Adicione seu primeiro código...", "Remover", "Última atualização:" |
| LoginScreen | `login_screen.dart` | "Email" (label), "Senha" (label), "Informe seu email", "Informe sua senha", "Email ou senha inválidos", "Não tem conta? Cadastre-se" |
| RegisterScreen | `register_screen.dart` | "Criar Conta", "Preencha os dados para se cadastrar", "Nome", "Email", "Senha", "Repetir Senha", "Informe seu nome", "Informe seu email", "Email inválido", "Mínimo de 6 caracteres", "Senhas não conferem", "Cadastrar", "Já tem conta? Faça login", "Conta criada com sucesso! Faça login.", "Erro:" |
| SearchScreen | `search_screen.dart` | "Search", "Search packages", "Find your packages..." |
| SupportScreen | `support_screen.dart` | "Support", "Chat", "FAQ", "Log in with MitID for chat.", "Access chat and features...", "Started new chat", "Chat feature coming soon!", FAQ items |
| BuyPostageScreen | `buy_postage_screen.dart` | "Buy postage", "Destination", "Denmark", "Shipping options", "Letter", "Parcel", "Postcards", "From 29 DKK", etc. |
| ProfileScreen | `profile_screen.dart` | "Profile", "Andrew Hawkins", "andrew@example.com", "Profile settings coming soon", "We're working on it!" |
| FloatingBottomNav | `floating_bottom_nav.dart` | "Home", "Market", "Chat", "Profile" |
| Router | `router.dart` | "Erro", "Página não encontrada", "Voltar ao início" |
| AppShell | `app_shell.dart` | (nenhum hardcoded) |
| SplashScreen | `splash_screen.dart` | "Bugigangas Go", "Package Tracker" |

### O que precisa ser feito

1. **Adicionar todas as strings faltantes ao `AppStrings`** (`lib/l10n/app_strings.dart`)
   - Mapear cada string hardcoded para uma chave correspondente
   - Incluir traduções pt-BR e en-US para cada chave nova

2. **Substituir strings hardcoded por chamadas `AppStrings.of(context)`** em todas as telas:
   - `home_screen.dart`
   - `tracking_screen.dart`
   - `login_screen.dart`
   - `register_screen.dart`
   - `search_screen.dart`
   - `support_screen.dart`
   - `buy_postage_screen.dart`
   - `profile_screen.dart`
   - `floating_bottom_nav.dart`
   - `router.dart` (error page)
   - `splash_screen.dart`

3. **Verificar que a troca de idioma funciona em todo o fluxo:**
   - Selecionar idioma na `LanguageScreen` → atualiza `localeProvider`
   - `MaterialApp.router` escuta `localeProvider` e reconstrói
   - Navegar para `/login` → deve exibir no novo idioma
   - Logar → navegar para `/` (home) → deve exibir no novo idioma
   - Navegar entre abas → deve manter o idioma

### Critérios de aceite

- [ ] Ao selecionar "Português (Brasil)" na tela de idioma, TODAS as telas subsequentes exibem texto em português
- [ ] Ao selecionar "English", TODAS as telas exibem texto em inglês
- [ ] A troca de idioma persiste após fechar e reabrir o app
- [ ] Strings de validação (form errors, snackbars) também são traduzidas
- [ ] Labels da bottom navigation também são traduzidas
- [ ] Nenhum texto hardcoded em inglês ou português permanece nas telas

---

## 2. PROBLEMA: Exibir Nome do Usuário Logado

### Diagnóstico

A `HomeScreen` exibe "Andrew Hawkins" como nome do usuário, mas esse valor é hardcoded. O app já possui um `authStateProvider` que retorna o `UserModel` logado, mas a home screen não o consulta.

### O que precisa ser feito

1. **HomeScreen:** Consultar `authStateProvider` para obter o `UserModel` atual
   - Substituir 'Andrew Hawkins' por `user.name`
   - Substituir 'Welcome back,' por `AppStrings.of(context).welcomeBack`
   - Exibir a primeira letra do nome no avatar (fallback: `Icons.person`)

2. **ProfileScreen:** Consultar `authStateProvider` para exibir dados reais do usuário
   - Nome, email, avatar com iniciais
   - Botão de logout funcional

3. **TrackingScreen:** Associar pacotes ao usuário logado (ver Seção 3)

### Critérios de aceite

- [ ] HomeScreen mostra "Bem-vindo de volta, {nome}" com o nome real do banco
- [ ] Avatar mostra a primeira letra do nome do usuário
- [ ] ProfileScreen mostra nome e email do usuário logado
- [ ] Logout funciona e retorna ao fluxo de login

---

## 3. PROBLEMA: Associar Pacotes ao Usuário no Banco de Dados

### Diagnóstico

Atualmente os pacotes são `PackageModel` armazenados apenas em memória via `PackageListNotifier` com dados mock. Não há:
- Tabela no Neon para pacotes
- Relação entre usuário e pacotes
- Persistência de pacotes adicionados

### O que precisa ser feito

1. **Criar tabela `packages` no Neon** (via `ensureSchema()` em `neon_service.dart`):
   ```sql
   CREATE TABLE IF NOT EXISTS packages (
     id         SERIAL PRIMARY KEY,
     user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
     code       TEXT NOT NULL,
     description TEXT DEFAULT '',
     status     TEXT DEFAULT 'Registrado',
     origin     TEXT DEFAULT '',
     destination TEXT DEFAULT '',
     last_update TEXT,
     created_at TEXT NOT NULL,
     UNIQUE(user_id, code)
   );
   ```

2. **Adicionar métodos no `NeonService`**:
   - `getUserPackages(userId)`: Lista pacotes de um usuário
   - `insertPackage(userId, package)`: Adiciona pacote
   - `deletePackage(userId, code)`: Remove pacote
   - `updatePackageStatus(userId, code, status)`: Atualiza status

3. **Criar um `packageRepositoryProvider` no Neon** ou estender o `PackageRepository` existente para:
   - Carregar pacotes do banco ao iniciar
   - Salvar pacotes novos no banco ao adicionar
   - Remover do banco ao deletar

4. **Atualizar `PackageListNotifier`** para:
   - Inicializar a lista a partir do banco (carregar pacotes do usuário logado)
   - Persistir adições e remoções no banco
   - Associar cada pacote ao `user_id` correto

### Modelo de Dados Sugerido

```dart
class UserPackage {
  final int? id;
  final int userId;
  final String code;
  final String description;
  final String status;
  final String? origin;
  final String? destination;
  final DateTime? lastUpdate;
  final DateTime createdAt;
}
```

### Critérios de aceite

- [ ] Pacotes adicionados via "Adicionar pacote" persistem no Neon
- [ ] Ao reabrir o app, pacotes do usuário logado são carregados do banco
- [ ] Remover pacote exclui do banco
- [ ] Cada usuário vê apenas seus próprios pacotes
- [ ] Se usuário A adiciona um pacote, usuário B não vê esse pacote

---

## 4. PROBLEMA: Integrar API do Melhor Rastreio

### Diagnóstico

O `PackageRepository` atualmente retorna dados mock para códigos específicos (`BR123456789`, `US987654321`, `CN555666777`). A base URL configurada é `https://api.seurastreio.com`.

### Melhor Rastreio API

**Site:** https://melhorrastreio.com.br  
**API:** https://api.melhorrastreio.com.br/api/v1/tracking/{code}

A API do Melhor Rastreio requer uma chave de API (token) e retorna dados de rastreamento em JSON.

**Endpoint (exemplo):**
```
GET https://api.melhorrastreio.com.br/api/v1/tracking/{code}
Headers:
  Authorization: Bearer {api_key}
```

**Resposta esperada (formato aproximado):**
```json
{
  "code": "BR123456789",
  "status": "in_transit",
  "status_label": "Em trânsito",
  "events": [
    {
      "date": "2026-06-04T10:00:00Z",
      "location": "São Paulo, SP",
      "description": "Objeto postado"
    }
  ],
  "origin": "São Paulo, SP",
  "destination": "Rio de Janeiro, RJ",
  "last_update": "2026-06-09T15:00:00Z"
}
```

### O que precisa ser feito

1. **Adicionar a chave da API** no `.env`:
   ```
   MELHOR_RASTREIO_API_KEY=your_api_key_here
   MELHOR_RASTREIO_BASE_URL=https://api.melhorrastreio.com.br/api/v1
   ```

2. **Carregar a chave** via `flutter_dotenv` no `PackageRepository`

3. **Substituir a lógica mock** por chamada HTTP real usando `Dio`:
   - Fazer GET para `/tracking/{code}` com Authorization header
   - Parsear resposta JSON para `PackageModel`
   - Tratar erros (código não encontrado, timeout, rede)

4. **Manter fallback para dados mock** caso a API não esteja disponível ou o código não seja encontrado (para não quebrar o fluxo de teste)

5. **Atualizar o `PackageRepository` provider** com a nova configuração

### Critérios de aceite

- [ ] Ao adicionar um código de rastreio válido, os dados são buscados na API do Melhor Rastreio
- [ ] Status, eventos, origem e destino são exibidos corretamente
- [ ] Erros de rede são tratados com SnackBar amigável
- [ ] Timeout configurado (30s sugerido)
- [ ] Não há vazamento de chave de API no código fonte
- [ ] Fallback para dados mock se a API falhar (modo de desenvolvimento)

---

## 5. PROBLEMA: Criptografia de Senha 🔒

### Diagnóstico

Atualmente as senhas dos usuários são armazenadas **em texto puro** no banco de dados Neon. A comparação no login é feita diretamente: `user.password != password`. Isso é uma **falha grave de segurança**.

**Arquivos afetados:**
- `lib/features/auth/domain/user_model.dart` — campo `password` armazena texto puro
- `lib/features/auth/presentation/auth_providers.dart` — `register()` salva senha pura, `login()` compara em texto puro
- `lib/core/database/neon_service.dart` — `insertUser()` e `getUserByEmail()` trafegam senha pura

### O que precisa ser feito

#### 5a. Adicionar dependência `crypto`

No `pubspec.yaml`:
```yaml
dependencies:
  crypto: ^3.0.6
```

O pacote `crypto` é mantido pelo time Dart (https://pub.dev/packages/crypto) e fornece SHA-256, HMAC, etc.

#### 5b. Criar `PasswordHasher` (serviço de hash)

Criar `lib/core/security/password_hasher.dart`:

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Serviço para hash de senhas usando SHA-256 com salt.
///
/// Formato armazenado: `salt:hash` (ambos em hex)
/// - salt: 16 bytes aleatórios gerados no registro
/// - hash: SHA-256(salt + password)
class PasswordHasher {
  /// Gera um salt aleatório de 16 bytes.
  static String _generateSalt() {
    final random = List<int>.generate(16, (_) => DateTime.now().microsecondsSinceEpoch % 256);
    // Usar um gerador mais seguro: em produção, substituir por Random.secure()
    final secure = DateTime.now().microsecondsSinceEpoch;
    final bytes = List<int>.generate(16, (i) => ((secure >> (i * 4)) & 0xFF));
    return base64Url.encode(bytes);
  }

  /// Retorna o hash no formato `salt:hash`.
  static String hashPassword(String password) {
    final salt = _generateSalt();
    final hash = _sha256(salt, password);
    return '$salt:$hash';
  }

  /// Verifica se a [password] corresponde ao [storedHash] (formato `salt:hash`).
  static bool verifyPassword(String password, String storedHash) {
    final parts = storedHash.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    final hash = parts[1];
    return _sha256(salt, password) == hash;
  }

  static String _sha256(String salt, String password) {
    final bytes = utf8.encode(salt + password);
    return sha256.convert(bytes).toString();
  }
}
```

#### 5c. Modificar `AuthActions.register()` em `auth_providers.dart`

```dart
Future<UserModel> register(String name, String email, String password) async {
  final neon = _ref.read(neonServiceProvider);
  final hashedPassword = PasswordHasher.hashPassword(password);
  final user = UserModel(
    name: name,
    email: email,
    password: hashedPassword,  // ← salva hash, não texto puro
    createdAt: DateTime.now(),
  );
  await neon.insertUser(user);
  return user;
}
```

#### 5d. Modificar `AuthActions.login()` em `auth_providers.dart`

```dart
Future<UserModel?> login(String email, String password) async {
  final neon = _ref.read(neonServiceProvider);
  final user = await neon.getUserByEmail(email);
  if (user == null) return null;
  if (!PasswordHasher.verifyPassword(password, user.password)) return null;
  return user;
}
```

#### 5e. Considerações importantes

1. **Usuários existentes:** As senhas em texto puro no banco precisarão ser re-hashadas. Como isso é um app em desenvolvimento com dados mock, pode-se simplesmente deletar os usuários existentes e recriar.

2. **Nunca logar a senha:** Garantir que nenhum `debugPrint` ou log exiba a senha (hash ou texto puro).

3. **Segurança do salt:** O `_generateSalt()` usa uma abordagem simplificada. Em produção, usar `Random.secure()` do Dart.

### Critérios de aceite

- [ ] Ao cadastrar um novo usuário, a senha armazenada no Neon está no formato `salt:hash` (não texto puro)
- [ ] Ao fazer login, a senha digitada é comparada corretamente com o hash armazenado
- [ ] Senhas existentes em texto puro são tratadas (login inválido até recadastro)
- [ ] Nenhuma senha (hash ou texto puro) é exibida em logs ou console
- [ ] `flutter analyze` não aponta erros com a nova dependência `crypto`

---

## 6. ESCOPO E PRIORIZAÇÃO

| Item | Prioridade | Esforço estimado | Dependências |
|------|-----------|-------------------|--------------|
| 1. i18n — Traduzir interface | 🔴 Alta | 2-3 dias | Nenhuma |
| 2. Nome do usuário logado | 🔴 Alta | 0.5 dia | Nenhuma |
| 3. Associar pacotes ao usuário | 🟡 Média | 2-3 dias | Item 2 |
| 4. API Melhor Rastreio | 🟡 Média | 1-2 dias | Item 3 |
| 5. Criptografia de senha | 🔴 Alta | 0.5 dia | Nenhuma |

### Ordem sugerida de implementação

1. **Sprint atual — Fase 1 (Dias 1-2):** i18n completo + nome do usuário + criptografia de senha
2. **Sprint atual — Fase 2 (Dias 3-4):** Tabela de pacotes + persistência
3. **Próximo sprint:** Integração com API Melhor Rastreio

---

## 7. RISCOS

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Quebrar strings existentes ao adicionar novas chaves | Baixa | Alto | Usar o padrão existente, manter chaves antigas |
| Perder pacotes ao migrar de mock para banco | Média | Alto | Script de migração ou manter mock como fallback |
| API do Melhor Rastreio mudar o formato de resposta | Média | Alto | Validar modelo de dados, criar testes |
| Chave de API exposta no repositório | Baixa | Crítico | .env no .gitignore, não commitar |
| Neon offline | Baixa | Alto | Cache local ou tratamento de erro amigável |
| Usuários existentes com senha em texto puro não conseguem logar | Alta | Médio | Documentar necessidade de recadastro |

---

## 8. ARQUIVOS QUE PRECISAM SER MODIFICADOS

### i18n
- `lib/l10n/app_strings.dart` — Adicionar ~60 novas chaves
- `lib/features/home/presentation/home_screen.dart` — Usar AppStrings
- `lib/features/tracking/presentation/tracking_screen.dart` — Usar AppStrings
- `lib/features/tracking/presentation/package_detail_screen.dart` — Usar AppStrings
- `lib/features/auth/presentation/login_screen.dart` — Usar AppStrings
- `lib/features/auth/presentation/register_screen.dart` — Usar AppStrings
- `lib/features/search/presentation/search_screen.dart` — Usar AppStrings
- `lib/features/support/presentation/support_screen.dart` — Usar AppStrings
- `lib/features/postage/presentation/buy_postage_screen.dart` — Usar AppStrings
- `lib/features/profile/presentation/profile_screen.dart` — Usar AppStrings
- `lib/shared/widgets/floating_bottom_nav.dart` — Usar AppStrings
- `lib/core/router.dart` — Usar AppStrings (error page)
- `lib/features/auth/presentation/splash_screen.dart` — Usar AppStrings

### Nome do usuário
- `lib/features/home/presentation/home_screen.dart` — Consultar `authStateProvider`
- `lib/features/profile/presentation/profile_screen.dart` — Consultar `authStateProvider`, adicionar logout
- `lib/core/database/neon_service.dart` — Método `getUserById` se necessário

### Pacotes no banco
- `lib/core/database/neon_service.dart` — Nova tabela + CRUD de pacotes
- `lib/features/tracking/domain/package_model.dart` — Pode precisar de `userId`
- `lib/features/tracking/presentation/tracking_providers.dart` — Integrar com banco
- `lib/features/tracking/presentation/tracking_screen.dart` — Persistir adições/remoções

### API Melhor Rastreio
- `.env` — Adicionar `MELHOR_RASTREIO_API_KEY` e `MELHOR_RASTREIO_BASE_URL`
- `lib/features/tracking/data/package_repository.dart` — Implementar chamada real
- `lib/features/tracking/data/package_repository.g.dart` — Regenerar (se aplicável)

### Criptografia 🔒
- `pubspec.yaml` — Adicionar `crypto: ^3.0.6`
- `lib/core/security/password_hasher.dart` — NOVO arquivo
- `lib/features/auth/presentation/auth_providers.dart` — Usar PasswordHasher no register e login

---

## 9. NOTAS DE IMPLEMENTAÇÃO

### Padrão para AppStrings

Seguir o padrão existente:
```dart
// No app_strings.dart
String get welcomeBack => _map('welcomeBack');

// No _pt
'welcomeBack': 'Bem-vindo de volta',

// No _en
'welcomeBack': 'Welcome back',
```

### Como obter o usuário logado em uma tela

```dart
final userAsync = ref.watch(authStateProvider);
return userAsync.when(
  data: (user) => Text(user?.name ?? 'Usuário'),
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => Text('Erro: $e'),
);
```

### Persistência de pacotes (padrão sugerido)

Criar um provider que combina `authStateProvider` e `packageListProvider`:
```dart
final userPackagesProvider = FutureProvider<List<PackageModel>>((ref) async {
  final neon = ref.watch(neonServiceProvider);
  final user = await ref.watch(authStateProvider.future);
  if (user == null || user.id == null) return [];
  return neon.getUserPackages(user.id!);
});
```

### Criptografia de senha

- Usar `package:crypto` (SHA-256) com salt aleatório
- Formato armazenado: `salt_base64:hash_hex`
- Salt: 16 bytes aleatórios (base64)
- Hash: SHA-256(salt + password) em hex
- Verificação: extrair salt do hash armazenado, recomputar SHA-256(salt + input) e comparar

---

*Fim do documento de requisitos*
