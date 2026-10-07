# LISTO

Aplicativo de listas desenvolvido com Flutter, criado para ser simples, rápido e direto ao ponto.

O LISTO permite criar várias listas e adicionar itens dentro de cada uma delas. Os itens podem ser marcados como concluídos quando necessário.

A proposta do aplicativo é oferecer uma experiência simples, sem configurações complexas ou recursos desnecessários.

Uma lista de compras, tarefas, filmes, livros, ferramentas ou qualquer outra coisa. **Você decide como usar.**

## Funcionalidades

* Criação de múltiplas listas
* Adição de vários itens em cada lista
* Visualização e organização dos itens por lista
* Marcação de itens como concluídos
* Desmarcação de itens quando necessário
* Armazenamento local dos dados
* Interface compatível com Android, iOS e Web

## Tecnologias utilizadas

* Flutter
* Dart
* SQLite
* Sqflite

## Observação sobre a versão Web

A versão Web está disponível para demonstração e testes da interface.

Atualmente, o armazenamento utilizado no projeto é baseado em SQLite, que funciona localmente no Android e iOS.

No navegador, o banco de dados é recriado sempre que o aplicativo é iniciado novamente. Por esse motivo, as listas e os itens cadastrados não são mantidos entre diferentes execuções do aplicativo.

Durante a mesma execução, incluindo o uso de hot reload, os dados permanecem disponíveis.

## Como executar o projeto

### Pré-requisitos

Antes de começar, é necessário ter o Flutter instalado e configurado no computador.

Verifique a instalação com:

```bash
flutter doctor
```

### Instalação

Clone este repositório:

```bash
git clone https://github.com/bfritschrenan-jpg/app-minha-lista.git
```

Entre na pasta do projeto:

```bash
cd app-minha-lista
```

Instale as dependências:

```bash
flutter pub get
```

Execute o aplicativo em um dispositivo ou emulador:

```bash
flutter run
```

## Executar no navegador

Para testar a versão Web no Google Chrome:

```bash
flutter run -d chrome
```

## Estrutura do projeto

```text
lib/
├── assets/          # Recursos visuais do aplicativo
├── database/        # Banco de dados e persistência local
├── page/            # Telas do aplicativo
├── card_item.dart   # Componente visual dos itens da lista
└── main.dart        # Ponto de entrada do aplicativo
```

## Autor

Desenvolvido por Renan Fritsch.

## Licença

Projeto desenvolvido para fins de estudo e aprendizado.
