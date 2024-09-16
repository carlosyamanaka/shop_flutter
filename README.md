# Projeto Loja Flutter

Este projeto é uma aplicação de e-commerce desenvolvida em Flutter. A aplicação permite que usuários façam login, visualizem produtos, filtrem por favoritos, adicionem itens ao carrinho e façam pedidos, com cada operação sendo associada ao usuário autenticado. A persistência de dados é feita no Firebase Realtime Database, e todas as operações de CRUD estão disponíveis.

## Funcionalidades Implementadas

- **Autenticação de Usuários**: Utilizando Firebase Authentication para login e registro.
- **Requisições HTTP**: Comunicação com o backend utilizando o pacote `http`.
- **Firebase Realtime Database**: Persistência dos dados de produtos, usuários, favoritos e pedidos.
- **CRUD de Produtos**: Criação, leitura, atualização e remoção de produtos no banco de dados.
- **Favoritar Produtos**: Os usuários podem marcar produtos como favoritos, e o filtro de favoritos exibe apenas esses itens.
- **Carrinho de Compras**: Adicionar itens ao carrinho, visualizar o carrinho e realizar pedidos.
- **Pedidos por Usuário**: Os pedidos são filtrados por usuário autenticado, garantindo que cada usuário visualize apenas seus próprios pedidos.
- **Animações**: Implementação de animações visuais para melhorar a experiência do usuário.

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento do aplicativo.
- **Provider**: Gerenciamento de estado reativo.
- **Firebase Authentication**: Para login e autenticação de usuários.
- **Firebase Realtime Database**: Para persistência dos dados da loja.
- **Requisições HTTP**: Utilizando o pacote `http` para comunicação com o backend.
- **Shared Preferences**: Para persistência de dados localmente.
- **Intl**: Para internacionalização e formatação de datas.

## Estrutura do Projeto

- **components/**: Contém os widgets reutilizáveis, como cards de produtos e botões.
- **data/**: Contém os modelos de dados usados no projeto, como `Product` e `Order`.
- **exceptions/**: Contém os modelos de dados usados no projeto, como `Product` e `Order`.
- **models/**: Contém os modelos de dados usados no projeto, como `Product` e `Order`.
- **pages/**: Contém as telas da aplicação, como lista de produtos, detalhes do produto, e a tela de carrinho.
- **utils/**: Serviços de comunicação com a API e Firebase.

## Como Executar o Projeto

### Clone o repositório:

```bash
git clone https://github.com/usuario/flutter-loja.git
```

### Instale as dependências:

```bash
flutter pub get
```

### Configure o Firebase:
1. Crie um projeto no Firebase.
2. Adicione o Firebase Authentication e Realtime Database.
3. Baixe o arquivo google-services.json e o configure no seu projeto.

### Execute o aplicativo:
```bash
flutter run
```

### Autor
Desenvolvido por Carlos Koiti Yamanaka.
