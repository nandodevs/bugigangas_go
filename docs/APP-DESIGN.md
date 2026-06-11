## 📐 Visão Geral do Design (Design System Global)

* **Paleta de Cores:**
* **Cor Primária (Teal/Turquesa):** `#009696` ou `#0B9B9B` (usada em botões principais, abas ativas e ícone central da bottom nav).
* **Fundo Principal:** Branco puro `#FFFFFF` ou um cinza/azul extremamente claro e limpo para os cards de fundo.
* **Cores de Status (Badges):**
* *Processing:* Laranja claro/pastel com texto marrom/laranja escuro.
* *On Delivery:* Verde claro/pastel com texto verde escuro.
* *On Process:* Amarelo/Dourado claro com texto escuro.


* **Texto Principal:** Grafite escuro `#1A1A1A` para alta legibilidade.
* **Texto Secundário:** Cinza médio `#757575` para subtítulos e descrições.


* **Tipografia:** Fonte Sans-Serif moderna (ex: *Inter*, *Roboto* ou *Poppins*). Títulos em negrito (`FontWeight.bold`) e descrições em peso regular ou médio.
* **Bordas e Arredondamento:** Uso consistente de `BorderRadius.circular(24)` a `(32)` para os cards principais e telas, dando um aspecto moderno, "soft" e flutuante.
* **Navegação Inferior (BottomNavigationBar):** Uma barra flutuante customizada com fundo branco, cantos muito arredondados e 5 itens: Home, Carrinho/Mercado, Busca (Ícone central destacado em um círculo Turquesa), Chat e Perfil.

---

## 📱 Detalhamento das Telas (Componentes Flutter)

### Tela 1: Rastreamento e Lista de Encomendas (Home/Dashboard)

* **Header (Cabeçalho Superior):**
* Um container com fundo turquesa claro/degradê suave.
* **Linha superior:** Foto de perfil circular (`CircleAvatar`) à esquerda, texto de boas-vindas ("Welcome back, Andrew Hawkins") ao lado, e um botão de notificação (`IconButton` com badge) à direita.
* **Título:** Texto em destaque "Track your Package" seguido de um subtítulo menor.
* **Barra de Pesquisa (Search Bar):** Um `TextField` branco sobreposto ao container, com cantos arredondados, texto de placeholder "Tracking by precel" (nota: corrigir erro de digitação para *parcel* no código) e um ícone de lupa à direita.


* **Filtros Rápidos (Horizontal Scroll/ListView):**
* Uma lista horizontal de botões ovais (`ElevatedButton` ou `ActionChip`). O selecionado ("Pick Up") fica em Turquesa com texto branco; os demais ("Package Claim") ficam em cinza bem claro com texto escuro.


* **Lista de Encomendas (PostNord parcel):**
* Título da seção em negrito: "PostNord parcel".
* Uma `ListView.builder` vertical contendo cards (`Card` ou `Container` com `BoxShadow` suave).
* **Estrutura de cada Card (Row):**
* *Leading:* Um círculo colorido com um ícone de caixa/pacote dentro. Cada card tem uma cor de círculo diferente (Laranja, Azul, Roxo) para diferenciar as encomendas.
* *Title & Subtitle (Column):* Código de rastreio em negrito (ex: `CRG211000581`) e logo abaixo os detalhes físicos em cinza ("150 kg - 1200x800x100").
* *Trailing:* Um badge/etiqueta de status com cantos arredondados (`Container` com padding e `BorderRadius`). As cores do badge mudam conforme o status (*Processing*, *On delivery*, etc.).

---

### Tela 2: Compra de Postagem / Opções de Envio (Buy Postage)

* **AppBar Customizada:**
* Botão de voltar (`ArrowBack`) à esquerda, título centralizado "Buy postage", e um botão de menu hamburguer ou opções (`Icons.menu`) à direita.


* **Seção "Destination":**
* Título "Destination" em cinza.
* Um card de seleção (`Dropdown` ou `ListTile` clicável) mostrando a bandeira do país (ex: Dinamarca), o nome do país "Denmark" e uma seta para baixo à direita.


* **Seção "Shipping options" (Lista de Serviços):**
* Título da seção em negrito.
* Cards grandes e verticais para cada tipo de serviço (Letter, Parcel, Postcards).
* **Design dos Cards de Serviço:**
* Fundo colorido em tons pastel muito suaves (Azul claro para Letter, Amarelo claro para Parcel, Verde/Azul para Postcards).
* Layout interno em duas colunas (`Row` principal):
* *Esquerda (Column):* Nome do serviço em negrito, descrição detalhada das regras de envio e prazo em letras menores, e o preço em destaque na parte inferior ("From 29 DKK").
* *Direita:* Uma ilustração em vetor 2D estilizada correspondente ao serviço (um envelope azul saindo da caixa para Letter, duas caixas amarelas empilhadas para Parcel).

---

### Tela 3: Suporte e Chat (Support)

* **AppBar Customizada:**
* Botão de voltar à esquerda e título centralizado "Support".


* **Alternador de Abas (Segmented Control / TabBar Customizada):**
* Um container cinza claro em formato de pílula que engloba duas opções: "Chat" e "FAQ".
* A opção selecionada ("Chat") possui um fundo Turquesa sólido e texto branco. A opção inativa ("FAQ") possui apenas o texto em cinza sobre o fundo do container.


* **Área Central (Ilustração e Autenticação):**
* Uma ilustração centralizada em vetor mostrando duas pessoas interagindo através de uma tela de smartphone (foco em atendimento/comunicação).
* **Textos de Instrução:**
* Um texto de apoio cinza menor: "Log in with MitID for chat."
* Um título principal em negrito e centralizado: "Access chat and features log in with MitID."


* **Botão de Ação Principal (CTA - Call To Action):**
* Um `ElevatedButton` expandido na horizontal (`width: double.infinity`), com cantos totalmente arredondados, fundo Turquesa e texto branco em negrito: "Started new chat".